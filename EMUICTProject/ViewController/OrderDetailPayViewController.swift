//
//  OrderDetailPayViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/30/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase
import OmiseSDK

class OrderDetailPayViewController: UIViewController, CreditCardFormDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
   
    private let publicKey = "pkey_test_5bjql4eprf9n0y13zn4"
    
    var product = [Product]()
    var Orderdate:String!
    var Orderstatus:String!
    var oid:String!
    var totalPrice = 0
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var paybutton: UIButton!
    @IBOutlet weak var cancelBut: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentCreditFormWithModal",
            let creditCardFormNavigationController = segue.destination as? UINavigationController,
            let creditCardFormController = creditCardFormNavigationController.topViewController as? CreditCardFormController {
            creditCardFormController.publicKey = publicKey
            creditCardFormController.handleErrors = true
            creditCardFormController.delegate = self
            
            creditCardFormController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissCreditCardForm))
        }
    }
    @objc fileprivate func dismissCreditCardForm() {
        dismissCreditCardFormWithCompletion(nil)
    }
    @objc fileprivate func dismissCreditCardFormWithCompletion(_ completion: (() -> Void)?) {
        if presentedViewController != nil {
            dismiss(animated: true, completion: completion)
        } else {
            _ = navigationController?.popToViewController(self, animated: true)
            completion?()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailPayView")
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
            self.totalPrice = 0
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                if let value = child.value as? NSDictionary {
                    let products = Product()
                    let pdname = value["ProductName"] as? String
                    let quant = value["Quantity"] as? String
                    let prices = value["Price"] as? String
                    
                    self.totalPrice = self.totalPrice + Int(prices!)!
                    print(self.totalPrice)
                    self.price.text = String(self.totalPrice)
                    
                    products.name = pdname
                    products.quantity = quant
                    products.price = prices
                    
                    print(products.name)
                    print(products.quantity)
                    print(products.price)
                    
                    
                    self.product.append(products)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }}}}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailPayCell") as! OrderDetailPayTableViewCell
        
        let products = product[indexPath.row]
        print("printCell")
        print(products.name)
        print(products.quantity)
        print(products.price)
        
        cell.name.text = products.name!
        cell.quantity.text = "x" + products.quantity!
        cell.price.text = products.price!
        
        return cell
    }
    

    
    
    @IBAction func cancelPressed(_ sender: Any) {
        let OrderID = oid!
        Database.database().reference().child("Order").child("\(OrderID)").removeValue()
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func payPressed(_ sender: Any) {
        
//        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductPayment") as? ProductPaymentViewController
//        {
//            if let navigator = self.navigationController {
//                navigator.show(vc, sender: true)
//            }
//            vc.total = totalPrice
//            vc.oid = oid
//            print(totalPrice)
//        }
        
        let creditCardFormController = CreditCardFormController.makeCreditCardForm(withPublicKey: publicKey)
        creditCardFormController.handleErrors = true
        creditCardFormController.delegate = self
        show(creditCardFormController, sender: self)
        
    }
    
    func creditCardForm(_ controller: CreditCardFormController, didSucceedWithToken token: OmiseToken) {
        dismissCreditCardFormWithCompletion({
            // Sends `OmiseToken` to your server for creating a charge, or a customer object.
            //Send to HTTP request
            
            let url:NSURL = NSURL(string: "http://127.0.0.1/php-test/services/chargeService.php")!
            let session = URLSession.shared
            let priceNew = Int(self.totalPrice)
            let pricethb = priceNew * 100
            let description = self.oid!
            let request = NSMutableURLRequest(url:url as URL)
            request.httpMethod = "POST"
            
            let datatoken = "token=\(token.tokenId!)&total=\(pricethb)&description=\(description)"
            request.httpBody = datatoken.data(using: String.Encoding.utf8)
            
            let task = session.dataTask(with: request as URLRequest){(data,response,error) in
                guard error == nil else{ //Have error
                    return
                }
                if let data = data { // can charge
                    let string = String(data: data, encoding: String.Encoding.utf8)
                    print(response!)
                    print("Test: " + string!) //JSONSerialization
                    print(pricethb)
                    self.updateStatus()
                    self.displyAlertMessage(userMessage: "Payment Successful")
                }
                
            }
            task.resume()
            
            
            //self.performSegue(withIdentifier: "CompletePayment", sender: self)
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
    }
    func updateStatus(){
        let rootRef = Database.database().reference()
        
        
        let newUpdateStatus: [String : Any] = [
            "seller_status": "Verified Payment",
            "buyer_status": "Verified Payment"
        ]
        
        rootRef.child("Order").child("\(oid!)").updateChildValues(newUpdateStatus, withCompletionBlock: { (error, ref) in
            if let error = error{
                print(error)
                //return
            }
            print("Payment success")
        })
        
    }
    
    func creditCardForm(_ controller: CreditCardFormController, didFailWithError error: Error) {
        // Only important if we set `handleErrors = false`.
        // You can send errors to a logging service, or display them to the user here.
        print(error)
        self.displyAlertMessage(userMessage: "Paymernt Error!")
        self.dismissCreditCardForm()
    }
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }
    
  
    
}
