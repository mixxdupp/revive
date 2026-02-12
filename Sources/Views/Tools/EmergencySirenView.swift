import SwiftUI
import AVFoundation
import MediaPlayer

final class SirenManager: ObservableObject {
    @Published var isPlaying = false
    @Published var includeStrobe = false
    @Published var screenFlashColor: Color = .clear
    
    // Audio Components
    private var audioEngine: AVAudioEngine?
    private var sourceNode: AVAudioSourceNode?
    
    // Siren Parameters
    private let lowFreq: Double = 600
    private let highFreq: Double = 1400
    private let sweepRate: Double = 2.0
    
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
        // Observer for Interruption (Lock Screen)
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    deinit {
        stopSiren()
        NotificationCenter.default.removeObserver(self)
    }

    func toggleSiren() {
        if isPlaying { stopSiren() } else { startSiren() }
    }
    
    func startSiren() {
        guard !isPlaying else { return }
        
        // Prevent Sleep & Start Background Task
        UIApplication.shared.isIdleTimerDisabled = true
        backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "SirenLoop") {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
            self.backgroundTaskID = .invalid
        }
        
        // Ensure Remote Controls are received (keeps session alive)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        setupRemoteTransportControls()
        
        setupAudioSession()
        startAudioEngine()
        maximizeVolume()
        
        if includeStrobe { startFlash() }
        startScreenFlash()
        
        // Debug Heartbeat to verify background execution
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self, self.isPlaying else {
                timer.invalidate()
                return
            }
            print("Siren Alive: \(Date()) | Background Time Remaining: \(UIApplication.shared.backgroundTimeRemaining)")
        }
        
        isPlaying = true
    }
    
    func stopSiren() {
        stopAudioEngine()
        stopFlash()
        
        // Clean up tasks
        flashTask?.cancel()
        flashTask = nil
        screenFlashTask?.cancel()
        screenFlashTask = nil
        
        // Reset State
        isPlaying = false
        screenFlashColor = .clear
        
        // End Background Execution
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
                    // Try to restart audio engine vigorously
                    do {
                        try audioEngine?.start()
                    } catch {
                        startAudioEngine() // Rebuild if start fails
                    }
                }
            }
        }
    }
    
    // MARK: - Audio Internal
    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add dummy handlers to qualify as a "Active Media App" to iOS
        commandCenter.playCommand.addTarget { _ in .success }
        commandCenter.pauseCommand.addTarget { _ in .success }
        commandCenter.stopCommand.addTarget { _ in .success }
        commandCenter.togglePlayPauseCommand.addTarget { _ in .success }
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { print("Audio Session Error: \(error)") }
    }
    
    private func startAudioEngine() {
        let engine = AVAudioEngine()
        let sampleRate = engine.outputNode.outputFormat(forBus: 0).sampleRate
        var lfoPhase: Double = 0
        var tonePhase: Double = 0
        
        let source = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                lfoPhase += 1.0 / sampleRate
                let t = self.sweepRate * lfoPhase
                let dt = t - floor(t)
                let lfoValue = abs(2.0 * dt - 1.0)
                
                let currentFreq = self.lowFreq + (self.highFreq - self.lowFreq) * lfoValue
                tonePhase += currentFreq / sampleRate
                if tonePhase >= 1.0 { tonePhase -= 1.0 }
                
                let val = sin(2.0 * .pi * tonePhase)
                let sample: Float = (val >= 0 ? 0.9 : -0.9)
                
                for buffer in ablPointer {
                    let buf = buffer.mData?.assumingMemoryBound(to: Float.self)
                    buf?[frame] = sample
                }
            }
            return noErr
        }

        engine.attach(source)
        engine.connect(source, to: engine.mainMixerNode, format: nil)
        
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

    // MARK: - Volume & Flashlight Internal
    private func maximizeVolume() {
        // Known workaround: Use MPVolumeView slider to set system volume
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
    
    // Helpers for View
    var osColor: Color {
        return screenFlashColor == .red ? .blue : .red
    }
}

