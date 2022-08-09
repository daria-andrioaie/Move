//
//  RegisterView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

struct RegisterView: View {
    @State private var emailAddress = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Image("littleIcon")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)

                Text("Let's get started")
                    .font(.custom("BaiJamjuree-Bold", size: 32))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 38)
                    .padding(.bottom, 20)

                Text("Sign up or login and start riding right away")
                    .font(.custom("BaiJamjuree-Medium", size: 20))
                    .foregroundColor(Color("NeutralPurple"))
                    .frame(width: 283, alignment: .leading)
                    .offset(x: -30)
                
                TextField("Email address", text: $emailAddress)
                    .foregroundColor(.white)
                    .padding(.leading, 50)
                
                Text(emailAddress)
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
