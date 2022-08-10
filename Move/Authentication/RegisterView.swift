//
//  RegisterView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

struct RegisterView: View {
    @State private var emailAddress = ""
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Image("littleIcon")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 34)

                Text("Let's get started")
                    .font(.custom("BaiJamjuree-Bold", size: 32))
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
                
                Text("By continuing you agree to Move’s  Terms and Conditions and Privacy Policy")
                    .font(.custom("BaiJamjuree-Regular", size: 12))
                    .foregroundColor(.white)
                    .frame(width: 231)
                    .padding(.leading, -110)
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
