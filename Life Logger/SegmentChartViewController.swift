//
//  SegmentChartViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/15/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class SegmentChartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: Properties
    var chartMode: TimeMode = .day {
        didSet {
            self.tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Data Source and Delegation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "segmentChartCell") else {
            fatalError("Could not find segment chart cell")
        }
        
        guard let segmentChartView = cell.contentView.subviews.first! as? SegmentChartView else {
            fatalError("Could not find segment chart view")
        }
        
        segmentChartView.dayOffSet = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            switch chartMode {
            case .day:
                return 1
            case .week:
                return 7
            case .month:
                return 30
            case .year:
                return 355
            }
        }
        return 0
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