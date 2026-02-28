import SwiftUI
import CoreLocation

struct CompassView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var hasPlayedNorthHaptic = false
    @State private var hasPlayedTargetHaptic = false
    
    // Apple Watch Ultra / Wayfinder "Action" Orange
    private let actionOrange = Color(red: 1.0, green: 0.35, blue: 0.0)
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 20)
                
                // MARK: - Massive True North Readout
                VStack(spacing: -8) {
                    Text("\(Int(locationManager.trueNorth))°")
                        .font(.system(size: 110, weight: .ultraLight, design: .rounded).monospacedDigit())
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    
                    Text(cardinalFromHeading(locationManager.trueNorth))
                        .font(.system(size: 28, weight: .medium, design: .rounded))
                        .foregroundStyle(locationManager.isLocked ? actionOrange : .white)
                }
                .padding(.bottom, 60)
                
                Spacer()
                
                // MARK: - Precision Mechanical Dial
                ZStack {
                    // Outer structural ring
                    Circle()
                        .stroke(Color(white: 0.1), lineWidth: 1)
                        .frame(width: 340, height: 340)

                    // Hash Marks (144 subdivisions for precision)
                    ForEach(0..<144) { tick in
                        let isMajor = tick % 36 == 0 // 90 degrees
                        let isMinor = tick % 12 == 0 // 30 degrees
                        let isTick = tick % 4 == 0   // 10 degrees

                        Capsule()
                            .fill(isMajor ? Color.white : (isMinor ? Color(white: 0.6) : (isTick ? Color(white: 0.4) : Color(white: 0.2))))
                            .frame(
                                width: isMajor ? 3 : (isMinor ? 2 : 1),
                                height: isMajor ? 18 : (isMinor ? 12 : 6)
                            )
                            .offset(y: -160)
                            .rotationEffect(.degrees(Double(tick) * 2.5))
                    }
                    
                    // Rotating Inner Dial Plate
                    ZStack {
                        // Degree markers inside
                        ForEach(0..<12) { i in
                            if i % 3 != 0 { 
                                Text("\(i * 30)")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color(white: 0.5))
                                    .offset(y: -120)
                                    .rotationEffect(.degrees(Double(i) * 30))
                            }
                        }
                        
                        // Cardinal Directions
                        ForEach(Cardinal.allCases, id: \.self) { cardinal in
                            Text(cardinal.rawValue)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(cardinal == .N ? actionOrange : .white)
                                .offset(y: -120)
                                .rotationEffect(.degrees(cardinal.degree))
                        }
                        
                        // Ultra-thin crosshairs
                        Path { path in
                            path.move(to: CGPoint(x: 170, y: 70))
                            path.addLine(to: CGPoint(x: 170, y: 270))
                            path.move(to: CGPoint(x: 70, y: 170))
                            path.addLine(to: CGPoint(x: 270, y: 170))
                        }
                        .stroke(Color(white: 0.3), lineWidth: 0.5)
                        
                    }
                    .frame(width: 340, height: 340)
                    // Fluid, weight-bearing compass rotation
                    .rotationEffect(.degrees(-locationManager.trueNorth))
                    .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.7), value: locationManager.trueNorth)
                    
                    // Center Targeting Reticle
                    Image(systemName: "plus")
                        .font(.system(size: 32, weight: .ultraLight))
                        .foregroundStyle(locationManager.isLocked ? actionOrange : .white)
                    
                    // Locked True North Indicator (Top fixed needle)
                    Path { path in
                        path.move(to: CGPoint(x: 170, y: -10))
                        path.addLine(to: CGPoint(x: 170, y: 24))
                    }
                    .stroke(locationManager.isLocked ? actionOrange : .white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 340, height: 340)
                    
                    // Active SOS / Waypoint Indicator (Green)
                    if let targetBearing = locationManager.targetBearing {
                        ZStack {
                            Image(systemName: "triangle.fill")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(Color.green)
                                .offset(y: -160)
                            
                            if let icon = locationManager.activeTarget?.icon {
                                Image(systemName: icon)
                                    .font(.system(size: 14, weight: .heavy))
                                    .foregroundStyle(Color.black)
                                    .padding(8)
                                    .background(Color.green)
                                    .clipShape(Circle())
                                    .shadow(color: .green.opacity(0.4), radius: 8)
                                    .offset(y: -190)
                            }
                        }
                        // Rotates opposite the dial to match world coords
                        .rotationEffect(.degrees(targetBearing - locationManager.trueNorth))
                        .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.7), value: targetBearing - locationManager.trueNorth)
                    }
                }
                .frame(width: 340, height: 340)
                // Lock trigger with rigid tactile feedback
                .onTapGesture {
                    let generator = UIImpactFeedbackGenerator(style: .rigid)
                    generator.impactOccurred()
                    locationManager.toggleLock()
                }
                
                Spacer()
                
                // MARK: - Waypoint / Metric Display
                if let distance = locationManager.distanceToTarget, let target = locationManager.activeTarget {
                    VStack(spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "location.north.circle.fill")
                            Text(target.name.uppercased())
                        }
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.green)
                        .kerning(1)
                        
                        Text(formatDistance(distance))
                            .font(.system(size: 40, weight: .medium, design: .rounded).monospacedDigit())
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 60)
                } else {
                    // Lock status label
                    if locationManager.isLocked {
                        Text("BEARING LOCKED")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.red)
                            .kerning(2)
                            .padding(.bottom, 60)
                    } else {
                        Text("TAP TO LOCK BEARING")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color(white: 0.3))
                            .kerning(2)
                            .padding(.bottom, 60)
                    }
                }
            }
        }
        .navigationTitle("Compass")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            locationManager.requestPermission()
        }
        .onChange(of: locationManager.trueNorth) { _, newHeading in
            let normalized = newHeading < 0 ? newHeading + 360 : newHeading
            let distToNorth = min(abs(normalized - 0), abs(normalized - 360))
            
            // Haptic bump across True North
            if distToNorth < 2 {
                if !hasPlayedNorthHaptic {
                    HapticsService.shared.playImpact(style: .medium)
                    hasPlayedNorthHaptic = true
                }
            } else {
                hasPlayedNorthHaptic = false
            }
            
            // Haptic success on Waypoint Alignment
            if let target = locationManager.targetBearing {
                let rawDiff = abs(normalized - target)
                let diff = min(rawDiff, 360 - rawDiff)
                if diff < 2 {
                    if !hasPlayedTargetHaptic {
                        HapticsService.shared.playNotification(type: .success)
                        hasPlayedTargetHaptic = true
                    }
                } else {
                    hasPlayedTargetHaptic = false
                }
            }
        }
        .onDisappear {
            locationManager.stopUpdating()
        }
    }
    
    private func cardinalFromHeading(_ heading: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"]
        let index = Int((heading + 22.5) / 45.0)
        return directions[index]
    }
    
    private func formatDistance(_ meters: Double) -> String {
        if meters < 1000 {
            return String(format: "%.0f m", meters)
        } else {
            return String(format: "%.1f km", meters / 1000)
        }
    }
}

enum Cardinal: String, CaseIterable {
    case N, E, S, W
    var degree: Double {
        switch self {
        case .N: return 0
        case .E: return 90
        case .S: return 180
        case .W: return 270
        }
    }
}
