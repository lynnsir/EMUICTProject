//
//  AccountMenuViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/14/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountMenuViewController: UIViewController {

    @IBOutlet weak var watchlist: UIButton!
    @IBOutlet weak var order: UIButton!
    @IBOutlet weak var profile: UIButton!
    @IBOutlet weak var logout: UIButton!
    
    var type:String!
    var imageURL:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getType()

       
    }


    
    @IBAction func ProfileButton(_ sender: Any) {
        
        print("Start")
        print(type)
         
         if self.type == "Student"{
            print("Student")
         if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileStudent") as? MyProfileStudentViewController
         
         {
         if let navigator = self.navigationController {
         navigator.show(vc, sender: true)
         }
         vc.type = "Student"
         }
         }
         
         else if self.type == "Alumni"{
            print("Alumni")
         if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileAlumni") as? MyProfileAlumniViewController
         
         {
         if let navigator = self.navigationController {
         navigator.show(vc, sender: true)
         }
         vc.type = "Alumni"
         
         }
         }
         
         else if self.type == "Company"{
            print("Company user")
         if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileCompany") as? MyProfileCompanyViewController
         
         {
         if let navigator = self.navigationController {
         navigator.show(vc, sender: true)
         }
         vc.type = "Company"
         
         
         }
         
         }
         
         else if self.type == "Staff" || self.type == "Admin"{
            print("Staff")
         if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileStaff") as? MyProfileStaffViewController
         
         {
         if let navigator = self.navigationController {
         navigator.show(vc, sender: true)
         }
         vc.type = "Staff"
         
         }
         
         } 
 
        
    }
    
    
    
//    @IBAction func OrderPressed(_ sender: Any) {
//        if self.type == "Company"{
//            displyAlertMessage(userMessage: "Can't access this menu")
//        }
//        else if self.type == "Admin"{
//          if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "....") as? ......ViewController
//
//                {
//                    if let navigator = self.navigationController {
//                        navigator.show(vc, sender: true)
//                    }
//                }
//            }
//    }
//        else {
//
//            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderList") as? OrderListViewController
//
//            {
//                if let navigator = self.navigationController {
//                    navigator.show(vc, sender: true)
//                }
//            }
//        }
//    }
    
    
    @IBAction func LogoutPressd(_ sender: Any) {
        if Auth.auth().currentUser != nil
        {
            try? Auth.auth().signOut()
        }
    }
    
    func getType(){
        
        //if the user is logged in get the profile data
        let rootRef = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid{
            rootRef.child("Alluser").child(userID).observe(.value, with: { (snapshot) in
                //create a dictionary of users profile data
                let values = snapshot.value as? NSDictionary
                self.type = values?["Type"] as? String
            })
        }
    }
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }
    
 
  

}
