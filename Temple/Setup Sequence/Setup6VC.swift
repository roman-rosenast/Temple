//
//  Setup5VC.swift
//  Temple
//
//  Created by Roman Rosenast on 6/15/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit

class Setup6VC: SetupStepVC {

    @IBOutlet weak var startTemple: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTemple.layer.borderWidth = 2
        startTemple.layer.masksToBounds = true
        startTemple.layer.cornerRadius = 8
        
    }
    
    @IBAction func startTemple(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.myConfiguration = Array((pvc?.setupPillars.prefix(5))!)
        pvc?.endSetup()
    }

}
