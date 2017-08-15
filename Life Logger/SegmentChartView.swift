//
//  SegmentChartView.swift
//  Life Logger
//
//  Created by Edward Huang on 8/14/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class SegmentChartView: UIView {
    
    var offSet: TimeInterval = (0.00) * 60 * 60 // 7:00 a.m
    
    
    /// 0 - day, 1 - week, 2 - month, 3 - year
    var mode: Int = 0
    
    var logs = [Log]()

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        logs = DatabaseController.loadLogs()!
        
        UIColor.gray.setFill()
        let outlinePath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5.0)
        outlinePath.addClip()
        outlinePath.fill()
        
        let length = self.bounds.width
        
        for log in logs {
            let activity = log.activity!
            let color = ActivityColor.getColor(index: activity.color)
            color.setFill()
            
            let bounds = getPercentageBoundaries(log: log)
            
            if bounds.start == bounds.end {
                continue
            }
            
            let segmentLength = (bounds.end - bounds.start) * length
            let segmentSize = CGSize(width: segmentLength, height: self.bounds.height)
            let segmentStartPosition = CGPoint(x: bounds.start * length, y: 0.0)
            
            let segmentRect = CGRect(origin: segmentStartPosition, size: segmentSize)
            
            let segmentPath = UIBezierPath(rect: segmentRect)
            segmentPath.fill()
        }
        
    }
    
    /// Given a log, return where the beginning and end of the segment should lie in terms of percentages
    ///
    /// - Parameter log: The Log
    /// - Returns: A tuple. First number is the beginning, last number is the end
    private func getPercentageBoundaries(log: Log) -> (start: CGFloat, end: CGFloat) {
        
        let numberOfSecondsInADay: TimeInterval = 24 * 60 * 60
        
        var startPercentage: CGFloat = 0.0
        var endPercentage: CGFloat = 0.0
        
        let currentTime = NSDate()
        let currentCalendar = Calendar.current
        let startOfTheDay = currentCalendar.startOfDay(for: currentTime as Date)
        
        let logStartDate = log.dateStarted!
        
        let logEndDate = log.dateEnded
        
        
        let logStartTimeInSeconds = logStartDate.timeIntervalSince(startOfTheDay)
        
        let logEndTimeInSeconds = logEndDate?.timeIntervalSince(startOfTheDay)
        
        
        startPercentage = CGFloat((logStartTimeInSeconds - offSet) / numberOfSecondsInADay)
        
        startPercentage = max(startPercentage, 0.0)
        startPercentage = min(startPercentage, 1.0)
        
        if let logEndTimeInSeconds = logEndTimeInSeconds {
            endPercentage = CGFloat((logEndTimeInSeconds - offSet) / numberOfSecondsInADay)
            
            endPercentage = max(endPercentage, 0.0)
            endPercentage = min(endPercentage, 1.0)
        } else {
            endPercentage = CGFloat((currentTime.timeIntervalSince(startOfTheDay) - offSet) / numberOfSecondsInADay)
        }
        
        
        return (startPercentage, endPercentage)
    }
 

}