struct EmergencySirenView: View {
    var autoPlay: Bool = false
    @StateObject private var manager = SirenManager()
    @State private var showSecurityInfo = false
    @State private var isGuidedAccessActive = UIAccessibility.isGuidedAccessEnabled
    @State private var blink = false
    
    var body: some View {
        ZStack {
            // MARK: - Flashing Background
            if manager.isPlaying {
                manager.screenFlashColor
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color(uiColor: .systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack(spacing: 32) {
                Spacer()

                // Visual siren indicator (Circles)
                sirenIndicatorView
                
                Text("Emergency Siren")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(manager.isPlaying ? .white : DesignSystem.textPrimary)

                Text(manager.isPlaying ? "Distress Signal Active" : "Generates loud alarm & strobe")
                    .font(.body.weight(.medium))
                    .foregroundStyle(manager.isPlaying ? .white.opacity(0.9) : DesignSystem.textSecondary)

                if manager.isPlaying && !isGuidedAccessActive {
                    Text("TRIPLE-CLICK SIDE BUTTON TO LOCK")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.yellow)
                        .clipShape(Capsule())
                }

                // Security Status Banner (Relocated)
                Button(action: { showSecurityInfo = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: isGuidedAccessActive ? "lock.shield.fill" : "lock.open.trianglebadge.exclamationmark.fill")
                            .foregroundStyle(isGuidedAccessActive ? .green : .black)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(isGuidedAccessActive ? "Intruder Protection Active" : "Intruder Protection: OFF")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(isGuidedAccessActive ? (manager.isPlaying ? .white : DesignSystem.textPrimary) : .black)
                            
                            if !isGuidedAccessActive {
                                Text("Tap to learn how to lock buttons")
                                    .font(.caption)
                                    .foregroundStyle(isGuidedAccessActive ? (manager.isPlaying ? .white.opacity(0.7) : DesignSystem.textSecondary) : .black.opacity(0.8))
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(isGuidedAccessActive ? Color.green.opacity(0.15) : Color.yellow)
                    .cornerRadius(12)
                }
                .sheet(isPresented: $showSecurityInfo) {
                    NavigationStack {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Prevent Intruder Stop")
                                    .font(.title2.weight(.bold))
                                
                                if UIAccessibility.isGuidedAccessEnabled {
                                    Label("Guided Access is ENABLED", systemImage: "checkmark.shield.fill")
                                        .font(.headline)
                                        .foregroundStyle(.green)
                                } else {
                                    Label("Guided Access is DISABLED", systemImage: "exclamationmark.shield.fill")
                                        .font(.headline)
                                        .foregroundStyle(.orange)
                                }
                                
                                Divider()
                                
                                Text("Can this be automatic?")
                                    .font(.headline)
                                Text("No. Apple security rules prevent apps from locking the phone automatically. You must manually trigger it.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text("Why use it?")
                                    .font(.headline)
                                Text("It disables the Power Button and Volume Buttons so no one can silence your device.")
                                    .font(.body)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("How to Activate:")
                                        .font(.caption.weight(.bold))
                                    Text("1. Go to Settings > Accessibility > Guided Access > Toggle ON.")
                                    Text("2. Create a Passcode.")
                                    Text("3. Return here.")
                                    Text("4. Triple-Click the Side Button.")
                                    Text("5. CRITICAL: Tap 'Options' (bottom left) → Turn OFF EVERYTHING.")
                                        .foregroundStyle(.red)
                                        .bold()
                                    Text("   • Side Button (Sleep/Wake)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text("   • Volume Buttons")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text("   • Motion")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text("   • Keyboards")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(12)
                                
                                Divider()
                                
                                Text("Triple-Click to Activate Siren?")
                                    .font(.headline)
                                Text("Apple reserves the Side Button Triple-Click for Guided Access. However, you can use **Back Tap**.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("How to set up Back Tap:")
                                        .font(.caption.weight(.bold))
                                    Text("1. Settings > Accessibility > Touch > Back Tap.")
                                    Text("2. Choose 'Double Tap' or 'Triple Tap'.")
                                    Text("3. Scroll down to 'SHORTCUTS'.")
                                    Text("4. Select 'Start Siren'.")
                                    
                                    Button("Open Shortcuts App") {
                                        if let url = URL(string: "shortcuts://") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                    .font(.caption.weight(.bold))
                                    .padding(.top, 4)
                                }
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(12)
                            }
                            .padding()
                        }
                        .navigationTitle("Security Info")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") { showSecurityInfo = false }
                            }
                        }
                    }
                    .presentationDetents([.medium])
                }
                
                Spacer()

                // Controls
                controlsView
                    .padding(.bottom, 30)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if autoPlay {
                manager.includeStrobe = true
                manager.startSiren()
            }
            // Check Guided Access Status
            isGuidedAccessActive = UIAccessibility.isGuidedAccessEnabled
        }
        .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.guidedAccessStatusDidChangeNotification)) { _ in
            isGuidedAccessActive = UIAccessibility.isGuidedAccessEnabled
        }
        .onDisappear { manager.stopSiren() }
    }
    
