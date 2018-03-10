//
//  CompanySearchViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/14/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class CompanySearchViewController: UIViewController {
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBAction func searchPressed(_ sender: Any) {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompanyReport") as? CompanyReportViewController
    
        {
            if let navigator = self.navigationController {
                navigator.show(vc, sender: true)
            }
            vc.compName = companyName.text
   
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
}
