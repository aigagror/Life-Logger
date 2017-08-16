//
//  PieChartView.swift
//  Life Logger
//
//  Created by Edward Huang on 8/16/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class PieChartView: UIView {
    
    // MARK: Properties
    
    /// The number of days to go back by. (Always positive)
    var numberOfDays = 1 {
        didSet {
            self.setNeedsDisplay()
            if numberOfDays < 1 {
                fatalError("number of days must be positive")
            }
        }
    }
    
    private let numberOfSecondsInADay = 24 * 60 * 60

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let radius = min(self.bounds.height, self.bounds.width) / 2
        
        let circumscribingRect = CGRect(origin: .zero, size: CGSize(width: radius*2, height: radius*2))
        
        let circleOutline = UIBezierPath(ovalIn: circumscribingRect)
        
        UIColor.gray.setFill()
        circleOutline.fill()
        circleOutline.addClip()
        
        let activityProportions = getProportions().sorted { (key1, key2) -> Bool in
            return key1.value > key2.value
        }
        
        let π = CGFloat(Double.pi)
        let center = CGPoint(x: radius, y: radius)
        
        var currentAngle = -π / 2
        for activityTime in activityProportions {
            let proportion = activityTime.value
            
            let delta = 2 * π * proportion
            
            let slicePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: currentAngle, endAngle: currentAngle + delta, clockwise: true)
            
            slicePath.addLine(to: center)
            slicePath.move(to: center)
            slicePath.close()
            
            let colorIndex = activityTime.key.color
            let color = ActivityColor.getColor(index: colorIndex)
            color.setFill()
            
            slicePath.fill()
            
            currentAngle += delta
        }
    }
    
    // MARK: Private Methods
    
    
    /// Using the number of days, this function looks at all the logs that have a timestamp between now and the number of days ago and outputs the proportion of time spent on each activity
    ///
    /// - Returns: Key-value pairs of time percentages spent for each activity
    private func getProportions() -> [Activity: CGFloat] {
        let logs = DatabaseController.loadLogs()!
        
        var ret = [Activity: CGFloat]()
        
        let totalTime: TimeInterval = TimeInterval(numberOfDays * numberOfSecondsInADay)
        
        for log in logs {
            let activity = log.activity!
            let timeIntersected = getTime(log: log)
            
            if ret[activity] == nil {
                ret[activity] = CGFloat(0)
            }
            
            ret[activity] = ret[activity]! + CGFloat(timeIntersected)
        }
        
        for (activity, time) in ret {
            ret[activity] = time / CGFloat(totalTime)
        }
        
        return ret
    }
    
    /// Returns the amount of time that was spent within the past numberOfDays
    ///
    /// - Parameter log:
    private func getTime(log: Log) -> TimeInterval {
        
        let currentCalendar = Calendar.current
        
        let earliestTime = currentCalendar.startOfDay(for: NSDate(timeIntervalSinceNow: TimeInterval(-(numberOfDays-1) * numberOfSecondsInADay)) as Date)
        
        let dateStarted = log.dateStarted!
        
        let dateEnded: NSDate
        if log.dateEnded != nil {
            dateEnded = log.dateEnded!
        } else {
            dateEnded = NSDate()
        }
        
        if dateEnded.timeIntervalSince(earliestTime) > 0 {
            let earliestToDateEnded = dateEnded.timeIntervalSince(earliestTime)
            
            let earliestToDateStarted = dateStarted.timeIntervalSince(earliestTime)
            
            if earliestToDateStarted > 0 {
                return earliestToDateEnded - earliestToDateStarted
            } else {
                return earliestToDateEnded
            }
        }
        return 0
    }
}
