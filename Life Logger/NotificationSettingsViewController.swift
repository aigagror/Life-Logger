//
//  NotificationSettingsViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/21/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit
import UserNotifications
import os.log
import CoreData

class NotificationSettingsViewController: UIViewController {
    
    
    @IBOutlet weak var logReportTimeLabel: UILabel!
    @IBOutlet weak var logReportTimeStepper: UIStepper!
    
    @IBOutlet weak var noLogTimeLabel: UILabel!
    @IBOutlet weak var noLogTimeStepper: UIStepper!
    
    @IBAction func valueChanged(_ sender: UIStepper) {
        if sender === logReportTimeStepper {
            UserDefaults.standard.set(Int(sender.value), forKey: UserDefaults.minutesReport)
            
            // load the current activity if any
            let fetchRequest: NSFetchRequest<Log> = Log.fetchRequest()
            let predicate = NSPredicate(format: "dateEnded = nil")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = predicate
            
            do {
                let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                guard searchResults.count <= 1 else {
                    os_log("More than one log fetched", log: OSLog.default, type: .debug)
                    return
                }
                
                if let log = searchResults.first {
                    // Update the notifications
                    UNUserNotificationCenter.reconfigureNotifications(for: log)
                }
            }
            catch {
                print("Error: \(error)")
            }
            
            
            logReportTimeLabel.text = sender.value == 0 ? "None" : TimeInterval(sender.value * 60).formatStringMinutes()
        } else {
            assert(sender === noLogTimeStepper)
            
            UserDefaults.standard.set(Int(sender.value), forKey: UserDefaults.noActivityMinutesReport)
            
            UNUserNotificationCenter.reconfigureNotifications(for: nil)
            
            noLogTimeLabel.text = sender.value == 0 ? "None" : TimeInterval(sender.value * 60).formatStringMinutes()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let minutesReport = UserDefaults.standard.integer(forKey: UserDefaults.minutesReport)
        logReportTimeStepper.value = Double(minutesReport)
        logReportTimeLabel.text = TimeInterval(minutesReport * 60).formatStringMinutes()
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

}
