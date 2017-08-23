//
//  UNNotificationCenter.swift
//  Life Logger
//
//  Created by Edward Huang on 8/22/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    
    
    /// Removes all pending and delivered notifications and schedules new set of notifications based on new current log
    ///
    /// - Parameter currentLog: Current log should have no date ended yet
    static func reconfigureNotifications(for currentLog: Log) {
        assert(currentLog.dateEnded == nil)
        
        let center = UNUserNotificationCenter.current()
        
        // Remove old notifications
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        
        let minutes = UserDefaults.standard.integer(forKey: UserDefaults.minutesReport)
        if minutes <= 0 {
            return
        }
        let numberOfNotifications = (24 * 60) / minutes
        let activity = currentLog.activity!
        
        let startDate = currentLog.dateStarted! as Date
        let currentDate = Date()
        let duration = currentDate.timeIntervalSince(startDate)
        
        assert(duration >= 0)
        
        for i in 1...numberOfNotifications {
            
            let triggerTime = TimeInterval(minutes * i * 60) - duration
            if triggerTime < 0 {
                continue
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Log Report"
            content.body = "You have logged \(activity.name!) for \(minutes * i) minutes"
            content.sound = UNNotificationSound.default()
            
            // Configure the trigger to fire every hour
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTime, repeats: false)
            
            // Create the request object.
            let request = UNNotificationRequest(identifier: "LogAlert\(i)", content: content, trigger: trigger)
            
            // Schedule the request.
            center.add(request) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
        }
    }
}
