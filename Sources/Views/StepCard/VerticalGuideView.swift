import SwiftUI

struct VerticalGuideView: View {
    let technique: Technique
    @State private var expandedStep: Int? = 0 // Start with step 1 open
    @Environment(\.dismiss) var dismiss
    
    // Voice Control
    @ObservedObject private var speech = SpeechRecognitionService.shared
    @State private var isAudioReadingEnabled = false
    @State private var idleSpeechTimer: Timer?
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack {
                DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // MARK: - Header
                        headerView
                        

                        // MARK: - Steps List
                        VStack(spacing: 16) {
                            ForEach(0..<technique.steps.count, id: \.self) { index in
                                StepAccordionRow(
                                    step: technique.steps[index],
                                    stepIndex: index,
                                    domain: technique.domain,
                                    expandedStep: $expandedStep
                                )
                                .id(index) // Anchor for scrolling
                            }
                        }
                        
                        // MARK: - Source Link & Glossary
                        HStack {
                            if let sourceName = technique.sourceName, let sourceUrl = technique.sourceUrl, let url = URL(string: sourceUrl) {
                                Link(destination: url) {
                                    HStack(spacing: 6) {
                                        Text("Source:")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                        
                                        Text(sourceName)
                                            .font(.footnote.weight(.semibold))
                                            .foregroundStyle(technique.domain.color)
                                            .underline()
                                        
                                        Image(systemName: "arrow.up.right")
                                            .font(.caption2)
                                            .foregroundStyle(technique.domain.color)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: GlossaryView()) {
                                HStack(spacing: 4) {
                                    Image(systemName: "text.book.closed.fill")
                                    Text("Glossary")
                                }
                                .font(.footnote.weight(.medium))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        

                        // MARK: - Special Tool Redirects
                        if technique.id == "rescue-morse-code" {
                            NavigationLink(destination: SOSFlashlightView()) {
                                HStack {
                                    Image(systemName: "flashlight.on.fill")
                                        .font(.title2)
                                    VStack(alignment: .leading) {
                                        Text("Open SOS Flashlight Tool")
                                            .font(.headline)
                                        Text("Use your phone's camera flash to send SOS automatically.")
                                            .font(.caption)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .padding()
                                .background(Color.orange.opacity(0.15))
                                .foregroundStyle(.orange)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                            }
                        }
                        
                        // MARK: - Related Techniques
                        if let relatedIds = technique.relatedIds, !relatedIds.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Related Guides")
                                .font(.title3.weight(.bold))
                                .foregroundStyle(DesignSystem.textPrimary)
                                .padding(.horizontal, 20)
                            
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(relatedIds, id: \.self) { id in
                                            if let relatedTechnique = ContentDatabase.shared.techniques.first(where: { $0.id == id }) {
                                                NavigationLink(destination: VerticalGuideView(technique: relatedTechnique)) {
                                                    RelatedTechniqueCard(technique: relatedTechnique)
                                                }
                                                .buttonStyle(ScalableButtonStyle())
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            .padding(.top, 24)
                        }
                        
                        Spacer().frame(height: 120) // Space for floating button
                    }
                }
                .onChange(of: speech.detectedCommand) { _, command in
                    guard let command = command else { return }
                    withAnimation {
                        if command == "next" {
                            if let current = expandedStep, current < technique.steps.count - 1 {
                                expandedStep = current + 1
                                proxy.scrollTo(current + 1, anchor: .center)
                                HapticsService.shared.playImpact(style: .medium)
                            }
                        } else if command == "back" {
                            if let current = expandedStep, current > 0 {
                                expandedStep = current - 1
                                proxy.scrollTo(current - 1, anchor: .center)
                                HapticsService.shared.playImpact(style: .light)
                            }
                        } else if command == "stop" {
                            speech.stopListening()
                        }
                    }
                }
                .onChange(of: expandedStep) { _, newStep in
                    if let stepIndex = newStep, isAudioReadingEnabled {
                        let step = technique.steps[stepIndex]
                        let fullText = "\(step.instruction). \(step.helpDetail)"
                        speech.speak(fullText)
                        scheduleIdleSpeechTimer(text: fullText)
                    }
                }
                .onChange(of: speech.isSpeaking) { _, isSpeaking in
                    if !isSpeaking && isAudioReadingEnabled {
                        // Speech just finished. Start the exact 15 second timer.
                        if let currentStep = expandedStep {
                            let step = technique.steps[currentStep]
                            let fullText = "\(step.instruction). \(step.helpDetail)"
                            scheduleIdleSpeechTimer(text: fullText)
                        }
                    } else if isSpeaking {
                        // Pause the timer while speaking
                        idleSpeechTimer?.invalidate()
                    }
                }
                
                // MARK: - Floating Action Button
                VStack {
                    Spacer()
                    if let current = expandedStep, current < technique.steps.count - 1 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                expandedStep = current + 1
                                proxy.scrollTo(current + 1, anchor: .center)
                            }
                            HapticsService.shared.playImpact(style: .medium)
                        }) {
                            Text("Next Step")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(technique.domain.color)
                                .clipShape(Capsule())
                                .shadow(color: technique.domain.color.opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        .padding(.bottom, 30)
                        .transition(.scale.combined(with: .opacity))
                    } else if expandedStep == technique.steps.count - 1 {
                        Button(action: {
                            dismiss()
                            HapticsService.shared.playNotification(type: .success)
                        }) {
                            Text("Finish Guide")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(Color.green)
                                .clipShape(Capsule())
                                .shadow(color: Color.green.opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Voice control opt-in via top-right toggle
            }
            .onDisappear {
                speech.stopListening()
                speech.stopSpeaking()
                idleSpeechTimer?.invalidate()
            }
        }
    }
    
    // MARK: - Auto-Repeat Timer Logic
    private func scheduleIdleSpeechTimer(text: String) {
        // Invalidate any existing timer
        idleSpeechTimer?.invalidate()
        
        // Wait 8 seconds after the current speech finishes before repeating
        idleSpeechTimer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { _ in
            if isAudioReadingEnabled, !speech.isSpeaking {
                speech.speak(text)
            }
        }
    }
}

extension VerticalGuideView {
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.headline)
                    .foregroundStyle(technique.domain.color)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    // Text-to-Speech Toggle
                    Button(action: {
                        isAudioReadingEnabled.toggle()
                        if !isAudioReadingEnabled {
                            speech.stopSpeaking()
                            idleSpeechTimer?.invalidate()
                        } else {
                            if let currentStep = expandedStep {
                                let step = technique.steps[currentStep]
                                let fullText = "\(step.instruction). \(step.helpDetail)"
                                speech.speak(fullText)
                                scheduleIdleSpeechTimer(text: fullText)
                            }
                        }
                        HapticsService.shared.playImpact(style: .light)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: isAudioReadingEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill")
                                .foregroundStyle(isAudioReadingEnabled ? technique.domain.color : .secondary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                    }

                    // Voice Control Toggle (Mic)
                    Button(action: {
                        if speech.isRecording {
                            speech.stopListening()
                            HapticsService.shared.playImpact(style: .light)
                        } else {
                            do {
                                try speech.startListening()
                                HapticsService.shared.playImpact(style: .medium)
                            } catch {
                                print("Voice control failed: \(error)")
                            }
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: speech.isRecording ? "mic.fill" : "mic.slash.fill")
                                .foregroundStyle(speech.isRecording ? .red : .secondary)
                                .symbolEffect(.pulse.byLayer, isActive: speech.isRecording)
                            
                            Text(speech.isRecording ? "Listening" : "Hands-Free")
                                .font(.caption2.bold())
                                .foregroundStyle(speech.isRecording ? .red : .secondary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(speech.isRecording ? Color.red.opacity(0.3) : Color.clear, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.bottom, 6)
            
            Text(technique.name)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(DesignSystem.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(technique.subtitle)
                .font(.body)
                .foregroundStyle(DesignSystem.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

struct RelatedTechniqueCard: View {
    let technique: Technique
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(technique.domain.color.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: technique.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(technique.domain.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(technique.name)
                    .font(.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(technique.domain.rawValue.capitalized)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(technique.domain.color)
            }
        }
        .padding(16)
        .frame(width: 160, height: 180, alignment: .topLeading)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        )
    }
}
