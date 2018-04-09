//
//  LoginViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 1/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController,UITextFieldDelegate {

     @IBOutlet weak var email: UITextField!
     @IBOutlet weak var password: UITextField!
     @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if email.text == "" || password.text == ""
        {
            displyAlertMessage(userMessage:"Please sign in")
        }
        
        else if email.text == "" && password.text == ""
        {
            displyAlertMessage(userMessage:"Please sign in")
        }
        
        else if email.text != "" && password.text != ""
        {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if user != nil{
                    print("Successful")

                    
                    let myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = myTabBar
                }
                else{
            
                    self.displyAlertMessage(userMessage:"Wrong password")
                    if let myError = error?.localizedDescription
                    {
                        self.displyAlertMessage(userMessage: "Please sign in again")
                        print(myError)
                        
                    }
                    else{
                        self.displyAlertMessage(userMessage:"Wrong password")
                        print("Error")
                        
                    }
                }
            })
        }
       
      
       
    }
    
    
    @IBAction func ForgetPwd(_ sender: Any) {
        if email.text != ""{
            Auth.auth().sendPasswordReset(withEmail: email.text!) { error in
                
                if error != nil
                {
                    print(error!)
                }
                else
                {
                    print("Send email!")
                }
                
            }
        }else{
            
             displyAlertMessage(userMessage: "Please fill in your email")
        }
        
     
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self

    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
