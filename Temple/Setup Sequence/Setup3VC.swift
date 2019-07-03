//
//  Setup3VC.swift
//  Temple
//
//  Created by Roman Rosenast on 6/25/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit

class Setup3VC: SetupStepVC, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
//    BEGIN TABLE FUNCTIONS
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dynamicRowHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "description", for: indexPath)
            as! DescriptionCell
        
        let pvc = self.parent as? SetupViewController
        
        cell.textField.layer.borderWidth = 3
        cell.textField.layer.masksToBounds = true
        cell.textField.layer.cornerRadius = cell.label.layer.bounds.height/2
        cell.textField.backgroundColor = pvc?.setupPillars[indexPath.row].color

        cell.textField.text = pvc?.setupPillars[indexPath.row].description

        cell.textField.frame.size.height = dynamicRowHeight() - 20
        cell.label.text = "\(pvc!.setupPillars[indexPath.row].title)"
        
        cell.selectionStyle = .none
        
        cell.textField.delegate = self
        cell.textField.tag = indexPath.row
        
        return cell
    }
    
//    END TABLE FUNCTIONS
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let pvc = self.parent as? SetupViewController
        pvc!.setupPillars[textView.tag].description = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func reloadTable() {
        tableView.reloadData()
    }
    
    func dynamicRowHeight() -> CGFloat {
        let MinHeight: CGFloat = 30.0
        let tHeight = tableView.bounds.height
        
        let temp = tHeight / CGFloat(5)
        
        return temp > MinHeight ? temp : MinHeight
    }
    
}

class DescriptionCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
