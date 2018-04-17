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

class CompanyRegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPassword: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBG: UIView!
   @IBOutlet weak var companyDes: UITextView!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var insertImageBtn: UIButton!
    @IBOutlet weak var ContinueBtn: UIButton!
   
    
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    var type = "Company"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        companyName.delegate = self
        username.delegate = self
        password.delegate = self
        conPassword.delegate = self
        email.delegate = self
        contactNumber.delegate = self
        contactName.delegate = self
        companyDes.delegate = self
        
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        
        ref = Database.database().reference()
        userStorage = storage.child("Company user")
        
 
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.clipsToBounds = true
        
        self.imageBG.layer.cornerRadius = self.imageBG.frame.size.width/2
        self.imageBG.clipsToBounds = true
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
        if companyName.text! == "" || username.text! == "" || password.text! == "" || conPassword.text! == "" || email.text! == "" || contactNumber.text! == "" || contactName.text != ""{
            self.displyAlertMessage(userMessage: "Please fill in your information in required fields") }
        guard companyName.text != "", username.text != "", password.text != "",conPassword.text != "", email.text != "", contactNumber.text != "", contactName.text != ""
            else { return }
        if password.text == conPassword.text { Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                if let error = error{ print(error.localizedDescription)
                    self.displyAlertMessage(userMessage: error.localizedDescription)
                    
            }
                if let user = user{
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    changeRequest.displayName = self.companyName.text!
                    changeRequest.commitChanges(completion: nil)
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
                        if err != nil { print(err!.localizedDescription) }
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil { print(er!.localizedDescription) }
                            if let url = url {
                                let userInfo: [String : Any] = [ "uid" : user.uid,
                                                                 "Company name" : self.companyName.text!,
                                                                 "Username" : self.username.text!,
                                                                 "Email" : self.email.text!,
                                                                 "Contact number": self.contactNumber.text!,
                                                                 "Company Description": self.companyDes.text!,
                                                                 "Contact Name": self.contactName.text!,
                                                                 "Type":self.type,
                                                                 "urlToImage": url.absoluteString ]
                                self.ref.child("Company user").child(user.uid).setValue(userInfo)
                                self.ref.child("Alluser").child(user.uid).setValue(userInfo)
                                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "regisPayment") as? InvoiceViewController {
                                    if let navigator = self.navigationController {
                                        navigator.show(vc, sender: true) }
                                    vc.name = self.companyName.text
                                    vc.type = "Company"
                                }}})})
                    uploadTask.resume() }})}
        else{
            self.displyAlertMessage(userMessage:"Password doesn't match!") } }
    
    @IBAction func cancelPressed(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
