//
//  TimeInterval.swift
//  Life Logger
//
//  Created by Edward Huang on 8/13/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

extension TimeInterval {
    func formatString() -> String {
        if self < 0 {
            return "-"
        }
        let hours = Int(self / 3600)
        let minutes = Int(self / 60) % 60
        let seconds = Int(self) % 60
        
        let hoursString = hours < 10 ? "0\(hours)" : "\(hours)"
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    func formatStringMinutes() -> String {
        if self < 0 {
            return "-"
        }
        let hours = Int(self / 3600)
        let minutes = Int(self / 60) % 60
        
        let hoursString = hours < 10 ? "0\(hours)" : "\(hours)"
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        return "\(hoursString):\(minutesString)"
    }
}
