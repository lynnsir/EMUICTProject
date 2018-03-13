//
//  StudentIndividualSearchViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/21/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class StudentIndividualSearchViewController: UIViewController {
    
    var img : String!
    var name: String!
    var id : String!
    var yr : String!
    var mj : String!
    var mail : String!
    var uid: String!
    
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var studentID: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullname.text = name
        studentID.text = id
        year.text = yr
        major.text = mj
        email.text = mail
        
        getImage(url: img) { photo in
            if photo != nil {
                    DispatchQueue.main.async {
                        self.imageProfile.image = photo
                    }
            }
        }
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
          self.imageProfile.clipsToBounds = true
        
        self.imageBG.layer.cornerRadius = self.imageBG.frame.size.width/2
        self.imageBG.clipsToBounds = true
        


    }
    
    func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error == nil {
                completion(UIImage(data: data!))
            } else {
                completion(nil)
            }
            }.resume()
    }}
        

    
    
   






