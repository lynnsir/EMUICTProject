//
//  AdminOrderViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 4/6/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class AdminOrderViewController: UIViewController {

    @IBOutlet weak var orderID: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

 
    @IBAction func search(_ sender: Any) {
        if orderID.text == ""{
            displyAlertMessage(userMessage: "Please fill in Order ID")
        }
        else{
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminOrderDetail") as? AdminOrderDetailViewController
            {
                if let navigator = self.navigationController {
                    navigator.show(vc, sender: true)
                }
                vc.orderid = orderID.text
            }
        }

    }
    
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }
 
 
    
    
    
    
}
