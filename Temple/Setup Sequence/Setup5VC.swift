//
//  Setup4VC.swift
//  Temple
//
//  Created by Roman Rosenast on 6/15/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit

class Setup5VC: SetupStepVC, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerIsShown = false
    var currentlySelectedRow: Int? = nil
    
    var pickerOptions = [
        "Daily",
        "3-5 Times per Week",
        "1-2 Times per Week"
    ]
    
    var rigorSelectionArray = [
        0,
        0,
        0,
        0,
        0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.picker.delegate = self
        self.picker.dataSource = self
        
    }
    
    override func reloadTable() {
        tableView.reloadData()
    }
    
//    Begin Table Section
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dynamicRowHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rigor", for: indexPath)
            as! RigorCell
        
        let pvc = self.parent as? SetupViewController
        
        cell.rigorLabel.text = (pvc?.setupPillars[indexPath.row].title)! + ":"
        cell.rigorSelection.text = pickerOptions[rigorSelectionArray[indexPath.row]]
        
            cell.rigorBG.layer.borderWidth = 3
        cell.rigorBG.layer.masksToBounds = true
        cell.rigorBG.layer.cornerRadius = cell.rigorBG.layer.bounds.height/2
        cell.rigorBG.backgroundColor = pvc?.setupPillars[indexPath.row].color
                
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentlySelectedRow = indexPath.row
        
        if (!pickerIsShown){
            let myRow = rigorSelectionArray[indexPath.row]
            picker.selectRow(myRow, inComponent:0, animated:false)
            pickerView.animShow()
            pickerIsShown = true
            
        } else {
            pickerView.animHide()
            pickerIsShown = false
        }
    }
    
//    End Table Section
//    Begin Picker Section
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        rigorSelectionArray[currentlySelectedRow!] = row

        tableView.reloadRows(at: [IndexPath(row: currentlySelectedRow!, section: 0)], with: .none)
        
        // Handle parent model updating
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[currentlySelectedRow!].daysToComplete = (row + 1) * 4
    }
    
//    End Picker Section
    
    func dynamicRowHeight() -> CGFloat {
        let MinHeight: CGFloat = 30.0
        let tHeight = tableView.bounds.height
        
        let temp = tHeight / CGFloat(5)
        
        return temp > MinHeight ? temp : MinHeight
    }

}

class RigorCell: UITableViewCell {
    
    @IBOutlet weak var rigorLabel: UILabel!
    @IBOutlet weak var rigorSelection: UILabel!
    @IBOutlet weak var rigorBG: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension UIView{
    func animShow(){
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
}
