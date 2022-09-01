//
//  LoginView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI


struct LoginView: View {
    let onSwitch: () -> Void
    let onForgotPassword: () -> Void
    let onFinished: () -> Void
    
    @StateObject var viewModel = LoginViewModel()
    
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            viewModel.login {
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
                LoginView(onSwitch: {}, onForgotPassword: {}, onFinished: {})
                    .previewDevice(device)
            }
        }
    }
}
