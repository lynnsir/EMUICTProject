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

class StaffRegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var insertImageButton: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPassword: UITextField!
    @IBOutlet weak var IDnumber: UITextField!
    @IBOutlet weak var ContactNumber: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Position: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var month: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var ContinueButton: UIButton!
    
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        
        ref = Database.database().reference()
        userStorage = storage.child("Staff user")
        
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
            ContinueButton.isHidden = false
        }
        self.dismiss(animated: true, completion:nil)
    }
    
    
    
    @IBAction func ContinuePressed(_ sender: Any) {
        guard firstName.text != "", LastName.text != "", Username.text != "", password.text != "", conPassword.text != "", IDnumber.text != "", ContactNumber.text != "", Email.text != "", Position.text != "", date.text != "", month.text != "", year.text != ""
            
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
                                                                 "First name" : self.firstName.text!,
                                                                 "Last name": self.LastName.text!,
                                                                 
                                                                 "Username": self.Username.text!,
                                                                 
                                                                 "ID Number" : self.IDnumber.text!,
                                                                 
                                                                 "Contact number": self.ContactNumber.text!,
                                                                 
                                                                 "Position" : self.Position.text!,
                                                                 "BirthDate-Date": self.date.text!,
                                                                 "BirthDate-Month": self.month.text!,
                                                                 "BirthDate-Year": self.year.text!,
                                                                 "urlToImage": url.absoluteString
                                    
                                ]
                                self.ref.child("Staff user").child(user.uid).setValue(userInfo)
                             /*   let StaffRegis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "regisPayment")
                                self.present(StaffRegis, animated: true, completion: nil) */
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

