//
//  InvoiceViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/27/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase
import OmiseSDK

class InvoiceViewController: UIViewController, CreditCardFormDelegate, UINavigationControllerDelegate {
    

    private let publicKey = "pkey_test_5bjql4eprf9n0y13zn4"
    
    var userStorage: StorageReference!
    var name:String!
    var type:String!
    var db:String!
  
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var memberType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var confirm: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentCreditFormWithModal",
            let creditCardFormNavigationController = segue.destination as? UINavigationController,
            let creditCardFormController = creditCardFormNavigationController.topViewController as? CreditCardFormController {
            creditCardFormController.publicKey = publicKey
            creditCardFormController.handleErrors = true
            creditCardFormController.delegate = self
            
            creditCardFormController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissCreditCardForm))
        }
    }
    @objc fileprivate func dismissCreditCardForm() {
        dismissCreditCardFormWithCompletion(nil)
    }
    @objc fileprivate func dismissCreditCardFormWithCompletion(_ completion: (() -> Void)?) {
        if presentedViewController != nil {
            dismiss(animated: true, completion: completion)
        } else {
            _ = navigationController?.popToViewController(self, animated: true)
            completion?()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fullname.text = name
        self.memberType.text = type
        
        if memberType.text == "Student"{
            price.text = "150"
            self.db = "Student user"
        }
        else if memberType.text == "Staff"{
            price.text = "250"
            self.db = "Staff user"
        }
        else if memberType.text == "Alumni"{
            price.text = "200"
            self.db = "Alumni user"
        }
        else if memberType.text == "Company"{
            price.text = "300"
            self.db = "Company user"
        }
        
    }

    @IBAction func confirmPressed(_ sender: Any) {
//        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Payment") as? PaymentViewController
//
//        {
//            if let navigator = self.navigationController {
//                navigator.show(vc, sender: true)
//            }
//            vc.totalPrice = price.text
//        }
        let creditCardFormController = CreditCardFormController.makeCreditCardForm(withPublicKey: publicKey)
        creditCardFormController.handleErrors = true
        creditCardFormController.delegate = self
        show(creditCardFormController, sender: self)
    
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        let user = Auth.auth().currentUser
        let user2 = Auth.auth().currentUser?.uid
        let user3 = user2
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        userStorage = storage.child(self.db)
        let imageRef = userStorage.child(user2!+".jpg")
        print(user2!+".jpg")
        imageRef.delete(completion: { error in
            if let error = error {
                print(error)
            } else {
                print("Company user: delete image from Storage")
            }
        })
        
        user?.delete { error in
            if let error = error {
                print(error)
            } else {
                Database.database().reference(withPath: "Company user").child(user3!).removeValue()
                print("Company:Delete db")
                
                Database.database().reference(withPath: "Alluser").child(user3!).removeValue()
                print("Alluser:Delete db")
                
                print("delete account success")
                
                
                
            }
        }
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    func creditCardForm(_ controller: CreditCardFormController, didSucceedWithToken token: OmiseToken) {
        dismissCreditCardFormWithCompletion({
            // Sends `OmiseToken` to your server for creating a charge, or a customer object.
            //Send to HTTP request
            //let uid = Auth.auth().currentUser?.uid
            let url:NSURL = NSURL(string: "http://127.0.0.1/php-test/services/chargeService.php")!
            let session = URLSession.shared
            let price: String =  (self.price?.text)!
            let priceNew = Int(price)
            let pricethb = priceNew! * 100
            let memberDes = "Name :" + self.fullname.text! + " " + self.memberType.text! + " " + "  Membership fee"
            let request = NSMutableURLRequest(url:url as URL)
            request.httpMethod = "POST"
           
            let datatoken = "token=\(token.tokenId!)&total=\(pricethb)&description=\(memberDes)"
            request.httpBody = datatoken.data(using: String.Encoding.utf8)
            
            let task = session.dataTask(with: request as URLRequest){(data,response,error) in
                guard error == nil else{ //Have error
                    print(error!)
                    self.displyAlertMessage(userMessage: "Paymernt Error!")
                    self.dismissCreditCardForm()
                    return
                }
                if let data = data { // can charge
                    let string = String(data: data, encoding: String.Encoding.utf8)
                    print(response!)
                    print("Test: " + string!) //JSONSerialization
                    print(pricethb)
                    self.updateStatus()
                    self.displyAlertMessage(userMessage: "Payment Successful")
                }
                
            }
            task.resume()
            
            
            //self.performSegue(withIdentifier: "CompletePayment", sender: self)
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func updateStatus(){
        let rootRef = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
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
        
        
    }
    
    
    func creditCardForm(_ controller: CreditCardFormController, didFailWithError error: Error) {
        dismissCreditCardForm()
        // Only important if we set `handleErrors = false`.
        // You can send errors to a logging service, or display them to the user here.
    }
    
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }

}

