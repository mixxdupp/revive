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
        
        // Configure Audio Session
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
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
        
        // Pause listening while speaking to prevent feedback loops, if recording
        let wasRecording = isRecording
        if wasRecording {
            audioEngine.pause()
        }
        
        synthesizer.speak(utterance)
        
        // Note: Resuming listening is now handled by AVSpeechSynthesizerDelegate didFinish utterance.
    }
    
    private func processCommand(_ text: String) {
        // Simple keyword matching from the last few words
        let words = text.components(separatedBy: " ")
        if let lastWord = words.last {
            if commands.contains(lastWord) {
                DispatchQueue.main.async {
                    self.detectedCommand = lastWord
                    // Reset command after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        if self.detectedCommand == lastWord {
                            self.detectedCommand = nil
                        }
                    }
                }
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
        
        // Resume listening if we were recording
        if isRecording && !audioEngine.isRunning {
            try? audioEngine.start()
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
}
