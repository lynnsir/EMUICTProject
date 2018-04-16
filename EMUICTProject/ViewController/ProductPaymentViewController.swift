//
//  ProductPaymentViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class ProductPaymentViewController: UIViewController {
    
var total = 0.00
var totalText:String!
var oid:String!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bank: DLRadioButton!
    @IBOutlet weak var card: DLRadioButton!
    @IBOutlet weak var bankAcc: UITextField!
    @IBOutlet weak var Accname: UITextField!
    
    @IBOutlet weak var cardNum: UITextField!
    @IBOutlet weak var cardName: UITextField!
    @IBOutlet weak var expireMM: UITextField!
    @IBOutlet weak var expireYY: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var Confirmbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalText = String(total)
        price.text = totalText

    
    }
    


    
    
    @IBAction func bankPressed(_ sender: Any) {
        
    }
    
    @IBAction func cardPressed(_ sender: Any) {
    }
    
    
    @IBAction func confirmPressed(_ sender: Any) {
        if bankAcc.text != "" && Accname.text != "" {
            self.updateStatus()
            let alert = UIAlertController(title: "Success", message:   "Payment is confirmed!", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
            alert.addAction(OKAction)
            self.present(alert, animated: true){}
        }
        else if cardNum.text != "" && cardName.text != "" && expireMM.text != "" && expireYY.text != "" && cvv.text != "" {
            self.updateStatus()
            let alert = UIAlertController(title: "Success", message:   "Payment is confirmed!", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
            alert.addAction(OKAction)
            self.present(alert, animated: true){}
        }
            
        else{
            displyAlertMessage(userMessage: "Please fill in payment information")
        }
        
        
    }


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func updateStatus(){
        let rootRef = Database.database().reference()

        
        let newUpdateStatus: [String : Any] = [
            "seller_status": "Verified Payment",
            "buyer_status": "Verified Payment"
            ]
        
        rootRef.child("Order").child("\(oid!)").updateChildValues(newUpdateStatus, withCompletionBlock: { (error, ref) in
            if let error = error{
                print(error)
                //return
            }
            print("Payment success")
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }
    

}
