//
//  ForgotPasswordView.swift
//  Move
//
//  Created by Daria Andrioaie on 11.08.2022.
//

import SwiftUI

class ForgotPasswordViewModel: ObservableObject {
    @Published var emailAddress = ""
    
    func sendResetLink() {
        
    }
}

struct ForgotPasswordView: View {
    @StateObject var viewModel = ForgotPasswordViewModel()
    
    private var formIsCompleted: Bool {
        if !viewModel.emailAddress.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Image("chevron-left")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .padding(.leading, 40)
                    .padding(.bottom, 10)


                Text("Forgot password")
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 42)
                    .padding(.bottom, 20)

                Text("Enter the email address you’re using for your account bellow and we’ll send you a password reset link.")
                    .font(.primary(type: .body1))
                    .foregroundColor(.neutralPurple)
                    .frame(width: 327, alignment: .leading)
                    .offset(x: -7)
                    .padding(.bottom, 32)
     
                
                SimpleUnderlinedTextField(placeholder: "Email address", binding: $viewModel.emailAddress)
                
                Button("Send Reset Link") {
                    viewModel.sendResetLink()
                }
                    .frame(width: 327)
                    .largeButton(isEnabled: formIsCompleted)
                    .padding(.bottom, 32)
                
                Spacer()
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                ForgotPasswordView()
                    .previewDevice(device)
            }
        }
    }
}
