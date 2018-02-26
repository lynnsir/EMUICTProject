//
//  StudentSearchViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/14/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class StudentSearchViewController: UIViewController {


    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var studentID: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    
    @IBAction func SearchPressed(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudentReport") as? StudentReportViewController
            
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            vc.name = name.text!
            vc.year = year.text!
            vc.maj = major.text!
            vc.sid = studentID.text!
    
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  

    
}
