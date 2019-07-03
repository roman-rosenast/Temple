//
//  Setup3VC.swift
//  Temple
//
//  Created by Roman Rosenast on 6/15/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit

class Setup4VC: SetupStepVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Modal: UIView!
    
    let colorOptions = [
        UIColor(red:0.23, green:0.54, blue:0.41, alpha:1.0),
        UIColor(red:0.85, green:0.36, blue:0.26, alpha:1.0),
        UIColor(red:0.98, green:0.41, blue:0.00, alpha:1.0),
        UIColor(red:0.95, green:0.53, blue:0.19, alpha:1.0),
        UIColor(red:0.93, green:0.82, blue:0.47, alpha:1.0),
        UIColor(red:0.88, green:0.89, blue:0.80, alpha:1.0),
        UIColor(red:0.65, green:0.86, blue:0.85, alpha:1.0),
        UIColor(red:0.33, green:0.47, blue:0.48, alpha:1.0),
        UIColor(red:0.41, green:0.82, blue:0.91, alpha:1.0),
        UIColor(red:0.81, green:0.94, blue:0.62, alpha:1.0),
        UIColor(red:0.07, green:0.44, blue:0.65, alpha:1.0),
        UIColor(red:0.91, green:0.77, blue:0.93, alpha:1.0)
    ]
    
    var selectedColorIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
                
        setupModal()
    }
    
//    BEGIN TABLE FUNCTIONS
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dynamicRowHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "color", for: indexPath)
            as! ColorCell
        
        let pvc = self.parent as? SetupViewController
        
        cell.colorLabel.layer.borderWidth = 3
        cell.colorLabel.layer.masksToBounds = true
        cell.colorLabel.layer.cornerRadius = cell.colorLabel.layer.bounds.width/2
        cell.colorLabel.backgroundColor = pvc?.setupPillars[indexPath.row].color
        
        cell.habitLabel.text = pvc?.setupPillars[indexPath.row].title
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedColorIndex = indexPath.row
        toggleModal()
    }
    
//    END TABLE FUNCTIONS
    
    override func reloadTable() {
        tableView.reloadData()
    }
    
    func dynamicRowHeight() -> CGFloat {
        let MinHeight: CGFloat = 30.0
        let tHeight = tableView.bounds.height
        
        let temp = tHeight / CGFloat(5)
        
        return temp > MinHeight ? temp : MinHeight
    }
    
//    BEGIN MODAL SECTION
    
    @IBOutlet weak var color1: UIButton!
    @IBOutlet weak var color2: UIButton!
    @IBOutlet weak var color3: UIButton!
    @IBOutlet weak var color4: UIButton!
    @IBOutlet weak var color5: UIButton!
    @IBOutlet weak var color6: UIButton!
    @IBOutlet weak var color7: UIButton!
    @IBOutlet weak var color8: UIButton!
    @IBOutlet weak var color9: UIButton!
    @IBOutlet weak var color10: UIButton!
    @IBOutlet weak var color11: UIButton!
    @IBOutlet weak var color12: UIButton!
    
    func toggleModal() {
        Modal.isHidden = !Modal.isHidden
        tableView.reloadData()
    }
    
    func setupModal() {
        Modal.isHidden = true
        Modal.layer.cornerRadius = 10
        
        color1.backgroundColor = colorOptions[0]
        color2.backgroundColor = colorOptions[1]
        color3.backgroundColor = colorOptions[2]
        color4.backgroundColor = colorOptions[3]
        color5.backgroundColor = colorOptions[4]
        color6.backgroundColor = colorOptions[5]
        color7.backgroundColor = colorOptions[6]
        color8.backgroundColor = colorOptions[7]
        color9.backgroundColor = colorOptions[8]
        color10.backgroundColor = colorOptions[9]
        color11.backgroundColor = colorOptions[10]
        color12.backgroundColor = colorOptions[11]
        
        let colorHeight = color1.layer.bounds.height
        color1.layer.cornerRadius = colorHeight/2
        color2.layer.cornerRadius = colorHeight/2
        color3.layer.cornerRadius = colorHeight/2
        color4.layer.cornerRadius = colorHeight/2
        color5.layer.cornerRadius = colorHeight/2
        color6.layer.cornerRadius = colorHeight/2
        color7.layer.cornerRadius = colorHeight/2
        color8.layer.cornerRadius = colorHeight/2
        color9.layer.cornerRadius = colorHeight/2
        color10.layer.cornerRadius = colorHeight/2
        color11.layer.cornerRadius = colorHeight/2
        color12.layer.cornerRadius = colorHeight/2
        
        color1.layer.borderWidth = 3
        color2.layer.borderWidth = 3
        color3.layer.borderWidth = 3
        color4.layer.borderWidth = 3
        color5.layer.borderWidth = 3
        color6.layer.borderWidth = 3
        color7.layer.borderWidth = 3
        color8.layer.borderWidth = 3
        color9.layer.borderWidth = 3
        color10.layer.borderWidth = 3
        color11.layer.borderWidth = 3
        color12.layer.borderWidth = 3
    }
    
    @IBAction func color1Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[0]
        toggleModal()
    }
    @IBAction func color2Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[1]
        toggleModal()
    }
    @IBAction func color3Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[2]
        toggleModal()
    }
    @IBAction func color4Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[3]
        toggleModal()
    }
    @IBAction func color5Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[4]
        toggleModal()
    }
    @IBAction func color6Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[5]
        toggleModal()
    }
    @IBAction func color7Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[6]
        toggleModal()
    }
    @IBAction func color8Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[7]
        toggleModal()
    }
    @IBAction func color9Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[8]
        toggleModal()
    }
    @IBAction func color10Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[9]
        toggleModal()
    }
    @IBAction func color11Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[10]
        toggleModal()
    }
    @IBAction func color12Pressed(_ sender: Any) {
        let pvc = self.parent as? SetupViewController
        pvc?.setupPillars[selectedColorIndex!].color = colorOptions[11]
        toggleModal()
    }
    
//    END MODAL SECTION
    
}

class ColorCell: UITableViewCell {
    
    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
