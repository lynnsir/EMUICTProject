//
//  AlumniIndividualSearchViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/21/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class AlumniIndividualSearchViewController: UIViewController {
    
  
    var fullname: String!
    var id: String!
    var mj: String!
    var job: String!
    var mail: String!
    var phonenum: String!
    var imageURL: String!
    
    
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var studentID: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var career: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = fullname
        studentID.text = id
        major.text = mj
        career.text = job
        email.text = mail
        
        getImage(url: imageURL) { photo in
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
    }



}
