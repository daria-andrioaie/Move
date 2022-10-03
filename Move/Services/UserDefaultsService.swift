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
    case cannotEncodeRide
    case cannotDecodeRide
}

class UserDefaultsService {
    static let sharedInstance = UserDefaultsService()
    
    private let currentUserKey = "currentUser"
    private let currentRideKey = "currentRide"
    private let currentUserTokenKey = "currentUserToken"
    private let isAppAlreadyLaunchedOnceKey = "isAppAlreadyLaunchedOnce"
    
    //TODO: make a generic method for saving, getting and removing an object
    
    //TODO: only keep the id of the user, and not the whole user entity, because its data may change in the meantime
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
    
    func removeCurrentUser() {
        UserDefaults.standard.removeObject(forKey: currentUserKey)
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
    
    func removeCurrentUserToken() {
        UserDefaults.standard.removeObject(forKey: currentUserTokenKey)
    }
    
    func saveRide(_ ride: Ride) throws {
        if let rideData = try? JSONEncoder().encode(ride) {
            UserDefaults.standard.set(rideData, forKey: currentRideKey)
        }
        else {
            throw CodingError.cannotEncodeRide
        }
    }
    
    func getRide() throws -> Ride {
        if let rideData = UserDefaults.standard.value(forKey: currentRideKey) as? Data {
            if let decodedRide = try? JSONDecoder().decode(Ride.self, from: rideData) {
                return decodedRide
            }
            else {
                throw CodingError.cannotDecodeRide
            }
        }
        else {
            throw UserDefaultsServiceError.cannotFindKey
        }
    }
    
    func removeCurrentRide() {
        UserDefaults.standard.removeObject(forKey: currentRideKey)
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
