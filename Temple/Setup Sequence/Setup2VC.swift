//
//  Setup2VC.swift
//  Temple
//
//  Created by Roman Rosenast on 6/15/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit

class Setup2VC: SetupStepVC, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCustomHabit: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.addCustomHabit.delegate = self
        
        tableView.setEditing(true, animated: false)
        tableView.allowsSelectionDuringEditing = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let pvc = self.parent as? SetupViewController
        return pvc?.setupPillars.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habit", for: indexPath)
            as! HabitTableViewCell
        
        let pvc = self.parent as? SetupViewController
        
        cell.habitIcon.image = pvc?.setupPillars[indexPath.row].image
        cell.habitLabel.text = pvc?.setupPillars[indexPath.row].title
        
        if (indexPath.row < 5) {
            cell.habitBG.layer.borderWidth = 3
            cell.habitBG.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            cell.NumberLabel.text = String(indexPath.row + 1)
        } else {
            cell.habitBG.layer.borderWidth = 0
            cell.habitBG.backgroundColor = .white
            cell.NumberLabel.text = ""
        }
        
        cell.cellWidthConstraint.constant = tableView.bounds.width
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let pvc = self.parent as? SetupViewController
        
        let habitToMove = (pvc?.setupPillars[sourceIndexPath.row])!
        
        pvc?.setupPillars.remove(at: sourceIndexPath.row)
        pvc?.setupPillars.insert(habitToMove, at: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //            let cell: HabitTableViewCell = tableView.cellForRow(at: indexPath) as! HabitTableViewCell

        CATransaction.begin()
        tableView.beginUpdates()
        
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0) )
        
        let pvc = self.parent as? SetupViewController
        let habitToMove = (pvc?.setupPillars[indexPath.row])!
        pvc?.setupPillars.remove(at: indexPath.row)
        pvc?.setupPillars.insert(habitToMove, at: 0)
        
        CATransaction.setCompletionBlock { () -> Void in
            tableView.reloadData()
        }
        tableView.endUpdates()
        CATransaction.commit()

    }
    
    //    END TABLE SECTION
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 15
    }
    
    @IBAction func addCustomHabit(_ sender: UITextField) {
        
        var weAreGoodToGo = true ? (addCustomHabit.text != "") : false
        
        let pvc = self.parent as? SetupViewController
        
        for pillar in pvc!.setupPillars {
            if (pillar.title == addCustomHabit.text) {
                weAreGoodToGo = false
            }
        }
        if (weAreGoodToGo) {
            pvc?.setupPillars.insert(Pillar(title: addCustomHabit.text!, image: UIImage(named: "Other_Icon")!, progress: 0, level: 1, templeComp: "", color: UIColor(red:0.91, green:0.77, blue:0.93, alpha:1.0), daysToComplete: 12, description: "Description of \(addCustomHabit.text!)"), at: 0)
        }
        addCustomHabit.text = "Add Your Own Habit"
        tableView.reloadData()
    }
    
}

class HabitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var habitIcon: UIImageView!
    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var habitBG: UIView!
    @IBOutlet weak var NumberLabel: UILabel!
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        habitBG.layer.cornerRadius = self.layer.bounds.height/2
    }
}

extension UITableView {
    override open func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if "\(type(of: subview))" == "UIShadowView" {
            subview.removeFromSuperview()
        }
    }
}

class NeverClearView: UIView {
    override var backgroundColor: UIColor? {
        didSet {
            if UIColor.clear.isEqual(backgroundColor) {
                backgroundColor = .white
            }
        }
    }
}
