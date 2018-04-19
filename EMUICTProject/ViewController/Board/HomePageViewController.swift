//
//  HomePageViewController.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 27/3/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    let cellId = "NewsAndEventPostCell"
    var type:String!
    var board = [PostBoard]()
    var ref = Database.database().reference(withPath:"NewAndEventPost")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.register(NewsAndEventFeedTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor(red:0.99, green:1.00, blue:0.95, alpha:1.0)
        // admin check
        let uid = Auth.auth().currentUser!.uid
        let rootRef = Database.database().reference()
        let query = rootRef.child("Alluser").child("\(uid)")
        var usertype: String!
        query.observe(.value) { (snapshot) in
            
            if let uservalue = snapshot.value as? NSDictionary{
                
                usertype = uservalue["Position"] as? String ?? "Type not found"
                
                if(usertype == "admin"){
                    //user is admin
                    self.navigationItem.title = "Board Reported"
                    self.refreshButton.isEnabled = true
                    self.getReport()
                    
                }else{
                    //user is gen user
                    self.getPost()
                    self.refreshButton.isEnabled = false
                }
            }
            
        }
      
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // deselect the selected row if any
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            tableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
    }
    
    @IBAction func refreshBut(_ sender: Any) {
        board.removeAll()
        tableView.reloadData()
        print("Refresh")
     getReport()
        
    }
    
    func getReport(){
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("BoardReport")
        
        query.observe(.value) { (snapshot) in
             self.board.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    let post = PostBoard()
                    
                    let boardid = child.key
                    let boardtype = value["BoardType"] as? String ?? "board type not found"
                    self.type = boardtype
                    
                    let query2 = Database.database().reference().child("\(boardtype)").child("\(boardid)")
                    
                    query2.observe(.value, with: {(snapshot2) in
                        
                        if let value2 = snapshot2.value as? NSDictionary {
                            
                            let postid = child.key
                            let creatorid = value2["creator"] as? String ?? "Creator not found"
                            let bTitle = value2["Title"] as? String ?? "Title not found"
                            let bContent = value2["Content"] as? String ?? "Content not found"
                            let imagePath = value2["urlToImage"] as? String ?? "Image not found"
                            
                            post.imagePost = imagePath
                            post.title = bTitle
                            post.content = bContent
                            post.creator = creatorid
                            post.postId = postid
                            post.boardType = boardtype
                            
                            self.board.append(post)
                            DispatchQueue.main.async { self.tableView.reloadData() }
                        }
                    })
                }
            }
        }    }
    
    
    func getPost(){
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("NewAndEventPost")
        
        
        query.observe(.value) { (snapshot) in
            self.board.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    let post = PostBoard()
                    
                    let postid = child.key
                    let creatorid = value["creator"] as? String ?? "Creator not found"
                    let bTitle = value["Title"] as? String ?? "Title not found"
                    let bContent = value["Content"] as? String ?? "Content not found"
                    let imagePath = value["urlToImage"] as? String ?? "Image not found"
                    
                    post.imagePost = imagePath
                    post.title = bTitle
                    post.content = bContent
                    post.creator = creatorid
                    post.postId = postid
                    
                    
                    self.board.append(post)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return board.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsAndEventFeedTableViewCell
         cell.backgroundColor = UIColor(red:0.99, green:1.00, blue:0.95, alpha:1.0)
        let post = board[indexPath.row]
        
        if let postimgUrl = post.imagePost{
            let url = URL(string: postimgUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                if error != nil{print(error.debugDescription)}
                DispatchQueue.main.async {
                    cell.textLabel?.text = post.title
                    let content = post.content!
                    if content.count > 40{
                        let indexEndOfText = content.index(content.startIndex, offsetBy: 40)
                        let subdetail = content[..<indexEndOfText]
                        let sdetail = String(subdetail) + " ...More"
                        cell.detailTextLabel?.text = sdetail
                    }
                    cell.detailTextLabel?.text = content
                    cell.postedImg.image = UIImage(data: data!)
                    
                }
            }).resume()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePageContent") as? HomePageContentViewController
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            let post = board[indexPath.row]
            
            vc.img = post.imagePost
            vc.Title = post.title
            vc.content = post.content
            vc.creator = post.creator
            vc.boardId = post.postId
            vc.type = self.type
        }
    }
}
