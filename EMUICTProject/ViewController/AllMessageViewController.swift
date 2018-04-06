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
        reloadUserMessage()
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func reloadUserMessage(){
        messages.removeAll()
        messageDic.removeAll()
        tableView.reloadData()
        observeUserMessage()
        
    }
    
    func observeUserMessage(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded , with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            messageReference.observe(.value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let message = Message(dictionary: dictionary)
                    // group user chat
                    if let chatPartnetId = message.chatPartnerId(){
                        self.messageDic[chatPartnetId] = message
                        self.messages = Array(self.messageDic.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            if let timestamp1 = message1.timestamp, let timestamp2 = message2.timestamp {
                                return timestamp1.intValue > timestamp2.intValue
                            } else {
                                //At least one of your timestamps is nil.  You have to decide how to sort here.
                                return true
                            }

                        })
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
        
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            print("chatPartnerid is nil")
            return
        }
        let ref = Database.database().reference().child("Alluser").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else{
                return
            }
            let user = User(dictionary: dictionary)
            user.id = chatPartnerId
            self.showChatControllerUser(user)
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsAndEventFeedTableViewCell
        let messchat = messages[indexPath.row]
        
        if let id = messchat.chatPartnerId(){ // check chat partner
            let ref = Database.database().reference().child("Alluser").child(id)
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
                                self.tableView.reloadData()
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
    func showChatControllerUser(_ user: User) {
       
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Chat") as? ChatViewController
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            let senderid = Auth.auth().currentUser!.uid
            let recieverid = user.id
            
            
            vc.senderid = senderid
            vc.recieverid = recieverid
            
    }

}
}
