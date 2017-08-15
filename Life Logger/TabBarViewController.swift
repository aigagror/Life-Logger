//
//  TabBarViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/13/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit
import CoreData

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let notFirstTimeLoadingKey = "notFirstTimeLoading"
        
        if !UserDefaults.standard.bool(forKey: notFirstTimeLoadingKey) {
            UserDefaults.standard.set(true, forKey: notFirstTimeLoadingKey)
            loadSampleActivities()
        }
        
        // Reset everything
        let reset = true
        
        if reset {
            let context = DatabaseController.getContext()
            guard let activities = DatabaseController.loadActivities() else {
                fatalError("Could not load logs")
            }
            
            for activity in activities {
                context.delete(activity)
            }
            
            
            
            loadSampleActivities()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private Methods
    
    private func loadSampleActivities() {
                
        let work = NSEntityDescription.insertNewObject(forEntityName: DatabaseController.activityClassName, into: DatabaseController.getContext()) as! Activity
        work.name = "Work"
        work.color = 0
        
        let leisure = NSEntityDescription.insertNewObject(forEntityName: DatabaseController.activityClassName, into: DatabaseController.getContext()) as! Activity
        leisure.name = "Leisure"
        work.color = 1
        
        let sleep = NSEntityDescription.insertNewObject(forEntityName: DatabaseController.activityClassName, into: DatabaseController.getContext()) as! Activity
        sleep.name = "Sleep"
        sleep.color = 2
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        
        let sleepLog = NSEntityDescription.insertNewObject(forEntityName: DatabaseController.logClassName, into: DatabaseController.getContext()) as! Log
        sleepLog.activity = sleep

        // slept at 11:00pm last night all the way to 7:00am today
        sleepLog.dateStarted = dateFormatter.date(from: "2017-08-14T23:00:00-04:00")! as NSDate
        sleepLog.dateEnded = dateFormatter.date(from: "2017-08-15T07:00:00-04:00")! as NSDate
        
        
        
        let workLog = NSEntityDescription.insertNewObject(forEntityName: DatabaseController.logClassName, into: DatabaseController.getContext()) as! Log
        workLog.activity = work
        
        workLog.dateStarted = dateFormatter.date(from: "2017-08-15T09:00:00-04:00")! as NSDate
        workLog.dateEnded = dateFormatter.date(from: "2017-08-15T17:00:00-04:00")! as NSDate
        
        let leisureLog = NSEntityDescription.insertNewObject(forEntityName: DatabaseController.logClassName, into: DatabaseController.getContext()) as! Log
        leisureLog.activity = leisure
        
        leisureLog.dateStarted = dateFormatter.date(from: "2017-08-15T17:00:00-04:00")! as NSDate
        leisureLog.dateEnded = dateFormatter.date(from: "2017-08-15T22:00:00-04:00")! as NSDate
        
        DatabaseController.saveContext()
    }

}
