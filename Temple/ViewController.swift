//
//  ViewController.swift
//  Temple
//
//  Created by Roman Rosenast on 5/30/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var pillarsTableView: UITableView!
    @IBOutlet weak var mainTabBar: UITabBar!
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var TempleTapHandler: UIButton!
    
    //    Sprite Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var pillar1ImageView: UIImageView!
    @IBOutlet weak var pillar2ImageView: UIImageView!
    @IBOutlet weak var pillar3ImageView: UIImageView!
    @IBOutlet weak var pillar4ImageView: UIImageView!
    @IBOutlet weak var pillar5ImageView: UIImageView!
    
    //    Outlets for Sprite Top Margins
    @IBOutlet weak var P5TopMargin: NSLayoutConstraint!
    @IBOutlet weak var P4TopMargin: NSLayoutConstraint!
    @IBOutlet weak var P3TopMargin: NSLayoutConstraint!
    @IBOutlet weak var P2TopMargin: NSLayoutConstraint!
    @IBOutlet weak var P1TopMargin: NSLayoutConstraint!
    @IBOutlet weak var BGTopMargin: NSLayoutConstraint!
    @IBOutlet weak var ButtonTopMargin: NSLayoutConstraint!
    
    //    Outlets for Sprite Widths
    @IBOutlet weak var ButtonW: NSLayoutConstraint!
    @IBOutlet weak var BGW: NSLayoutConstraint!
    @IBOutlet weak var P1W: NSLayoutConstraint!
    @IBOutlet weak var P2W: NSLayoutConstraint!
    @IBOutlet weak var P3W: NSLayoutConstraint!
    @IBOutlet weak var P4W: NSLayoutConstraint!
    @IBOutlet weak var P5W: NSLayoutConstraint!
    
    var buildViewController: UIViewController?
    var statsViewController: UIViewController?
    var settingsViewController: UIViewController?
    
    var readyToUpgrade = false
    var spaceBetweenRows: CGFloat = 10
    
    var pillarData: [Pillar]?
    var dailyChecklist: [Bool]?
    var streaks: [Int]?
    
//    Description Views
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        
        return cv
    }()
//    End Description Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabBar.delegate = self
        checkforUpgrade(self)
        setupTemple()
        applyStyles()
        
        self.pillarsTableView.delegate = self
        self.pillarsTableView.dataSource = self
        
        let calendar = Calendar.current
        let now = Date()
        let date = calendar.date(
            bySettingHour: 23,
            minute: 59,
            second: 59,
            of: now)!
        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(midnightReload), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        
        //Long Press
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.pillarsTableView.addGestureRecognizer(longPressGesture)
                
    }
    
    @objc func midnightReload() {
        print("Automated Midnight reload triggered")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "loadingViewController") as! LoadingViewController
        present(secondVC, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pillarsTableView.reloadData()
        snakeHints()
    }
    
    func dynamicRowHeight() -> CGFloat {
        let MinHeight: CGFloat = 30.0
        let tHeight = pillarsTableView.bounds.height
        
        let temp = (tHeight - (spaceBetweenRows * 5)) / CGFloat(5)
        
        return temp > MinHeight ? temp : MinHeight
    }
    
    func applyStyles() {
        
//        Night mode handling
        let now = Date()
        let morning = now.dateAt(hours: 6, minutes: 0)
        let night = now.dateAt(hours: 21, minutes: 0)
        
        if now <= morning ||
            now >= night
        {
            backgroundImageView.image = UIImage(named: "Temple-Background-Only-Night")
        }
        
        pillarsTableView.layer.backgroundColor = UIColor.clear.cgColor
        pillarsTableView.backgroundColor = .clear
        
        mainTabBar.tintColor = UIColor(red: 0.98, green: 0.412, blue: 0, alpha: 1)
        mainTabBar.backgroundImage = UIImage.colorAsImage(from: UIColor.clear, for: CGSize(width: 1, height: 1))
        
        mainTabBar.layer.borderWidth = 0.50
        mainTabBar.layer.borderColor = UIColor.clear.cgColor
        mainTabBar.clipsToBounds = true
        
//      Handle responsive top margin
        let TopMargins: [NSLayoutConstraint] = [
            P5TopMargin,
            P4TopMargin,
            P3TopMargin,
            P2TopMargin,
            P1TopMargin,
            BGTopMargin,
            ButtonTopMargin
        ]
        let screenHeight = UIScreen.main.bounds.height
        for constraint in TopMargins {
            constraint.constant = screenHeight/20
        }
        
//      Handle responsive temple image
        let Widths = [
            ButtonW,
            BGW,
            P1W,
            P2W,
            P3W,
            P4W,
            P5W
        ]
        for constraint in Widths {
            constraint!.constant = screenHeight/3
        }
        
        TempleTapHandler.layer.cornerRadius = screenHeight/6
        TempleTapHandler.clipsToBounds = true

    }
    
