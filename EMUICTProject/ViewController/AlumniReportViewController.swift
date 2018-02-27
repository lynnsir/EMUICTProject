//
//  AlumniReportViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/14/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class AlumniReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var alumniReport = [PersonReport]()
    var ref = Database.database().reference(withPath:"Alumni user")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
   
    }
    func getUser(){
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("Alumni user")
        
        
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    let user = PersonReport()
                    let uid = value["uid"] as? String ?? "not found"
                    
                    let fullname = value["Full name"] as? String ?? "Full name not found"
                    let studentID = value["Student ID"] as? String ?? "Student ID not found"
                    let major = value["Major"] as? String ?? "Major not found"
                    
                    let career = value["Career"] as? String ?? "Career not found"
                    
                    
                    let email = value["Email"] as? String ?? "email not found"
                    
                    let tNumber = value["Contact number"] as? String ?? "Contact Number not found"
                    
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    
                    user.fullname = fullname
                    user.uid = uid
                    user.studentID = studentID
                    user.major = major
                    user.career = career
                    user.email = email
                    user.telephoneNumber = tNumber
                    user.imageProfile = imagePath
                    
                    self.alumniReport.append(user)
                    
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
            
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alumniReport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AlumniCell")
        let user = alumniReport[indexPath.row]
        
        
        
        cell.textLabel?.text = user.fullname
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlumniProfile") as? AlumniIndividualSearchViewController
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            let user = alumniReport[indexPath.row]
            vc.fullname = user.fullname
            vc.id = user.studentID
            vc.mj = user.major
            vc.job = user.career
            vc.mail = user.email
            vc.phonenum = user.telephoneNumber
            vc.imageURL = user.imageProfile
            
            

            
           
            
        }
        
        
        
        
    }

  
    



}
