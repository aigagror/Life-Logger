//
//  Int.swift
//  Life Logger
//
//  Created by Edward Huang on 8/17/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

extension Int {
    func getHourString() -> String {
        let mode = self < 12 ? "am" : "pm"
        let hourString: String
        if self == 0 {
            hourString = "\(12)"
        } else if self <= 12 {
            hourString = "\(self)"
        } else {
            hourString = "\(self - 12)"
        }
        return "\(hourString)\(mode)"
    }
}
