//
//  LoginViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 01.09.2022.
//

import Foundation

class LoginViewModel: ObservableObject {
//    let userDefaultsService: UserDefaultsService
    let authenticationAPIService: AuthenticationAPIService
    
    @Published var emailAddress = ""
    @Published var password = ""
    @Published var requestInProgress = false
    
    init(authenticationAPIService: AuthenticationAPIService) {
        self.authenticationAPIService = authenticationAPIService
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
    
    func isValid(password: String) -> Bool {
        if password == "" {
            return false
        }
        if password.count < 5 {
            return false
        }
        return true
    }
    
    func login(onInvalidField: (String) -> Void, onAPIError: @escaping (APIError) -> Void, onLoginCompleted: @escaping () -> Void) {
        guard isValid(emailAddress: emailAddress) else {
            onInvalidField("email address")
            return
        }
        
        let loginParameters = ["email": emailAddress, "password": password]
        
        self.authenticationAPIService.authenticationRequest(type: .login, parameters: loginParameters, onRequestCompleted: { result in
                switch result {
                case .success(_):
                    onLoginCompleted()
                case .failure(let apiError):
                    onAPIError(apiError)
                }
        })
    }
}
