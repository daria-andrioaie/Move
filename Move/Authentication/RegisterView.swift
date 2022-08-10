//
//  RegisterView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

struct RegisterView: View {
    let onSwitch: () -> Void
    
    @State private var emailAddress = ""
    @State private var username = ""
    @State private var password = ""
    private var formIsCompleted: Bool {
        if !emailAddress.isEmpty && !username.isEmpty && !password.isEmpty {
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

                Text("Let's get started")
//                    .font(.custom("BaiJamjuree-Bold", size: 32))
                    .font(.primary(.bold, size: 32))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 42)
                    .padding(.bottom, 20)

                Text("Sign up or login and start riding right away")
                    .font(.custom("BaiJamjuree-Medium", size: 20))
                    .foregroundColor(Color("NeutralPurple"))
                    .frame(width: 283, alignment: .leading)
                    .offset(x: -27)
                    .padding(.bottom, 24)
     
                
                SimpleUnderlinedTextField(placeholder: "Email address", binding: $emailAddress)
                
                SimpleUnderlinedTextField(placeholder: "Username", binding: $username)

                SecureUnderlinedTextField(placeholder: "Password", binding: $password)
                
                Text("By continuing you agree to Move’s  [Terms and Conditions](http://www.tapptitude.com/) and [Privacy Policy](http://www.tapptitude.com/).")
                    .font(.custom("BaiJamjuree-Regular", size: 12))
                    .tint(.white)
                    .foregroundColor(.white)
                    .frame(width: 231)
                    .padding(.leading, -110)
                    .padding(.bottom, 32)
                
                Button("Get started") { }
                    .largeButton(isEnabled: formIsCompleted)
                    .padding(.bottom, 32)
                
                HStack {
                    Text("You already have an account? You can ")
                        .foregroundColor(.white)
                        .font(.custom("BaiJamjuree-Regular", size: 12))
                    Button {
                        onSwitch()
                    } label: {
                        Text("log in here")
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView {
            print("")
        }
    }
}
