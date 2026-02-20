import Cocoa

let size = CGSize(width: 1024, height: 1024)
let image = NSImage(size: size)

image.lockFocus()

guard let ctx = NSGraphicsContext.current?.cgContext else {
    print("No context")
    exit(1)
}

// Flip context to top-down
ctx.translateBy(x: 0, y: size.height)
ctx.scaleBy(x: 1, y: -1)

// Background
ctx.setFillColor(NSColor(red: 254/255.0, green: 216/255.0, blue: 0/255.0, alpha: 1.0).cgColor)
ctx.fill(CGRect(origin: .zero, size: size))

ctx.setStrokeColor(NSColor.black.cgColor)
ctx.setLineCap(.round)
ctx.setLineJoin(.round)

// Draw Fire
let fireX: CGFloat = 630
let fireY: CGFloat = 650 // centered fire bottom

// Sticks for fire
ctx.setLineWidth(16)
ctx.move(to: CGPoint(x: fireX - 100, y: fireY + 40))
ctx.addLine(to: CGPoint(x: fireX + 100, y: fireY - 20))

ctx.move(to: CGPoint(x: fireX + 100, y: fireY + 40))
ctx.addLine(to: CGPoint(x: fireX - 100, y: fireY - 20))

ctx.move(to: CGPoint(x: fireX - 70, y: fireY + 50))
ctx.addLine(to: CGPoint(x: fireX + 110, y: fireY + 5))

ctx.move(to: CGPoint(x: fireX + 70, y: fireY + 50))
ctx.addLine(to: CGPoint(x: fireX - 110, y: fireY + 5))

ctx.move(to: CGPoint(x: fireX - 140, y: fireY + 20))
ctx.addLine(to: CGPoint(x: fireX + 130, y: fireY + 30))
ctx.strokePath()

// Draw Flame
ctx.setFillColor(NSColor(red: 239/255.0, green: 76/255.0, blue: 35/255.0, alpha: 1.0).cgColor) // Orange/Red
ctx.move(to: CGPoint(x: fireX, y: fireY - 180))
ctx.addCurve(to: CGPoint(x: fireX + 60, y: fireY - 30),
             control1: CGPoint(x: fireX + 40, y: fireY - 100),
             control2: CGPoint(x: fireX + 80, y: fireY - 60))
ctx.addCurve(to: CGPoint(x: fireX, y: fireY - 60),
             control1: CGPoint(x: fireX + 20, y: fireY - 50),
             control2: CGPoint(x: fireX + 30, y: fireY - 60))
ctx.addCurve(to: CGPoint(x: fireX - 60, y: fireY - 30),
             control1: CGPoint(x: fireX - 20, y: fireY - 60),
             control2: CGPoint(x: fireX - 40, y: fireY - 50))
ctx.addCurve(to: CGPoint(x: fireX, y: fireY - 180),
             control1: CGPoint(x: fireX - 60, y: fireY - 80),
             control2: CGPoint(x: fireX - 30, y: fireY - 100))
ctx.fillPath()

// Inner flame
ctx.setFillColor(NSColor(red: 250/255.0, green: 204/255.0, blue: 21/255.0, alpha: 1.0).cgColor) // Yellow inside
ctx.move(to: CGPoint(x: fireX, y: fireY - 110))
ctx.addCurve(to: CGPoint(x: fireX + 30, y: fireY - 40),
             control1: CGPoint(x: fireX + 20, y: fireY - 80),
             control2: CGPoint(x: fireX + 35, y: fireY - 60))
ctx.addCurve(to: CGPoint(x: fireX, y: fireY - 60),
             control1: CGPoint(x: fireX + 10, y: fireY - 50),
             control2: CGPoint(x: fireX + 15, y: fireY - 60))
ctx.addCurve(to: CGPoint(x: fireX - 30, y: fireY - 40),
             control1: CGPoint(x: fireX - 10, y: fireY - 60),
             control2: CGPoint(x: fireX - 20, y: fireY - 50))
ctx.addCurve(to: CGPoint(x: fireX, y: fireY - 110),
             control1: CGPoint(x: fireX - 30, y: fireY - 70),
             control2: CGPoint(x: fireX - 20, y: fireY - 90))
ctx.fillPath()


// Stick Figure
ctx.setLineWidth(32)
let hips = CGPoint(x: 350, y: 560)

// Back Leg (Kneeling)
ctx.move(to: hips)
let backKnee = CGPoint(x: hips.x - 20, y: hips.y + 110)
ctx.addLine(to: backKnee)
ctx.addLine(to: CGPoint(x: hips.x - 140, y: hips.y + 110))
ctx.strokePath()

// Torso (curved)
ctx.move(to: hips)
let neck = CGPoint(x: hips.x + 30, y: hips.y - 180)
ctx.addQuadCurve(to: neck, control: CGPoint(x: hips.x - 40, y: hips.y - 90))
ctx.strokePath()

// Front Leg (Foot flat, knee up)
ctx.move(to: hips)
let frontKnee = CGPoint(x: hips.x + 130, y: hips.y - 40)
let frontAnkle = CGPoint(x: hips.x + 130, y: hips.y + 110)
ctx.addLine(to: frontKnee)
ctx.addLine(to: frontAnkle)
// Front foot flat on ground
ctx.addLine(to: CGPoint(x: frontAnkle.x + 50, y: frontAnkle.y))
ctx.strokePath()

// Arms
ctx.move(to: CGPoint(x: hips.x + 10, y: hips.y - 130))
let hand = CGPoint(x: hips.x + 180, y: hips.y + 10)
let elbow = CGPoint(x: hips.x + 40, y: hips.y)
// Give elbow some bend
ctx.addLine(to: elbow)
ctx.addLine(to: hand)
ctx.strokePath()

// Head (not filled)
ctx.setLineWidth(32)
ctx.addArc(center: CGPoint(x: neck.x + 20, y: neck.y - 60), radius: 60, startAngle: 0, endAngle: .pi * 2, clockwise: true)
ctx.strokePath()

// Rubbing sticks
ctx.setLineWidth(16)
ctx.move(to: CGPoint(x: hand.x - 40, y: hand.y + 20))
ctx.addLine(to: CGPoint(x: fireX - 30, y: fireY - 40)) // Point to fire
ctx.move(to: CGPoint(x: hand.x - 10, y: hand.y + 40))
ctx.addLine(to: CGPoint(x: fireX + 10, y: fireY - 70))
ctx.strokePath()


image.unlockFocus()

let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
let pngData = bitmapRep.representation(using: .png, properties: [:])!

let fileURL = URL(fileURLWithPath: "app_icon_fire_starter.png")
try! pngData.write(to: fileURL)
print("Saved to \(fileURL.path)")
