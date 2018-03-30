//
//  OrderListViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var order = [Order]()
    var total:String!
    var status:String!
    var oid:String!
    var date:String!
    var role:String!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSellerOrder()
     

    }

    
    @IBAction func segmentPressed(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            print("SellerSelected")
            getSellerOrder()
            
        case 1:
            print("BuyerSelected")
            getBuyerOrder()
            
        default:
            break
        }
    }
    
    func getSellerOrder(){
        
        let uid = Auth.auth().currentUser?.uid
        let rootRef = Database.database().reference()
        let query = rootRef.child("Order").queryOrdered(byChild: "sellerID").queryEqual(toValue:uid)
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let orders = Order()
                    let orderid = value["orderID"] as? String ?? "not found"
                    let total = value["totalPrice"] as? String ?? "not found"
                    let status = value["status"] as? String ?? "not found"
                    let date = value["Date"] as? String ?? "not found"
                    
                    self.oid = orderid
                    self.total = total
                    self.status = status
                    self.date = date
                    self.role = "seller"
                    print(orderid)
                    self.order.append(orders)
                                  DispatchQueue.main.async { self.tableView.reloadData() }
                }}}}
    
    
    func getBuyerOrder(){
        
        let uid = Auth.auth().currentUser?.uid
        let rootRef = Database.database().reference()
        let query = rootRef.child("Order").queryOrdered(byChild: "buyerID").queryEqual(toValue:uid)
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let orders = Order()
                    let orderid = value["orderID"] as? String ?? "not found"
                    let total = value["totalPrice"] as? String ?? "not found"
                    let status = value["status"] as? String ?? "not found"
                    let date = value["Date"] as? String ?? "not found"
                    
                    self.oid = orderid
                    self.total = total
                    self.status = status
                    self.date = date
                    self.role = "buyer"
                    print(orderid)
                    self.order.append(orders)
                                 DispatchQueue.main.async { self.tableView.reloadData() }
                    
                }}}}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
                return order.count
        
            }
    
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell") as! OrderListTableViewCell
      
        
                cell.img.image = #imageLiteral(resourceName: "orderimg")
                cell.status.text = status
                print(status)
                cell.total.text = total
                cell.date.text = date
        
                return cell
            }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            
            if status == "Confirmed Order" && role == "buyer"{
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailPay") as? OrderDetailPayViewController
    
                {
                    if let navigator = navigationController {
                        navigator.show(vc, sender: true)
                    }
    
                    vc.Orderdate = date
                    vc.Orderstatus = status
                    vc.oid = oid
                    vc.totalPrice = total
                    
    
                }
            }
            else{
    
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetail") as? OrderDetailViewController
    
                {
                    if let navigator = navigationController {
                        navigator.show(vc, sender: true)
                    }
    
                    vc.Orderdate = date
                    vc.Orderstatus = status
                    vc.oid = oid
                    vc.totalPrice = total
    
                }
            }
    
    
        }
    
    
 
    
}
