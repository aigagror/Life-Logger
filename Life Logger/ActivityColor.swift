//
//  ActivityColor.swift
//  Life Logger
//
//  Created by Edward Huang on 8/14/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation
import UIKit

final class ActivityColor {
    private static let fillColors = [#colorLiteral(red: 0.4809921384, green: 0.329392314, blue: 1, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)]
    private static let strokeColors = [#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.6642322919, green: 0.4418049207, blue: 0.09606531344, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)]
    
    static var numberOfColors: Int {
        return ActivityColor.fillColors.count
    }
    
    static func getColor(index: Int) -> UIColor {
        return ActivityColor.fillColors[index]
    }
    
    static func getColor(index: Int16) -> UIColor {
        return ActivityColor.fillColors[Int(index)]
    }
    
    static func getName(index: Int) -> String {
        return getName(index: Int16(index))
    }
    
    
    static func getName(index: Int16) -> String {
        switch index {
        case 0:
            return "Purple"
        case 1:
            return "Green"
        case 2:
            return "Blue"
        case 3:
            return "Yellow"
        case 4:
            return "Brown"
        case 5:
            return "Red"
        case 6:
            return "Orange"
        default:
            return "Unknown"
        }
    }
    
    static func getImage(index: Int16) -> UIImage {
        return getImage(index: Int(index))
    }
    
    static func getImage(index: Int) -> UIImage {
        let fillColor = fillColors[index]
        let strokeColor = strokeColors[index]
        let lineWidth: CGFloat = 5.0
        let imageSize = CGSize(width: 100, height: 200)
        let circleSize = CGSize(width: 80, height: 80)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x:10,y:60), size: circleSize))
        fillColor.setFill()
        circlePath.fill()
        
        strokeColor.setStroke()
        circlePath.lineWidth = lineWidth
        circlePath.stroke()
        
        
        
        // This code must always be at the end of the playground
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("Could not load image")
        }
        UIGraphicsEndImageContext()
        
        return image
    }
}
