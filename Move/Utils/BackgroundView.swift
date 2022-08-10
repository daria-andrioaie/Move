//
//  BackgroundView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Color("PrimaryPurple")
            VStack {
                RoundedRectangle(cornerRadius: 94)
                    .frame(width: 327, height: 327)
                    .opacity(0.05)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(-20.86), anchor: .topTrailing)
                    .offset(x: 100, y: -105)
                RoundedRectangle(cornerRadius: 165)
                    .frame(width: 423, height: 423)
                    .opacity(0.05)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(6), anchor: .topLeading)
                    .offset(x: -110, y: 50)
            }
        }
        .ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
