//
//  Setup2bVC.swift
//  Temple
//
//  Created by Roman Rosenast on 6/25/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit

class Setup3VC: SetupStepVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    Begin Table Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }

//    End Table Delegate
    
}