    // MARK: - Subviews UI
    private var sirenIndicatorView: some View {
        ZStack {
            // Static Background Circle
            Circle()
                .fill(manager.isPlaying ? manager.osColor : Color.purple.opacity(0.1))
                .frame(width: 160, height: 160)

            // Static Icon
            Image(systemName: manager.isPlaying ? "light.beacon.max.fill" : "speaker.wave.3.fill")
                .font(.system(size: 64))
                .foregroundStyle(manager.isPlaying ? .white : DesignSystem.textPrimary)
        }
    }
    
    private var controlsView: some View {
        VStack(spacing: 24) {
            // Strobe Toggle
            Toggle(isOn: $manager.includeStrobe) {
                HStack {
                    Image(systemName: "flashlight.on.fill")
                        .foregroundStyle(manager.isPlaying ? .white.opacity(0.8) : DesignSystem.textSecondary)
                    Text("Include SOS Strobe")
                        .font(.body.weight(.medium))
                        .foregroundStyle(manager.isPlaying ? .white : DesignSystem.textPrimary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .white))
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(manager.isPlaying ? Color.black.opacity(0.2) : Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 40)
            .onChange(of: manager.includeStrobe) { _, newValue in
                if manager.isPlaying {
                    if newValue { manager.startFlash() } else { manager.stopFlash() }
                }
            }

            // Warning
            HStack(spacing: 8) {
                Image(systemName: "ear.trianglebadge.exclamationmark")
                    .font(.subheadline)
                Text("Very loud. Check device volume.")
                    .font(.caption.weight(.medium))
            }
            .foregroundStyle(manager.isPlaying ? .white.opacity(0.8) : DesignSystem.textSecondary)

            // Hold-to-Disarm Button
            LongPressButton(isPlaying: manager.isPlaying) {
                manager.toggleSiren()
            }
            .padding(.horizontal, 40)
        }
    }
}

struct LongPressButton: View {
    var isPlaying: Bool
    var action: () -> Void
    
    @State private var isHolding = false
    @State private var progress: CGFloat = 0.0
    private let holdDuration: TimeInterval = 3.0
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(isPlaying ? .white : Color.purple)
                .frame(height: 64)
            
            // Progress Fill (Red when holding to stop)
            if isPlaying {
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.red)
                        .frame(width: geo.size.width * progress, height: 64)
                        .animation(.linear(duration: 0.1), value: progress)
                }
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            
            // Text
            Text(buttonText)
                .font(.title3.weight(.bold))
                .foregroundStyle(isPlaying ? (progress > 0.5 ? .white : .red) : .white)
        }
        .scaleEffect(isHolding ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHolding)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isHolding {
                        startHolding()
                    }
                }
                .onEnded { _ in
                    stopHolding()
                }
        )
    }
    
    private var buttonText: String {
        if !isPlaying { return "ACTIVATE SIGNAL" }
        if isHolding { return "HOLD TO DISARM" }
        return "HOLD 3S TO STOP"
    }
    
    private func startHolding() {
        guard isPlaying else {
            action() // Tap to start is immediate
            return
        }
        
        isHolding = true
        progress = 0.0
        
        // Impact Haptic
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Start Timer
        let startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { t in
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
        
        // Success Haptic
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        action()
    }
}
