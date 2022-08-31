//
//  RegisterView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var emailAddress = ""
    @Published var username = ""
    @Published var password = ""
    @Published var requestInProgress = false
    
    func validate(emailAddress: String) -> Bool {
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
    
    func validate(username: String) -> Bool {
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
    
    func validate(password: String) -> Bool {
        if password == "" {
            return false
        }
        if password.count < 5 {
            return false
        }
        return true

    }
    
    func register(onRegisterCompleted: @escaping () -> Void) {
        guard validate(emailAddress: emailAddress) && validate(username: username) && validate(password: password) else {
            return
        }
        APIService.registerUser(username: username, email: emailAddress, password: password, onRegisterCompleted: onRegisterCompleted)
    }
}

struct RegisterView: View {
    let onSwitch: () -> Void
    let onFinished: () -> Void
    
    @StateObject var viewModel = RegisterViewModel()
    
    private var formIsCompleted: Bool {
        if !viewModel.emailAddress.isEmpty && !viewModel.username.isEmpty && !viewModel.password.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            PurpleBackgroundView()
            ScrollView {
                VStack() {
                    AuthenticationHeaderView(title: "Let's get started", caption: "Sign up or login and start riding right away")

                    SimpleUnderlinedTextField(placeholder: "Email address", inputValue: $viewModel.emailAddress)

                    SimpleUnderlinedTextField(placeholder: "Username", inputValue: $viewModel.username)

                    SecureUnderlinedTextField(placeholder: "Password", inputValue: $viewModel.password)

                    Text("By continuing you agree to Move’s \n[Terms and Conditions](http://www.tapptitude.com/) and [Privacy Policy](http://www.tapptitude.com/).")
                        .font(.primary(type: .smallText))
                        .tint(.white)
                        .foregroundColor(.white)
                        .alignLeadingWithHorizontalPadding()
                        .padding(.bottom, 32)

                    switch viewModel.requestInProgress {
                    case false:
                        FormButton(title: "Get started", isEnabled: formIsCompleted) {
                            viewModel.requestInProgress = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                viewModel.register {
                                    onFinished()
                                }
                            })
                        }
                    case true:
                        LoadingDisabledButton()
                    }
                    
                    
                    HStack {
                        Text("You already have an account? You can ")
                            .foregroundColor(.white)
                            .font(.primary(type: .smallText))
                        Button {
                            onSwitch()
                        } label: {
                            Text("log in here")
                                .foregroundColor(.white)
                                .font(.primary(type: .smallText))
                                .bold()
                                .underline()
                                .offset(x: -7)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                }
    //            .padding(.horizontal, 24)
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                RegisterView {} onFinished: {}
                    .previewDevice(device)
            }
        }
    }
}