//    BEGIN TABLE SECTION
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dynamicRowHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return spaceBetweenRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pillar", for: indexPath)
            as! PillarTableViewCell
        
        cell.PillarCellLabel.text = pillarData?[indexPath.section].title
        if (dailyChecklist![indexPath.section] == false) {
            cell.PillarCellImage.image = self.pillarData?[indexPath.section].image
        } else {
            cell.PillarCellImage.image = UIImage(named: "Check_Icon")
        }
        cell.PillarCellProgress.layer.cornerRadius = 8
        cell.PillarCellProgress.clipsToBounds = true
        cell.PillarCellProgress.layer.sublayers![1].cornerRadius = 8
        cell.PillarCellProgress.subviews[1].clipsToBounds = true
        cell.PillarCellProgress.trackTintColor =
            UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        cell.PillarCellProgress.progressTintColor = pillarData?[indexPath.section].color
        
        cell.PillarCellProgress.setProgress(pillarData?[indexPath.section].progress ?? 0.0, animated: false)
        cell.PillarCellProgress.layoutIfNeeded()
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        
        cell.templeComp = pillarData![indexPath.section].templeComp
        
        if (streaks![indexPath.section] > 0) {
            cell.PillarCellStreak.text = String(streaks![indexPath.section])
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        var completeAction: UIContextualAction
        
        if (dailyChecklist![indexPath.section]) {
            completeAction = UIContextualAction(style: .normal, title:  "un-Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("\(self.pillarData![indexPath.section].title) marked as Incomplete.")
                self.unLogSkill(skillNumber: indexPath.section + 1)
            
                success(true)
            })
        } else {
            completeAction = UIContextualAction(style: .normal, title:  "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("\(self.pillarData![indexPath.section].title) marked as Complete!")
                self.logSkill(skillNumber: indexPath.section + 1)
                success(true)
            })
        }
        
        completeAction.backgroundColor = UIColor.getComplementColor(color: pillarData![indexPath.section].color)
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    
//    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
//    {
//        tableView.reloadRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
//    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        return UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: PillarTableViewCell = tableView.cellForRow(at: indexPath) as! PillarTableViewCell
//        showDescription(habit: 0)
        cell.animateSwipeHint()
    }
    
