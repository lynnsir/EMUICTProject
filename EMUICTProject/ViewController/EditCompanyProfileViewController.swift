//
//  EditCompanyProfileViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/11/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class EditCompanyProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    var imageURL:String!
    var compname: String!
    var uname: String!
    var pwd: String!
    var conPwd: String!
    var conNumb: String!
    var mail: String!
    var contName: String!
    var comdescrip: String!
    
    @IBOutlet weak var imgPro: UIImageView!
    @IBOutlet weak var insertImg: UIButton!
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var comname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPassword: UITextField!
    @IBOutlet weak var ConNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var conName: UITextField!
    @IBOutlet weak var comdescription: UITextField!
    @IBOutlet weak var save: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
       
         comname.text = compname
         username.text = uname
         password.text = "123456"
         conPassword.text = "123456"
         ConNumber.text = conNumb
         email.text = mail
         conName.text = contName
         comdescription.text = comdescrip
        
         getImage(url: imageURL) { photo in
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
        }
        
        

            //update value to firebase
        

        
        
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
    }
    
    @IBAction func DeleteButton(_ sender: Any) {
        
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
