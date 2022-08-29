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
    
    func validate(emailAddress: String) -> Bool {
        return true
    }
    
    func validate(username: String) -> Bool {
        return true
    }
    
    func validate(password: String) -> Bool {
        return true
    }
    
    func register() {
        guard validate(emailAddress: emailAddress) && validate(username: username) && validate(password: password) else {
            return
        }
        APIService.registerUser(name: username, email: emailAddress, password: password)
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

                    FormButton(title: "Get started", isEnabled: formIsCompleted) {
                        viewModel.register()
                        onFinished()
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
