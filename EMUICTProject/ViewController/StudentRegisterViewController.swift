//
//  StudentRegisterViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 1/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class StudentRegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
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
    @IBOutlet weak var birthmonth: UITextField!
    @IBOutlet weak var birthyear: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    

    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        birthmonth.delegate = self
        birthyear.delegate = self
        
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
        

    
    
    @IBAction func ContinuePressed(_ sender: Any) {
        guard fullname.text != "",
            studentID.text != "",
            username.text != "", password.text != "", conPassword.text != "", idNumber.text != "", contactNumber.text != "", email.text != "",  birthdate.text != "", birthmonth.text != "", birthyear.text != ""
            
            else { return }
        
        if password.text == conPassword.text {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                
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
                                                                 "Email" : self.email.text!,
                                                                 "BirthDate-Date": self.birthdate.text!,
                                                                 "BirthDate-Month": self.birthmonth.text!,
                                                                 "BirthDate-Year": self.birthyear.text!,
                                                                 "urlToImage": url.absoluteString
                                    
                                ]
                                self.ref.child("Student user").child(user.uid).setValue(userInfo)
                       /*         let StudentRegis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "regisPayment")
                                self.present(StudentRegis, animated: true, completion: nil) */
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

 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
