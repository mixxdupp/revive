import Cocoa

let size = CGSize(width: 1024, height: 1024)
let image = NSImage(size: size)
image.lockFocus()

guard let ctx = NSGraphicsContext.current?.cgContext else { exit(1) }

// Flip coordinates so (0,0) is top-left
ctx.translateBy(x: 0, y: size.height)
ctx.scaleBy(x: 1, y: -1)

// Background
ctx.setFillColor(NSColor(red: 254/255.0, green: 216/255.0, blue: 15/255.0, alpha: 1.0).cgColor)
ctx.fill(CGRect(origin: .zero, size: size))

ctx.setLineCap(.round)
ctx.setLineJoin(.round)
let black = NSColor.black.cgColor
let lineWidth: CGFloat = 42.0

func drawLine(_ p1: CGPoint, _ p2: CGPoint) {
    ctx.move(to: p1)
    ctx.addLine(to: p2)
    ctx.strokePath()
}

// Draw Logs
ctx.setStrokeColor(black)
ctx.setLineWidth(24)
let fX: CGFloat = 630
let fY: CGFloat = 720

// Cross lines for logs
drawLine(CGPoint(x: fX - 120, y: fY + 20), CGPoint(x: fX + 120, y: fY + 40))
drawLine(CGPoint(x: fX - 130, y: fY + 50), CGPoint(x: fX + 110, y: fY - 10))
drawLine(CGPoint(x: fX - 100, y: fY - 10), CGPoint(x: fX + 130, y: fY + 60))
drawLine(CGPoint(x: fX - 110, y: fY + 80), CGPoint(x: fX + 100, y: fY - 40))
drawLine(CGPoint(x: fX - 140, y: fY + 10), CGPoint(x: fX + 140, y: fY + 20))


// Draw Flame
ctx.setFillColor(NSColor(red: 242/255.0, green: 78/255.0, blue: 33/255.0, alpha: 1.0).cgColor)
ctx.beginPath()
ctx.move(to: CGPoint(x: fX - 10, y: fY - 280)) // Top tip
ctx.addCurve(to: CGPoint(x: fX + 80, y: fY - 60), control1: CGPoint(x: fX + 30, y: fY - 170), control2: CGPoint(x: fX + 90, y: fY - 120))
ctx.addCurve(to: CGPoint(x: fX - 80, y: fY - 60), control1: CGPoint(x: fX + 70, y: fY + 10), control2: CGPoint(x: fX - 70, y: fY + 10))
ctx.addCurve(to: CGPoint(x: fX - 10, y: fY - 280), control1: CGPoint(x: fX - 90, y: fY - 120), control2: CGPoint(x: fX - 50, y: fY - 170))
ctx.fillPath()

ctx.setFillColor(NSColor(red: 255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0).cgColor)
ctx.beginPath()
ctx.move(to: CGPoint(x: fX - 10, y: fY - 160)) // Inner top tip
ctx.addCurve(to: CGPoint(x: fX + 40, y: fY - 60), control1: CGPoint(x: fX + 10, y: fY - 110), control2: CGPoint(x: fX + 50, y: fY - 80))
ctx.addCurve(to: CGPoint(x: fX - 50, y: fY - 60), control1: CGPoint(x: fX + 30, y: fY - 20), control2: CGPoint(x: fX - 40, y: fY - 20))
ctx.addCurve(to: CGPoint(x: fX - 10, y: fY - 160), control1: CGPoint(x: fX - 60, y: fY - 90), control2: CGPoint(x: fX - 30, y: fY - 110))
ctx.fillPath()

// Figure
ctx.setStrokeColor(black)
ctx.setLineWidth(lineWidth)

let hX: CGFloat = 360
let hY: CGFloat = 280

// Head
ctx.strokeEllipse(in: CGRect(x: hX - 60, y: hY - 60, width: 120, height: 120))

// Body
ctx.beginPath()
ctx.move(to: CGPoint(x: hX - 20, y: hY + 60)) // neck
ctx.addQuadCurve(to: CGPoint(x: hX - 80, y: hY + 300), control: CGPoint(x: hX - 60, y: hY + 150))
ctx.strokePath()

// Back Leg
ctx.beginPath()
ctx.move(to: CGPoint(x: hX - 80, y: hY + 300)) // hips
ctx.addLine(to: CGPoint(x: hX - 80, y: hY + 440)) // knee
ctx.addLine(to: CGPoint(x: hX - 220, y: hY + 440)) // foot (backwards)
ctx.strokePath()

// Front Leg
ctx.beginPath()
ctx.move(to: CGPoint(x: hX - 80, y: hY + 300)) // hips
ctx.addLine(to: CGPoint(x: hX + 90, y: hY + 280)) // knee
ctx.addLine(to: CGPoint(x: hX + 90, y: hY + 440)) // ankle
ctx.addLine(to: CGPoint(x: hX + 180, y: hY + 440)) // foot
ctx.strokePath()

// Arm (Straight line from shoulder to hand)
ctx.beginPath()
ctx.move(to: CGPoint(x: hX - 50, y: hY + 120)) // shoulder
ctx.addLine(to: CGPoint(x: hX + 150, y: hY + 240)) // hand
ctx.strokePath()

// Sticks
ctx.setLineWidth(16)
drawLine(CGPoint(x: hX + 120, y: hY + 140), CGPoint(x: hX + 220, y: hY + 280))
drawLine(CGPoint(x: hX + 150, y: hY + 120), CGPoint(x: hX + 260, y: hY + 260))

image.unlockFocus()

let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
let pngData = bitmapRep.representation(using: .png, properties: [:])!

let fileURL = URL(fileURLWithPath: "app_icon_fire_starter_v2.png")
try! pngData.write(to: fileURL)
print("Saved to \(fileURL.path)")
