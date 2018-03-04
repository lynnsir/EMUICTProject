//
//  StaffSearchViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/14/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class StaffSearchViewController: UIViewController {

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

        // Do any additional setup after loading the view.
    }

   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
