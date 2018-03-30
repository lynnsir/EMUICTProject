//
//  ConfirmOrderViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/28/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class ConfirmOrderViewController: UIViewController,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource{

    var oid:String!
    var bid:String!
    var sid:String!
    var order = [Order]()
    var totalPrice = 0.00
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Start next page")
        print(oid)
        getProduct()
  
    }
    
     

    @IBAction func canclePressed(_ sender: Any) {
        let OrderID = oid!
        Database.database().reference().child("Order").child("\(OrderID)").removeValue()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        updateStatus()
//        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductPayment") as? ProductPaymentViewController
//        {
//            if let navigator = navigationController {
//                navigator.show(vc, sender: true)
//            }
//            //vc.orderid = orderID
//        }
    }
    
    //getProduct
    func getProduct(){

        let OrderID = oid!
        print(OrderID)
        let rootRef = Database.database().reference()
        let query = rootRef.child("Order").child("\(OrderID)").child("Product")

        query.observe(.value) { (snapshot) in
            self.order.removeAll()
            self.totalPrice = 0.00
            for child in snapshot.children.allObjects as! [DataSnapshot] {

                if let value = child.value as? NSDictionary {
                    let orders = Order()
                    let pdname = value["ProductName"] as? String
                    let quant = value["Quantity"] as? String
                    let prices = value["Price"] as? String

                    self.totalPrice = self.totalPrice + Double(prices!)!
                    print(self.totalPrice)
                    self.price.text = String(self.totalPrice)
                    orders.name = pdname
                    orders.quantity = quant
                    orders.price = prices


                    self.order.append(orders)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }}}}

  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return order.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmOrderCell") as! ConfirmOrderTableViewCell
        
        let orders = order[indexPath.row]
        
        cell.name.text = orders.name
        cell.quantity.text = orders.quantity
        cell.price.text = orders.price
        
        return cell
    }
    

    func updateStatus(){
        let rootRef = Database.database().reference()

        let newUpdateStatus: [String : Any] = [
            "status": "CF",
            "s_b_o": sid! + "_" + bid! + "_" + "CF"
        ]
        
        rootRef.child("Order").child("\(oid!)").updateChildValues(newUpdateStatus, withCompletionBlock: { (error, ref) in
            if let error = error{
                print(error)
                //return
            }
            print("Confirm success")
        })

    }
    
    

}
