//
//  StaffReportViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/14/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class StaffReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var fname: String!
    var pos: String!
    
    var staffReport = [PersonReport]()
    
    var ref = Database.database().reference(withPath:"Staff user")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Start")
        print(fname)
        print(pos)
        
        if fname != nil{
            getName()
        }
        else if fname == nil && pos != nil{
            getPos()
        }
        else if fname == nil && pos == nil{
            getUser()
        }
    }
    
    func getUser(){
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("Staff user")
        
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    let user = PersonReport()
                    let uid = value["uid"] as? String ?? "not found"
                    let fullname = value["Full name"] as? String ?? "Full name not found"
                    let Position = value["Position"] as? String ?? "Position not found"
                    let email = value["Email"] as? String ?? "email not found"
                    let tNumber = value["Contact number"] as? String ?? "Contact Number not found"
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    user.fullname = fullname
                    user.uid = uid
                    user.position = Position
                    user.email = email
                    user.telephoneNumber = tNumber
                    user.imageProfile = imagePath
                    self.staffReport.append(user)
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    func getName(){
        
        let rootRef2 = Database.database().reference()
        let query2 = rootRef2.child("Staff user").queryOrdered(byChild: "Full name").queryEqual(toValue: fname)
        
        query2.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    let user = PersonReport()
                    let uid = value["uid"] as? String ?? "not found"
                    let fullname = value["Full name"] as? String ?? "Full name not found"
                    let Position = value["Position"] as? String ?? "Position not found"
                    let email = value["Email"] as? String ?? "email not found"
                    let tNumber = value["Contact number"] as? String ?? "Contact Number not found"
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    user.fullname = fullname
                    user.uid = uid
                    user.position = Position
                    user.email = email
                    user.telephoneNumber = tNumber
                    user.imageProfile = imagePath
                    self.staffReport.append(user)
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    func getPos(){
        
        let rootRef3 = Database.database().reference()
        let query3 = rootRef3.child("Staff user").queryOrdered(byChild: "Position").queryEqual(toValue: pos)
        
        query3.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    let user = PersonReport()
                    let uid = value["uid"] as? String ?? "not found"
                    let fullname = value["Full name"] as? String ?? "Full name not found"
                    let Position = value["Position"] as? String ?? "Position not found"
                    let email = value["Email"] as? String ?? "email not found"
                    let tNumber = value["Contact number"] as? String ?? "Contact Number not found"
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    user.fullname = fullname
                    user.uid = uid
                    user.position = Position
                    user.email = email
                    user.telephoneNumber = tNumber
                    user.imageProfile = imagePath
                    self.staffReport.append(user)
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffReport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "StaffCell")
        let user = staffReport[indexPath.row]
        
 
        
        cell.textLabel?.text = user.fullname
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StaffProfile") as? StaffIndividualSearchViewController
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            let user = staffReport[indexPath.row]
            vc.name = user.fullname
            vc.pos = user.position
            vc.mail = user.email
            vc.phonenum = user.telephoneNumber
            vc.imageURL = user.imageProfile
            
        }
        
        
        
        
    }
    

  

}
