//
//  ChatViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/29/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController,UINavigationControllerDelegate {

    var orderID:String!
    var buyerId:String!
    var sellerId:String!
    var ordate:String!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func seller(_ sender: Any) {

        let OrderID = Database.database().reference().child("Order").childByAutoId().key
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYY"
        let date = formatter.string(from: Date())
        self.ordate = date
        
        // change!! when msg completes
//        let sellerID = Auth.auth().currentUser!.uid
//        let buyerID = "JKy0SZ5RC8RIOKbRPzIRFZEL4X83" //com001
        
        let sellerID = Auth.auth().currentUser!.uid
        let buyerID = "Fgp0F4XN71dzCMpdqhhtlFm7Jz23" //Lynn001@test
        
        let postOrder: [String:Any] = [
            "orderID" : OrderID as AnyObject,
            "sellerID" : sellerID as AnyObject,
            "buyerID": buyerID as AnyObject,
            "status": "Not confirmed order"  as AnyObject,
            "s_b_o": sellerID + "_" + buyerID + "_" + "NCF"  as AnyObject,
             "Date": date as AnyObject
        ]
        Database.database().reference().child("Order").child("\(OrderID)").setValue(postOrder)

        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Order") as? OrderViewController
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            vc.orderID = OrderID
        }
        
    }
    
    
    
    @IBAction func buyer(_ sender: Any) {
        print("Start getting OrderID")
        confirmOrder()
      
    }
    
    func confirmOrder(){
        getorderID()
    }
 
    
    func getorderID(){
        
        let bid = Auth.auth().currentUser?.uid
        let sid = "JKy0SZ5RC8RIOKbRPzIRFZEL4X83" // com001@test.com
        
//        let bid = Auth.auth().currentUser?.uid
//        let sid = "Fgp0F4XN71dzCMpdqhhtlFm7Jz23" // lynn001@test.com
        
        let sbo = sid + "_" + bid! + "_" + "NCF"

        let rootRef = Database.database().reference()
        let query = rootRef.child("Order").queryOrdered(byChild: "s_b_o").queryEqual(toValue:sbo)
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let orderid = value["orderID"] as? String ?? "not found"
                    let sid = value["sellerID"] as? String ?? "not found"
                    let bid = value["buyerID"] as? String ?? "not found"
                    self.orderID = orderid
                    self.buyerId = bid
                    self.sellerId = sid

                }}}
        run(after: 2) {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrder") as? ConfirmOrderViewController
            {
                if let navigator = self.navigationController {
                    navigator.show(vc, sender: true)
                }
                vc.oid = self.orderID
                vc.sid = self.sellerId
                vc.bid = self.buyerId   
                print(self.orderID)
            }
        }
      
            
        
        
     
        
    }
    func run(after seconds: Int, completion: @escaping () -> Void){
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    
    
    
}
