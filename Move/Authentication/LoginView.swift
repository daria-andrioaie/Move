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
        
    }
}

struct LoginView: View {
    let onSwitch: () -> Void
    
    @StateObject var viewModel = LoginViewModel()
    
    private var formIsCompleted: Bool {
        if !viewModel.emailAddress.isEmpty && !viewModel.password.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Image("littleIcon")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 34)
                    .padding(.bottom, 20.4)

                Text("Login")
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 42)
                    .padding(.bottom, 20)

                Text("Enter your account credentials and start riding away")
                    .font(.primary(type: .heading2))
                    .foregroundColor(Color("NeutralPurple"))
                    .frame(width: 327, alignment: .leading)
                    .offset(x: -7)
                    .padding(.bottom, 24)
     
                
                SimpleUnderlinedTextField(placeholder: "Email address", binding: $viewModel.emailAddress)

                SecureUnderlinedTextField(placeholder: "Password", binding: $viewModel.password)
                
                Text("Forgot your password?")
                    .font(.primary(type: .smallText))
                    .foregroundColor(.white)
                    .underline()
                    .frame(width: 231)
                    .padding(.leading, -210)
                    .padding(.bottom, 32)
                
                Button("Login") {
                    viewModel.login()
                }
                .frame(width: 327)
                    .largeButton(isEnabled: formIsCompleted)
                    .padding(.bottom, 32)
                
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
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView {
            print("")
        }
    }
}
