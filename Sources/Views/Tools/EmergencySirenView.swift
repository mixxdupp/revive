import SwiftUI
import AVFoundation
import MediaPlayer
import CoreHaptics

final class SirenManager: ObservableObject {
    @Published var isPlaying = false
    @Published var includeStrobe = true
    @Published var screenFlashColor: Color = .clear
    
    // Audio Components
    private var audioEngine: AVAudioEngine?
    private var sourceNode: AVAudioSourceNode?
    
    // Siren Parameters (High-speed Two-Tone Chirp to match aggressive physical alarms)
    private let freq1: Double = 2700.0 // Piercing high
    private let freq2: Double = 3300.0 // Even higher peak
    private let chirpRate: Double = 12.0 // Fast oscillation between the two frequencies
    
    // SOS Pattern
    private let sosPattern: [(Bool, Double)] = [
        (true, 0.2), (false, 0.2), (true, 0.2), (false, 0.2), (true, 0.2), (false, 0.6), // S
        (true, 0.6), (false, 0.2), (true, 0.6), (false, 0.2), (true, 0.6), (false, 0.6), // O
        (true, 0.2), (false, 0.2), (true, 0.2), (false, 0.2), (true, 0.2), (false, 1.4)  // S
    ]
    
    // Tasks & Background
    private var flashTask: Task<Void, Never>?
    private var screenFlashTask: Task<Void, Never>?
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    deinit {
        stopSiren()
        NotificationCenter.default.removeObserver(self)
    }

    func toggleSiren() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        if isPlaying { stopSiren() } else { startSiren() }
    }
    
    func startSiren() {
        guard !isPlaying else { return }
        
        UIApplication.shared.isIdleTimerDisabled = true
        backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "SirenLoop") {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
            self.backgroundTaskID = .invalid
        }
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        setupRemoteTransportControls()
        
        setupAudioSession()
        startAudioEngine()
        maximizeVolume()
        
        if includeStrobe { startFlash() }
        startScreenFlash()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self, self.isPlaying else {
                timer.invalidate()
                return
            }
        }
        
        isPlaying = true
    }
    
    func stopSiren() {
        stopAudioEngine()
        stopFlash()
        
        flashTask?.cancel()
        flashTask = nil
        screenFlashTask?.cancel()
        screenFlashTask = nil
        
        isPlaying = false
        screenFlashColor = .clear
        
        if backgroundTaskID != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
        UIApplication.shared.endReceivingRemoteControlEvents()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
        
        if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) && isPlaying {
                    do {
                        try audioEngine?.start()
                    } catch {
                        startAudioEngine()
                    }
                }
            }
        }
    }
    
    // MARK: - Audio Internal
    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { _ in .success }
        commandCenter.pauseCommand.addTarget { _ in .success }
        commandCenter.stopCommand.addTarget { _ in .success }
        commandCenter.togglePlayPauseCommand.addTarget { _ in .success }
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { print("Audio Session Error: \(error)") }
    }
    
    private func startAudioEngine() {
        let engine = AVAudioEngine()
        guard let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1) else { return }
        
        let sampleRate = format.sampleRate
        var time: Double = 0
        var phase: Double = 0
        
        // Generates an aggressive, fast-switching square wave chirp (like a rape alarm)
        let source = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                time += 1.0 / sampleRate
                
                // Fast square-wave modulation between freq1 and freq2
                let modulation = (sin(2.0 * .pi * self.chirpRate * time) > 0) ? 1.0 : 0.0
                let currentFreq = self.freq1 + (self.freq2 - self.freq1) * modulation
                
                phase += currentFreq / sampleRate
                if phase >= 1.0 { phase -= 1.0 }
                
                // Hard square wave for maximum harshness/loudness
                let sample: Float = (phase >= 0.5 ? 1.0 : -1.0)
                
                for buffer in ablPointer {
                    let buf = buffer.mData?.assumingMemoryBound(to: Float.self)
                    buf?[frame] = sample
                }
            }
            return noErr
        }

        engine.attach(source)
        engine.connect(source, to: engine.mainMixerNode, format: format)
        
        do {
            try engine.start()
            self.audioEngine = engine
            self.sourceNode = source
        } catch {}
    }

    private func stopAudioEngine() {
        audioEngine?.stop()
        audioEngine = nil
        sourceNode = nil
    }

    // MARK: - Volume Internal
    private func maximizeVolume() {
        audioEngine?.mainMixerNode.outputVolume = 1.0
        let volumeView = MPVolumeView()
        if let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                slider.setValue(1.0, animated: false)
            }
        }
    }

    func startFlash() {
        flashTask?.cancel()
        flashTask = Task {
            while !Task.isCancelled && includeStrobe {
                for (on, duration) in sosPattern {
                    if Task.isCancelled || !includeStrobe { break }
                    setTorch(on: on)
                    if on { HapticsService.shared.playImpact(style: .heavy) } // Tactile Sync
                    try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                }
            }
            setTorch(on: false)
        }
    }
    
    func stopFlash() {
        flashTask?.cancel()
        flashTask = nil
        setTorch(on: false)
    }
    
    private func startScreenFlash() {
        screenFlashTask?.cancel()
        screenFlashTask = Task { @MainActor in
            while !Task.isCancelled {
                self.screenFlashColor = Color(red: 1.0, green: 0.0, blue: 0.0)
                try? await Task.sleep(nanoseconds: 500_000_000)
                if Task.isCancelled { break }
                
                self.screenFlashColor = Color(red: 0.0, green: 0.0, blue: 1.0)
                try? await Task.sleep(nanoseconds: 500_000_000)
                if Task.isCancelled { break }
            }
            self.screenFlashColor = .clear
        }
    }
    
    private func setTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {}
    }
}

