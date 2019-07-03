//
//  LoadingViewController.swift
//  Temple
//
//  Created by Roman Rosenast on 6/6/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn

class LoadingViewController: UIViewController {
    
    var dailyChecklist = Array(repeating: false, count: 5)
    var pillarData = [Pillar]()
    var streaks = [Int]()
    
    var ViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.loginDone()
            } else {
                print("we are in loadingVC and user is not logged in")
                self.performSegue(withIdentifier: "needToLoginSegue", sender: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination.restorationIdentifier == "viewController") {
            let vc = segue.destination as! ViewController
            vc.dailyChecklist = dailyChecklist
            vc.pillarData = pillarData
            vc.streaks = streaks
        }
    }
    
    func loginDone() {
        let db = Database.database().reference()
        db.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var dataSnapshot = snapshot.value as? [String: Any]
        
            let keyExists = dataSnapshot?[String(Auth.auth().currentUser?.uid ?? "nil")] != nil
            
            if (keyExists) {
                self.fetchData(completion: { myTuple in
                    self.performSegue(withIdentifier: "doneLoading", sender: self)
                })
            } else {
//                try! Auth.auth().signOut()
//                GIDSignIn.sharedInstance().signOut()
                self.beginSetupSequence()
//                self.addUserToDatabase()
            }
        })
    }
    
    func beginSetupSequence() {
        self.performSegue(withIdentifier: "beginSetupSegue", sender: self)
    }
    
    func addUserToDatabase(newConfig: [Pillar]) {
        print("addUser Called")
        let db = Database.database().reference()

        // Step 1: Add user's id to top level of DB. Then add History and config starter dicts
        let myDate = Date.getDateStr(dateObj: self.dateFor(timeStamp: Date.getDateStr(dateObj: Date())) as Date)
        
        var icons = [String]()
        for index in 0...4 {
            if (newConfig[index].image.isEqualToImage(image: UIImage(named: "Other_Icon")!)) {
                icons.append("Other_Icon")
            }
            else {
                icons.append(newConfig[index].title + "_Icon")
            }
        }
        
        let starterDict = [
            "History": [
                "CurrentDay": 1,
                "Day1": [
                    "Date": myDate,
                    "P1Completed": "False",
                    "P2Completed": "False",
                    "P3Completed": "False",
                    "P4Completed": "False",
                    "P5Completed": "False"
                ]
            ],
            "Configuration": [
                "Pillar1": [
                    "Color": [
                        "R": newConfig[0].color.rgba.red,
                        "G": newConfig[0].color.rgba.green,
                        "B": newConfig[0].color.rgba.blue
                    ],
                    "Days To Complete": newConfig[0].daysToComplete,
                    "Icon": icons[0],
                    "Level": 1,
                    "Progress": 0.0,
                    "Skill": newConfig[0].title,
                    "Temple Component": newConfig[0].templeComp,
                    "Description": newConfig[0].description
                ],
                "Pillar2": [
                    "Color": [
                        "R": newConfig[1].color.rgba.red,
                        "G": newConfig[1].color.rgba.green,
                        "B": newConfig[1].color.rgba.blue
                    ],
                    "Days To Complete": newConfig[1].daysToComplete,
                    "Icon": icons[1],
                    "Level": 1,
                    "Progress": 0.0,
                    "Skill": newConfig[1].title,
                    "Temple Component": newConfig[1].templeComp,
                    "Description": newConfig[1].description
                ],
                "Pillar3": [
                    "Color": [
                        "R": newConfig[2].color.rgba.red,
                        "G": newConfig[2].color.rgba.green,
                        "B": newConfig[2].color.rgba.blue
                    ],
                    "Days To Complete": newConfig[2].daysToComplete,
                    "Icon": icons[2],
                    "Level": 1,
                    "Progress": 0.0,
                    "Skill": newConfig[2].title,
                    "Temple Component": newConfig[2].templeComp,
                    "Description": newConfig[2].description
                ],
                "Pillar4": [
                    "Color": [
                        "R": newConfig[3].color.rgba.red,
                        "G": newConfig[3].color.rgba.green,
                        "B": newConfig[3].color.rgba.blue
                    ],
                    "Days To Complete": newConfig[3].daysToComplete,
                    "Icon": icons[3],
                    "Level": 1,
                    "Progress": 0.0,
                    "Skill": newConfig[3].title,
                    "Temple Component": newConfig[3].templeComp,
                    "Description": newConfig[3].description
                ],
                "Pillar5": [
                    "Color": [
                        "R": newConfig[4].color.rgba.red,
                        "G": newConfig[4].color.rgba.green,
                        "B": newConfig[4].color.rgba.blue
                    ],
                    "Days To Complete": newConfig[4].daysToComplete,
                    "Icon": icons[4],
                    "Level": 1,
                    "Progress": 0.0,
                    "Skill": newConfig[4].title,
                    "Temple Component": newConfig[4].templeComp,
                    "Description": newConfig[4].description
                ],
            ]
        ]
        db.child(String(Auth.auth().currentUser!.uid)).setValue(starterDict)
    }
    
    func fetchData(completion: @escaping ( ([Pillar], [Bool], [Int])) -> Void) {
        let db = Database.database().reference().child(String(Auth.auth().currentUser!.uid))
        db.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var dataSnapshot = snapshot.value as? [String: Any]
            
            let history = dataSnapshot!["History"] as? [String: Any]
            
            let currentDay = history!["CurrentDay"] as! Int
            let currentDayStr = "Day" + String(currentDay)
            
            let currentDayDict = history![currentDayStr] as? [String: Any]
            
            //                Handle History Updating
            
            // Step 1: How behind are we?
            let lastLogStr = currentDayDict!["Date"] as? String ?? ""
            let lastLog: NSDate = self.dateFor(timeStamp: lastLogStr)
            let todaysDate: NSDate = self.dateFor(timeStamp: Date.getDateStr(dateObj: Date()))
            
            let calendar = Calendar.current
            
            let date1 = calendar.startOfDay(for: lastLog as Date)
            let date2 = calendar.startOfDay(for: todaysDate as Date)
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            var numberOfDaysToAdd = components.day! as Int
            
            var shouldResetDailyChecklist = false
            
            
            if (numberOfDaysToAdd >= 1) {
                
                shouldResetDailyChecklist = true
                
                // Step 2: Add the first day that they missed with completions they got
                //      Note that if there are mulitple missed days than every single once after the first will have no completions
                db.child("History/CurrentDay").setValue(currentDay + 1)
                
                let dayAfterLastLog = Calendar.current.date(byAdding: .day, value: 1, to: lastLog as Date)
                let dayAfterLastLogStr = Date.getDateStr(dateObj: dayAfterLastLog!)
                
                
                db.child("History/Day\(currentDay + 1)").setValue(["Date": dayAfterLastLogStr,
                                                                   "P1Completed": "False",
                                                                   "P2Completed": "False",
                                                                   "P3Completed": "False",
                                                                   "P4Completed": "False",
                                                                   "P5Completed": "False"])
                numberOfDaysToAdd -= 1
                
                // Step 3: for every day that they have missed, add a failed day
                var dayAccumulator = 2
                var dateObjAccumulator = Calendar.current.date(byAdding: .day, value: 1, to: (dayAfterLastLog)!)
                while (numberOfDaysToAdd > 0) {
                    
                    let nextDayStr = Date.getDateStr(dateObj: dateObjAccumulator!)
                    
                    db.child("History/Day\(currentDay + dayAccumulator)").setValue(["Date": nextDayStr,
                                                                                    "P1Completed": "False",
                                                                                    "P2Completed": "False",
                                                                                    "P3Completed": "False",
                                                                                    "P4Completed": "False",
                                                                                    "P5Completed": "False"])
                    numberOfDaysToAdd -= 1
                    dayAccumulator += 1
                    dateObjAccumulator = Calendar.current.date( byAdding: .day, value: 1, to: (dateObjAccumulator)!)
                }
                db.child("History/CurrentDay").setValue(currentDay + dayAccumulator - 1)
                
            }
            
            //                 History Handling Done
            //                 Begin Updating DailyChecklist
            
            if shouldResetDailyChecklist {
                for index in 0...4 {
                    self.dailyChecklist[index] = false
                }
            } else {
                
                for index in 1...5 {
                    
                    let skillBool = "P" + String(index) + "Completed"
                    
                    let skillStatus = currentDayDict![skillBool] as? String ?? ""
                    
                    if (skillStatus == "False") {
                        self.dailyChecklist[index - 1] = false
                    } else {
                        self.dailyChecklist[index - 1] = true
                    }
                }
            }
            
            //                 DailyChecklist Update Done
            //                 Begin Updating Configuration
            
            let configuration = dataSnapshot!["Configuration"]
            var pillarDict = configuration as? [String: Any]
            
            for PillarKey in pillarDict! {
                pillarDict![String(PillarKey.key.suffix(1))] = PillarKey.value
                pillarDict![PillarKey.key] = nil
            }
            
            let pillarDictSorted = pillarDict!.sorted(by: { $0.key < $1.key })
            
            for PillarKey in pillarDictSorted {
                var temp = PillarKey.value as? [String: Any]
                var tempColor = temp!["Color"] as? [String: CGFloat]
                let tempPillar = Pillar(title: temp?["Skill"] as! String,
                                        image: UIImage(named: temp?["Icon"] as! String)!,
                                        progress: (temp?["Progress"] as? NSNumber)!.floatValue,
                                        level: temp?["Level"] as! Int,
                                        templeComp: temp?["Temple Component"] as! String,
                                        color: UIColor(red: tempColor!["R"]!, green: tempColor!["G"]!, blue: tempColor!["B"]!, alpha: 1),
                                        daysToComplete: temp?["Days To Complete"] as! Int,
                                        description: temp?["Description"] as! String
                )
                
                self.pillarData.append(tempPillar)
                
            }
            
            //                 Done Updating Configuration
            //                 Populate Streaks Array
            
            if (history!["CurrentDay"] as! Int == 1) { // No Streaks if its the first day
                self.streaks = [0, 0, 0, 0, 0]
            } else {
                for index in 1...5 {
                    
                    let skillBool = "P" + String(index) + "Completed"
                    
                    var myDay = history!["CurrentDay"] as! Int - 1
                    var myDayStr = "Day" + String(myDay)
                    var myDayDict = history![myDayStr] as? [String: Any]
                    var skillStatus = myDayDict![skillBool] as? String ?? ""

                    var currentStreak = 0
                    while (skillStatus == "True" && myDay > 0) {
                        
                        myDay -= 1
                        myDayStr = "Day" + String(myDay)
                        myDayDict = history![myDayStr] as? [String: Any]
                        skillStatus = myDayDict![skillBool] as? String ?? ""
                        
                        currentStreak += 1
                    }
                    
                    if (self.dailyChecklist[index-1]) { currentStreak += 1} // Handle user having completed habit that day
                    
                    self.streaks.append(currentStreak)
                    
                }
            }
            
            //                  Done Populating Streaks Array
        
            completion((self.pillarData, self.dailyChecklist, self.streaks))
            
            
        })
    }
    
    func dateFor(timeStamp: String) -> NSDate
    {
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yy"
        return formater.date(from: timeStamp)! as NSDate
    }
    
}

extension Date {
    
    static func getDateStr( dateObj: Date ) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd/yy"
        
        return dateFormatter.string(from: dateObj)
        
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}

extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = self.pngData()! as NSData
        let data2: NSData = image.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
}
