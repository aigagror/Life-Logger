//
//  SegmentChartSettingsViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/17/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class SegmentChartSettingsViewController: UIViewController {
    
    // MARK: Properties
    var startHour = 0
    var endHour = 24
    
    @IBOutlet weak var startHourLabel: UILabel!
    @IBOutlet weak var endHourLabel: UILabel!
    
    @IBOutlet weak var startStepper: UIStepper!
    @IBOutlet weak var endStepper: UIStepper!
    
    @IBAction func startStepperPressed(_ sender: UIStepper) {
        let newValue = Int(sender.value)
        if newValue >= endHour {
            sender.value = Double(endHour - 1)
        }
        startHour = Int(sender.value)
        updateTimeLabels()
    }
    
    @IBAction func endStepperPressed(_ sender: UIStepper) {
        let newValue = Int(sender.value)
        if newValue <= startHour {
            sender.value = Double(startHour + 1)
        }
        endHour = Int(sender.value)
        updateTimeLabels()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startStepper.value = Double(UserDefaults.standard.integer(forKey: "SegmentChartStartHour"))
        endStepper.value = Double(UserDefaults.standard.integer(forKey: "SegmentChartEndHour"))
        updateTimeLabels()
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
    private func updateTimeLabels() {
        startHourLabel.text = startHour.getHourString()
        endHourLabel.text = endHour.getHourString()
    }
}
