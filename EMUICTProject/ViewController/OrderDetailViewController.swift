//
//  OrderDetailViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class OrderDetailViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    var product = [Product]()
    var Orderdate:String!
    var Orderstatus:String!
    var oid:String!
    var totalPrice = 0.00
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var okbutton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailView")
         print(oid)
        date.text = Orderdate
        status.text = Orderstatus
        getProduct()
 
    }
    
    func getProduct(){
        print(oid)
        let OrderID = oid!
        print(OrderID)
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
                }}}}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell") as! OrderDetailTableViewCell
        
       let products = product[indexPath.row]

        cell.name.text = products.name!
        cell.quantity.text = "x" + products.quantity!
        cell.price.text = products.price!
        
        return cell
    }
    

  
    @IBAction func okPressed(_ sender: Any) {
         _ = navigationController?.popViewController(animated: true)
    }
    
}
