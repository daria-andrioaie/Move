//
//  LoginResponse.swift
//  Move
//
//  Created by Daria Andrioaie on 29.08.2022.
//

import Foundation

class LoginResponse: Decodable {
    let user: User
    let token: String
}
