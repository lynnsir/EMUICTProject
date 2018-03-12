//
//  MyProfileStaffViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/10/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class MyProfileStaffViewController: UIViewController {
    
    var type:String!

    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var imgPro: UIImageView!
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var idNumber: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var birthdate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func editProfileButton(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditStaffProfile") as? EditStaffProfileViewController
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            
        }
    }
    
    



    

}
