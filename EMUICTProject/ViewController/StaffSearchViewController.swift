//
//  StaffSearchViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/14/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class StaffSearchViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBAction func searchPressed(_ sender: Any) {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StaffReport") as? StaffReportViewController
            
        {
            if let navigator = self.navigationController {
                navigator.show(vc, sender: true)
            }
            
            vc.fname = fullname.text
            vc.pos = position.text
                        
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullname.delegate = self
        position.delegate = self  
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
