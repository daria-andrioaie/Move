//
//  User.swift
//  Move
//
//  Created by Daria Andrioaie on 29.08.2022.
//

import Foundation


//TODO: change model classes with structs
class User: Codable {
    var _id: String
    var username: String
    var email: String
    var status: String
    var driverLicenseKey: String? = nil
    var numberRides: Int? = nil
    
    required init(_id: String, username: String, email: String, status: String) {
        self._id = _id
        self.username = username
        self.email = email
        self.status = status
    }
}
