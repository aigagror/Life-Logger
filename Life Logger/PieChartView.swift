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
    
    var delegate: ChartDelegate?
    
    /// The number of days to go back by. (Always positive)
    var numberOfDays = 1 {
        didSet {
            self.setNeedsDisplay()
            if numberOfDays < 1 {
                fatalError("number of days must be positive")
            }
        }
    }
    
    var activityPaths: [Activity : UIBezierPath]!
    var activityTimes: [Activity : TimeInterval]!
    
    
    private let numberOfSecondsInADay = 24 * 60 * 60
    
    // MARK: Touch Recognition
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
        
        activityPaths = [:]
        activityTimes = [:]
        
        let minLength = min(self.bounds.height, self.bounds.width)
        
        // Shadows
        let context = UIGraphicsGetCurrentContext()
        let shadow: UIColor = UIColor.black.withAlphaComponent(0.50)
        let shadowOffset = CGSize(width: 0.0, height: 5)
        let shadowBlurRadius: CGFloat = 5
        
        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)
        
        let π = CGFloat(Double.pi)
        
        
        let radius = minLength / 2 * 0.9
        let innerRadius = radius * 0.6
        let lineWidth = radius - innerRadius

        let center = CGPoint(x: minLength / 2, y: minLength / 2)

        let circumscribingRect = CGRect(origin: CGPoint.init(x: minLength/2 - radius + lineWidth / 2, y: minLength/2 - radius + lineWidth / 2), size: CGSize(width: (radius + innerRadius), height: (radius + innerRadius)))
        
        let circleOutline = UIBezierPath(ovalIn: circumscribingRect)
        circleOutline.lineWidth = lineWidth
        
        UIColor.lightGray.set()
        circleOutline.stroke()
        
        let activityProportions = getProportions().sorted { (key1, key2) -> Bool in
            return key1.value > key2.value
        }
        
        
        
        var currentAngle = -π / 2
        for activityTime in activityProportions {
            let proportion = activityTime.value
            
            let delta = 2 * π * proportion
            
            let slicePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: currentAngle, endAngle: currentAngle + delta, clockwise: true)
            
            let innerSlicePath = UIBezierPath(arcCenter: center, radius: innerRadius, startAngle: currentAngle, endAngle: currentAngle + delta, clockwise: true)
            
            slicePath.addLine(to: innerSlicePath.currentPoint)
            
            slicePath.addArc(withCenter: center, radius: innerRadius, startAngle: currentAngle + delta, endAngle: currentAngle, clockwise: false)
            
            slicePath.close()
            
            let colorIndex = activityTime.key.color
            let color = ActivityColor.getColor(index: colorIndex)
            color.setFill()
            
            slicePath.fill()
            
            currentAngle += delta
            
            // add data to activity paths and times
            activityPaths[activityTime.key] = slicePath
            activityTimes[activityTime.key] = TimeInterval(activityTime.value) * TimeInterval(numberOfSecondsInADay) * TimeInterval(numberOfDays)
        }
    }
    
    // MARK: Private Methods
    
    private func informDelegateAboutTouch(_ touch: UITouch) -> Void {
        
        // see if one of the paths in logPaths contains the touch
        if let delegate = self.delegate {
            let position = touch.location(in: self)
            for (activity , path) in activityPaths {
                if path.contains(position) {
                    let time = activityTimes[activity]!
                    delegate.userWantsToSee?(activity: activity, forTime: time)
                    return
                }
            }
            delegate.userTouchedUnknownTimeSection()
        }
    }
    
    
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
