//
//  CreateNewsAndEventBoardViewController.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 21/2/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

//var imagePicker: UIImagePickerController!
//var selectedImage: UIImage!

class CreateNewAndEventsPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var BoardTitle: UITextField!
    @IBOutlet weak var BoardContent: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        
        ref = Database.database().reference()
        userStorage = storage.child("NewsAndEvent")

    }
    
    
    @IBAction func BoardPostButtom(_ sender: Any) {
        let title = BoardTitle.text
        let content = BoardContent.text
        
        postBoardContent(Title: title!,Content: content!)
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
        
        let uid = Auth.auth().currentUser!.uid
        let postedId = Database.database().reference().child("NewAndEventPost").childByAutoId().key
        let imageRef = self.userStorage.child("\(postedId).jpg")
        let data = UIImageJPEGRepresentation(self.imgView.image!, 0.5)
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
                        "urlToImage": url.absoluteString
                        
                    ]
                    Database.database().reference().child("NewAndEventPost").child("\(postedId)").setValue(postData)
                    
                }
                
            })
            
        })
        uploadTask.resume()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



