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
        userStorage = storage.child("Company user")
        
 
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
    
    
    
    @IBAction func ContinuePressed(_ sender: Any) {

        guard companyName.text != "", username.text != "", password.text != "",conPassword.text != "", email.text != "", contactNumber.text != ""
            else { return }
        if password.text == conPassword.text {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                
                if let error = error{
                    print(error.localizedDescription)
                }
                
                if let user = user{
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    changeRequest.displayName = self.companyName.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    
                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
                        if err != nil{
                            print(err!.localizedDescription)
                        }
                        
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil {
                                print(er!.localizedDescription)
                            }
                            
                            if let url = url {
                                let userInfo: [String : Any] = [ "uid" : user.uid,
                                                                 "Company name" : self.companyName.text!,
                                                                 "Username" : self.username.text!,
                                                                 "Email" : self.email.text!,
                                                                 "Contact number": self.contactNumber.text!,
                                                                 "urlToImage": url.absoluteString ]
                                self.ref.child("Company user").child(user.uid).setValue(userInfo)
                            /*    let CompanyRegis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "regisPayment")
                                self.present(CompanyRegis, animated: true, completion: nil) */
                            }
                            
                        })
                        
                    })
                    uploadTask.resume()
                }
                
                })
           
        }
            
            
        else{
            print("Password doesn't match!")
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
    


}
