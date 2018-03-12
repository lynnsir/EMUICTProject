//
//  MyProfileAlumniViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/10/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class MyProfileAlumniViewController: UIViewController {
    
    var type:String!
    var imageURL:String!
    var uid:String!
    
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var imgPro: UIImageView!
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var studentID: UILabel!
    @IBOutlet weak var idNumber: UILabel!
    @IBOutlet weak var career: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var birthdate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 getProfile()
        
        self.imgPro.layer.cornerRadius = self.imgPro.frame.size.width / 2
        self.imgPro.clipsToBounds = true
        
        self.imageBG.layer.cornerRadius = self.imageBG.frame.size.width/2
        self.imageBG.clipsToBounds = true

    }
    
   
    @IBAction func editProfileButton(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditAlumniProfile") as? EditAlumniProfileViewController
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            vc.imageUR = imageURL
            vc.fname = fullname.text
            vc.uname = username.text
            vc.conNumb = phoneNumber.text
            vc.job = career.text
            vc.mail = email.text
            vc.mj = major.text
            vc.bd = birthdate.text
        }
    }
    func getProfile(){
        let rootRef = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid{
            rootRef.child("Alluser").child(userID).observe(.value, with: { (snapshot) in
       
                
                let values = snapshot.value as? NSDictionary
                self.imageURL = values?["urlToImage"] as? String
                self.uid = values?["uid"] as? String
                self.fullname.text = values?["Full name"] as? String
                self.username.text = values?["Username"] as? String
                self.studentID.text = values?["Student ID"] as? String
                self.idNumber.text = values?["ID Number"] as? String
                self.career.text = values?["Career"] as? String
                self.major.text = values?["Major"] as? String
                self.email.text = values?["Email"] as? String
                self.phoneNumber.text = values?["Contact number"] as? String
                self.birthdate.text = values?["BirthDate"] as? String
                
                self.getImage(url: self.imageURL) { photo in
                    if photo != nil {
                        DispatchQueue.main.async {
                            self.imgPro.image = photo
                        }
                    }
                }
                
            })
            
        }
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
  

}
