//
//  LoginView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var password = ""
    
    func login() {
        APIService.loginUser(email: emailAddress, password: password)
    }
}

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

                FormButton(title: "Login", isEnabled: formIsCompleted) {
                    viewModel.login()
                    onFinished()
                }
                
                HStack {
                    Text("Don't have an account? You can ")
                        .foregroundColor(.white)
                        .font(.primary(type: .smallText))
                    Button {
                        onSwitch()
                    } label: {
                        Text("start with one here")
                            .foregroundColor(.white)
                            .font(.primary(type: .smallText))
                            .bold()
                            .underline()
                            .offset(x: -7)
                    }
                }
                Spacer()
            }
//            .padding(.horizontal, 24)
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
