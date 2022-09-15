//
//  LogoutResponse.swift
//  Move
//
//  Created by Daria Andrioaie on 15.09.2022.
//

import Foundation

class LogoutResponse: Decodable {
    let userId: String
    let token: String
}
