//
//  RegisterView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

struct RegisterView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            Text("Register")
                .font(.custom("BaiJamjuree-Bold", size: 20))
                .foregroundColor(.white)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
