//
//  OrderMenuViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 4/18/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class OrderMenuViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

 
    }

    @IBAction func vendorPressed(_ sender: Any) {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderList") as? OrderListViewController
            
        {
            if let navigator = self.navigationController {
                navigator.show(vc, sender: true)
            }
        }
        
    }
    
    @IBAction func BuyerPressed(_ sender: Any) {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderListBuyer") as? OrderListBuyerViewController
            
        {
            if let navigator = self.navigationController {
                navigator.show(vc, sender: true)
            }
        }
        
    }
    

}
