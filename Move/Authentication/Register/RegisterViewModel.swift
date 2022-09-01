//
//  RegisterViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 01.09.2022.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var username = ""
    @Published var password = ""
    @Published var requestInProgress = false
    
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
    
    func register(onRegisterCompleted: @escaping () -> Void) {
        guard isValid(emailAddress: emailAddress) && isValid(username: username) && isValid(password: password) else {
            //TODO: handle this case
            return
        }
        AuthenticationAPIService.registerUser(username: username, email: emailAddress, password: password, onRegisterCompleted: onRegisterCompleted)
    }
}
