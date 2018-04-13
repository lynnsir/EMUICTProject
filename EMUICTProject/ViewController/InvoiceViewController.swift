//
//  InvoiceViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 2/27/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class InvoiceViewController: UIViewController {

    var userStorage: StorageReference!
   
    var name:String!
    var type:String!
    var db:String!
  
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var memberType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var confirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fullname.text = name
        self.memberType.text = type
        
        if memberType.text == "Student"{
            price.text = "150.00"
            self.db = "Student user"
        }
        else if memberType.text == "Staff"{
            price.text = "250.00"
            self.db = "Staff user"
        }
        else if memberType.text == "Alumni"{
            price.text = "200.00"
            self.db = "Alumni user"
        }
        else if memberType.text == "Company"{
            price.text = "300.00"
            self.db = "Company user"
        }
        
    }

    @IBAction func confirmPressed(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Payment") as? PaymentViewController
            
        {
            if let navigator = self.navigationController {
                navigator.show(vc, sender: true)
            }
            vc.totalPrice = price.text            
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        let user = Auth.auth().currentUser
        let user2 = Auth.auth().currentUser?.uid
        let user3 = user2
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        userStorage = storage.child(self.db)
        let imageRef = userStorage.child(user2!+".jpg")
        print(user2!+".jpg")
        imageRef.delete(completion: { error in
            if let error = error {
                print(error)
            } else {
                print("Company user: delete image from Storage")
            }
        })
        
        user?.delete { error in
            if let error = error {
                print(error)
            } else {
                Database.database().reference(withPath: "Company user").child(user3!).removeValue()
                print("Company:Delete db")
                
                Database.database().reference(withPath: "Alluser").child(user3!).removeValue()
                print("Alluser:Delete db")
                
                print("delete account success")
                
                
                
            }
        }
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    

    
    
}
