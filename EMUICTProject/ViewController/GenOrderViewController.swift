//
//  GenOrderViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/28/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class GenOrderViewController: UIViewController,UINavigationControllerDelegate {
    
    var orderid : String!

    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var Quantity: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var cfbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
    }

    
    @IBAction func confirmPressed(_ sender: Any) {
        if productName.text == "" && Quantity.text == "" && price.text == ""{
            self.displyAlertMessage(userMessage: "Please fill in your product")
        }
        else if productName.text != "" && Quantity.text != "" && price.text != ""{
            let OrderID = orderid!
            let postProduct: [String : Any] = [
                "ProductName" : self.productName.text!,
                "Quantity":self.Quantity.text!,
                "Price":self.price.text!
            ]
            Database.database().reference().child("Order").child("\(OrderID)").child("Product").childByAutoId().setValue(postProduct)
            
                  _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
