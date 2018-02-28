//
//  CompanyIndividualSearchViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/21/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class CompanyIndividualSearchViewController: UIViewController {
    
    
    var nameCompany: String!
    var des: String!
    var mail: String!
    var phonenum: String!
    var conname: String!
    var imageURL: String!

    @IBOutlet weak var companyname: UILabel!
    @IBOutlet weak var companyDes: UITextView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var contactname: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageBG: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyname.text = nameCompany
        companyDes.text = des
        contactname.text = conname
        email.text = mail
        phone.text = phonenum
        
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
