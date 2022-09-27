//
//  QRUnlockView.swift
//  Move
//
//  Created by Daria Andrioaie on 26.09.2022.
//

import SwiftUI

struct QRUnlockView: View {
    let onCancelUnlock: () -> Void
    let onUnlockSuccessful: () -> Void
    let onSwitchToPIN: () -> Void
    let onSwitchToNFC: () -> Void
    
//    @ObservedObject var viewModel:
//    @State private var isUnlockInProgress: Bool = false

    var body: some View {
        ZStack {
            Image("QRUnlock")
                .resizable()
                .aspectRatio(contentMode: .fill)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(Color.black.opacity(0.60))
                .ignoresSafeArea()
            VStack {
                UnlockHeaderView(headerTitle: "Unlock scooter", showLightbulb: true, onCancelUnlock: onCancelUnlock)
                
                Text("Scan QR")
                    .multilineTextAlignment(.center)
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .padding(.top, 55)
                
                Text("You can find it on the \nscooter’s front panel")
                    .multilineTextAlignment(.center)
                    .font(.primary(type: .body1))
                    .foregroundColor(.white)
                    .padding(.top, 16)
                    .padding(.bottom, 60)
                
                Color.clear
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .overlay(
                            RoundedRectangle(cornerRadius: 29)
                                .stroke(.white, lineWidth: 2)
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 72)
                    
                
                AlternativeUnlockOptionsView(alternative1: "123", onAlternaive1: {
                    onSwitchToPIN()
                }, alternative2: "NFC") {
                    onSwitchToNFC()
                }
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
    }
}

struct QRUnlockView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                QRUnlockView(onCancelUnlock: {}, onUnlockSuccessful: {}, onSwitchToPIN: {}, onSwitchToNFC: {})
                    .previewDevice(device)
            }
        }
    }
}
