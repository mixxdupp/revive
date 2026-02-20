import Foundation
import CoreGraphics
import ImageIO

let size = CGSize(width: 1024, height: 1024)
let colorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue

guard let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo) else {
    print("Cannot create context")
    exit(1)
}

// Background Yellow
ctx.setFillColor(red: 254/255.0, green: 216/255.0, blue: 15/255.0, alpha: 1.0)
ctx.fill(CGRect(origin: .zero, size: size))

ctx.setLineCap(.round)
ctx.setLineJoin(.round)
ctx.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1.0)

// ---- LOGS ----
ctx.setLineWidth(24)
let fX: CGFloat = 630
let fY: CGFloat = 720
ctx.move(to: CGPoint(x: fX - 120, y: fY + 20)); ctx.addLine(to: CGPoint(x: fX + 120, y: fY + 40)); ctx.strokePath()
ctx.move(to: CGPoint(x: fX - 130, y: fY + 50)); ctx.addLine(to: CGPoint(x: fX + 110, y: fY - 10)); ctx.strokePath()
ctx.move(to: CGPoint(x: fX - 100, y: fY - 10)); ctx.addLine(to: CGPoint(x: fX + 130, y: fY + 60)); ctx.strokePath()
ctx.move(to: CGPoint(x: fX - 110, y: fY + 80)); ctx.addLine(to: CGPoint(x: fX + 100, y: fY - 40)); ctx.strokePath()
ctx.move(to: CGPoint(x: fX - 140, y: fY + 10)); ctx.addLine(to: CGPoint(x: fX + 140, y: fY + 20)); ctx.strokePath()

// ---- FLAME OUTER ----
ctx.setFillColor(red: 242/255.0, green: 78/255.0, blue: 33/255.0, alpha: 1.0)
ctx.beginPath()
ctx.move(to: CGPoint(x: fX - 10, y: fY - 280))
ctx.addCurve(to: CGPoint(x: fX + 80, y: fY - 60), control1: CGPoint(x: fX + 30, y: fY - 170), control2: CGPoint(x: fX + 90, y: fY - 120))
ctx.addCurve(to: CGPoint(x: fX - 80, y: fY - 60), control1: CGPoint(x: fX + 70, y: fY + 10), control2: CGPoint(x: fX - 70, y: fY + 10))
ctx.addCurve(to: CGPoint(x: fX - 10, y: fY - 280), control1: CGPoint(x: fX - 90, y: fY - 120), control2: CGPoint(x: fX - 50, y: fY - 170))
ctx.fillPath()

// ---- FLAME INNER ----
ctx.setFillColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0)
ctx.beginPath()
ctx.move(to: CGPoint(x: fX - 10, y: fY - 160))
ctx.addCurve(to: CGPoint(x: fX + 40, y: fY - 60), control1: CGPoint(x: fX + 10, y: fY - 110), control2: CGPoint(x: fX + 50, y: fY - 80))
ctx.addCurve(to: CGPoint(x: fX - 50, y: fY - 60), control1: CGPoint(x: fX + 30, y: fY - 20), control2: CGPoint(x: fX - 40, y: fY - 20))
ctx.addCurve(to: CGPoint(x: fX - 10, y: fY - 160), control1: CGPoint(x: fX - 60, y: fY - 90), control2: CGPoint(x: fX - 30, y: fY - 110))
ctx.fillPath()

// ---- FIGURE ----
ctx.setLineWidth(42.0)
let hX: CGFloat = 360
let hY: CGFloat = 280

// Head
ctx.strokeEllipse(in: CGRect(x: hX - 60, y: hY - 60, width: 120, height: 120))

// Body
ctx.beginPath()
ctx.move(to: CGPoint(x: hX - 20, y: hY + 60))
ctx.addQuadCurve(to: CGPoint(x: hX - 80, y: hY + 300), control: CGPoint(x: hX - 60, y: hY + 150))
ctx.strokePath()

// Back Leg
ctx.beginPath()
ctx.move(to: CGPoint(x: hX - 80, y: hY + 300))
ctx.addLine(to: CGPoint(x: hX - 80, y: hY + 440))
ctx.addLine(to: CGPoint(x: hX - 220, y: hY + 440))
ctx.strokePath()

// Front Leg
ctx.beginPath()
ctx.move(to: CGPoint(x: hX - 80, y: hY + 300))
ctx.addLine(to: CGPoint(x: hX + 90, y: hY + 280))
ctx.addLine(to: CGPoint(x: hX + 90, y: hY + 440))
ctx.addLine(to: CGPoint(x: hX + 180, y: hY + 440))
ctx.strokePath()

// Arm
ctx.beginPath()
ctx.move(to: CGPoint(x: hX - 50, y: hY + 120))
ctx.addLine(to: CGPoint(x: hX + 150, y: hY + 240))
ctx.strokePath()

// Hand/Sticks
ctx.setLineWidth(16)
ctx.move(to: CGPoint(x: hX + 120, y: hY + 140)); ctx.addLine(to: CGPoint(x: hX + 220, y: hY + 280)); ctx.strokePath()
ctx.move(to: CGPoint(x: hX + 150, y: hY + 120)); ctx.addLine(to: CGPoint(x: hX + 260, y: hY + 260)); ctx.strokePath()


// Save to file
guard let imageRef = ctx.makeImage() else { exit(1) }
let url = URL(fileURLWithPath: "appicon_raw.png")
guard let destination = CGImageDestinationCreateWithURL(url as CFURL, "public.png" as CFString, 1, nil) else { exit(1) }
CGImageDestinationAddImage(destination, imageRef, nil)
CGImageDestinationFinalize(destination)

print("SUCCESS")
