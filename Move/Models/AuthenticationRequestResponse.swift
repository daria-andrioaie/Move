//
//  LoginResponse.swift
//  Move
//
//  Created by Daria Andrioaie on 29.08.2022.
//

import Foundation

class AuthenticationRequestResponse: Decodable {
    let user: User
    let token: String
}
