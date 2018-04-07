//
//  OrderViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/28/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

protocol DataEnteredDelegate: class {
    func userDidEnterInformation(info: String)
}

class OrderViewController: UIViewController,UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource  {

    
    var orderID : String!
    var totalPrice = 0.00
     var totalMoney:String!

    
    var product = [Product]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancleBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(orderID)
        getOrder()
        tableView.dataSource = self
        tableView.delegate = self

    }


    @IBAction func canclePressed(_ sender: Any) {
        let OrderID = orderID!
        Database.database().reference().child("Order").child("\(OrderID)").removeValue()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        addTotal()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addProduct(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GenOrder") as? GenOrderViewController
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            vc.orderid = orderID
        }
    }
    
    //getOrder
    func getOrder(){
        
        let OrderID = orderID!
        let rootRef = Database.database().reference()
        let query = rootRef.child("Order").child("\(OrderID)").child("Product")
        
      
        query.observe(.value) { (snapshot) in
            self.product.removeAll()
            self.totalPrice = 0.00
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let value = child.value as? NSDictionary {
                    let products = Product()
                    let pdname = value["ProductName"] as? String
                    let quant = value["Quantity"] as? String
                    let prices = value["Price"] as? String
     
                    self.totalPrice = self.totalPrice + Double(prices!)!
                    print(self.totalPrice)
                    self.price.text = String(self.totalPrice)
                    products.name = pdname
                    products.quantity = quant
                    products.price = prices
                  
                    
                    self.product.append(products)
                     DispatchQueue.main.async { self.tableView.reloadData() }
                }
                
            }
        }
        
    }
    
    func addTotal(){
        let rootRef = Database.database().reference()
        print(totalPrice)
        self.totalMoney = String(totalPrice)
        
        let newUpdateStatus: [String : Any] = [
   
            "totalPrice": self.totalMoney
        ]
        
        rootRef.child("Order").child("\(orderID!)").updateChildValues(newUpdateStatus, withCompletionBlock: { (error, ref) in
            if let error = error{
                print(error)
                //return
            }
            print("Confirm success")
        })
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderTableViewCell
        let products = product[indexPath.row]
        
        cell.name.text = products.name
        cell.quantity.text = "x" + products.quantity
        cell.price.text = products.price
        
      
        return cell
        
    }
    
  

}
