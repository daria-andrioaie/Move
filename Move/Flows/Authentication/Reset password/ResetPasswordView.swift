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
    @Environment(\.colorScheme) var colorScheme
    
    @FocusState var newPassowrdFieldIsFocused: Bool
    @FocusState var confirmedPasswordFieldIsFocused: Bool
    
    private var formIsCompleted: Bool {
        if !viewModel.password.isEmpty && !viewModel.confirmedPassword.isEmpty {
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
                
                Text("Reset password")
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .alignLeadingWithHorizontalPadding()
                    .padding(.bottom, 20)


                SecureUnderlinedTextField(placeholder: "New password", inputValue: $viewModel.password, fieldIsFocused: _newPassowrdFieldIsFocused, colorScheme: colorScheme, returnType: .next) {
                    confirmedPasswordFieldIsFocused = true
                }
                SecureUnderlinedTextField(placeholder: "Confirm new password", inputValue: $viewModel.confirmedPassword, fieldIsFocused: _confirmedPasswordFieldIsFocused, colorScheme: colorScheme, returnType: .done) {
                    if formIsCompleted {
                        viewModel.resetPassword()
                    }
                }

                FormButton(title: "Reset password", isEnabled: formIsCompleted) {
                    viewModel.resetPassword()
                }
                
                Spacer()
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                ResetPasswordView()
                    .preferredColorScheme(.dark)
                    .previewDevice(device)
            }
        }
    }
}
