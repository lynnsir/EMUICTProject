//
//  StudentRegisterViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 1/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class StudentRegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var insertImageButton: UIButton!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var studentID: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPassword: UITextField!
    @IBOutlet weak var idNumber: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var birthdate: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    

    
    let picker = UIImagePickerController()
    let datePicker = UIDatePicker()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    var type = "Student"
    var track = ["Database & Intelligent Systems", "Software Engineering", "Computer Science" , "Computer Network" , "Multimedia" , "E-Business" , "Management Information System" , "Health Information Technology" ]
    var testid: String!
    let trackPicker = UIPickerView()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
        trackPicker.delegate = self
        trackPicker.dataSource = self
        major.inputView = trackPicker
        
        
        picker.delegate = self
        
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        
        ref = Database.database().reference()
        userStorage = storage.child("Student user")
        
        fullname.delegate = self
        studentID.delegate = self
        username.delegate = self
        password.delegate = self
        conPassword.delegate = self
        idNumber.delegate = self
        contactNumber.delegate = self
        year.delegate = self
        major.delegate = self
        email.delegate = self
        birthdate.delegate = self
        
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
            continueButton.isHidden = false
        }
        self.dismiss(animated: true, completion:nil)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return track.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return track[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        major.text = track[row]
        self.view.endEditing(false)
    }
    func secoundAuth() -> Bool{
        // Secound Auth
        var check: Bool?
        let rootRef = Database.database().reference()
        let query = rootRef.child("FacMembers").child(idNumber.text!)
        //let useridnumber = self.idNumber.text!
        
        query.observe(.value) { (snapshot) in
            
            if let uservalue = snapshot.value as? NSDictionary{
                
                if let idnumber = uservalue["idnum"] as? String{
                    print(idnumber)
                    DispatchQueue.main.async {
                         self.testid = idnumber
                         check = true
                    }
                }
            }
        }
        print(testid)
        if testid == nil{
            check = false
            return check!
            
        } else {
            check = true
            return check!
           
        }
    }
    
    
    @IBAction func ContinuePressed(_ sender: Any) {
        
        let checkauth = secoundAuth()
        guard checkauth == true else{
            print(checkauth)
            displyAlertMessage(userMessage: "Not is faculty member")
            return
        }
        

        if fullname.text! == "" || studentID.text! == "" || username.text! == "" || password.text! == "" || conPassword.text! == "" || idNumber.text! == "" || contactNumber.text! == "" || email.text! == "" || birthdate.text! == "" {
            self.displyAlertMessage(userMessage: "Please fill in your information in required fields")
        }
   
        guard fullname.text != "",
            studentID.text != "",
            username.text != "", password.text != "", conPassword.text != "", idNumber.text != "", contactNumber.text != "", email.text != "",  birthdate.text != ""
            
            else { return }
       
        
        
        
        if self.password.text == self.conPassword.text {
            Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
                
                if let error = error{
                    print(error.localizedDescription)
                }
                
                if let user = user{
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    changeRequest.displayName = self.username.text!
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
                                                                 
                                                                 
                                                                 "Student ID": self.studentID.text!,
                                                                 
                                                                 "Username": self.username.text!,
                                                                 
                                                                 "ID Number" : self.idNumber.text!,
                                                                 
                                                                 "Contact number": self.contactNumber.text!,
                                                                 
                                                                 "Year" : self.year.text!,
                                                                 "Major" : self.major.text!,
                                                                 "Year_Major" : self.year.text! + "_" + self.major.text!,
                                                                 "Email" : self.email.text!,
                                                                 "BirthDate": self.birthdate.text!,
                                                                 "Type" : self.type,
                                                                 "urlToImage": url.absoluteString
                                    
                                ]
                                self.ref.child("Student user").child(user.uid).setValue(userInfo)
                                //insert to alluser
                                self.ref.child("Alluser").child(user.uid).setValue(userInfo)
                                
                                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "regisPayment") as? InvoiceViewController
                                    
                                {
                                    if let navigator = self.navigationController {
                                        navigator.show(vc, sender: true)
                                    }
                                    
                                    vc.name = self.fullname.text
                                    vc.type = "Student"
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
    
    func createDatePicker() {
        
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        birthdate.inputAccessoryView = toolbar
        birthdate.inputView = datePicker
        
        // format picker for date
        datePicker.datePickerMode = .date
    }
    @objc func donePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: datePicker.date)
        
        birthdate.text = "\(dateString)"
        self.view.endEditing(true)
    }
}
