//
//  RegisterViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 01.09.2022.
//

import Foundation

class RegisterViewModel: ObservableObject {
    let userDefaultsManager: UserDefaultsManager

    @Published var emailAddress = ""
    @Published var username = ""
    @Published var password = ""
    
    @Published var requestInProgress = false
    
    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func isValid(emailAddress: String) -> Bool {
        if emailAddress == "" {
            return false
        }
        
        if emailAddress.count < 8 {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: emailAddress)
    }
    
    func isValid(username: String) -> Bool {
        if username == "" {
            return false
        }
        if username.count < 5 {
            return false
        }
        
        // the username must only contain word characters: letters, digits or underscores
        let usernameRegEx = "\\w{5,18}"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        return usernamePredicate.evaluate(with: username)
    }
    
    func isValid(password: String) -> Bool {
        if password == "" {
            return false
        }
        if password.count < 5 {
            return false
        }
        return true
    }
    
    func register(onInvalidField: (String) -> Void, onAPIError: @escaping (APIError) -> Void, onRegisterCompleted: @escaping () -> Void) {
        guard isValid(emailAddress: emailAddress) else {
            onInvalidField("email address")
            return
        }
        
        guard isValid(username: username) else {
            onInvalidField("username")
            return
        }
        
        guard isValid(password: password) else {
            onInvalidField("password")
            return
        }
        
        let registerParameters = ["username": username, "email": emailAddress, "password": password]
        
        AuthenticationAPIService.authenticationRequest(type: .register, parameters: registerParameters, onRequestCompleted: { result in
            switch result {
            case .success(let registerResponse):
                try? self.userDefaultsManager.saveUser(registerResponse.user)
                self.userDefaultsManager.saveUserToken(registerResponse.token)
                onRegisterCompleted()
            case .failure(let apiError):
                onAPIError(apiError)
            }
        })
    }
}
