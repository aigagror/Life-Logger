//
//  LogViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/15/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    // MARK: Properties
    
    var log: Log!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        let startDate = log.dateStarted!
        let endDate = log.dateEnded
        
        startDateLabel.text = dateFormatter.string(from: startDate as Date)
        if let endDate = endDate {
            endDateLabel.text = dateFormatter.string(from: endDate as Date)
        } else {
            endDateLabel.text = "present"
            endDatePicker.isHidden = true
        }
        
        self.navigationItem.title = log.activity!.name!
        
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
    
    // TODO: Implement
    private func updateSaveButtonState() {
        //Disable the Save button if the dates conflict with dates from other logs
        
    }

}
