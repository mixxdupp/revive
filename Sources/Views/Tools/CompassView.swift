import SwiftUI
import CoreLocation

struct CompassView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var hasPlayedNorthHaptic = false
    @State private var hasPlayedTargetHaptic = false
    
    var body: some View {
        ZStack {
            // Background
            DesignSystem.backgroundPrimary
                .ignoresSafeArea()
            
            // Mesh Gradient
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Color.teal.opacity(0.1))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: -100, y: -100)
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 8) {
                    Text("Compass")
                        .font(.system(size: 32, weight: .black))
                        .foregroundStyle(DesignSystem.textPrimary)
                    
                    Text(locationManager.isLocked ? "Bearing Locked" : "Tap Center to Lock")
                        .font(.subheadline)
                        .foregroundStyle(locationManager.isLocked ? Color.red : DesignSystem.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(locationManager.isLocked ? Color.red.opacity(0.1) : Color.clear)
                        )
                }
                .padding(.top, 20)
                
                // Compass Rose
                ZStack {
                    // Static Tick Marks (Outer Ring)
                    ForEach(0..<72) { tick in
                        Rectangle()
                            .fill(tick % 18 == 0 ? DesignSystem.textPrimary : DesignSystem.textSecondary.opacity(0.5))
                            .frame(width: tick % 18 == 0 ? 3 : 1, height: tick % 18 == 0 ? 20 : 10)
                            .offset(y: -140)
                            .rotationEffect(.degrees(Double(tick) * 5))
                    }
                    
                    // Rotating Rose
                    ZStack {
                        // Cardinal Directions
                        ForEach(Cardinal.allCases, id: \.self) { cardinal in
                            Text(cardinal.rawValue)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(cardinal == .N ? Color.red : DesignSystem.textPrimary)
                                .offset(y: -110)
                                .rotationEffect(.degrees(cardinal.degree))
                        }
                        
                        // Needle/Rose Body
                        Image(systemName: "location.north.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .foregroundStyle(Color.red)
                            .padding()
                    }
                    .rotationEffect(.degrees(-locationManager.trueNorth))
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: locationManager.trueNorth)
                    
                    // Lock Indicator
                    if locationManager.isLocked {
                        Rectangle()
                            .fill(Color.green)
                            .frame(width: 4, height: 50)
                            .offset(y: -140) // Top center fixed
                    }
                    
                    // Target Indicator (Ghost Needle)
                    if let targetBearing = locationManager.targetBearing {
                        ZStack {
                            // The Needle
                            Image(systemName: "arrow.up")
                                .font(.system(size: 40, weight: .black))
                                .foregroundStyle(Color.green)
                                .offset(y: -120)
                            
                            // Target Icon
                            if let icon = locationManager.activeTarget?.icon {
                                Image(systemName: icon)
                                    .font(.caption.bold())
                                    .foregroundStyle(Color.black)
                                    .padding(4)
                                    .background(Color.green)
                                    .clipShape(Circle())
                                    .offset(y: -155)
                            }
                        }
                        .rotationEffect(.degrees(targetBearing)) // Rotates to point to target (relative to North)
                    }
                    

                }
                .frame(width: 300, height: 300)
                .onTapGesture {
                    locationManager.toggleLock()
                }
                
                // Readout
                VStack(spacing: 4) {
                    Text("\(Int(locationManager.trueNorth))°")
                        .font(.system(size: 64, weight: .light, design: .monospaced))
                        .foregroundStyle(DesignSystem.textPrimary)
                    
                    Text(cardinalFromHeading(locationManager.trueNorth))
                        .font(.title2)
                        .foregroundStyle(DesignSystem.textSecondary)
                    
                    if let distance = locationManager.distanceToTarget, let target = locationManager.activeTarget {
                        VStack(spacing: 2) {
                            Text(target.name)
                                .font(.headline)
                                .foregroundStyle(Color.green)
                            
                            Text(formatDistance(distance))
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                                .foregroundStyle(Color.green)
                        }
                        .padding(.top, 16)
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            locationManager.requestPermission()
        }
        .onChange(of: locationManager.trueNorth) { _, newHeading in
            // 1. North Alignment Haptic (Light)
            // Normalize heading to 0-360
            let normalized = newHeading < 0 ? newHeading + 360 : newHeading
            let distToNorth = min(abs(normalized - 0), abs(normalized - 360))
            
            if distToNorth < 3 { // 3 degree tolerance
                if !hasPlayedNorthHaptic {
                    HapticsService.shared.playImpact(style: .light)
                    hasPlayedNorthHaptic = true
                }
            } else {
                hasPlayedNorthHaptic = false
            }
            
            // 2. Target Alignment Haptic (Heavy + Success)
            if let target = locationManager.targetBearing {
                let rawDiff = abs(normalized - target)
                let diff = min(rawDiff, 360 - rawDiff) // Handle wrap-around
                
                if diff < 3 {
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
            return String(format: "%.2f km", meters / 1000)
        }
    }
    

}

enum Cardinal: String, CaseIterable {
    case N
    case E
    case S
    case W
    
    var degree: Double {
        switch self {
        case .N: return 0
        case .E: return 90
        case .S: return 180
        case .W: return 270
        }
    }
}
