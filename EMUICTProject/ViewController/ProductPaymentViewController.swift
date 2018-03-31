//
//  ProductPaymentViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class ProductPaymentViewController: UIViewController {
    
var total = 0.00
var totalText:String!
    
    @IBOutlet weak var price: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalText = String(total)
        price.text = totalText

    
    }

  

}
