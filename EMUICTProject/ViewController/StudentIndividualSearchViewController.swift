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
    
    var img : NSURL!
    var name: String!
    var id : String!
    var yr : String!
    var mj : String!
    var mail : String!
    var number : String!
    var uid: String!
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var studentID: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var telephoneNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullname.text = name
        studentID.text = id
        year.text = yr
        major.text = mj
        email.text = mail
        telephoneNumber.text = number
       
        
  /*let image = try?
            Data(contentsOf: img as! NSURL)
        imageProfile.image = UIImage(data: image!)*/
        
        // Do any additional setup after loading the view.
    }

   

}
