import AVFoundation
import Combine

class SpeechSynthesisService: NSObject, ObservableObject, AVSpeechSynthesizerDelegate, @unchecked Sendable {
    static let shared = SpeechSynthesisService()
    
    private let synthesizer = AVSpeechSynthesizer()
    @MainActor @Published var isSpeaking = false
    
    override private init() {
        super.init()
        synthesizer.delegate = self
        
        // Configure audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session for TTS: \(error)")
        }
        
    }
    
    @MainActor
    func speak(_ text: String) {
        // Stop any current speech
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        // Dynamically select the best quality voice available
        utterance.voice = getBestVoice()
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        synthesizer.speak(utterance)
    }
    
    @MainActor
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
            self?.isSpeaking = true
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
            self?.isSpeaking = false
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { [weak self] in
             self?.isSpeaking = false
        }
    }
    
    // MARK: - Voice Selection
    
    /// Finds the highest quality English voice available on the device.
    /// Priority: Premium > Enhanced > Default
    private func getBestVoice() -> AVSpeechSynthesisVoice? {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        
        // Filter for English voices (preferring US, but accepting others if better quality is available there)
        let englishVoices = voices.filter { $0.language.starts(with: "en") }
        
        // 1. Explicitly look for "Siri" voices (often have 'siri' in identifier but might not be marked premium in sim)
        if let siri = englishVoices.first(where: { $0.identifier.lowercased().contains("siri") }) {
            print("TTS: Found Siri voice: \(siri.name)")
            return siri
        }
        
        // 2. Try to find a Premium voice
        if let premium = englishVoices.first(where: { $0.quality == .premium }) {
            print("TTS: Using Premium voice: \(premium.name)")
            return premium
        }
        
        // 3. Try Enhanced
        if let enhanced = englishVoices.first(where: { $0.quality == .enhanced }) {
            print("TTS: Using Enhanced voice: \(enhanced.name)")
            return enhanced
        }
        
        // 4. Fallback to standard en-US
        print("TTS: Using Default voice")
        return AVSpeechSynthesisVoice(language: "en-US")
    }
}
