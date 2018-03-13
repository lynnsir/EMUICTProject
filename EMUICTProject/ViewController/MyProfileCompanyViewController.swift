//
//  MyProfileCompanyViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/10/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase


class MyProfileCompanyViewController: UIViewController {
    
    var type:String!
    var imageURL:String!
    var uid:String!
    
    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var imgPro: UIImageView!
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var comDescription: UITextView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var conName: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCompanyProfile()
        
   
        self.imgPro.layer.cornerRadius = self.imgPro.frame.size.width / 2
        self.imgPro.clipsToBounds = true
        
        self.imageBG.layer.cornerRadius = self.imageBG.frame.size.width/2
        self.imageBG.clipsToBounds = true
        
        
    }
    
    @IBAction func editProfileButton(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCompanyProfile") as? EditCompanyProfileViewController
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            vc.imageUR = imageURL
            vc.compname = companyName.text
            vc.conNumb = phoneNumber.text
            vc.mail = email.text
            vc.contName = conName.text
            vc.comdescrip = comDescription.text
            vc.uname = username.text
            
        }
    }
    
 
     func getCompanyProfile(){
     let rootRef = Database.database().reference()
     if let userID = Auth.auth().currentUser?.uid{
     rootRef.child("Alluser").child(userID).observe(.value, with: { (snapshot) in
     
     let values = snapshot.value as? NSDictionary
     self.uid = values?["uid"] as? String
     self.companyName.text = values?["Company name"] as? String
     self.username.text = values?["Username"] as? String
     self.comDescription.text = values?["Company Description"] as? String
     self.conName.text = values?["Contact Name"] as? String
     self.email.text = values?["Email"] as? String
     self.phoneNumber.text = values?["Contact number"] as? String
     self.imageURL = values?["urlToImage"] as? String
        
        self.getImage(url: self.imageURL) { photo in
            if photo != nil {
                DispatchQueue.main.async {
                    self.imgPro.image = photo
                }}}

     })
  }
 
    
    }
    
    func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error == nil {
                completion(UIImage(data: data!))
            } else {
                completion(nil)
                print(error!)
            }
            }.resume()
    }
    
}






