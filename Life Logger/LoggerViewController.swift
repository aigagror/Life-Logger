//
//  FirstViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/12/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit
import CoreData
import os.log

class LoggerViewController: UIViewController, ActivityChooserDelegate {
    
    // MARK: Properties
    
    var currentActivity: Activity?
    var currentLog: Log?
    
    var timer = Timer()
    
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityTimer: UILabel!
    
    @IBAction func stopLog(_ sender: Any) {
        stopTimer()
        if let currentLog = currentLog {
            currentLog.dateEnded = NSDate()
            currentActivity = nil
            self.currentLog = nil
            DatabaseController.saveContext()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // load the current activity if any
        let fetchRequest: NSFetchRequest<Log> = Log.fetchRequest()
        let predicate = NSPredicate(format: "dateEnded = nil")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print("number of results: \(searchResults.count)")
            guard searchResults.count <= 1 else {
                os_log("More than one log fetched", log: OSLog.default, type: .debug)
                return
            }
            
            if let log = searchResults.first {
                currentLog = log
                currentActivity = log.activity
                
                activityTitle.text = currentActivity?.name
                
                let currentDate = NSDate()
                
                guard let startingDate = log.dateStarted else {
                    fatalError("Could not get starting date of log")
                }
                let timeInterval = currentDate.timeIntervalSince(startingDate as Date)
                activityTimer.text = timeInterval.formatString()
                startTimer()
            }
        }
        catch {
            print("Error: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigator = segue.destination as? UINavigationController {
            if let activityChooser = navigator.viewControllers.first as? ActivityChooserTableViewController {
                activityChooser.delegate = self
            }
        }
    }
    
    // MARK: Delegation
    func userChose(activity: Activity) {
        stopTimer()
        
        if let oldLog = currentLog {
            oldLog.dateEnded = NSDate()
        }
        
        currentActivity = activity
        
        activityTitle.text = activity.name
        activityTimer.text = "00:00:00"
        
        
        let newLog = NSEntityDescription.insertNewObject(forEntityName: DatabaseController.logClassName, into: DatabaseController.getContext()) as! Log
        newLog.dateStarted = NSDate()
        newLog.dateEnded = nil
        newLog.activity = currentActivity
        
        currentLog = newLog
        
        DatabaseController.saveContext()
        startTimer()
    }
    
    // MARK: Private Methods
    @objc private func updateTimer() {
        if let currentLog = currentLog {
            let startDate = currentLog.dateStarted! as Date
            let currentDate = Date()
            let timeInterval = currentDate.timeIntervalSince(startDate)
            activityTimer.text = timeInterval.formatString()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoggerViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer.invalidate()
    }

}

