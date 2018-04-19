//
//  JobAndInternshipFeedViewController.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 29/3/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class JobAndInternshipFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!

    let cellId = "NewsAndEventPostCell"
    
    var board = [PostBoard]()
    var filteredData = [PostBoard]()
    var searchActive : Bool = false
    var type:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getType()
        tableView.register(NewsAndEventFeedTableViewCell.self, forCellReuseIdentifier: cellId)
        getPost()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func getPost(){
        
        let rootRef = Database.database().reference()
        let query = rootRef.child("JobAndInternshipPost")
        
        
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
        if searchActive{
            return filteredData.count
        }
        return board.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsAndEventFeedTableViewCell
         cell.backgroundColor = UIColor(red:0.99, green:1.00, blue:0.95, alpha:1.0)
        var post = PostBoard()
        if searchActive {
            post = filteredData[indexPath.row]
        }else{
            post = board[indexPath.row]
        }
        
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
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JAIcontent") as? JobAndInternshipContentViewController
            
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
            vc.userType = type
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else{
            filteredData = board
            tableView.reloadData()
            return
        }
        
        filteredData = board.filter({ (PostBoard) -> Bool in
            PostBoard.title.lowercased().contains(searchText.lowercased())
            
        })
        filteredData = board.filter({ (PostBoard) -> Bool in
            PostBoard.content.lowercased().contains(searchText.lowercased())
            
        })
        
        if(filteredData.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
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
