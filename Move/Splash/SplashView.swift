//
//  SplashView.swift
//  Move
//
//  Created by Daria Andrioaie on 08.08.2022.
//

import SwiftUI

struct SplashView: View {
    let afterAppear: () -> Void
    
    var body: some View {
        ZStack {
            Color.primaryPurple
            Image("rectangleIcon")
            Image("eScooter")
                .offset(x: -192)
            Image("moveText")
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                afterAppear()
            }
        }
        .ignoresSafeArea()
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView {}
    }
}
