//
//  ValidationInProgressView.swift
//  Move
//
//  Created by Daria Andrioaie on 18.08.2022.
//

import SwiftUI


struct ValidationInProgressView: View {
    @State private var isAnimating = true
    
    var body: some View {
        ZStack {
            PurpleBackgroundView()
            VStack(alignment: .center) {
                Text("We are currently verifying your driving license")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                ActivityIndicator()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
//                Blinking(isAnimating: $isAnimating, count: 8, size: 16)
//                    .frame(width: 50, height: 50)
//                    .foregroundColor(.white)
            }
        }
    }
}

struct ValidationInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                ValidationInProgressView()
                    .previewDevice(device)
            }
        }
    }
}
