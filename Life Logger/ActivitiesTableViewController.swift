//
//  ActivitiesTableViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/12/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit
import CoreData
import os.log

class ActivitiesTableViewController: UITableViewController {
    
    
    // MARK: Properties
    var activities: [Activity]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Load the activities
        
        activities = DatabaseController.loadActivities()
        
        
        
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
        if section == 0 {
            return activities.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "activityCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let activity = activities[indexPath.row]
        
        let colorIndex = activity.color
        
        cell.textLabel?.text = activity.name
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
            
            let activity = activities[indexPath.row]
            activities.remove(at: indexPath.row)
            let context = DatabaseController.getContext()
            context.delete(activity)
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
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new activity.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let activityDetailViewController = segue.destination as? ActivityViewController else { fatalError("Unexpected destination: \(segue.destination)") }
            
            guard let selectedActivityCell = sender as? UITableViewCell else { fatalError("Unexpected sender: \(String(describing: sender))") }
            
            guard let indexPath = tableView.indexPath(for: selectedActivityCell) else { fatalError("The selected cell is not being displayed by the table") }
            
            let selectedActivity = activities[indexPath.row]
            activityDetailViewController.activity = selectedActivity
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func unwindToActivityList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ActivityViewController, let activity = sourceViewController.activity {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Update an existing activity.
//                activities[selectedIndexPath.row] = activity
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                // Add a new activity.
                let newIndexPath = IndexPath(row: activities.count, section: 0)
                
                activities.append(activity)
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                
            }
            
            // Save the activities
            
            DatabaseController.saveContext()
            
        }
    }
    
    // MARK: Private Methods
    
    
}
