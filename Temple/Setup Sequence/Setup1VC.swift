//
//  Setup1VC.swift
//  Temple
//
//  Created by Roman Rosenast on 6/15/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class Setup1VC: SetupStepVC {
    
    @IBOutlet weak var swipeImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoutButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIImageView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            
            self.swipeImage.transform = CGAffineTransform(translationX: -50, y: 0)
            
        }, completion: nil)
        
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        print("user signed out")
        
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "loadingViewController") as! LoadingViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
 }
