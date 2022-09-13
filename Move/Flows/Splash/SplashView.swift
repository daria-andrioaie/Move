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
//            Image("xiaomi-cut")
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//                .padding(.vertical, 200)

            GeometryReader { geo in
                Image("xiaomi-cut")
                    .frame(maxWidth: geo.size.width, alignment: .leading)
                    .frame(maxHeight: geo.size.height, alignment: .center)
                    .padding(.vertical, 50)
            }
            .frame(height: UIScreen.main.bounds.height)
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
        Group {
            ForEach(devices) { device in
                SplashView {}
                    .previewDevice(device)
            }
        }
    }
}
