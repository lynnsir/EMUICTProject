//
//  InvoiceViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/27/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewController {

    var name:String!
    var type:String!
    
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var memberType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var confirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fullname.text = name
        self.memberType.text = type
        
        if memberType.text == "Student"{
            price.text = "150.00"
        }
        else if memberType.text == "Staff"{
            price.text = "250.00"
        }
        else if memberType.text == "Alumni"{
            price.text = "200.00"
        }
        else if memberType.text == "Company"{
            price.text = "300.00"
        }
        
    }

    @IBAction func confirmPressed(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Payment") as? PaymentViewController
            
        {
            if let navigator = self.navigationController {
                navigator.show(vc, sender: true)
            }
            
            vc.totalPrice = price.text
            
            
            
            
        }
    }
    
    

}
