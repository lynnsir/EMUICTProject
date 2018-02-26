//
//  StaffIndividualSearchViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/21/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class StaffIndividualSearchViewController: UIViewController {
    
    var imageURL: String!
    var name: String!
    var pos: String!
    var mail: String!
    var phonenum: String!
    
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var imageBG: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullname.text = name
        position.text = pos
        email.text = mail
        phone.text = phonenum
        
        getImage(url: imageURL) { photo in
            if photo != nil {
                DispatchQueue.main.async {
                    self.profileImage.image = photo
                }
            }
        }
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
        
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
