//
//  AdminOrderDetailViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 4/6/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class AdminOrderDetailViewController: UIViewController {
    
    @IBOutlet weak var oid: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var buyerName: UILabel!
    @IBOutlet weak var total: UILabel!
    
    var orderid:String!
    var buyerID:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        BuyerName()
    }
    
    func OrderDetail(){
        let rootRef = Database.database().reference()
            rootRef.child("Order").child(orderid).observe(.value, with: { (snapshot) in
                
                let values = snapshot.value as? NSDictionary
                self.oid.text = values?["orderID"] as? String
                self.date.text = values?["Date"] as? String
                self.status.text = values?["seller_status"] as? String
                self.total.text = values?["totalPrice"] as? String
                self.buyerID = values?["buyerID"] as? String
                
                if self.oid.text == "" {
                    
                    let alert = UIAlertController(title: "Success", message:   "Payment is confirmed!", preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(OKAction)
                    self.present(alert, animated: true){}
                }
            })}
    

    
    
    func BuyerName(){
        OrderDetail()
        let rootRef = Database.database().reference()
        rootRef.child("Alluser").child(buyerID).observe(.value, with: { (snapshot) in
            
            let values = snapshot.value as? NSDictionary
            self.buyerName.text = values?["Full name"] as? String
        })
    }
  
    @IBAction func cancelPressed(_ sender: Any) {
           _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sendMsg(_ sender: Any) {
        // send message to board creator
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Chat") as? ChatViewController
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            

            vc.senderid = Auth.auth().currentUser?.uid
            vc.recieverid = buyerID
            
        }
    }
    
    
    @IBAction func updateStatus(_ sender: Any) {
        updateStatus()
         _ = navigationController?.popViewController(animated: true)
    }
    
    func updateStatus(){
        let rootRef = Database.database().reference()
        
        
        let newUpdateStatus: [String : Any] = [
            "seller_status": "Transfer to vendor"
           
            ]
        
        rootRef.child("Order").child("\(orderid)").updateChildValues(newUpdateStatus, withCompletionBlock: { (error, ref) in
            if let error = error{
                print(error)
                //return
            }
            print("Update success")
        })
    }
    
}
