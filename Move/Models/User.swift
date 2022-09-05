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
    var driverLicenseKey: String? = nil
    
    required init(_id: String, username: String, email: String, password: String, status: String) {
        self._id = _id
        self.username = username
        self.email = email
        self.password = password
        self.status = status
    }
}
