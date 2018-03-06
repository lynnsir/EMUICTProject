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
    
    var name: String!
    var year: String!
    var maj : String!
    var sid : String!

    
    

    var studentReport = [PersonReport]()



    var ref = Database.database().reference(withPath:"Student user")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Start")
        print("name = "+name)
        print("year = "+year)
        print("major = "+maj)
        print("sid = "+sid)

  
        if name == "" && year == "" && maj == "" && sid == "" {
            getUser()
            print("getuser")
        }
            
        else if sid != "" {
            getSID()
            print("getsid")
        }
        else if name != "" && sid == ""  {
            getName()
            print("getName")
        }
        else if year != "" && name == "" && sid == "" && maj == ""{
            getYear()
            print("getYear")
        }
        else if maj != "" && name == "" && sid == "" && year == "" {
                getMajor()
            print("getMajor")
        }
        else if maj != "" && name == "" && sid == "" && year != "" {
                getYearMaj()
            print("getYearMajor")
        }
        
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
                        let studentID = value["Student ID"] as? String ?? "StudentID not found"
                        let year = value["Year"] as? String ?? "Year not found"
                        let Major = value["Major"] as? String ?? "Major not found"
                        let email = value["Email"] as? String ?? "email not found"
                        let tNumber = value["Contact number"] as? String ?? "Contact Number not found"
                        let imagePath = value["urlToImage"] as? String ?? "Image not found"
                        user.fullname = fullname
                        user.uid = uid
                        user.studentID = studentID
                        user.year = year
                        user.major = Major
                        user.email = email
                        user.telephoneNumber = tNumber
                        user.imageProfile = imagePath
                        self.studentReport.append(user)

                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }
                }
            }
    }
    
    func getName(){
        let rootRef2 = Database.database().reference()
        let query2 = rootRef2.child("Student user").queryOrdered(byChild: "Full name").queryEqual(toValue:name)
        query2.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = PersonReport()
                    let uid = value["uid"] as? String ?? "not found"
                    let fullname = value["Full name"] as? String ?? "Full name not found"
                    let studentID = value["Student ID"] as? String ?? "StudentID not found"
                    let year = value["Year"] as? String ?? "Year not found"
                    let Major = value["Major"] as? String ?? "Major not found"
                    let email = value["Email"] as? String ?? "email not found"
                    let tNumber = value["Contact number"] as? String ?? "Contact Number not found"
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    user.fullname = fullname
                    user.uid = uid
                    user.studentID = studentID
                    user.year = year
                    user.major = Major
                    user.email = email
                    user.telephoneNumber = tNumber
                    user.imageProfile = imagePath
                    self.studentReport.append(user)
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    func getSID(){
        let rootRef3 = Database.database().reference()
        let query3 = rootRef3.child("Student user").queryOrdered(byChild: "Student ID").queryEqual(toValue: sid)
        query3.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = PersonReport()
                    let uid = value["uid"] as? String ?? "not found"
                    let fullname = value["Full name"] as? String ?? "Full name not found"
                    let studentID = value["Student ID"] as? String ?? "StudentID not found"
                    let year = value["Year"] as? String ?? "Year not found"
                    let Major = value["Major"] as? String ?? "Major not found"
                    let email = value["Email"] as? String ?? "email not found"
                    let tNumber = value["Contact number"] as? String ?? "Contact Number not found"
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    user.fullname = fullname
                    user.uid = uid
                    user.studentID = studentID
                    user.year = year
                    user.major = Major
                    user.email = email
                    user.telephoneNumber = tNumber
                    user.imageProfile = imagePath
                    self.studentReport.append(user)
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    func getYear(){
        let rootRef4 = Database.database().reference()
        let query4 = rootRef4.child("Student user").queryOrdered(byChild: "Year").queryEqual(toValue: year)
        query4.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = PersonReport()
                    let uid = value["uid"] as? String ?? "not found"
                    let fullname = value["Full name"] as? String ?? "Full name not found"
                    let studentID = value["Student ID"] as? String ?? "StudentID not found"
                    let year = value["Year"] as? String ?? "Year not found"
                    let Major = value["Major"] as? String ?? "Major not found"
                    let email = value["Email"] as? String ?? "email not found"
                    let tNumber = value["Contact number"] as? String ?? "Contact Number not found"
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    user.fullname = fullname
                    user.uid = uid
                    user.studentID = studentID
                    user.year = year
                    user.major = Major
                    user.email = email
                    user.telephoneNumber = tNumber
                    user.imageProfile = imagePath
                    self.studentReport.append(user)
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    func getMajor(){
        let rootRef5 = Database.database().reference()
        let query5 = rootRef5.child("Student user").queryOrdered(byChild: "Major").queryEqual(toValue: maj)
        query5.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = PersonReport()
                    let uid = value["uid"] as? String ?? "not found"
                    let fullname = value["Full name"] as? String ?? "Full name not found"
                    let studentID = value["Student ID"] as? String ?? "StudentID not found"
                    let year = value["Year"] as? String ?? "Year not found"
                    let Major = value["Major"] as? String ?? "Major not found"
                    let email = value["Email"] as? String ?? "email not found"
                    let tNumber = value["Contact number"] as? String ?? "Contact Number not found"
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    user.fullname = fullname
                    user.uid = uid
                    user.studentID = studentID
                    user.year = year
                    user.major = Major
                    user.email = email
                    user.telephoneNumber = tNumber
                    user.imageProfile = imagePath
                    self.studentReport.append(user)
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    func getYearMaj(){
        let rootRef6 = Database.database().reference()
        let query6 = rootRef6.child("Student user").queryOrdered(byChild: "Year_Major").queryEqual(toValue: year + "_" + maj)
        query6.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let user = PersonReport()
                    let uid = value["uid"] as? String ?? "not found"
                    let fullname = value["Full name"] as? String ?? "Full name not found"
                    let studentID = value["Student ID"] as? String ?? "StudentID not found"
                    let year = value["Year"] as? String ?? "Year not found"
                    let Major = value["Major"] as? String ?? "Major not found"
                    let email = value["Email"] as? String ?? "email not found"
                    let tNumber = value["Contact number"] as? String ?? "Contact Number not found"
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    user.fullname = fullname
                    user.uid = uid
                    user.studentID = studentID
                    user.year = year
                    user.major = Major
                    user.email = email
                    user.telephoneNumber = tNumber
                    user.imageProfile = imagePath
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
            let user = studentReport[indexPath.row]
            vc.name = user.fullname
            vc.uid = user.uid
            vc.id = user.studentID
            vc.yr = user.year
            vc.mj = user.major
            vc.mail = user.email
            vc.number = user.telephoneNumber
            vc.img = user.imageProfile
            
        }
        
    
     

    }
   
    
    

    
  
   

}
