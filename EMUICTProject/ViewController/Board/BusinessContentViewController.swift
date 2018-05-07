//
//  BusinessContentViewController.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 29/3/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//  BusinessPost

import UIKit
import Firebase

class BusinessContentViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    let cellId = "CommentCell"
    var img : String!
    var Title: String!
    var content: String!
    var creator: String!
    var boardId: String!
    var usertype:String!
    var userStorage: StorageReference!
    var BoardcreateDate: String!
    var Productname: String!
    var comment = [NAEcomment]()
    
    @IBOutlet weak var TableView: UITableView!
    
    @IBOutlet weak var postedImg: UIImageView!
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var commentText: UITextView!
    
    @IBOutlet weak var editbut: UIButton!
    @IBOutlet weak var savebut: UIButton!
    @IBOutlet weak var ReportBut: UIButton!
    @IBOutlet weak var ReportLab: UILabel!
    
    @IBOutlet weak var DeleteBut: UIButton!
    @IBOutlet weak var sendMessBut: UIButton!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var PostDate: UILabel!
    
    @IBAction func editPressed(_ sender: Any) {
        editbut.isEnabled = true
        editbut.isHidden = true
        postContent.isEditable = true
        savebut.isHidden = false
    }
    
    @IBAction func savePressed(_ sender: Any) {
        savebut.isEnabled = true
        updateBoard()
    }
    
    
    
    
    func updateBoard(){
        let rootRef = Database.database().reference()
        let newUpdatedPost:[String : Any] = [
            "Content": postContent.text as AnyObject
        ]
        
        rootRef.child("BusinessPost").child("\(boardId!)").updateChildValues(newUpdatedPost, withCompletionBlock: { (error, ref) in
            if let error = error{
                print(error)
                //return
            }
            print("Board is updated!")
        })
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reportBut(_ sender: Any) {
        //For Gen user
        ReportBut.isEnabled = false
        ReportBut.isHidden = true
        ReportLab.isHidden = false
        
        let BoardId = boardId!
        let BoardTitle = Title!
        let Boardtype = "BusinessPost"
        let BoardCreator = creator!
        let BoardReport : [String : Any] = [
            "BoardTitle": BoardTitle as AnyObject,
            "BoardType": Boardtype as AnyObject,
            "BoardCreator": BoardCreator as AnyObject
        ]
        Database.database().reference().child("BoardReport").child("\(BoardId)").setValue(BoardReport)
        displyAlertMessage(userMessage: "Our system recieved your Report")    }
    
    @IBAction func DeleteBut(_ sender: Any) {
        let storage = Storage.storage().reference(forURL:"gs://emuictproject-8baae.appspot.com")
        let imageRef = storage.child("BusinessPost").child(boardId + ".jpg")
        
        print(boardId + ".jpg")
        imageRef.delete(completion: { error in
            if let error = error {
                print(error)
            } else {
                print("delete image from Storage")
            }
        })
 
        Database.database().reference(withPath: "BusinessPost").child(boardId).removeValue()
        print("Delete db")
        print("delete account success")
        
        
        let alert = UIAlertController(title: "Success", message:   "Delete successful", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(OKAction)
        self.present(alert, animated: true){}
    
    }
    @IBAction func commentButt(_ sender: Any) {
        let comment = commentText.text
        let commentOwner = Auth.auth().currentUser!.uid
        let BoardId = boardId!
        let postComment : [String : Any] = [
            "Commentuid": commentOwner as AnyObject,
            "Comment": comment as AnyObject
        ]
        Database.database().reference().child("BusinessPost").child("\(BoardId)").child("comment").childByAutoId().setValue(postComment)
        self.commentText.text = nil //clear comment text
    }
    
    @IBAction func SendMessageBut(_ sender: Any) {
        getbuyerAndseller()
        // send message to board creator
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Chat") as? ChatViewController
            
        {
            if let navigator = navigationController {
                navigator.show(vc, sender: true)
            }
            
            let senderid = Auth.auth().currentUser!.uid
            let recieverid = creator!
            let boardid = boardId!
            
            vc.senderid = senderid
            vc.recieverid = recieverid
            vc.boardid = boardid
           
        }
    }
    
    @IBAction func Addwatchlist(_ sender: Any) {
        
        let userid = Auth.auth().currentUser!.uid
        let boardid = boardId!
        let title = Title!
        let boardType = "BusinessPost" // change to another board tyype
        
        let addWatchlist : [String : Any] = [
            "BoardTitle": title as AnyObject,
            "BoardType" : boardType as AnyObject
        ]
        Database.database().reference().child("Watchlist").child("\(userid)").child("\(boardid)").setValue(addWatchlist)
        
        displyAlertMessage(userMessage: "Add to Wacthlist successful")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.register(commentCell.self, forCellReuseIdentifier: cellId)
        postContent.text = content
        ProductName.text = Productname
        PostDate.text = BoardcreateDate
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
    
    override func viewWillAppear(_ animated: Bool) {
        let uid = Auth.auth().currentUser?.uid
        let creatorid = creator!
        if uid == creatorid{
            
            self.sendMessBut.isEnabled = false
            self.DeleteBut.isEnabled = true
            self.ReportBut.isHidden = true
            self.ReportLab.isHidden = true
            self.editbut.isHidden = false
            self.savebut.isHidden = true
        }else
        {
            
            if(usertype == "Admin"){
                print(usertype)
                //user is admin
                self.DeleteBut.isHidden = false
                self.DeleteBut.isEnabled = true
                self.ReportBut.isHidden = true
                self.ReportLab.isHidden = true
                self.sendMessBut.isEnabled = true
                 self.editbut.isHidden = true
                self.savebut.isHidden = true
                
            }else{
                print(usertype)
                //user is gen user
                self.DeleteBut.isHidden = true
                self.ReportLab.isHidden = true
                self.sendMessBut.isEnabled = true
                 self.editbut.isHidden = true
                self.savebut.isHidden = true
            }
        }
        
      
 
        
        
    }
    // get comment and owner name
    func getcomment(){
        let boardid = boardId!
        let rootRef = Database.database().reference()
        let query = rootRef.child("BusinessPost").child("\(boardid)").child("comment")
        
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
                            let userName = userinfo["Username"] as? String ?? "Not found user name"
                            
                            pcomment.userName = userName
                            self.comment.append(pcomment)
                            DispatchQueue.main.async { self.TableView.reloadData() }
                        }
                    })
                }
            }
        }
    }
    
    func getbuyerAndseller(){
        let buyer = Auth.auth().currentUser?.uid
        let seller = creator
        print("SaleID: " + seller!)
        print("BuyID: " + buyer!)
        let sab = seller! + "_" + buyer!
   
        let postProduct: [String : Any] = [
            "Buyer" : buyer!,
            "Seller": seller!
        ]
        Database.database().reference().child("SAB").child("\(sab)").setValue(postProduct)

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
    
    func displyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert,animated: true, completion:nil)
    }
    
}
    

