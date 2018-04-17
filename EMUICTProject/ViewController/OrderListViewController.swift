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
    var order2 = [Order]()
    var total:String!
    var status:String!
    var oid:String!
    var sid:String!
    var bid:String!
    var date:String!
    var role:String!

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSellerOrder()
        tableView.backgroundColor = UIColor(red:0.99, green:1.00, blue:0.95, alpha:1.0)

    }
  
    @IBAction func segmentPressed(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            tableView.reloadData()
            print("SellerSelected")
            getSellerOrder()
        }
    
        else  {
            tableView.reloadData()
            print("BuyerSelected")
            getBuyerOrder()
        }
    }
    
    func getSellerOrder(){
        
        let uid = Auth.auth().currentUser?.uid
        let rootRef = Database.database().reference()
        let query = rootRef.child("Order").queryOrdered(byChild: "sellerID").queryEqual(toValue:uid)
  
        query.observe(.value) { (snapshot) in
           self.order.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let orders = Order()
                    let orderid = value["orderID"] as? String ?? "not found"
                    let total = value["totalPrice"] as? String ?? "not found"
                    let status = value["seller_status"] as? String ?? "not found"
                    let date = value["Date"] as? String ?? "not found"
                    let bid = value["buyerID"] as? String ?? "not found"
                    let sid = value["sellerID"] as? String ?? "not found"
                    
                    orders.sellerID = sid
                    orders.buyerID = bid
                    orders.orderID = orderid
                    orders.total = total
                    orders.status = status
                    orders.date = date
                    self.role = "seller"
                    
                    print(orderid)
                    print(total)
                    
                    self.order.append(orders)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }}}}
    
    
    func getBuyerOrder(){
        
        let uid = Auth.auth().currentUser?.uid
        let rootRef = Database.database().reference()
        let query = rootRef.child("Order").queryOrdered(byChild: "buyerID").queryEqual(toValue:uid)
        
        query.observe(.value) { (snapshot) in
                self.order2.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let orders = Order()
                    let orderid = value["orderID"] as? String ?? "not found"
                    let total = value["totalPrice"] as? String ?? "not found"
                    let status = value["buyer_status"] as? String ?? "not found"
                    let date = value["Date"] as? String ?? "not found"
                    let bid = value["buyerID"] as? String ?? "not found"
                    let sid = value["sellerID"] as? String ?? "not found"
                    
                    orders.sellerID = sid
                    orders.buyerID = bid
                    orders.orderID = orderid
                    orders.total = total
                    orders.status = status
                    orders.date = date
                    self.role = "buyer"
                    print(orderid)
                    self.order2.append(orders)
                  DispatchQueue.main.async { self.tableView.reloadData() }
                    
                }}}}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 1{
            return order2.count
        }
        else{
            return order.count
        }

            }
    
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell") as! OrderListTableViewCell
                let order = self.order[indexPath.row]
                let order2 = self.order2[indexPath.row]
                
                if segmentControl.selectedSegmentIndex == 1{
                    cell.img.image = #imageLiteral(resourceName: "orderimg")
                    cell.status.text = order2.status
                    print(status)
                    cell.total.text = order2.total
                    cell.date.text = order2.date
                }
                else{
                    
                    cell.img.image = #imageLiteral(resourceName: "orderimg")
                    cell.status.text = order.status
                    print(status)
                    cell.total.text = order.total
                    cell.date.text = order.date
                }
                
        
             
        
                return cell
            }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            
            if role == "buyer"{
                
                if status == "Confirmed order" {
                    
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetailPay") as? OrderDetailPayViewController
                        
                    {
                        if let navigator = navigationController {
                            navigator.show(vc, sender: true)
                        }
                        
                        vc.Orderdate = date
                        vc.Orderstatus = status
                        vc.oid = oid
                        
                    }
        }
                
                else if status == "Unconfirmed order" {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmOrder") as? ConfirmOrderViewController
                        
                    {
                        if let navigator = navigationController {
                            navigator.show(vc, sender: true)
                        }
                        
                        vc.oid = oid
                        print("Helo: " + sid)
                        print(bid)
                        vc.sid = sid
                        vc.bid = bid
 
                    }
                }
                
                else {
                    
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderDetail") as? OrderDetailViewController
                        
                    {
                        if let navigator = navigationController {
                            navigator.show(vc, sender: true)
                        }
                        
                        vc.Orderdate = date
                        vc.Orderstatus = status
                        vc.oid = oid
                        
                    }
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


                }
            }

        }
    
    
 
    
}
