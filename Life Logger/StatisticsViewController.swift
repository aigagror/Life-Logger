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
    
    
    @IBOutlet weak var pageController: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    
    // MARK: Page control delegation and data source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is SegmentChartViewController {
            let ret = self.storyboard?.instantiateViewController(withIdentifier: "PieChartVC")
            return ret
        } else {
            let ret = self.storyboard?.instantiateViewController(withIdentifier: "SegmentChartVC")
            return ret
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is SegmentChartViewController {
            let ret = self.storyboard?.instantiateViewController(withIdentifier: "PieChartVC")
            return ret
        } else {
            let ret = self.storyboard?.instantiateViewController(withIdentifier: "SegmentChartVC")
            return ret
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