//    END TABLE SECTION
    
    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.pillarsTableView)
        let indexPath = self.pillarsTableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        }
        else if (longPressGesture.state == UIGestureRecognizer.State.began) {
            showDescription(habit: indexPath!.section + 1)
        }
    }
    
    func showDescription(habit: Int) {
        if let window = UIApplication.shared.keyWindow {
            
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)

            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDescription)))

            window.addSubview(blackView)
            
            let labelWidth = self.view.bounds.width - 100
            let label = UILabel(frame: CGRect(x: self.view.center.x - labelWidth/2, y: 0, width: labelWidth, height: 250))
            label.textAlignment = .center
            let streakText = (streaks![habit - 1] > 0) ? "\(streaks![habit - 1]) Day Streak" : "No Current Streak"
            label.attributedText = attributedText(myString: "\(pillarData![habit - 1].title)\n\(pillarData![habit - 1].description)\n\n\(streakText)\nThe \(pillarData![habit - 1].templeComp) of your Temple", habit: habit)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            
            collectionView.addSubview(label)
            
            let imageWidth = 50
            let icon = UIImageView(frame: CGRect(x: Int(self.view.center.x) - imageWidth/2, y: 15, width: imageWidth, height: imageWidth))
            icon.image = pillarData![habit - 1].image
            icon.layer.backgroundColor = pillarData![habit - 1].color.cgColor
            icon.layer.masksToBounds = true
            icon.layer.cornerRadius = 8 //icon.bounds.width/2
            
            collectionView.addSubview(icon)
            
            window.addSubview(collectionView)

            let height: CGFloat = 250
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)

            blackView.frame = window.frame
            blackView.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

                self.blackView.alpha = 1

                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)

            }, completion: nil)
        }
    }

    func attributedText(myString: String, habit: Int) -> NSAttributedString {
        
        let string = myString as NSString
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15.0)])
        
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0)]
        let titleFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25.0)]
        
        // Part of string to be customized
        attributedString.addAttributes(titleFontAttribute, range: string.range(of: "\(pillarData![habit - 1].title)"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "The \(pillarData![habit - 1].templeComp) of your Temple"))
        let streakText = (streaks![habit - 1] > 0) ? "\(streaks![habit - 1]) Day Streak" : "No Current Streak"
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "\(streakText)"))
        
        return attributedString
    }
    
    @objc func dismissDescription() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) {_ in
            for subview in self.collectionView.subviews {
                subview.removeFromSuperview()
            }
        }
    }
    
    func upgradeTemple( skill: Int ) {
        readyToUpgrade = false
        if (pillarData![skill-1].level < MAX_PILLAR_LEVEL) {
            
            pillarData![skill-1].level += 1
            pillarData![skill-1].progress = 0
            
            let db = Database.database().reference().child(String(Auth.auth().currentUser!.uid))
            db.child("Configuration/Pillar\(skill)/Level").setValue( pillarData![skill-1].level )
            db.child("Configuration/Pillar\(skill)/Progress").setValue( 0.0 )
        
            setupTemple()
        
        } else {
            print("\(pillarData![skill-1].title) is already at the maximum level. Well done!")
        }
    }
    
    func downgradeTemple( skill: Int ) {
        if (pillarData![skill-1].level > 1) {
            let secondToMaxVal: Float = 1.0 - 1.0/(Float(pillarData![skill-1].daysToComplete)/Float(MAX_PILLAR_LEVEL))
            let db = Database.database().reference().child(String(Auth.auth().currentUser!.uid))
            db.child("Configuration/Pillar\(skill)/Level").setValue( pillarData![skill-1].level - 1 )
            db.child("Configuration/Pillar\(skill)/Progress").setValue( secondToMaxVal )
            
            pillarData![skill-1].level -= 1
            pillarData![skill-1].progress = secondToMaxVal
            setupTemple()
            
        } else {
            print("\(pillarData![skill-1].title) is already at the minimum level. This should never get called.")
        }
        pillarsTableView.reloadData()
    }
    
    func readyToUpgrade(myColor: UIColor, skillTitle: String) {
        
//        if readyToUpgrade {
//            TempleTapHandler.setTitle("Upgrade", for: .normal)
//        } else {
//            TempleTapHandler.setTitle("Upgrade \(skillTitle)", for: .normal)
//        }
        
        TempleTapHandler.setImage(UIImage(named: "Tap_Icon"), for: .normal)
        TempleTapHandler.tintColor = .black
        view.bringSubviewToFront(TempleTapHandler)
        
        TempleTapHandler.layer.borderColor = UIColor.black.cgColor //myColor.cgColor
        TempleTapHandler.animateBorderWidth(toValue: 6.0, duration: 0.2)
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 0.75
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        TempleTapHandler.layer.add(pulseAnimation, forKey: nil)
        
        readyToUpgrade = true
    }
    
    func logSkill( skillNumber: Int ) {
        
        //        Synchronous local data updating
        
        dailyChecklist![skillNumber - 1] = true
        
        let incrementedValue = pillarData![skillNumber - 1].progress + (1.0 / (Float(pillarData![skillNumber-1].daysToComplete)/Float(MAX_PILLAR_LEVEL)))
        pillarData![skillNumber - 1].progress = incrementedValue
        
        let cell: PillarTableViewCell = pillarsTableView.cellForRow(at: IndexPath(row: 0, section: skillNumber - 1 )) as! PillarTableViewCell
        cell.PillarCellProgress.setProgress(incrementedValue, animated: false)
        cell.PillarCellProgress.layoutIfNeeded()
        
        if (incrementedValue >= 1 ) {
            self.readyToUpgrade(myColor: self.pillarData![skillNumber - 1].color, skillTitle: self.pillarData![skillNumber - 1].templeComp)
        }
        
        streaks![skillNumber - 1] += 1
        
        //        Asynchronous backend data updating
        
        let db = Database.database().reference().child(String(Auth.auth().currentUser!.uid))
        
        db.child("History/CurrentDay").observeSingleEvent(of: .value, with: { (snapshot) in
            let currentDay = (snapshot.value as? Int)!
            let currentDayStr = "Day" + String(currentDay)
            
            let skillBool = "P" + String(skillNumber) + "Completed"
            db.child("History/\(currentDayStr)/\(skillBool)").setValue("True")
            
            let configPillarNum = "Pillar" + String(skillNumber)
            db.child("Configuration/\(configPillarNum)/Progress").setValue(incrementedValue)
            
        })
        
        checkForDailyCompletion()
        
        pillarsTableView.reloadData()

    }
    
    func unLogSkill( skillNumber: Int ) {
        
        //        Synchronous local data updating
        
        dailyChecklist![skillNumber - 1] = false
        
        let decrementedValue = pillarData![skillNumber - 1].progress - (1.0 / (Float(pillarData![skillNumber-1].daysToComplete)/Float(MAX_PILLAR_LEVEL)))
        
        if (decrementedValue < 0) {
            self.downgradeTemple(skill: skillNumber)
        } else {
            pillarData![skillNumber - 1].progress = decrementedValue
        }
        
        streaks![skillNumber - 1] -= 1
        
        //        Asynchronous backend data updating
        
        let db = Database.database().reference().child(String(Auth.auth().currentUser!.uid))
        
        db.child("History/CurrentDay").observeSingleEvent(of: .value, with: { (snapshot) in
            let currentDay = (snapshot.value as? Int)!
            let currentDayStr = "Day" + String(currentDay)
            
            let skillBool = "P" + String(skillNumber) + "Completed"
            db.child("History/\(currentDayStr)/\(skillBool)").setValue("False")
            
            if (decrementedValue >= 0) {
                let configPillarNum = "Pillar" + String(skillNumber)
                db.child("Configuration/\(configPillarNum)/Progress").setValue(decrementedValue)
            }
            
        })
        
        //         Handling for multiple skills being ready to upgrade on unlog() call
        
        var noSkillsReadyToUpgrade: Bool = true
        for index in 0...4 {
            if (self.pillarData![index].progress >= 1) {
                noSkillsReadyToUpgrade = false
            }
        }
        if (noSkillsReadyToUpgrade) { // if all skills are not ready
            self.deanimateTemple()
        }
        
        pillarsTableView.reloadData()
    }
    
    func snakeHints() {
        var delay = 0.0
        for index in 0...4 {
            let cell = pillarsTableView.cellForRow(at: IndexPath(row: 0, section: index)) as! PillarTableViewCell
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                if !self.dailyChecklist![index] {
                    cell.animateSwipeHint()
                }
            })
            delay += 0.04
        }
    }
    
    func checkForDailyCompletion() {
        if dayIsComplete() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                let alert = UIAlertController(title: "Well Done", message: "You completed every habit today! Relax and enjoy the rest of your day.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            })
        }
    }
    
    func dayIsComplete() -> Bool {
        for myBool in dailyChecklist! {
            if !myBool {
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.destination.restorationIdentifier == "buildViewID") {
            let vc = segue.destination as? BuildViewController
            vc!.pillarData = pillarData
            vc!.dailyChecklist = dailyChecklist
            vc!.streaks = streaks
        }
        
        else if (segue.destination.restorationIdentifier == "statsViewID") {
            let vc = segue.destination as? StatsViewController
            vc!.pillarData = pillarData
            vc!.dailyChecklist = dailyChecklist
            vc!.streaks = streaks
        }
        
        else  { // transitioning to settings vc
            let vc = segue.destination as? SettingsViewController
            vc!.pillarData = pillarData
            vc!.dailyChecklist = dailyChecklist
            vc!.streaks = streaks
        }
        
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.tag {
            
        case 1:
            performSegue(withIdentifier: "showBuildModal", sender: self)
            break
            
        case 2:
            performSegue(withIdentifier: "showStatsModal", sender: self)
            break
        
        case 3:
            performSegue(withIdentifier: "showSettingsModal", sender: self)
            break
            
        default:
            break
            
        }   
        
    }
    
    func setupTemple() {
        
        UIView.transition(with: self.pillar1ImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.pillar1ImageView.image = UIImage(named: "Temple-Level\(self.pillarData![0].level)-\(self.pillarData![0].templeComp)") },
                          completion: nil)
        
        UIView.transition(with: self.pillar2ImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.pillar2ImageView.image = UIImage(named: "Temple-Level\(self.pillarData![1].level)-\(self.pillarData![1].templeComp)") },
                          completion: nil)
        
        UIView.transition(with: self.pillar3ImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.pillar3ImageView.image = UIImage(named: "Temple-Level\(self.pillarData![2].level)-\(self.pillarData![2].templeComp)") },
                          completion: nil)
        
        UIView.transition(with: self.pillar4ImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.pillar4ImageView.image = UIImage(named: "Temple-Level\(self.pillarData![3].level)-\(self.pillarData![3].templeComp)") },
                          completion: nil)
        
        UIView.transition(with: self.pillar5ImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.pillar5ImageView.image = UIImage(named: "Temple-Level\(self.pillarData![4].level)-\(self.pillarData![4].templeComp)") },
                          completion: nil)
    }
    
    @IBAction func checkforUpgrade(_ sender: Any) {
        for index in 1...5 {
            if ( pillarData![index-1].progress >= 1.0) {
                upgradeTemple(skill: index)
                setupTemple()
            }
        }
        deanimateTemple()
    }
    
    func deanimateTemple() {
        TempleTapHandler.animateBorderWidth(toValue: 0, duration: 1.0)
        TempleTapHandler.layer.removeAllAnimations()
        //        TempleTapHandler.setTitle("", for: .normal)
        TempleTapHandler.setImage(UIImage(), for: .normal)
        pillarsTableView.reloadData()
    }
    
}