// MARK: - View
struct EmergencySirenView: View {
    var autoPlay: Bool = false
    @StateObject private var manager = SirenManager()
    @State private var showSecurityInfo = false
    @State private var isGuidedAccessActive = UIAccessibility.isGuidedAccessEnabled
    
    var body: some View {
        ZStack {
            (manager.isPlaying ? manager.screenFlashColor : Color.black)
                .ignoresSafeArea()
                .animation(.easeOut(duration: 0.06), value: manager.isPlaying)
            
            VStack(spacing: 0) {
                Spacer()

                if manager.isPlaying {
                    activeView
                } else {
                    inactiveView
                }

                Spacer()
                
                if !manager.isPlaying {
                    Button(action: { showSecurityInfo = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: isGuidedAccessActive ? "lock.shield.fill" : "lock.open.trianglebadge.exclamationmark.fill")
                                .font(.title2)
                                .foregroundStyle(isGuidedAccessActive ? .green : .black)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(isGuidedAccessActive ? "Intruder Protection Active" : "Intruder Protection Off")
                                    .font(.headline)
                                    .foregroundStyle(isGuidedAccessActive ? .white : .black)
                                
                                if !isGuidedAccessActive {
                                    Text("Requires Guided Access check")
                                        .font(.caption)
                                        .foregroundStyle(.black.opacity(0.7))
                                }
                            }
                            Spacer()
                            Image(systemName: "info.circle")
                                .foregroundStyle(isGuidedAccessActive ? .white.opacity(0.5) : .black.opacity(0.5))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(isGuidedAccessActive ? Color(white: 0.15) : Color.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }

                controlsStrip
                    .padding(.bottom, 24)

                LongPressActionButton(isPlaying: manager.isPlaying, action: manager.toggleSiren)
            }
        }
        .navigationTitle(manager.isPlaying ? "" : "Emergency Siren")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(manager.isPlaying ? .hidden : .visible, for: .navigationBar)
        .onAppear {
            if autoPlay {
                manager.includeStrobe = true
                manager.startSiren()
            }
            isGuidedAccessActive = UIAccessibility.isGuidedAccessEnabled
        }
        .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.guidedAccessStatusDidChangeNotification)) { _ in
            isGuidedAccessActive = UIAccessibility.isGuidedAccessEnabled
        }
        .onDisappear { manager.stopSiren() }
        .sheet(isPresented: $showSecurityInfo) {
            SecurityInfoSheet(isGuidedAccessActive: isGuidedAccessActive)
                .presentationBackground(.black)
        }
    }
    
    private var activeView: some View {
        VStack(spacing: 16) {
            Text("Siren Active")
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.white.opacity(0.9))
                .frame(height: 30)
            
            Image(systemName: "speaker.wave.3.fill")
                .font(.system(size: 140, weight: .light))
                .foregroundStyle(.white)
                .scaleEffect(manager.screenFlashColor != .clear ? 0.95 : 1.0)
                .animation(.interactiveSpring(response: 0.2, dampingFraction: 0.5), value: manager.screenFlashColor)
            
            if !isGuidedAccessActive {
                Text("Triple-Click Side Button to Lock")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.black)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.yellow)
                    .clipShape(Capsule())
                    .padding(.top, 16)
            }
        }
        .accessibilityElement(children: .combine)
    }
    
    private var inactiveView: some View {
        VStack(spacing: 20) {
            Image(systemName: "light.beacon.max.fill")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(.red)
            
            VStack(spacing: 0) {
                Text("Emergency")
                Text("Siren")
            }
            .font(.largeTitle.weight(.bold))
            .foregroundStyle(.white)
            
            Text("Generates extremely loud oscillating chirp")
                .font(.body)
                .foregroundStyle(Color(white: 0.6))
                .multilineTextAlignment(.center)
            
            Text("Warning: Volume buttons can silence alarm")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color.red)
                .padding(.top, 8)
        }
        .accessibilityElement(children: .combine)
    }
    
    private var controlsStrip: some View {
        VStack(spacing: 0) {
            HStack {
                guidanceItem(
                    icon: "flashlight.on.fill",
                    label: "SOS Strobe",
                    isActive: manager.includeStrobe,
                    activeColor: .white
                )
                Spacer()
                Toggle("", isOn: $manager.includeStrobe)
                    .labelsHidden()
                    .tint(.red)
                    .onChange(of: manager.includeStrobe) { _, newValue in
                        if manager.isPlaying {
                            if newValue { manager.startFlash() } else { manager.stopFlash() }
                        }
                    }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            
            Divider().background(Color(white: 0.2)).padding(.horizontal, 24)
            
            if manager.isPlaying {
                Button(action: { showSecurityInfo = true }) {
                    HStack {
                        guidanceItem(
                            icon: isGuidedAccessActive ? "lock.shield.fill" : "exclamationmark.shield.fill",
                            label: isGuidedAccessActive ? "Intruder Protection Active" : "Intruder Protection Off",
                            isActive: isGuidedAccessActive,
                            activeColor: .green
                        )
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                            .foregroundStyle(Color(white: 0.4))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }
            }
        }
        .background(manager.isPlaying ? Color.black.opacity(0.85) : Color(white: 0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal, 24)
        .disabled(manager.isPlaying && isGuidedAccessActive)
    }
    
    private func guidanceItem(icon: String, label: String, isActive: Bool, activeColor: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(isActive ? activeColor : Color(white: 0.5))
                .frame(width: 24)
            Text(label)
                .font(.headline)
                .foregroundStyle(isActive ? .white : Color(white: 0.6))
        }
    }
}

// MARK: - Action Button
struct LongPressActionButton: View {
    var isPlaying: Bool
    var action: () -> Void
    
    @State private var isHolding = false
    @State private var progress: CGFloat = 0.0
    private let holdDuration: TimeInterval = 3.0
    @State private var timer: Timer?
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(isPlaying ? Color.white : Color.red)
                .frame(height: 72)
            
            if isPlaying {
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.black)
                        .frame(width: geo.size.width * progress, height: 72)
                        .animation(.linear(duration: 0.1), value: progress)
                }
                .frame(height: 72)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            
            HStack(spacing: 10) {
                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                    .font(.title3.weight(.bold))
                
                Text(buttonText)
                    .font(.title3.weight(.bold))
            }
            .foregroundStyle(isPlaying ? (progress > 0.5 ? .white : .black) : .white)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 72)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .scaleEffect(isHolding ? 0.96 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHolding)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isHolding { startHolding() }
                }
                .onEnded { _ in stopHolding() }
        )
    }
    
    private var buttonText: String {
        if !isPlaying { return "Start Siren" }
        if isHolding { return "Hold to Stop" }
        return "Slide or Hold"
    }
    
    private func startHolding() {
        guard isPlaying else {
            action()
            return
        }
        
        isHolding = true
        progress = 0.0
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            let elapsed = Date().timeIntervalSince(startTime)
            progress = CGFloat(elapsed / holdDuration)
            
            if elapsed >= holdDuration {
                completeHold()
            }
        }
    }
    
    private func stopHolding() {
        isHolding = false
        progress = 0.0
        timer?.invalidate()
        timer = nil
    }
    
    private func completeHold() {
        stopHolding()
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        action()
    }
}

