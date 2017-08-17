//
//  StatisticsViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/14/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: Properties
    
    var chartMode = TimeMode.day
    
    @IBOutlet weak var segmentContainerView: UIView!
    @IBOutlet weak var pieContainerView: UIView!
    
    @IBOutlet weak var chartSegmentControl: UISegmentedControl!
    @IBOutlet weak var timeModeSegmentControl: UISegmentedControl!
    @IBOutlet weak var pageController: UIPageControl!
    
    
    
    var segmentController: SegmentChartViewController!
    var pieController: PieChartViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        timeModeSegmentControl.addTarget(self, action: #selector(StatisticsViewController.userChoseTimeMode), for: .valueChanged)
        chartSegmentControl.addTarget(self, action: #selector(StatisticsViewController.userChoseChartMode), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    // MARK: SegmentControl Delegation
    
    func userChoseChartMode() -> Void {
        let selectedIndex = chartSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            
            segmentContainerView.isHidden = false
            
            pieContainerView.isHidden = true
        case 1:
            
            segmentContainerView.isHidden = true
            
            pieContainerView.isHidden = false
        default:
            fatalError("Unknown selection for chart segment control")
        }
    }
    
    func userChoseTimeMode() -> Void {
        
        let selectedIndex = timeModeSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            self.chartMode = .day
        case 1:
            self.chartMode = .week
        case 2:
            self.chartMode = .month
        case 3:
            self.chartMode = .year
        default:
            fatalError("Unknown selectedIndex: \(selectedIndex)")
        }
        
        // update the charts
        segmentController.chartMode = self.chartMode
        pieController.chartMode = self.chartMode
    }
    
    
    
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return 2
//    }
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        if let currentVC = pageViewController.viewControllers, let first = currentVC.first {
//            if first is SegmentChartViewController {
//                return 0
//            } else {
//                return 1
//            }
//        }
//        return 0
//    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let segmentVC = segue.destination as? SegmentChartViewController {
            self.segmentController = segmentVC
        } else if let pieVC = segue.destination as? PieChartViewController {
            self.pieController = pieVC
        } else {
            fatalError("Unknown segue")
        }
    }

}
