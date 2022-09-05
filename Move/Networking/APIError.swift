//
//  APIError.swift
//  Move
//
//  Created by Daria Andrioaie on 05.09.2022.
//

import Foundation

struct APIError: Error, Decodable {
    let message: String
    var code: Int?
}
