//
//  BuildViewController.swift
//  Temple
//
//  Created by Roman Rosenast on 6/4/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BuildViewController: UIViewController  {

    @IBOutlet weak var modalWindow: UIView!
    
    var pillarData: [Pillar]?
    var dailyChecklist: [Bool]?
    var streaks: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func applyStyles() {
        modalWindow.layer.cornerRadius = 8
        modalWindow.clipsToBounds = true
        
    }
    
    @IBAction func dismissBuildVC(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "hideBuildModal", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! ViewController
        vc.pillarData = pillarData
        vc.dailyChecklist = dailyChecklist
        vc.streaks = streaks
    }

}

class BuildTableViewCell: UITableViewCell {
    @IBOutlet weak var roundButton: UIButton!
    @IBOutlet weak var buildLabel: UILabel!
}
