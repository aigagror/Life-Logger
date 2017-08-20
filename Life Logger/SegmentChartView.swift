//
//  SegmentChartView.swift
//  Life Logger
//
//  Created by Edward Huang on 8/14/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class SegmentChartView: UIView {
    
    // MARK: Properties
    
    var delegate: ChartDelegate?
    
    var startingHour = 0
    var endingHour = 24
    
    /// The number of days to go back by. (Must be non-negative)
    var dayOffSet = 0 {
        didSet {
            self.setNeedsDisplay()
            if dayOffSet < 0 {
                fatalError("dayOffSet cannot be negative")
            }
        }
    }
    
    var logs = [Log]()
    
    var logPaths: [Log : UIBezierPath]!
    
    // MARK: Touch recognition
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        assert(touches.count == 1)
        
        informDelegateAboutTouch(touches.first!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        assert(touches.count == 1)
        
        informDelegateAboutTouch(touches.first!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.userStoppedTouching()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.userStoppedTouching()
    }
    
    // MARK: Drawing
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        logs = DatabaseController.loadLogs()!
        logPaths = [:]
        
        // Shadows
        let context = UIGraphicsGetCurrentContext()
        let shadow: UIColor = UIColor.black.withAlphaComponent(0.50)
        let shadowOffset = CGSize(width: 0.0, height: 5)
        let shadowBlurRadius: CGFloat = 5
        
        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)
        
        UIColor.gray.setFill()
        let outlinePath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5.0)
        outlinePath.addClip()
        outlinePath.fill()
        
        let length = self.bounds.width
        
        for log in logs {
            let activity = log.activity!
            let color = ActivityColor.getColor(index: activity.color)
            color.setFill()
            
            let bounds = getPercentageBoundaries(log: log)!
            
            if bounds.start == bounds.end {
                continue
            }
            
            let segmentLength = (bounds.end - bounds.start) * length
            let segmentSize = CGSize(width: segmentLength, height: self.bounds.height)
            let segmentStartPosition = CGPoint(x: bounds.start * length, y: 0.0)
            
            let segmentRect = CGRect(origin: segmentStartPosition, size: segmentSize)
            
            let segmentPath = UIBezierPath(rect: segmentRect)
            segmentPath.fill()
            
            // add the log:path
            
            logPaths[log] = segmentPath
        }
        
        
        // Draw tick marks to help evaluate measurements
        let numberOfTickMarks = endingHour - startingHour - 1
        
        assert(numberOfTickMarks >= 0)
        
        if numberOfTickMarks > 0 {
            
            let bottom: CGFloat = self.bounds.height
            let distanceBetweenTicks = self.bounds.width / CGFloat(numberOfTickMarks + 1)
            let tickPath = UIBezierPath()
            for i in 1...numberOfTickMarks {
                let tickHeight: CGFloat
                if (startingHour + i) % 3 == 0 {
                    tickHeight = 8.0
                } else {
                    tickHeight = 5.0
                }
                let bottomPoint = CGPoint(x: CGFloat(i) * distanceBetweenTicks, y: bottom)
                let topPoint = CGPoint(x: CGFloat(i) * distanceBetweenTicks, y: bottom - tickHeight)
                tickPath.move(to: bottomPoint)
                tickPath.addLine(to: topPoint)
            }
            tickPath.lineWidth = 1.0
            UIColor.white.setStroke()
            tickPath.stroke()
        }
    }
    
    
    // MARK: Private Methods
    private func informDelegateAboutTouch(_ touch: UITouch) -> Void {
        
        // see if one of the paths in logPaths contains the touch
        if let delegate = self.delegate {
            let position = touch.location(in: self)
            for (log , path) in logPaths {
                if path.contains(position) {
                    delegate.userWantsToSee?(log: log)
                    return
                }
            }
            delegate.userTouchedUnknownTimeSection()
        }
    }
    
    /// Given a log, return where the beginning and end of the segment should lie in terms of percentages
    ///
    /// - Parameter log: The Log
    /// - Returns: A tuple. First number is the beginning, last number is the end
    private func getPercentageBoundaries(log: Log) -> (start: CGFloat, end: CGFloat)? {
        
        let startingTime: TimeInterval = TimeInterval(startingHour) * 60 * 60
        
        let endingTime: TimeInterval = TimeInterval(endingHour) * 60 * 60
        
        let totalNumberOfSeconds: TimeInterval = endingTime - startingTime
        
        var startPercentage: CGFloat
        var endPercentage: CGFloat
        
        let currentTime = NSDate()
        let currentCalendar = Calendar.current
        
        var startOfTheDay = currentCalendar.startOfDay(for: currentTime as Date)
        startOfTheDay = Date(timeInterval: TimeInterval(-dayOffSet * 24 * 60 * 60), since: startOfTheDay)
        
        let logStartDate = log.dateStarted!
        
        let logEndDate = log.dateEnded
        
        
        let logStartTimeInSeconds = logStartDate.timeIntervalSince(startOfTheDay)
        
        let logEndTimeInSeconds = logEndDate?.timeIntervalSince(startOfTheDay)
        
        
        startPercentage = CGFloat((logStartTimeInSeconds - startingTime) / totalNumberOfSeconds)
        
        startPercentage = max(startPercentage, 0.0)
        startPercentage = min(startPercentage, 1.0)
        
        if let logEndTimeInSeconds = logEndTimeInSeconds {
            endPercentage = CGFloat((logEndTimeInSeconds - startingTime) / totalNumberOfSeconds)
            
            endPercentage = max(endPercentage, 0.0)
            endPercentage = min(endPercentage, 1.0)
        } else {
            endPercentage = CGFloat((currentTime.timeIntervalSince(startOfTheDay) - startingTime) / totalNumberOfSeconds)
        }
        
        
        return (startPercentage, endPercentage)
    }
 

}
