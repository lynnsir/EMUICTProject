//
//  EditStudentProfileViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/11/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class EditStudentProfileViewController: UIViewController {
    
    @IBOutlet weak var imgPro: UIImageView!
    @IBOutlet weak var imageBG: UIView!
    @IBOutlet weak var insertImg: UIButton!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var conPassword: UITextField!
    @IBOutlet weak var ConNumber: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var birthdate: UITextField!
    @IBOutlet weak var save: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func insertImageButton(_ sender: Any) {
    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    @IBAction func cancelButton(_ sender: Any) {
    }
    
    @IBAction func DeleteButton(_ sender: Any) {
    }
    

}
