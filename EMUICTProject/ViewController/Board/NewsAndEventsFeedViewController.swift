//
//  NewsAndEventsFeedViewController.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 3/3/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//
import UIKit
import Firebase

class NewsAndEventsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet var InsertNAEpost: UIBarButtonItem!
    
    let cellId = "NewsAndEventPostCell"

    var board = [PostBoard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.register(NewsAndEventFeedTableViewCell.self, forCellReuseIdentifier: cellId)
        getPost()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let uid = Auth.auth().currentUser!.uid
        let rootRef = Database.database().reference()
        let query = rootRef.child("Alluser").child("\(uid)")
        var usertype: String!
        query.observe(.value) { (snapshot) in
            
            if let uservalue = snapshot.value as? NSDictionary{
                
                usertype = uservalue["Position"] as? String ?? "Type not found"
                
                if(usertype == "admin"){
                    //user is admin
                    self.InsertNAEpost.isEnabled = true
                    
                }else{
                    //user is gen user
                    self.InsertNAEpost.isEnabled = false
              
                }
                
            }
            
        }
        
    }

    
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
        let post = board[indexPath.row]
        
        if let postimgUrl = post.imagePost{
            let url = URL(string: postimgUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                if error != nil{print(error.debugDescription)}
                DispatchQueue.main.async {
                    cell.textLabel?.text = post.title
                    cell.detailTextLabel?.text = post.content
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
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NAEcontent") as? NewsAndEventContentTableViewCell

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
               
        }
    }
}
