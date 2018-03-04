//
//  NewsAndEventContentTableViewCell.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 4/3/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.

import UIKit
import Firebase

class NewsAndEventContentTableViewCell: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var img : String!
    var Title: String!
    var content: String!
    var creator: String!
    var boardId: String!
    
    var comment = [NAEcomment]()
   
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var postedImg: UIImageView!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var commentText: UITextField!
    
    @IBAction func reportBut(_ sender: Any) {
        //For Admin
    }
    
    @IBAction func commentButt(_ sender: Any) {
        let comment = commentText.text
        let commentOwner = Auth.auth().currentUser!.uid
        let BoardId = boardId!
        let postComment : [String : Any] = [
            "Commentuid": commentOwner as AnyObject,
            "Comment": comment as AnyObject
                 ]
        Database.database().reference().child("NewAndEventPost").child("\(BoardId)").child("comment").childByAutoId().setValue(postComment)
    }
    
    @IBAction func Addwatchlist(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //let query2 = rootRef.child("Alluser").child
        
        
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    let pcomment = NAEcomment()
                    

                      let creatorid = value["Commentuid"] as? String ?? "Creator not found"
                      let commentContent = value["Comment"] as? String ?? "Title not found"

                    pcomment.comment = commentContent
                    pcomment.userid = creatorid
                    
                    let query2 = rootRef.child("Alluser").child("\(creatorid)")
                    query2.observe(.value, with: {(snapshot2) in
                        
                        if let userinfo = snapshot2.value as? [String : Any]{
                            let userName = userinfo["FullName"] as? String ?? "Not found user name"
                            
                            pcomment.userName = userName
                        }
                    })
                    
                    self.comment.append(pcomment)
                    DispatchQueue.main.async { self.TableView.reloadData() }
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
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
        let usercomment = comment[indexPath.row]
        
        cell.textLabel?.text = usercomment.userName
        cell.detailTextLabel?.text = usercomment.comment
        
        return cell
    }

}
