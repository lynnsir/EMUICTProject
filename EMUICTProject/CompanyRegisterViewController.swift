//
//  CompanyRegisterViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 1/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CompanyRegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPassword: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var insertImageBtn: UIButton!
    @IBOutlet weak var ContinueBtn: UIButton!
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        
        ref = Database.database().reference()
        userStorage = storage.child("users")
        
 
        
        // Do any additional setup after loading the view.
    }
    @IBAction func insertImagePressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
            ContinueBtn.isHidden = false
        }
        self.dismiss(animated: true, completion:nil)
    }
    
    /* @IBOutlet weak var companyName: UITextField!
     @IBOutlet weak var username: UITextField!
     @IBOutlet weak var password: UITextField!
     @IBOutlet weak var conPassword: UITextField!
     @IBOutlet weak var email: UITextField!
     @IBOutlet weak var contactNumber: UITextField!
     @IBOutlet weak var imageView: UIImageView!
     @IBOutlet weak var insertImageBtn: UIButton!
     @IBOutlet weak var ContinueBtn: UIButton!*/
    
    
    
    @IBAction func ContinuePressed(_ sender: Any) {
        if companyName.text == nil || username.text == nil || password.text == nil ||
            conPassword.text == nil || email.text == nil || contactNumber.text == nil
        {
            displyAlertMessage(userMessage: "Information is missing")
        }
            
        
        if password.text == conPassword.text
        {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                
                if let error = error
                {
                    print(error.localizedDescription)
                }
            
                else
                {
                    
                }
                
            })
        }
            
            else{
            displyAlertMessage(userMessage:"Password doesn't match!")
        
        }
        
        
    }
    
    
    
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }
    
    
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
