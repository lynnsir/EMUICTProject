//
//  LoginViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 1/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

     @IBOutlet weak var email: UITextField!
     @IBOutlet weak var password: UITextField!
     @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if email.text != "" && password.text != ""
        {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if user != nil{
                    print("Successful")
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar") as? UITabBarController
                        
                    {
                        if let navigator = self.navigationController {
                            navigator.show(vc, sender: true)
                        }
                
                        
                    }
       
   
                }
                else{
                    
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
        else if email.text == "" || password.text == ""
        {
            displyAlertMessage(userMessage:"Please sign in")
        }
        else if email.text == "" && password.text == "" {
            displyAlertMessage(userMessage:"Please sign in")
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


}
