//
//  EditStaffProfileViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/11/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class EditStaffProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate {
    
    let picker = UIImagePickerController()
    let datePicker = UIDatePicker()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    var imageUR:String!
    var fname: String!
    var uname: String!
    var pwd: String!
    var conPwd: String!
    var conNumb: String!
    var pos: String!
    var mail: String!
    var bd: String!
    
    @IBOutlet weak var imgPro: UIImageView!
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var insertImg: UIButton!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPassword: UITextField!
    @IBOutlet weak var ConNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var birthdate: UITextField!
    @IBOutlet weak var save: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
         createDatePicker()
        
        fullname.delegate = self
        username.delegate = self
        password.delegate = self
        conPassword.delegate = self
        ConNumber.delegate = self
        email.delegate = self
        position.delegate = self
        birthdate.delegate = self
        
        fullname.text = fname
        username.text = uname
        password.text = "123456"
        conPassword.text = "123456"
        ConNumber.text = conNumb
        position.text = pos
        email.text = mail
        birthdate.text = bd

        getImage(url: imageUR) { photo in
            if photo != nil {
                DispatchQueue.main.async {
                    self.imgPro.image = photo
                }
            }
        }
        picker.delegate = self
        
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        
        ref = Database.database().reference()
        userStorage = storage.child("Alluser")
        
        self.imgPro.layer.cornerRadius = self.imgPro.frame.size.width / 2
        self.imgPro.clipsToBounds = true
        
        self.imageBG.layer.cornerRadius = self.imageBG.frame.size.width/2
        self.imageBG.clipsToBounds = true
       
    }

    @IBAction func insertImageButton(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    @IBAction func saveButton(_ sender: Any) {
        if password.text != conPassword.text{
            displyAlertMessage(userMessage: "Password doesn't match!")
        }
            
        else{
            //changeEmail
            let user = Auth.auth().currentUser
            
            user?.updateEmail(to: email.text!
                , completion: { error in
                    if let error = error{
                        print(error)
                    }
                    else{
                        print("Success:Change Email")
                    }
            })
            
            
            //changePassword
            user?.updatePassword(to: password.text!, completion: { (error) in
                if let error = error{
                    print(error)
                }
                else{
                    print("Success:Change Password")
                }
            })
            
            updateUsersProfile()
            
            _ = navigationController?.popViewController(animated: true)
            
        }
    }
    @IBAction func cancelButton(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        
        let user = Auth.auth().currentUser
        let user2 = Auth.auth().currentUser?.uid
        let user3 = user2
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        
        let userStorage1 = storage.child("Staff user")
        
        let imageRef2 = userStorage1.child(user2!+".jpg")
        print(user2!+".jpg")
        imageRef2.delete(completion: { error in
            if let error = error {
                print(error)
            } else {
                print("Staff user: delete image from Storage")
            }
        })
        
        user?.delete { error in
            if let error = error {
                print(error)
            } else {
                Database.database().reference(withPath: "Staff user").child(user3!).removeValue()
                print("Staff:Delete db")
                
                // Database.database().reference(withPath: "Alluser").child(user3!).removeValue()
                //  print("Alluser:Delete db")
                
                print("delete account success")
                
                
                
            }
        }
        
    }
    
   
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imgPro.image = image
        }
        self.dismiss(animated: true, completion:nil)
    }
    
    func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error == nil {
                completion(UIImage(data: data!))
            } else {
                completion(nil)
            }
            }.resume()
    }
    
    func updateUsersProfile(){
        //check to see if the user is logged in
        if let user = Auth.auth().currentUser?.uid{
            //create an access point for the Firebase storage
            let imageRef = userStorage.child("\(user).jpg")
            //get the image uploaded from photo library ***
            //guard let image = imgPro.image else {return}
            
            
            let data = UIImageJPEGRepresentation(self.imgPro.image!, 0.5)
            
            let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
                if err != nil{
                    print(err!.localizedDescription)
                }
                //upload to firebase storage
                
                imageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let imageURL = url?.absoluteString{
                        
                        let newUpdatedProfile:[String : Any] =
                            [
                                "Fullname": self.fullname.text!,
                                "Username": self.username.text!,
                                "Contact number":self.ConNumber.text!,
                                "Email":self.email.text!,
                                "Position": self.position.text!,
                                "BirthDate":self.birthdate.text!,
                                "urlToImage":imageURL
                        ]
                        //update the firebase database for that user
                        self.imageUR = imageURL
                        
                        self.ref.child("Alluser").child(user).updateChildValues(newUpdatedProfile, withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            print("Profile Successfully Update in All user")
                        })
                        self.ref.child("Staff user").child(user).updateChildValues(newUpdatedProfile, withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            print("Profile Successfully Update in Staff user")
                        })
                    }
                })
            })
            uploadTask.resume()
            
        }
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
