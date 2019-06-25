//
//  Setup5VC.swift
//  Temple
//
//  Created by Roman Rosenast on 6/15/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit

class Setup5VC: SetupStepVC {

    @IBOutlet weak var startTemple: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTemple.layer.borderWidth = 3
        startTemple.layer.masksToBounds = true
        startTemple.layer.cornerRadius = 20
        
        startLabel.font = UIFont(name:"Roboto",size:30)
    }
    
    @IBAction func startTemple(_ sender: Any) {
        
        
        let pvc = self.parent as? SetupViewController
        pvc?.myConfiguration = Array((pvc?.setupPillars.prefix(5))!)
        pvc?.endSetup()
    }

}
