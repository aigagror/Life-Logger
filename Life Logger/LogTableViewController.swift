//
//  LogTableViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/12/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class LogTableViewController: UITableViewController {
    
    var logs: [Log]!

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        logs = DatabaseController.loadLogs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "logCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // Configure the cell...
        let log = logs[indexPath.row]
        cell.textLabel?.text = log.activity?.name
        
        let startingDate = log.dateStarted!
        let endingDate = log.dateEnded
        
        
        let dateFormatter = DateFormatter()
        let currentCalendar = Calendar.current
        
        let detailText: String
        if let endingDate = endingDate {
            
            if currentCalendar.isDateInToday(endingDate as Date) {
                dateFormatter.timeStyle = .short
                dateFormatter.dateStyle = .none
                detailText = "\(dateFormatter.string(from: startingDate as Date)) - \(dateFormatter.string(from: endingDate as Date))"
            } else {
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .none
                detailText = dateFormatter.string(from: endingDate as Date)
            }
        } else {
            if currentCalendar.isDateInToday(startingDate as Date) {
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
            } else {
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .none
            }
            detailText = "\(dateFormatter.string(from: startingDate as Date)) - present"
        }
        
        
        
        cell.detailTextLabel?.text = detailText
        
        let colorIndex = log.activity!.color
        cell.imageView?.image = ActivityColor.getImage(index: colorIndex)

        return cell
    }
 

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let logToDelete = logs[indexPath.row]
            let context = DatabaseController.getContext()
            context.delete(logToDelete)
            DatabaseController.saveContext()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let logViewController = segue.destination as? LogViewController {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("Could not find index path for selected log cell")
            }
            let logToView = logs[indexPath.row]
            
            logViewController.log = logToView
        }
    }
    
    // MARK: Actions
    
    @IBAction func unwindToLogList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? LogViewController, let log = sourceViewController.log {
            
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                fatalError("Could not get selected log cell")
            }
            
            // Update an existing log.
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
            
            // Save the logs
            DatabaseController.saveContext()
        }
    }
 

}
