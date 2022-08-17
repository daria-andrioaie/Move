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
            PurpleBackgroundView()
            VStack {
                Image("chevron-left")
                    .alignLeadingWithHorizontalPadding()
                    .padding(.top, 45)
                    .padding(.bottom, 10)


                Text("Forgot password")
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .alignLeadingWithHorizontalPadding()
                    .padding(.bottom, 20)

                Text("Enter the email address you’re using for your account bellow and we’ll send you a password reset link.")
                    .font(.primary(type: .body1))
                    .foregroundColor(.neutralPurple)
                    .alignLeadingWithHorizontalPadding()
                    .padding(.bottom, 32)
     
                
                SimpleUnderlinedTextField(placeholder: "Email address", inputValue: $viewModel.emailAddress)
                
                FormButton(title: "Send reset link", isEnabled: formIsCompleted) {
                    viewModel.sendResetLink()
                }
                
                Spacer()
            }
//            .padding(.horizontal, 24)
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
