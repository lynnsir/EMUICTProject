//
//  StudentReportViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/14/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class StudentReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    

    var studentReport = [PersonReport]()
    var ref = Database.database().reference(withPath:"Student user")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
    }
    
    func getUser(){

        let rootRef = Database.database().reference()
            let query = rootRef.child("Student user")
        
            query.observe(.value) { (snapshot) in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    if let value = child.value as? NSDictionary {
                        let user = PersonReport()
                        let uid = value["uid"] as? String ?? "not found"
                        let fullname = value["Full name"] as? String ?? "Full name not found"
                        user.fullname = fullname
                        print(uid)
                        self.studentReport.append(user)
                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }
                }
            }
        
        
    }
    
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentReport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "StudentCell")
        let user = studentReport[indexPath.row]
        cell.textLabel?.text = user.fullname
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StudentProfile") as? StudentIndividualSearchViewController
        
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
        }
        
        
     

    }
   
    
    

    
  
   

}
