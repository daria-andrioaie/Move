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
    let userDefaultsManager = UserDefaultsManager()
    
    var body: some Scene {
        WindowGroup {
            MainCoordinatorView(errorHandler: errorHandler, userDefaultsManager: userDefaultsManager, authenticationAPIService: AuthenticationAPIService(userDefaultsManager: self.userDefaultsManager))
        }
    }
}
