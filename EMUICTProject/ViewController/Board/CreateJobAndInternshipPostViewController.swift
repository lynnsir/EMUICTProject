//
//  CreateJobAndInternshipPostViewController.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 2/3/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase



class CreateJobAndInternshipPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var BoardTitle: UITextField!
    @IBOutlet weak var BoardContent: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    var createDate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        
        ref = Database.database().reference()
        userStorage = storage.child("JobAndInternshipPost")
        
    }
    

    @IBAction func cancelPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    

    @IBAction func BoardPostButtom(_ sender: Any) {
        let title = BoardTitle.text
        let content = BoardContent.text
        
        postBoardContent(Title: title!,Content: content!)
         _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func InsertPhotoButtom(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imgView.image = image
        }
        self.dismiss(animated: true, completion:nil)
    }
    
    func postBoardContent(Title: String,Content: String){
        
        let title = Title
        let content = Content
        //date add
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYY"
        let date = formatter.string(from: Date())
        self.createDate = date
        //end date add
        let uid = Auth.auth().currentUser!.uid
        let postedId = Database.database().reference().child("JobAndInternshipPost").childByAutoId().key
        let imageRef = self.userStorage.child("\(postedId).jpg")
        let data = UIImageJPEGRepresentation(self.imgView.image!, 0.5)
        let timestamp = Int(Date().timeIntervalSince1970)
        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
            if err != nil{
                print(err!.localizedDescription)
            }
            
            imageRef.downloadURL(completion: { (url, er) in
                if er != nil {
                    print(er!.localizedDescription)
                }
                
                if let url = url {
                    let postData: [String : Any] = [
                        "Title": title as AnyObject,
                        "Content": content as AnyObject,
                        "creator": uid as AnyObject,
                        "urlToImage": url.absoluteString,
                        "timestamp": timestamp as AnyObject,
                        "CreateDate": date as AnyObject
                        
                    ]
                    Database.database().reference().child("JobAndInternshipPost").child("\(postedId)").setValue(postData)
                    
                }
                
            })
            
        })
        uploadTask.resume()
        
    }
    
    
  
    
}
