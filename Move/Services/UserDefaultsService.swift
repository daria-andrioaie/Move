//
//  UserDefaultsService.swift
//  Move
//
//  Created by Daria Andrioaie on 01.09.2022.
//

import Foundation

enum UserDefaultsServiceError: Error {
    case cannotFindKey
}


enum CodingError: Error {
    case cannotEncodeUser
    case cannotDecodeUser
}

class UserDefaultsService {
    static let sharedInstance = UserDefaultsService()
    
    private let currentUserKey = "currentUser"
    private let currentUserTokenKey = "currentUserToken"
    private let isAppAlreadyLaunchedOnceKey = "isAppAlreadyLaunchedOnce"
    
    func saveUser(_ user: User) throws {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: currentUserKey)
        }
        else {
            throw CodingError.cannotEncodeUser
        }
    }
    
    func getUser() throws -> User {
        if let userData = UserDefaults.standard.value(forKey: currentUserKey) as? Data {
            if let decodedUser = try? JSONDecoder().decode(User.self, from: userData) {
                return decodedUser
            }
            else {
                throw CodingError.cannotDecodeUser
            }
        }
        else {
            throw UserDefaultsServiceError.cannotFindKey
        }
    }
    
    func saveUserToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: currentUserTokenKey)
    }
    
    func getUserToken() throws -> String {
        if let token = UserDefaults.standard.value(forKey: currentUserTokenKey) as? String {
            return token
        }
        else {
            throw UserDefaultsServiceError.cannotFindKey
        }
    }
    
    func isAppOnFirstLaunch() -> Bool {
        if UserDefaults.standard.bool(forKey: isAppAlreadyLaunchedOnceKey) {
            return false
        }
        return true
    }
    
    func setAppAlreadyLanchedOnce() {
        UserDefaults.standard.set(true, forKey: isAppAlreadyLaunchedOnceKey)

    }
}