extension UIImage {
    class func colorAsImage(from color:UIColor, for size:CGSize) -> UIImage? {
        var img:UIImage?
        let rect = CGRect(x:0.0, y:0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let colorImage = img else { return nil }
        return colorImage
    }
}

extension Date
{
    
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}

extension UIView {
    func animateBorderWidth(toValue: CGFloat, duration: Double) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = layer.borderWidth
        animation.toValue = toValue
        animation.duration = duration
        layer.add(animation, forKey: "Width")
        layer.borderWidth = toValue
    }
    
    func constraintWithIdentifier(_ identifier: String) -> NSLayoutConstraint? {
        return self.constraints.first { $0.identifier == identifier }
    }
}

extension UIColor {
    static func getComplementColor(color: UIColor) -> UIColor{
        
        let ciColor = CIColor(color: color)
        
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        
        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
    }
}

class PillarTableViewCell: UITableViewCell {
    @IBOutlet weak var PillarCellImage: UIImageView!
    @IBOutlet weak var PillarCellLabel: UILabel!
    @IBOutlet weak var PillarCellProgress: UIProgressView!
    @IBOutlet weak var PillarCellStreak: UILabel!
    
    @IBOutlet weak var PillarCellBehind: UIView!
    @IBOutlet weak var PillarCellBackground: UIView!
    
