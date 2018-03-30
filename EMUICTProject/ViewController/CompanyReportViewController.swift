//
//  CompanyReportViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/14/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class CompanyReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var compName:String!
    
    @IBOutlet weak var tableView: UITableView!
    var companyReport = [CompanyReport]()
    var ref = Database.database().reference(withPath:"Company user")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if compName != ""{
            getCompanyName()
        }
        else {
            getUser()
        }
        
        
    }
    
    
    
    func getUser(){
        let rootRef = Database.database().reference()
        let query = rootRef.child("Company user")
        
        
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let value = child.value as? NSDictionary {
                    let user = CompanyReport()
                    let uid = value["uid"] as? String ?? "not found"
                    let comName = value["Company name"] as? String ?? "Full name not found"
                    let comDes = value["Company Description"] as? String ?? "Not found"
                    let email = value["Email"] as? String ?? "email not found"
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    
                    user.companyName = comName
                    user.uid = uid
                    user.companyDes = comDes
                    user.email = email
                    user.imageProfile = imagePath
                    self.companyReport.append(user)
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
        
    }
    
    func getCompanyName(){
        
        let rootRef2 = Database.database().reference()
        let query2 = rootRef2.child("Company user").queryOrdered(byChild: "Company name").queryEqual(toValue: compName)
        
        query2.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let value = child.value as? NSDictionary {
                    let user = CompanyReport()
                    let uid = value["uid"] as? String ?? "not found"
                    let comName = value["Company name"] as? String ?? "Full name not found"
                    let comDes = value["Company Description"] as? String ?? "Not found"
                    let email = value["Email"] as? String ?? "email not found"
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    
                    user.companyName = comName
                    user.uid = uid
                    user.companyDes = comDes
                    user.email = email
                    user.imageProfile = imagePath
                    self.companyReport.append(user)
                    
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyReport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CompanyCell")
        let user = companyReport[indexPath.row]
        
        cell.textLabel?.text = user.companyName
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompanyProfile") as? CompanyIndividualSearchViewController
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            let user = companyReport[indexPath.row]
            vc.nameCompany = user.companyName
            vc.des = user.companyDes
            vc.mail = user.email
            vc.imageURL = user.imageProfile

        }
        
        
        
        
    }
    
    
    
}

