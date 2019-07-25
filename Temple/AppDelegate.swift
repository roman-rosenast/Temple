//
//  AppDelegate.swift
//  Temple
//
//  Created by Roman Rosenast on 5/30/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import UserNotifications
import IQKeyboardManagerSwift

//    GLOBAL APP DATA

let MAX_PILLAR_LEVEL: Int = 4
let NUMBER_OF_TEMPLES: Int = 2

var db: DatabaseReference?
var currentTempledbRef: DatabaseReference?

struct Pillar {
    var title: String
    var image: UIImage
    var progress: Float
    var level: Int
    var templeComp: String
    var color: UIColor
    var daysToComplete: Int
    var description: String
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "loadingViewController") as UIViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        setupNotifications()
        
        IQKeyboardManager.shared.enable = true
        
        return true
    }
    
    func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests { (notifications) in
            if (notifications.count < 1) {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                    if granted {
                        print("Notification Authorization granted")
                        self.scheduleNotification()
                    } else {
                        print("Notification Authorization denied :(")
                    }
                }
            }
        }
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget to log your habits!"
        content.body = ""
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 12 + 9
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "Nightly Notification", content: content, trigger: trigger)
        center.add(request)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.restrictRotation
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "loadingViewController") as UIViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        print("attempted to sign in")
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("error returned from signIn")
                return
            }
            // User is signed in
            print("user logged in email \(user.profile.email)")
            setupDbRef()
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "loadingViewController") as UIViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

}

func setupDbRef() {
    db = Database.database().reference()
    
    db!.child(String(Auth.auth().currentUser!.uid)).observeSingleEvent(of: .value, with: { (snapshot) in
        var dataSnapshot = snapshot.value as? [String: Any]
        
        var iterator = 1
        var templeExists = dataSnapshot?["Temple\(iterator + 1)"] != nil
        while (templeExists) {
            
            iterator += 1
            templeExists = dataSnapshot?["Temple\(iterator + 1)"] != nil
        }
        
        currentTempledbRef = db!.child(String(Auth.auth().currentUser!.uid)).child("Temple\(iterator)")
    })
}
