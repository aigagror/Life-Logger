//
//  ChartDelegate.swift
//  Life Logger
//
//  Created by Edward Huang on 8/16/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

@objc protocol ChartDelegate {
    @objc optional func userWantsToSee(log: Log) -> Void
    @objc optional func userWantsToSee(activity: Activity, forTime: TimeInterval) -> Void
    func userTouchedUnknownTimeSection() -> Void
    func userStoppedTouching() -> Void
}
