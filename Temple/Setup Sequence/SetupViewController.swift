//
//  SetupViewController.swift
//  Temple
//
//  Created by Roman Rosenast on 6/15/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var setupScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var pages = [SetupStepVC]()
    
    var myConfiguration = [Pillar]()
    
    var setupPillars = [
        Pillar(title: "Meditation", image: UIImage(named: "Meditation_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.98, green:0.41, blue:0.00, alpha:1.0)
, daysToComplete: 12),
        Pillar(title: "Exercise", image: UIImage(named: "Exercise_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.95, green:0.53, blue:0.19, alpha:1.0)
, daysToComplete: 12),
        Pillar(title: "Diet", image: UIImage(named: "Diet_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.88, green:0.89, blue:0.80, alpha:1.0)
, daysToComplete: 12),
        Pillar(title: "Sleep", image: UIImage(named: "Sleep_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.65, green:0.86, blue:0.85, alpha:1.0), daysToComplete: 12),
        Pillar(title: "Hydration", image: UIImage(named: "Hydration_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.41, green:0.82, blue:0.91, alpha:1.0), daysToComplete: 12),
        Pillar(title: "Family", image: UIImage(named: "Family_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.23, green:0.54, blue:0.41, alpha:1.0), daysToComplete: 12),
        Pillar(title: "Language", image: UIImage(named: "Language_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.33, green:0.47, blue:0.48, alpha:1.0), daysToComplete: 12),
        Pillar(title: "Yoga", image: UIImage(named: "Yoga_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.93, green:0.82, blue:0.47, alpha:1.0), daysToComplete: 12),
        
        Pillar(title: "Read", image: UIImage(named: "Read_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.23, green:0.54, blue:0.41, alpha:1.0), daysToComplete: 12),
        Pillar(title: "Save", image: UIImage(named: "Save_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.85, green:0.36, blue:0.26, alpha:1.0), daysToComplete: 12),
        Pillar(title: "Floss", image: UIImage(named: "Floss_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.81, green:0.94, blue:0.62, alpha:1.0), daysToComplete: 12),
        Pillar(title: "Journal", image: UIImage(named: "Journal_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.07, green:0.44, blue:0.65, alpha:1.0), daysToComplete: 12)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScrollView.delegate = self

        let page1: SetupStepVC = addSetupStep(setupNumber: 1) as! Setup1VC
        let page2: SetupStepVC = addSetupStep(setupNumber: 2) as! Setup2VC
        let page3: SetupStepVC = addSetupStep(setupNumber: 3) as! Setup3VC
        let page4: SetupStepVC = addSetupStep(setupNumber: 4) as! Setup4VC
        let page5: SetupStepVC = addSetupStep(setupNumber: 5) as! Setup5VC
        pages = [page1, page2, page3, page4, page5]
        
        let views: [String: UIView] = ["view": view, "page1": page1.view, "page2": page2.view, "page3": page3.view, "page4": page4.view, "page5": page5.view]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[page1(==view)]|", options: [], metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[page1(==view)][page2(==view)][page3(==view)][page4(==view)][page5(==view)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraints + horizontalConstraints)
        
        pageControl.numberOfPages = 5
        
    }
    
    //    Plan: call method whenever a swipe is registered that updates the tableviews of Setup3VC and Setup4VC
    var previousPageXOffset: CGFloat = 0.0
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let targetOffset = targetContentOffset.pointee
        
        if targetOffset.x == previousPageXOffset {
            // page will not change
        } else if targetOffset.x < previousPageXOffset {
            // scroll view will page left
        } else if targetOffset.x > previousPageXOffset {
            updateTables()
        }
        
        previousPageXOffset = targetOffset.x
        // If you want to track the index of the page you are on just just divide the previousPageXOffset by the scrollView width.
        // let index = Int(previousPageXOffset / scrollView.frame.width)
        
    }
    
    func updateTables() {
        pages[2].reloadTable()
        pages[3].reloadTable()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width: Float = Float(scrollView.frame.size.width)
        let xPos: Float = Float(scrollView.contentOffset.x + 10)
        pageControl.currentPage = Int(xPos/width)
    }
    
    func addSetupStep(setupNumber: Int) -> UIViewController {
        let setupStep = storyboard!.instantiateViewController(withIdentifier: "setup\(setupNumber)VC")
        setupStep.view.translatesAutoresizingMaskIntoConstraints = false
        setupScrollView.addSubview(setupStep.view)
        addChild(setupStep)
        setupStep.didMove(toParent: self)
        
        return setupStep
        
    }
    
    func endSetup() {
        self.performSegue(withIdentifier: "setupDone", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Quick finalization of PillarData
        var templeComponents = [
            "Walls",
            "Archway",
            "Foundation",
            "Roof",
            "Door"
        ]
        
        for index in 0...4 {
            myConfiguration[index].templeComp = templeComponents[index]
        }
        
        let vc = segue.destination as! LoadingViewController
        vc.addUserToDatabase(newConfig: myConfiguration)
    }

}
