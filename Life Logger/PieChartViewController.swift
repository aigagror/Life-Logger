//
//  PieChartViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/15/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class PieChartViewController: UIViewController, ChartDelegate {

    // MARK: Properties
    
    
    var chartMode: TimeMode = .day {
        didSet {
            switch chartMode {
            case .day:
                pieChartView.numberOfDays = 1
            case .week:
                pieChartView.numberOfDays = 7
            case .month:
                pieChartView.numberOfDays = 30
            case .year:
                pieChartView.numberOfDays = 355
            }
        }
    }
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var colorIconView: UIImageView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityDetailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pieChartView.delegate = self
        colorIconView.image = ActivityColor.getImage(index: -1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if chartMode == .day {
            pieChartView.setNeedsDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Chart Delegation
    func userWantsToSee(activity: Activity, forTime time: TimeInterval) -> Void {
        let name = activity.name!
        colorIconView.image = ActivityColor.getImage(index: activity.color)
        activityLabel.text = "\(name)"
        activityDetailLabel.text = "\(time.formatString())"
    }
    
    func userTouchedUnknownTimeSection() {
        colorIconView.image = ActivityColor.getImage(index: -1)
        activityLabel.text = "Unknown"
        activityDetailLabel.text = ""
    }
    
    func userStoppedTouching() {
        colorIconView.image = ActivityColor.getImage(index: -1)
        activityLabel.text = "-"
        activityDetailLabel.text = ""
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
