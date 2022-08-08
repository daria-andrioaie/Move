//
//  SplashView.swift
//  Move
//
//  Created by Daria Andrioaie on 08.08.2022.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color("PrimaryPurple")
            Image("rectangleIcon")
            Image("eScooter")
                .offset(x: -192)
            Image("moveText")
        }
        .ignoresSafeArea()
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
