//
//  PaymentViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/27/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController,UITextFieldDelegate  {

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
    
      //  displyAlertMessage(userMessage: "Payment is confirmed!")
        
        let alert = UIAlertController(title: "Success", message:   "Payment is confirmed!", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            self.present(nextViewController, animated: true, completion: nil)
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true){}

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }

}
