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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .padding(.leading, 42)
                    .padding(.bottom, 10)

                Text("Reset password")
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 42)
                    .padding(.bottom, 45)


                SecureUnderlinedTextField(placeholder: "New password", binding: $viewModel.password)
                SecureUnderlinedTextField(placeholder: "Confirm new password", binding: $viewModel.confirmedPassword)

                Button("Reset password") {
                    viewModel.resetPassword()
                }
                    .frame(width: 327)
                    .largeButton(isEnabled: formIsCompleted)
                
                Spacer()
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
