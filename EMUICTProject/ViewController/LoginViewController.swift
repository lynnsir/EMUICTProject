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
    
    var status:String!
    var userStorage: StorageReference!
    var type:String!
    var db:String!
    
     @IBOutlet weak var email: UITextField!
     @IBOutlet weak var password: UITextField!
     @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if email.text == "" || password.text == ""
        {
            displyAlertMessage(userMessage:"Please sign in")
        }
        else if email.text != "" && password.text != ""
        {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if user != nil{
        
                    self.getStatus()
                    self.run(after: 2, completion: {
                        if self.status == "Pay"{
                            let myTabBar = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            
                            appDelegate.window?.rootViewController = myTabBar
                            print("Login complete")
                        }
                        else{
                            self.delete()
                            self.displyAlertMessage(userMessage: "No user found!")
                        }
                    })
        
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
                        
                        }}})}}
    
    
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
    func getStatus(){
        let ref = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid{
            ref.child("Alluser").child(userID).observe(.value, with: { (snapshot) in
                //create a dictionary of users profile data
                let values = snapshot.value as? NSDictionary
                self.status = values?["Status"] as? String ?? "Not found"
            })}}
    
    func getType(){
        //if the user is logged in get the profile data
        let rootRef = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid{
            rootRef.child("Alluser").child(userID).observe(.value, with: { (snapshot) in
                //create a dictionary of users profile data
                let values = snapshot.value as? NSDictionary
                self.type = values?["Type"] as? String
            })}}
    
    func delete(){
        getType()
        
                if self.type == "Student"{
                    self.db = "Student user"
                    self.deleteUser()
                    
        }
                else if self.type == "Alumni"{
                    self.db = "Alumni user"
                    self.deleteUser()
        }
        
                else if self.type == "Company"{
                    self.db = "Company user"
                    self.deleteUser()
        }
                else if self.type == "Staff"{
                    self.db = "Staff user"
                    self.deleteUser()
        }
        
    }
    
    func deleteUser(){
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
                    print("delete image from Storage")
                }
            })
  
        user?.delete { error in
            if let error = error {
                print(error)
            } else {
                Database.database().reference(withPath:self.db).child(user3!).removeValue()
                print("Delete db")
                
                 Database.database().reference(withPath: "Alluser").child(user3!).removeValue()
                  print("Alluser:Delete db")
                
                print("delete account success")
                
                
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void){
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
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
