//
//  User.swift
//  EMUICTProject
//
//  Created by Teeraphon Issaranuluk on 3/4/2561 BE.
//  Copyright © 2561 Sirinda. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["uid"] as? String
        self.name = dictionary["Username"] as? String
        self.email = dictionary["Email"] as? String
        self.profileImageUrl = dictionary["urlToImage"] as? String
    }
}
