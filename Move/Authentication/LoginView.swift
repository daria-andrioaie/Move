//
//  LoginView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

struct LoginView: View {
    let onSwitch: () -> Void
    
    var body: some View {
        ZStack {
            BackgroundView()
            Text("Login")
                .font(.custom("BaiJamjuree-Bold", size: 20))
                .foregroundColor(.white)
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
