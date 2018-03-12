//
//  StaffRegisterViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/11/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class StaffRegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var imageView: UIImageView!
 
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var insertImageButton: UIButton!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPassword: UITextField!
    @IBOutlet weak var IDnumber: UITextField!
    @IBOutlet weak var ContactNumber: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Position: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var ContinueButton: UIButton!
    
    
    let picker = UIImagePickerController()
    let datePicker = UIDatePicker()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    var type = "Staff"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
        picker.delegate = self
        fullname.delegate = self
        Username.delegate = self
        password.delegate = self
        conPassword.delegate = self
        IDnumber.delegate = self
        ContactNumber.delegate = self
        Email.delegate = self
        Position.delegate = self
        date.delegate = self

        
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        
        ref = Database.database().reference()
        userStorage = storage.child("Staff user")
        
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
            ContinueButton.isHidden = false
        }
        self.dismiss(animated: true, completion:nil)
    }
    
    
    
    @IBAction func ContinuePressed(_ sender: Any) {
        guard fullname.text != "", Username.text != "", password.text != "", conPassword.text != "", IDnumber.text != "", ContactNumber.text != "", Email.text != "", Position.text != "", date.text != ""
            
            else { return }
        
        if password.text == conPassword.text {
            Auth.auth().createUser(withEmail: Email.text!, password: password.text!, completion: { (user, error) in
                
                if let error = error{
                    print(error.localizedDescription)
                }
                
                if let user = user{
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    changeRequest.displayName = self.Username.text!
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
                                                                 "Full name" : self.fullname.text!,
                                    
                                                                 "Username": self.Username.text!,
                                                                 
                                                                 "ID Number" : self.IDnumber.text!,
                                                                 
                                                                 "Contact number": self.ContactNumber.text!,
                                                                 "Email": self.Email.text!,
                                                                 "Position" : self.Position.text!,
                                                                 "BirthDate": self.date.text!,                                                           
                                                                 "Type": self.type,
                                                                 "urlToImage": url.absoluteString
                                    
                                ]
                                self.ref.child("Staff user").child(user.uid).setValue(userInfo)
                                //insert to alluser
                                self.ref.child("Alluser").child(user.uid).setValue(userInfo)
                                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "regisPayment") as? InvoiceViewController
                                    
                                {
                                    if let navigator = self.navigationController {
                                        navigator.show(vc, sender: true)
                                    }
                                    
                                    vc.name = self.fullname.text
                                    vc.type = "Staff"
                                    
                                    
                                    
                                }
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
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func createDatePicker() {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        date.inputAccessoryView = toolbar
        date.inputView = datePicker
        
        // format picker for date
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: datePicker.date)
        
        date.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    
 
    
}

