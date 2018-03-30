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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var paybutton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBOutlet weak var payPressed: UIButton!
    
}
