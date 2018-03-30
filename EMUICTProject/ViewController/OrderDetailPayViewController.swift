//
//  OrderDetailPayViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class OrderDetailPayViewController: UIViewController {

    var order = [Order]()
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var paybutton: UIButton!
    @IBOutlet weak var cancelBut: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func payPressed(_ sender: Any) {
        
        
    }
    
  
    
}