    let swipeHintDistance: CGFloat = 75
    
    var templeComp: String = "temp"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.5 // half second press
        longPressGesture.delegate = self
        self.addGestureRecognizer(longPressGesture)
    }
    
    func animateSwipeHint() {
        slideInFromLeft()
    }
    
    func peakTempleComp() {
        
        let temp = self.PillarCellLabel.text
        
        self.PillarCellLabel.text = self.templeComp
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.PillarCellLabel.text = temp
        }
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            peakTempleComp()
        }
    }
    
    private func slideInFromLeft() {
        
        self.PillarCellBehind.layer.backgroundColor = UIColor.getComplementColor(color: self.PillarCellProgress.progressTintColor!).cgColor
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut], animations: {
            self.PillarCellProgress.transform = CGAffineTransform(translationX: self.swipeHintDistance, y: 0)
            self.PillarCellImage.transform = CGAffineTransform(translationX: self.swipeHintDistance, y: 0)
            self.PillarCellLabel.transform = CGAffineTransform(translationX: self.swipeHintDistance, y: 0)
            self.PillarCellBackground.transform = CGAffineTransform(translationX: self.swipeHintDistance, y: 0)
            self.PillarCellStreak.transform = CGAffineTransform(translationX: self.swipeHintDistance, y: 0)
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: {
                self.PillarCellProgress.transform = .identity
                self.PillarCellImage.transform = .identity
                self.PillarCellLabel.transform = .identity
                self.PillarCellBackground.transform = .identity
                self.PillarCellStreak.transform = .identity
            })
        }
    }
}
