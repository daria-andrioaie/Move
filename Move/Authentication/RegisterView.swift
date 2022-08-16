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
        // fields are valid
        // send register request
    }
}

struct RegisterView: View {
    let onSwitch: () -> Void
    
    @StateObject var viewModel = RegisterViewModel()
    
    private var formIsCompleted: Bool {
        if !viewModel.emailAddress.isEmpty && !viewModel.username.isEmpty && !viewModel.password.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack() {
                Image("littleIcon")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 14)
                    .padding(.bottom, 20)

                Text("Let's get started")
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)

                Text("Sign up or login and start riding right away")
                    .font(.primary(type: .heading2))
                    .foregroundColor(.neutralPurple)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
     
                
                SimpleUnderlinedTextField(placeholder: "Email address", inputValue: $viewModel.emailAddress)
                
                SimpleUnderlinedTextField(placeholder: "Username", inputValue: $viewModel.username)

                SecureUnderlinedTextField(placeholder: "Password", inputValue: $viewModel.password)
                
                Text("By continuing you agree to Move’s  [Terms and Conditions](http://www.tapptitude.com/) and [Privacy Policy](http://www.tapptitude.com/).")
                    .font(.primary(type: .smallText))
                    .tint(.white)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                
                Button("Get started") {
                    viewModel.register()
                }
                .frame(maxWidth: .infinity)
                .largeButton(isEnabled: formIsCompleted)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
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
            .padding(.horizontal, 24)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                RegisterView {}
                    .previewDevice(device)
            }
        }
    }
}
