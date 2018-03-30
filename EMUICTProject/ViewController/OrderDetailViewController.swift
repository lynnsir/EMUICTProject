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
    var Orderdate:String!
    var Orderstatus:String!
    var totalPrice:String!
    var oid:String!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var okbutton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailView")
        print(Orderdate)
        print(Orderstatus)
        print(totalPrice)
        print(oid)
 
    }

  
    @IBAction func okPressed(_ sender: Any) {
    }
    
}
