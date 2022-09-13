//
//  LoginView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI
import SwiftMessages


extension LoginView {
    struct ServiceDependencies {
        let userDefaultsService: UserDefaultsService
        let errorHandler: SwiftMessagesErrorHandler
    }
    
    struct Actions {
        let onSwitch: () -> Void
        let onForgotPassword: () -> Void
        let onFinished: () -> Void
    }
}

struct LoginView: View {
//    let userDefaultsService: UserDefaultsService
    let authenticationAPIService: AuthenticationAPIService
    let errorHandler: SwiftMessagesErrorHandler
    let onSwitch: () -> Void
    let onForgotPassword: () -> Void
    let onFinished: () -> Void
    
    @StateObject var viewModel: LoginViewModel
    
    init(authenticationAPIService: AuthenticationAPIService, errorHandler: SwiftMessagesErrorHandler, onSwitch: @escaping () -> Void, onForgotPassword: @escaping () -> Void, onFinished: @escaping () -> Void) {
        self.authenticationAPIService = authenticationAPIService
        self.errorHandler = errorHandler
        self.onSwitch = onSwitch
        self.onForgotPassword = onForgotPassword
        self.onFinished = onFinished
        self._viewModel = StateObject(wrappedValue: LoginViewModel(authenticationAPIService: authenticationAPIService))
    }
    
    private var formIsCompleted: Bool {
        if !viewModel.emailAddress.isEmpty && !viewModel.password.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            PurpleBackgroundView()
            VStack {
                AuthenticationHeaderView(title: "Login", caption: "Enter your account credentials and start riding away")
                
                SimpleUnderlinedTextField(placeholder: "Email address", inputValue: $viewModel.emailAddress)

                SecureUnderlinedTextField(placeholder: "Password", inputValue: $viewModel.password)
                
                Button {
                    onForgotPassword()
                } label: {
                    Text("Forgot your password?")
                        .font(.primary(type: .smallText))
                        .foregroundColor(.white)
                        .underline()
                        .alignLeadingWithHorizontalPadding()
                        .padding(.bottom, 32)
                }
                
                //TODO: duplicate block ( also present in RegisterView), break it into a separatecomponent and make an AuthenticationViewModelProtocol to pass as a variable

                switch viewModel.requestInProgress {
                case false:
                    FormButton(title: "Login", isEnabled: formIsCompleted) {
                        viewModel.requestInProgress = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            viewModel.login { fieldName in
                                viewModel.requestInProgress = false
                                errorHandler.handle(message: "The \(fieldName) you entered is invalid", type: .warning)
//                                showInvalidFieldWarning(fieldName: fieldName)
                            } onAPIError: { error in
                                viewModel.requestInProgress = false
                                errorHandler.handle(message: error.message, type: .error)
//                                showAPIError(message: error.message)
                            } onLoginCompleted: {
                                onFinished()
                            }
                        })
                    }
                case true:
                    LoadingDisabledButton()
                }
                
                SwitchAuthenticationMethodLink(questionText: "Don't have an account? You can ", linkText: "start with one here", onSwitch: onSwitch)
                
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                LoginView(authenticationAPIService: AuthenticationAPIService(userDefaultsService: UserDefaultsService()), errorHandler: SwiftMessagesErrorHandler(), onSwitch: {}, onForgotPassword: {}, onFinished: {})
                    .previewDevice(device)
            }
        }
    }
}
