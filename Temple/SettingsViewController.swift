//
//  SettingsViewController.swift
//  Temple
//
//  Created by Roman Rosenast on 6/7/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var modalWindow: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    var pillarData: [Pillar]?
    var dailyChecklist: [Bool]?
    var streaks: [Int]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let boldText  = "Logged in as: \n"
        let font = UIFont(name: "Roboto", size: 15)
        let attrs = [NSAttributedString.Key.font: font]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs as [NSAttributedString.Key : Any])
        
        let normalText = Auth.auth().currentUser?.displayName
        let normalString = NSMutableAttributedString(string:normalText!)
        
        attributedString.append(normalString)
        
        usernameLabel.attributedText = attributedString

        modalWindow.layer.cornerRadius = 8
        modalWindow.clipsToBounds = true
        
        resetButton.layer.cornerRadius = 8
        resetButton.clipsToBounds = true
//        resetButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        resetButton.titleLabel?.numberOfLines = 4
        resetButton.titleLabel?.textAlignment = .center
        resetButton.titleLabel?.minimumScaleFactor = 0.5
        resetButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 2.0
        longPressGesture.delegate = self
        resetButton.addGestureRecognizer(longPressGesture)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? ViewController
        vc!.pillarData = pillarData
        vc!.dailyChecklist = dailyChecklist
        vc!.streaks = streaks
    }
    
    @IBAction func dismiss(_ sender: Any) {
        performSegue(withIdentifier: "hideSettingsModal", sender: self)
    }
    
    @IBAction func signOutCurrentUSer(_ sender: Any) {
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        print("user signed out")
        
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "loadingViewController") as! LoadingViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            print("Reset Request Recieved!")
            resetTemple()
        }
    }
    
    func resetTemple() {
        let db = Database.database().reference().child(String(Auth.auth().currentUser!.uid))
        db.setValue(nil)
        
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "loadingViewController") as! LoadingViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    
}
