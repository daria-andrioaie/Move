//
//  User.swift
//  Move
//
//  Created by Daria Andrioaie on 29.08.2022.
//

import Foundation

class User: Codable {
    var _id: String
    var username: String
    var email: String
    var password: String
    var status: String
    
    required init(_id: String, username: String, email: String, password: String, status: String) {
        self._id = _id
        self.username = username
        self.email = email
        self.password = password
        self.status = status
    }
    
//    required init(coder: NSCoder) {
//        _id = coder.decodeObject(forKey: "_id") as! String
//        username = coder.decodeObject(forKey: "username") as! String
//        email = coder.decodeObject(forKey: "email") as! String
//        password = coder.decodeObject(forKey: "password") as! String
//        status = coder.decodeObject(forKey: "status") as! String
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(_id, forKey: "_id")
//        coder.encode(username, forKey: "username")
//        coder.encode(email, forKey: "email")
//        coder.encode(password, forKey: "password")
//        coder.encode(status, forKey: "status")
//    }
}
