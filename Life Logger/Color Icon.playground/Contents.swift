//: Playground - noun: a place where people can play

import UIKit

let fillColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
let strokeColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
let lineWidth: CGFloat = 5.0
let imageSize = CGSize(width: 200, height: 200)
let circleSize = CGSize(width: 80, height: 80)

UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
let context = UIGraphicsGetCurrentContext()

let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x:60,y:60), size: circleSize))
fillColor.setFill()
circlePath.fill()

strokeColor.setStroke()
circlePath.lineWidth = lineWidth
circlePath.stroke()



// This code must always be at the end of the playground
let image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()
