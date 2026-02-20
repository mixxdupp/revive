import Speech
import Combine
import AVFoundation

class SpeechRecognitionService: NSObject, ObservableObject, SFSpeechRecognizerDelegate, AVSpeechSynthesizerDelegate {
    static let shared = SpeechRecognitionService()
    
    @Published var isRecording = false
    @Published var detectedCommand: String?
    @Published var isSpeaking = false
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // Text to Speech
    private let synthesizer = AVSpeechSynthesizer()
    
    // Valid commands
    private let commands = ["next", "back", "stop", "repeat"]
    
    private override init() {
        super.init()
        requestAuthorization()
        synthesizer.delegate = self
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    print("Speech recognition authorized")
                case .denied, .restricted, .notDetermined:
                    print("Speech recognition not authorized")
                @unknown default:
                    break
                }
            }
        }
    }
    
    func startListening() throws {
        // Cancel existing tasks
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Configure Audio Session for Simultaneous Recording and Playback
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .duckOthers])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create recognition request")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        // Keep speech recognition data strictly on-device for privacy and offline requirement
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = true
            
            if speechRecognizer?.supportsOnDeviceRecognition == false {
                print("WARNING: On-device recognition not supported in this environment (likely Simulator or missing models). Speech recognition may fail.")
                // We keep requiresOnDeviceRecognition = true to force the requirement.
                // It will fail gracefully in the recognitionTask block if it cannot fulfill the request off-device.
            }
        }
        
        let inputNode = audioEngine.inputNode
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Check if the result matches any command
                let spokenText = result.bestTranscription.formattedString.lowercased()
                self.processCommand(spokenText)
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                DispatchQueue.main.async {
                    self.isRecording = false
                }
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        DispatchQueue.main.async {
            self.isRecording = true
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isRecording = false
        stopSpeaking() // Ensure speech also stops when listening stops
    }
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func speak(_ text: String) {
        // Stop any current speech
        synthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        
        synthesizer.speak(utterance)
    }
    
    private func processCommand(_ text: String) {
        // Ignore commands if the app is currently speaking to prevent feedback loops
        guard !isSpeaking else { return }
        
        // Clean text of punctuation
        let cleanText = text.lowercased().components(separatedBy: .punctuationCharacters).joined()
        let words = cleanText.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        // Search backwards for the most recent valid command
        for word in words.reversed() {
            if commands.contains(word) {
                DispatchQueue.main.async {
                    if self.detectedCommand != word {
                        self.detectedCommand = word
                        // Reset command after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if self.detectedCommand == word {
                                self.detectedCommand = nil
                            }
                        }
                    }
                }
                break
            }
        }
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
}