// MARK: - Security Info Sheet
struct SecurityInfoSheet: View {
    var isGuidedAccessActive: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if isGuidedAccessActive {
                            HStack {
                                Image(systemName: "checkmark.shield.fill")
                                    .font(.title2)
                                    .foregroundStyle(.green)
                                Text("Guided Access is ENABLED")
                                    .font(.headline)
                            }
                        } else {
                            HStack {
                                Image(systemName: "exclamationmark.shield.fill")
                                    .font(.title2)
                                    .foregroundStyle(.orange)
                                Text("Guided Access is DISABLED")
                                    .font(.headline)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why use it?")
                                .font(.headline)
                            Text("It disables the Power Button and Volume Buttons so an attacker cannot silence your device. It requires your passcode or FaceID to stop the siren.")
                                .font(.body)
                                .foregroundStyle(Color(white: 0.8))
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("How to Activate")
                                .font(.headline)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("1. Go to Settings > Accessibility > Guided Access > Toggle ON.")
                                Text("2. Create a Passcode.")
                                Text("3. Return to this app.")
                                Text("4. Triple-Click the Side Button.")
                            }
                            .font(.body)
                            
                            Text("CRITICAL: Tap 'Options' (bottom left) → Turn OFF EVERYTHING.")
                                .font(.headline)
                                .foregroundStyle(.red)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("• Side Button (Sleep/Wake)")
                                Text("• Volume Buttons")
                                Text("• Motion")
                                Text("• Keyboards")
                            }
                            .font(.subheadline)
                            .foregroundStyle(Color(white: 0.6))
                            .padding(.leading, 8)
                        }
                    }
                    .padding(24)
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Intruder Protection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.black, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
