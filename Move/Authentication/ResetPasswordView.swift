//
//  ResetPasswordView.swift
//  Move
//
//  Created by Daria Andrioaie on 11.08.2022.
//

import SwiftUI

class ResetPasswordViewModel: ObservableObject {
    @Published var password = ""
    @Published var confirmedPassword = ""
    
    func resetPassword() {
        guard password == confirmedPassword else {
            return
        }
    }
}


struct ResetPasswordView: View {
    @StateObject var viewModel = ResetPasswordViewModel()
    
    private var formIsCompleted: Bool {
        if !viewModel.password.isEmpty && !viewModel.confirmedPassword.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Image("chevron-left")
                    .alignLeadingWithHorizontalPadding()
                    .padding(.bottom, 10)
                
                Text("Reset password")
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .alignLeadingWithHorizontalPadding()
                    .padding(.bottom, 20)


                SecureUnderlinedTextField(placeholder: "New password", inputValue: $viewModel.password)
                SecureUnderlinedTextField(placeholder: "Confirm new password", inputValue: $viewModel.confirmedPassword)

                FormButton(title: "Reset password", isEnabled: formIsCompleted) {
                    viewModel.resetPassword()
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                ResetPasswordView()
                    .previewDevice(device)
            }
        }
    }
}
