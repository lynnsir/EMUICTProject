//
//  ChatViewController.swift
//  EMUICTProject
//
//  Created by Lynn on 3/29/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase



class ChatViewController: UIViewController,UINavigationControllerDelegate, UITextFieldDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var orderID:String!
    var buyerId:String!
    var sellerId:String!
    var ordate:String!
    
    var boardid:String!
    var senderid: String! //sender
    var recieverid: String! //reciever
    var uid = Auth.auth().currentUser?.uid
    var type:String!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var messageText: UITextField! //message text
    
    let cellId = "cellId"
    var messages = [Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getType()
        messageText.delegate = self
        observeMessages()
        collectionView?.contentInset = UIEdgeInsetsMake(9, 0, 58, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(9, 0, 50, 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatmessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
       
    }
    
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userMessageRef = Database.database().reference().child("user-messages").child(uid)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else{
                    return
                }
                let message = Message(dictionary: dictionary)
                if message.chatPartnerId() == self.recieverid{
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
               
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatmessageCollectionViewCell
        //cell.backgroundColor = UIColor.red
        let message = messages[indexPath.item]
        setupCell(cell: cell, message: message)
        cell.textView.text = message.textmessage
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.textmessage!).width + 32
        return cell
    }
    private func setupCell(cell: ChatmessageCollectionViewCell, message: Message){
        
        if let id = message.chatPartnerId(){ // check chat partner
            let ref = Database.database().reference().child("Alluser").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    
                    if let profileImageUrl = dictionary["urlToImage"] as? String{
                        let url = URL(string: profileImageUrl)
                        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                            if error != nil{print(error.debugDescription)}
                            DispatchQueue.main.async {
                                cell.profileImageView.image = UIImage(data: data!)
                            }
                        }).resume()
                     }
                }
                
            }, withCancel: nil)
           
        }
        
        if message.fromid == Auth.auth().currentUser?.uid{
            cell.bubbleView.backgroundColor = ChatmessageCollectionViewCell.aquarColor
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }else{
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        if let text = messages[indexPath.item].textmessage{
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
        
    }
    
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        let rootRef = Database.database().reference()
        let query = rootRef.child("Alluser").child(recieverid!)
        
        if recieverid! != "" {
            print(recieverid!)
            query.observe(.value) { (snapshot) in
                
                if let uservalue = snapshot.value as? NSDictionary{
                    
                    let recieverName = uservalue["Username"] as? String ?? "Type not found"
                    print(snapshot)
                    
                    self.navigationItem.title = recieverName
                    
                }
            }
        }
    }
    
    @IBAction func orderPressed(_ sender: Any) {
        if uid == recieverid {
            print("Set order")
            setOrder()
        }

        else if self.type == "Company" || self.type == "Admin" {
            displyAlertMessage(userMessage: "Can't access")
        }
        
        else{
            displyAlertMessage(userMessage: "Using for order generating only")
        }
    }
    
    @IBAction func sendMessageButt(_ sender: Any) {
        
        //send message
        // store message in database
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toid = recieverid! //reciever
        let fromid = senderid! //sender
        let timestamp = Int(Date().timeIntervalSince1970)
        let messagetext = messageText.text
        let messagevalue: [String : Any] = ["textmessage": messagetext as AnyObject,
                            "toid": toid as AnyObject,
                            "fromid": fromid as AnyObject,
                            "timestamp": timestamp as AnyObject
            ] 
        //childRef.updateChildValues(messagevalue)
        childRef.updateChildValues(messagevalue) { (error, ref) in
            if error != nil{
                print(error.debugDescription)
                return
            }
            self.messageText.text = nil
            let userMessageRef = Database.database().reference().child("user-messages").child(fromid)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId:1]) // sender message
            
            let receiverMessageRef = Database.database().reference().child("user-messages").child(toid)
            receiverMessageRef.updateChildValues([messageId:1]) //receiver message
        }
    
    }

    func setOrder(){
        let OrderID = Database.database().reference().child("Order").childByAutoId().key
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYY"
        let date = formatter.string(from: Date())
        self.ordate = date
        
        let sellerID = Auth.auth().currentUser!.uid
        let buyerID = senderid!
        
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
    
    func getorderID(){
        
        let bid = Auth.auth().currentUser?.uid
        let sid = recieverid!

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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }
    
    func getType(){
        
        //if the user is logged in get the profile data
        let rootRef = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid{
            rootRef.child("Alluser").child(userID).observe(.value, with: { (snapshot) in
                //create a dictionary of users profile data
                let values = snapshot.value as? NSDictionary
                self.type = values?["Type"] as? String
            })
        }
    }
}
