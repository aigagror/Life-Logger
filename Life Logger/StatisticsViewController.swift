//
//  StatisticsViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/14/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: Properties
    var pageViewController: UIPageViewController!
    var chartMode = TimeMode.day
    
    @IBOutlet weak var chartSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var timeModeSegmentControl: UISegmentedControl!
    @IBOutlet weak var pageController: UIPageControl!

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
            pageViewController.setViewControllers([(self.storyboard?.instantiateViewController(withIdentifier: "SegmentChartVC"))!], direction: .forward, animated: false, completion: nil)
        case 1:
            pageViewController.setViewControllers([(self.storyboard?.instantiateViewController(withIdentifier: "PieChartVC"))!], direction: .forward, animated: false, completion: nil)
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
        
        // update the currently presented chart
        
        guard let vc = pageViewController.viewControllers!.first else {
            fatalError("Could not get currently presented chart view controller")
        }
        
        if let segmentVC = vc as? SegmentChartViewController {
            segmentVC.chartMode = self.chartMode
        } else {
            guard let pieVC = vc as? PieChartViewController else { fatalError("Unknown View Controller") }
            pieVC.chartMode = self.chartMode
        }
    }
    
    // MARK: Page control delegation and data source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return nil
        
        if viewController is SegmentChartViewController {
            let ret = self.storyboard?.instantiateViewController(withIdentifier: "PieChartVC")
            return ret
        } else {
            let ret = self.storyboard?.instantiateViewController(withIdentifier: "SegmentChartVC")
            return ret
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return nil
        
        if viewController is SegmentChartViewController {
            let ret = self.storyboard?.instantiateViewController(withIdentifier: "PieChartVC")
            return ret
        } else {
            let ret = self.storyboard?.instantiateViewController(withIdentifier: "SegmentChartVC")
            return ret
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard pendingViewControllers.count == 1 else {
            fatalError("Expected only 1 view controller, got \(pendingViewControllers.count)")
        }
        let viewControllerToBeShown = pendingViewControllers.first!
        if let segmentViewController = viewControllerToBeShown as? SegmentChartViewController {
            segmentViewController.chartMode = self.chartMode
        } else {
            guard let pieVC = viewControllerToBeShown as? PieChartViewController else { fatalError("Unknown View Controller") }
            pieVC.chartMode = self.chartMode
        }
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
        
        if let pvc = segue.destination as? UIPageViewController {
            pageViewController = pvc
            pvc.delegate = self
            pvc.dataSource = self
            
            let segmentVC = self.storyboard!.instantiateViewController(withIdentifier: "SegmentChartVC")
            
            pvc.setViewControllers([segmentVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            
        }
    }
 

}
