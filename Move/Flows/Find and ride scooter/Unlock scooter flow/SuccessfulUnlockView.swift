//
//  SuccessfulUnlockView.swift
//  Move
//
//  Created by Daria Andrioaie on 17.09.2022.
//

import SwiftUI

struct SuccessfulUnlockView: View {
    let onUnlockFinished: () -> Void
    var body: some View {
        ZStack {
            PurpleBackgroundView()
            VStack {
                Text("Unlock")
                    .foregroundColor(.white)
                    .font(.primary(type: .heading1))
                    .padding(.top, 133)
                    
                Text("sucessful")
                    .foregroundColor(.white)
                    .font(.primary(type: .heading1))
                    .padding(.bottom, 97)
                
                Image("check-circle")
                    .padding(.bottom, 36)
                Text("Please respect all the driving regulations and other participants in traffic while using our scooters.")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.primary(type: .body1))
                    .opacity(0.7)
                    .padding(.horizontal, 24)

                Spacer()
            }
            .frame(maxHeight: .infinity)
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                onUnlockFinished()
            })
        }
    }
}

struct SuccessfulUnlockView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                SuccessfulUnlockView(onUnlockFinished: {})
                    .previewDevice(device)
            }
        }
        
    }
}
