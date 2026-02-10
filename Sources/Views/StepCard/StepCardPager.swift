import SwiftUI

struct StepCardPager: View {
    let technique: Technique
    @State private var currentStepIndex = 0
    @State private var isHandsFreeMode = false
    @State private var relatedTechniques: [Technique] = []
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var speechSynthesizer = SpeechSynthesisService.shared
    @ObservedObject private var speechRecognizer = SpeechRecognitionService.shared
    
    var body: some View {
        ZStack {
            DesignSystem.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        stopServices()
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(Typography.button)
                        .foregroundColor(DesignSystem.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text("Step \(currentStepIndex + 1)/\(technique.steps.count)")
                        .font(Typography.caption)
                        .foregroundColor(DesignSystem.textSecondary)
                }
                .padding(.horizontal, Layout.screenPadding)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                // TabView for Paging
                TabView(selection: $currentStepIndex) {
                    ForEach(0..<technique.steps.count, id: \.self) { index in
                        StepCardView(
                            technique: technique,
                            step: technique.steps[index],
                            stepIndex: index
                        )
                        .tag(index)
                    }
                    
                    // Final "What's Next" Card
                    RelatedTechniquesCard(
                        technique: technique,
                        relatedTechniques: relatedTechniques,
                        onDismiss: { dismiss() }
                    )
                    .tag(technique.steps.count)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: currentStepIndex) { newIndex in
                    if isHandsFreeMode {
                        speakCurrentStep()
                    }
                    HapticsService.shared.playImpact(style: .light)
                }
                
                // Footer
                VStack(spacing: 12) {
                    ProgressDots(
                        total: technique.steps.count + 1,
                        current: currentStepIndex,
                        activeColor: technique.domain.color
                    )
                    
                    // Hands Free Button
                    Button(action: {
                        toggleHandsFree()
                    }) {
                        HStack {
                            Image(systemName: isHandsFreeMode ? "mic.fill" : "mic.slash.fill")
                            Text(isHandsFreeMode ? "Listening..." : "Go Hands-Free")
                        }
                        .font(Typography.button)
                        .foregroundColor(DesignSystem.textPrimary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            isHandsFreeMode ? DesignSystem.emergencyRed : technique.domain.color.opacity(0.8)
                        )
                        .clipShape(Capsule())
                        .animation(Animations.cardRelease, value: isHandsFreeMode)
                    }
                }
                .padding(.bottom, 30)
            }
            
            // Voice Command Toast
            if isHandsFreeMode && speechRecognizer.isRecording {
                VStack {
                    Spacer()
                    Text("Say 'Next' or 'Back'")
                        .font(Typography.caption)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                        .padding(.bottom, 100)
                }
                .transition(.opacity)
            }
        }
        .navigationBarHidden(true)
        .onReceive(speechRecognizer.$detectedCommand) { command in
            guard let command = command, isHandsFreeMode else { return }
            handleVoiceCommand(command)
        }
        .onDisappear {
            stopServices()
        }
        .onAppear {
            relatedTechniques = ContentDatabase.shared.getRelatedTechniques(for: technique)
        }
    }
    
    private func toggleHandsFree() {
        isHandsFreeMode.toggle()
        if isHandsFreeMode {
            startHandsFree()
        } else {
            stopServices()
        }
    }
    
    private func startHandsFree() {
        do {
            try speechRecognizer.startListening()
            speakCurrentStep()
        } catch {
            print("Failed to start speech recognition")
            isHandsFreeMode = false
        }
    }
    
    private func stopServices() {
        speechSynthesizer.stop()
        speechRecognizer.stopListening()
        isHandsFreeMode = false
    }
    
    private func speakCurrentStep() {
        if currentStepIndex < technique.steps.count {
            let step = technique.steps[currentStepIndex]
            let text = "Step \(step.stepNumber). \(step.instruction). \(step.helpDetail)"
            speechSynthesizer.speak(text)
        } else {
            speechSynthesizer.speak("You have completed this technique. Say next to see related skills.")
        }
    }
    
    private func handleVoiceCommand(_ command: String) {
        switch command {
        case "next":
            if currentStepIndex < technique.steps.count {
                withAnimation { currentStepIndex += 1 }
            } else {
                speechSynthesizer.speak("You are at the end.")
            }
        case "back":
            if currentStepIndex > 0 {
                withAnimation { currentStepIndex -= 1 }
            } else {
                speechSynthesizer.speak("You are at the first step.")
            }
        case "stop":
            toggleHandsFree()
        case "repeat":
            speakCurrentStep()
        default:
            break
        }
    }
}
