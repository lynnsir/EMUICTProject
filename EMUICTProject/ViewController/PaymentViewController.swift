//
//  PaymentViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/27/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class PaymentViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate  {
    
    var totalPrice :String!
    var type:String!
    var status:String!
    var db:String!
    var uid = Auth.auth().currentUser?.uid
    
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
    
    
    @IBAction func bankPressed(_ sender: Any) {
        
    }
    
    @IBAction func cardPressed(_ sender: Any) {
    }
    
    
    @IBAction func confirmPressed(_ sender: Any) {
        if bankAcc.text != "" && Accname.text != "" {
            let alert = UIAlertController(title: "Success", message:   "Payment is confirmed!", preferredStyle: .alert)
            self.update()
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
            alert.addAction(OKAction)
            self.present(alert, animated: true){}
        }
        else if cardNum.text != "" && cardName.text != "" && expireMM.text != "" && expireYY.text != "" && cvv.text != "" {
            self.update()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getType()
        price.text = totalPrice

     
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func getType(){
        
        //if the user is logged in get the profile data
        let rootRef = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid{
            rootRef.child("Alluser").child(userID).observe(.value, with: { (snapshot) in
                //create a dictionary of users profile data
                let values = snapshot.value as? NSDictionary
                self.type = values?["Type"] as? String
            })
        }
    }
    
    func updateStatus(){
        let rootRef = Database.database().reference()

        let newUpdateStatus: [String : Any] = [
            "Status": "Pay",
        ]
        
        rootRef.child("Alluser").child("\(uid!)").updateChildValues(newUpdateStatus, withCompletionBlock: { (error, ref) in
            if let error = error{
                print(error)
                //return
            }
            print("Payment success")
        })
        
        rootRef.child(self.db).child("\(uid!)").updateChildValues(newUpdateStatus, withCompletionBlock: { (error, ref) in
            if let error = error{
                print(error)
                //return
            }
            print("Payment success")
        })
        
    }
    
    func update(){
        
        if self.type == "Student"{
            self.db = "Student user"
            self.updateStatus()
            
        }
        else if self.type == "Alumni"{
            self.db = "Alumni user"
            self.updateStatus()
        }
            
        else if self.type == "Company"{
            self.db = "Company user"
            self.updateStatus()
        }
        else if self.type == "Staff"{
            self.db = "Staff user"
            self.updateStatus()
        }
        
    }
    
    
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }

}
