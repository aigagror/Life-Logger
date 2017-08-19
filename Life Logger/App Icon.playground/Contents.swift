//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

class Activity: Hashable, Equatable {
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
    var name: String
    var color: UIColor
    
    var hashValue: Int {
        return name.hashValue ^ color.hashValue
    }
    
    static func ==(lhs: Activity, rhs: Activity) -> Bool {
        return lhs.name == rhs.name && lhs.color == rhs.color
    }
}

var activityProportions = [(key: Activity, value: CGFloat)]()

activityProportions.append((Activity.init(name: "1", color: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)), 0.2))
activityProportions.append((Activity.init(name: "2", color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), 0.2))
activityProportions.append((Activity.init(name: "4", color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), 0.2))
activityProportions.append((Activity.init(name: "3", color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), 0.15))
activityProportions.append((Activity.init(name: "5", color: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), 0.1))
activityProportions.append((Activity.init(name: "6", color: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)), 0.1))


activityProportions.sort { (kv1, kv2) -> Bool in
    return kv1.value > kv2.value
}


func createImageIcon(resolution: Double, multiplier: Int) -> UIImage {
    let backgroundStrokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    let frameLength: CGFloat = CGFloat(resolution * Double(multiplier))
    let lineWidth: CGFloat = frameLength * 0.1
    let radius: CGFloat = (frameLength - lineWidth*2) / 2
    
    let imageSize = CGSize(width: frameLength, height: frameLength)
    let circleSize = CGSize(width: radius*2, height: radius*2)
    
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    
    // Shadows
    let shadow: UIColor = UIColor.black.withAlphaComponent(0.50)
    let shadowOffset = CGSize(width: 0.0, height: lineWidth * 0.1)
    let shadowBlurRadius: CGFloat = 5
    
    context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)
    //context?.beginTransparencyLayer(auxiliaryInfo: nil)
    
    
    
    let circumscribingRectOrigin = CGPoint(x: (frameLength - radius*2) / 2, y: (frameLength - radius*2) / 2)
    let circlePath = UIBezierPath(ovalIn: CGRect(origin: circumscribingRectOrigin, size: circleSize))
    
    backgroundStrokeColor.setStroke()
    //circlePath.addClip()
    circlePath.lineWidth = lineWidth
    circlePath.stroke()
    
    let π = CGFloat(Double.pi)
    let center = CGPoint(x: frameLength / 2, y: frameLength / 2)
    
    var currentAngle = -π / 2
    for activityTime in activityProportions {
        let proportion = activityTime.value
        
        let delta = 2 * π * proportion
        
        let slicePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: currentAngle, endAngle: currentAngle + delta, clockwise: true)
        slicePath.lineWidth = lineWidth
        
        let color = activityTime.key.color
        color.setStroke()
        
        slicePath.stroke()
        
        currentAngle += delta
    }
    
    
    //context?.endTransparencyLayer()
    
    
    // This code must always be at the end of the playground
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    
    return image
//    let fileURL = XCPlaygroundSharedDataDirectoryURL.appendingPathComponent("appIcon.png")!
//    
//    do {
//        try UIImagePNGRepresentation(image!)?.write(to: fileURL)
//    } catch {
//        print(error)
//    }
}


let resolutions = [20, 29, 40, 60, 76, 83.5]

for resolution in resolutions {
    for mult in 1...3 {
        let icon = createImageIcon(resolution: resolution, multiplier: mult)
        let resolutionString: String
        if Int(resolution * 10) % 10 == 0 {
            resolutionString = "\(Int(resolution))"
        } else {
            resolutionString = "\(resolution)"
        }
        
        let multString: String
        if mult > 1 {
            multString = "@\(mult)x"
        } else {
            multString = ""
        }
        
        let fileName = "appIcon-\(resolutionString)\(multString).png"
        let fileURL = XCPlaygroundSharedDataDirectoryURL.appendingPathComponent(fileName)!
        
        do {
            try UIImagePNGRepresentation(icon)?.write(to: fileURL)
        } catch {
            print(error)
        }
    }
}





