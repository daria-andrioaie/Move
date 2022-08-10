//
//  LoginView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

struct LoginView: View {
    let onSwitch: () -> Void
    
    @State private var emailAddress = ""
    @State private var password = ""
    private var formIsCompleted: Bool {
        if !emailAddress.isEmpty && !password.isEmpty {
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
                    .font(.custom("BaiJamjuree-Bold", size: 32))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 42)
                    .padding(.bottom, 20)

                Text("Enter your account credentials and start riding away")
                    .font(.custom("BaiJamjuree-Medium", size: 20))
                    .foregroundColor(Color("NeutralPurple"))
                    .frame(width: 327, alignment: .leading)
                    .offset(x: -7)
                    .padding(.bottom, 24)
     
                
                SimpleUnderlinedTextField(placeholder: "Email address", binding: $emailAddress)

                SecureUnderlinedTextField(placeholder: "Password", binding: $password)
                
                Text("Forgot your password?")
                    .font(.custom("BaiJamjuree-Regular", size: 12))
                    .foregroundColor(.white)
                    .underline()
                    .frame(width: 231)
                    .padding(.leading, -210)
                    .padding(.bottom, 32)
                
                Button("Login") { }
                    .largeButton(isEnabled: formIsCompleted)
                    .padding(.bottom, 32)
                
                HStack {
                    Text("Don't have an account? You can ")
                        .foregroundColor(.white)
                        .font(.custom("BaiJamjuree-Regular", size: 12))
                    Button {
                        onSwitch()
                    } label: {
                        Text("start with one here")
                            .foregroundColor(.white)
                            .font(.custom("BaiJamjuree-Bold", size: 12))
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
