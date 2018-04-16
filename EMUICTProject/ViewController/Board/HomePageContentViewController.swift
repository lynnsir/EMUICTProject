//
//  HomePageContentViewController.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 27/3/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class HomePageContentViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    let cellId = "CommentCell"
    var img : String!
    var Title: String!
    var content: String!
    var creator: String!
    var boardId: String!
    var type:String!
    
    var comment = [NAEcomment]()
    
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var postedImg: UIImageView!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var sendMsg: UIButton!
    @IBOutlet weak var delete: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        // check admin status
        let uid = Auth.auth().currentUser!.uid
        let rootRef = Database.database().reference()
        let query = rootRef.child("Alluser").child("\(uid)")
        var usertype: String!
        query.observe(.value) { (snapshot) in
            
            if let uservalue = snapshot.value as? NSDictionary{
                
                usertype = uservalue["Type"] as? String ?? "Type not found"
                
                if(usertype == "Admin"){
                    //user is admin
                    self.sendMsg.isHidden = true
                    self.delete.isHidden = true
                    
                }else{
                    //user is gen user
                    self.sendMsg.isHidden = true
                    self.delete.isHidden = true
                }
                
            }
            
        }
        //check current user who are board creator
        let creatorid = creator!
        if uid == creatorid{
            self.sendMsg.isEnabled = false
        }else
        {
            self.sendMsg.isEnabled = true
        }
        
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        //delete post for admin
        let boardid = boardId!
        let ref = Database.database().reference().child("\(type)").child("\(boardid)")
        ref.removeValue(completionBlock: {(error, ref) in
            if(error != nil){
                print(error.debugDescription)
            }
        })
        displyAlertMessage(userMessage: "Delete successful")
        // send to feed page
       _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendmsg(_ sender: Any) {
        // send message to board creator
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Chat") as? ChatViewController
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            
            
            vc.senderid = Auth.auth().currentUser?.uid
            vc.recieverid = creator!
            
        }
    }
    
  
    
    
    @IBAction func commentButt(_ sender: Any) {
        
        let uid = Auth.auth().currentUser!.uid
        let rootRef = Database.database().reference()
        let query = rootRef.child("Alluser").child("\(uid)")
        var usertype: String!
        query.observe(.value) { (snapshot) in
            
            if let uservalue = snapshot.value as? NSDictionary{
                
                usertype = uservalue["Type"] as? String ?? "Type not found"
                
                if(usertype == "Admin"){
                    let comment = self.commentText.text
                    let commentOwner = Auth.auth().currentUser!.uid
                    let BoardId = self.boardId!
                    let postComment : [String : Any] = [
                        "Commentuid": commentOwner as AnyObject,
                        "Comment": comment as AnyObject
                    ]
                    Database.database().reference().child(self.type).child("\(BoardId)").child("comment").childByAutoId().setValue(postComment)
                    
                }else{
                    let comment = self.commentText.text
                    let commentOwner = Auth.auth().currentUser!.uid
                    let BoardId = self.boardId!
                    let postComment : [String : Any] = [
                        "Commentuid": commentOwner as AnyObject,
                        "Comment": comment as AnyObject
                    ]
                    Database.database().reference().child("NewAndEventPost").child("\(BoardId)").child("comment").childByAutoId().setValue(postComment)
                }
                
            }
            
        }
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.register(commentCell.self, forCellReuseIdentifier: cellId)
        postContent.text = content
        getImage(url: img) { photo in
            if photo != nil {
                DispatchQueue.main.async {
                    self.postedImg.image = photo
                }
            }
        }
        
        getcomment()
        TableView.dataSource = self
        TableView.delegate = self
        
        
    }
    // get comment and owner name
    func getcomment(){
        let boardid = boardId!
        let rootRef = Database.database().reference()
        let query = rootRef.child("NewAndEventPost").child("\(boardid)").child("comment")
        
        query.observe(.value) { (snapshot) in
            self.comment.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    let pcomment = NAEcomment()
                    
                    let creatorid = value["Commentuid"] as? String ?? "Creator not found"
                    let commentContent = value["Comment"] as? String ?? "Title not found"
                    
                    pcomment.comment = commentContent
                    pcomment.userid = creatorid
                    
                    let query2 = rootRef.child("Alluser").child("\(creatorid)")
                    query2.observe(.value, with: {(snapshot2) in
                        
                        if let userinfo = snapshot2.value as? NSDictionary{
                            let userName = userinfo["Full name"] as? String ?? "Not found user name"
                            
                            pcomment.userName = userName
                            self.comment.append(pcomment)
                            DispatchQueue.main.async { self.TableView.reloadData() }
                        }
                    })
                }
            }
        }
    }
    
    func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error == nil {
                completion(UIImage(data: data!))
            } else {
                completion(nil)
            }
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! commentCell
        let usercomment = comment[indexPath.row]
        
        DispatchQueue.main.async {
            cell.textLabel?.text = usercomment.userName
            cell.detailTextLabel?.text = usercomment.comment
        }
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }
    
    
}
