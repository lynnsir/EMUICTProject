//
//  OrderDetailViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {

    var order = [Order]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var okbutton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

  
    @IBAction func okPressed(_ sender: Any) {
    }
    
}
