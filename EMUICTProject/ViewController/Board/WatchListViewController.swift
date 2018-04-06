//
//  WatchListViewController.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 5/3/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class WatchListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "NewsAndEventPostCell"
    var board = [PostBoard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewsAndEventFeedTableViewCell.self, forCellReuseIdentifier: cellId)
        getPost()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func clearButton(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        let rootRef = Database.database().reference()
        rootRef.child("Watchlist").child("\(uid!)").removeValue()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func getPost(){
        
        let uid = Auth.auth().currentUser!.uid
        let rootRef = Database.database().reference()
        let query = rootRef.child("Watchlist").child("\(uid)")
        
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    
                    let post = PostBoard()
                    
                    let boardid = child.key
                    let boardtype = value["BoardType"] as? String ?? "board type not found"
                    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Watchlistcontent") as? WatchListContentViewController
            
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
            vc.boardType = post.boardType
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }


}
