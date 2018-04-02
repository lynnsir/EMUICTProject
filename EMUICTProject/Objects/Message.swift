//
//  chatuser.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 2/4/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    //var chatmessageId: String?
    var fromid: String?
    var timestamp: NSNumber?
    var textmessage: String?
    var toid: String?
    
    init(dictionary: [String: Any]) {
        self.fromid = dictionary["fromid"] as? String
        self.textmessage = dictionary["textmessage"] as? String
        self.toid = dictionary["toid"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
    
    func chatPartnerId() -> String? {
        return fromid == Auth.auth().currentUser?.uid ? toid : fromid
    }
    
}
