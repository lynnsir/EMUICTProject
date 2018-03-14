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
    
    
    var board = [PostBoard]()
    var ref = Database.database().reference(withPath:"NewAndEventPost")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPost()
        tableView.dataSource = self
        tableView.delegate = self
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

                            if let value = child.value as? NSDictionary {
                                
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
                    }) 
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
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "NewsAndEventPostCell")
        let post = board[indexPath.row]
        
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.content
        
        
        //        if let postimgUrl = post.imagePost{
        //            let url = URL(string: postimgUrl)
        //            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
        //                if error != nil{print(error.debugDescription)}
        //                DispatchQueue.main.async {
        //                    cell.imageView?.image = UIImage(data: data!)
        //                }
        //            }).resume()
        //        }
        
        getImage(url: post.imagePost) { photo in
            if photo != nil {
                DispatchQueue.main.async {
                    cell.imageView?.image = photo
                }
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NAEcontent") as? WatchListContentViewController
            
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
    
    func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error == nil {
                completion(UIImage(data: data!))
            } else {
                completion(nil)
            }
            }.resume()
    }


}
