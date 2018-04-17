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
    
    var name: String!
    var sid:String!
    var major:String!
    var career:String!
    var path:String!
    var word:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if name == "" && sid == "" && major == "" && career == ""{
            getUser()
            print("getUser")
        }
        else {
            getA()
            print("getA")
        }
        
        
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
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    user.fullname = fullname
                    user.uid = uid
                    user.studentID = studentID
                    user.major = major
                    user.career = career
                    user.email = email
                    user.imageProfile = imagePath
                    self.alumniReport.append(user)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    func getA(){
        if name != "" && career == "" && sid == "" && major == ""{
            print("1")
            self.path = "Full name"
            self.word = name
        }
        else if name == "" && career != "" && sid == "" && major == ""{
            print("2")
            self.path = "Career"
            self.word = career
        }
        else if name == "" && career == "" && sid != "" && major == ""{
            print("3")
            self.path = "Student ID"
            self.word = sid
        }
        else if name == "" && career == "" && sid == "" && major != "" {
            print("4")
            self.path = "Major"
            self.word = major
        }
        else if name == "" && career != "" && sid == "" && major != ""{
            print("5")
            self.path = "Career_Major"
            self.word = career + "_" + major
        }
        else if name != "" && career == "" && sid != "" && major == ""{
            print("6")
            self.path = "Student ID_Full name"
            self.word = sid + "_" + name
        }
        else if name == "" && career != "" && sid != "" && major == ""{
            print("7")
            self.path = "Student ID_Career"
            self.word = sid + "_" + career
        }
        else if name == "" && career == "" && sid != "" && major != ""{
            print("8")
            self.path = "Student ID_Major"
            self.word = sid + "_" + major
        }
        else if name != "" && career != "" && sid != "" && major == ""{
            print("9")
            self.path = "Student ID_Full name_Career"
            self.word = sid + "_" + name + "_" + career
        }
        else if name != "" && career == "" && sid != "" && major != ""{
            print("10")
            self.path = "Student ID_Full name_Major"
            self.word = sid + "_" + name + "_" + major
        }
        else if name != "" && career != "" && sid == "" && major != ""{
            print("11")
            self.path = "Full name_Career_Major"
            self.word = name + "_" + career + "_" + major
        }
        else if name == "" && career != "" && sid != "" && major != ""{
            print("12")
            self.path = "Student ID_Career_Major"
            self.word = sid + "_" + career + "_" + major
        }
        else if name != "" && career != "" && sid != "" && major != ""{
            print("13")
            self.path = "Student ID_Full name_Career_Major"
            let a = sid + "_" + name
            let b = career + "_" + major
            self.word = a + "_" + b
        }
        else if name != "" && career != "" && sid == "" && major == ""{
            print("14")
            self.path = "Full name_Career"
            self.word = name + "_" + career
        }
        else if name != "" && career == "" && sid == "" && major != ""{
            print("15")
            self.path = "Full name_Major"
            self.word = name + "_" + major
        }
        getquery()
        
    }
    func getquery(){
        let rootRef2 = Database.database().reference()
        print(path)
        print(word)
        let query = rootRef2.child("Alumni user").queryOrdered(byChild: path).queryEqual(toValue:word)
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
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    user.fullname = fullname
                    print("fullname: " + fullname)
                    user.uid = uid
                    user.studentID = studentID
                    user.major = major
                    user.career = career
                    user.email = email
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
            vc.imageURL = user.imageProfile
            
        }
         
    }


}
