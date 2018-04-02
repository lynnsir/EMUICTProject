//
//  AllMessageViewController.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 2/4/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class AllMessageViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
   
    @IBOutlet weak var tableView: UITableView!
    let cellId = "NewsAndEventPostCell"
    
    var board = [PostBoard]()
    var messages = [Message]()
    var messageDic = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewsAndEventFeedTableViewCell.self, forCellReuseIdentifier: cellId)
        observeMessages()
        tableView.dataSource = self
        tableView.delegate = self
    }
    func observeMessages(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                 let message = Message(dictionary: dictionary)
                //self.messages.append(message)
                
                if let toId = message.toid{
                    self.messageDic[toId] = message
                    self.messages = Array(self.messageDic.values)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsAndEventFeedTableViewCell
        let messchat = messages[indexPath.row]
        
        if let toid = messchat.toid{
            let ref = Database.database().reference().child("Alluser").child(toid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                   
                    if let profileImageUrl = dictionary["urlToImage"] as? String{
                        let url = URL(string: profileImageUrl)
                        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                            if error != nil{print(error.debugDescription)}
                            DispatchQueue.main.async {
                                 cell.textLabel?.text = dictionary["Username"] as? String
                                 cell.postedImg.image = UIImage(data: data!)
                                 cell.detailTextLabel?.text = messchat.textmessage
                            }
                        }).resume()                    }
                }
            }, withCancel: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
