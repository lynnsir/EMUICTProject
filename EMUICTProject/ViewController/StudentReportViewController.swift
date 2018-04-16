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
    var path:String!
    var word:String!
    

    var studentReport = [PersonReport]()



    var ref = Database.database().reference(withPath:"Student user")
    
    override func viewDidLoad() {
        super.viewDidLoad()
 

        if name == "" && year == "" && maj == "" && sid == "" {
            getUser()
            print("getuser")
        }
        else{
            getA()
            print("getA")
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
                        let imagePath = value["urlToImage"] as? String ?? "Image not found"
                        user.fullname = fullname
                        user.uid = uid
                        user.studentID = studentID
                        user.year = year
                        user.major = Major
                        user.email = email
                        user.imageProfile = imagePath
                        self.studentReport.append(user)

                        DispatchQueue.main.async { self.tableView.reloadData() }
                    }
                }
            }
    }
    func getA(){
        if name != "" && year == "" && sid == "" && maj == ""{
            print("1")
            self.path = "Full name"
            self.word = name
        }
        else if name == "" && year != "" && sid == "" && maj == ""{
            print("2")
            self.path = "Year"
            self.word = year
        }
        else if name == "" && year == "" && sid != "" && maj == ""{
            print("3")
            self.path = "Student ID"
            self.word = sid
        }
        else if name == "" && year == "" && sid == "" && maj != "" {
            print("4")
            self.path = "Major"
            self.word = maj
        }
        else if name == "" && year != "" && sid == "" && maj != ""{
            print("5")
            self.path = "Year_Major"
            self.word = year + "_" + maj
        }
        else if name != "" && year == "" && sid != "" && maj == ""{
            print("6")
            self.path = "Student ID_Full name"
             self.word = sid + "_" + name
        }
        else if name == "" && year != "" && sid != "" && maj == ""{
            print("7")
            self.path = "Student ID_Year"
             self.word = sid + "_" + year
        }
        else if name == "" && year == "" && sid != "" && maj != ""{
            print("8")
            self.path = "Student ID_Major"
             self.word = sid + "_" + maj
        }
        else if name != "" && year != "" && sid != "" && maj == ""{
            print("9")
            self.path = "Student ID_Full name_Year"
               self.word = sid + "_" + name + "_" + year
        }
        else if name != "" && year == "" && sid != "" && maj != ""{
            print("10")
            self.path = "Student ID_Full name_Major"
            self.word = sid + "_" + name + "_" + maj
        }
        else if name != "" && year != "" && sid == "" && maj != ""{
            print("11")
            self.path = "Full name_Year_Major"
            self.word = name + "_" + year + "_" + maj
        }
        else if name == "" && year != "" && sid != "" && maj != ""{
            print("12")
            self.path = "Student ID_Year_Major"
            self.word = sid + "_" + year + "_" + maj
        }
        else if name != "" && year != "" && sid != "" && maj != ""{
            print("13")
            self.path = "Student ID_Full name_Year_Major"
            let a = sid + "_" + name
            let b = year + "_" + maj
            self.word = a + "_" + b
        }
        else if name != "" && year != "" && sid == "" && maj == ""{
            print("14")
            self.path = "Full name_Year"
             self.word = name + "_" + year
        }
        else if name != "" && year == "" && sid == "" && maj != ""{
            print("15")
            self.path = "Full name_Major"
             self.word = name + "_" + maj
        }
        getquery()

    }
    func getquery(){
        let rootRef2 = Database.database().reference()
        let query2 = rootRef2.child("Student user").queryOrdered(byChild: self.path).queryEqual(toValue:word)
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
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    
                    user.fullname = fullname
                    user.uid = uid
                    user.studentID = studentID
                    user.year = year
                    user.major = Major
                    user.email = email
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
            vc.img = user.imageProfile
            
        }

    }
    
  

}
