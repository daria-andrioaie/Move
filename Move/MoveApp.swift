//
//  MoveApp.swift
//  Move
//
//  Created by Daria Andrioaie on 08.08.2022.
//

import SwiftUI

@main
struct MoveApp: App {
    let errorHandler = SwiftMessagesErrorHandler()
    let userDefaultsService = UserDefaultsService()
    
    var body: some Scene {
        WindowGroup {
            MainCoordinatorView(errorHandler: errorHandler, userDefaultsService: userDefaultsService, authenticationAPIService: AuthenticationAPIService(userDefaultsService: self.userDefaultsService))
        }
    }
}
