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
    /// - Parameter currentLog: Current log should have no date ended yet. If current log is nil, then schedule notifications for no activity
    static func reconfigureNotifications(for currentLog: Log?) {
        
        let center = UNUserNotificationCenter.current()
        
        // Remove old notifications
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        
        guard let currentLog = currentLog else {
            let minutes = UserDefaults.standard.integer(forKey: UserDefaults.noActivityMinutesReport)
            
            guard minutes > 0 else { return }
            
            let numberOfNotifications = (24 * 60) / minutes
            
            for i in 1...numberOfNotifications {
                let triggerTime = TimeInterval(minutes * i * 60)
                
                let content = UNMutableNotificationContent()
                content.title = "Log Report"
                
                let minutesLogged = minutes * i
                let hoursLogged = minutesLogged / 60
                content.body = "You have not logged anything for"
                if hoursLogged > 0 {
                    content.body += " \(hoursLogged) hour" + (hoursLogged == 1 ? "" : "s")
                    if minutesLogged % 60 > 0 {
                        content.body += " and \(minutesLogged % 60) minute" + (minutesLogged % 60 == 1 ? "" : "s")
                    }
                } else {
                    content.body += " \(minutesLogged % 60) minute" + (minutesLogged % 60 == 1 ? "" : "s")
                }
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
            
            return
        }
        
        assert(currentLog.dateEnded == nil)
        
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
            
            let minutesLogged = minutes * i
            let hoursLogged = minutesLogged / 60
            content.body = "You have logged \(activity.name!) for"
            if hoursLogged > 0 {
                content.body += " \(hoursLogged) hour" + (hoursLogged == 1 ? "" : "s")
                if minutesLogged % 60 > 0 {
                    content.body += " and \(minutesLogged % 60) minute" + (minutesLogged % 60 == 1 ? "" : "s")
                }
            } else {
                content.body += " \(minutesLogged % 60) minute" + (minutesLogged % 60 == 1 ? "" : "s")
            }
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
