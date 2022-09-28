//
//  NFCUnlockView.swift
//  Move
//
//  Created by Daria Andrioaie on 26.09.2022.
//

import SwiftUI

struct NFCUnlockView: View {
    let onCancelUnlock: () -> Void
    let onUnlockSuccessful: () -> Void
    let onSwitchToPIN: () -> Void
    let onSwitchToQR: () -> Void
    
    @ObservedObject var viewModel: UnlockViewModel
    
    @State private var isUnlockInProgress: Bool = false
    
    var body: some View {
        ZStack {
            PurpleBackgroundView()
            VStack {
                UnlockHeaderView(headerTitle: "Enter serial number", showLightbulb: false, onCancelUnlock: onCancelUnlock)
                
                Text("NFC unlock")
                    .multilineTextAlignment(.center)
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .padding(.top, 55)
                Text("Hold your phone close to the NFC Tag located on top of the handlebar of your scooter.")
                    .multilineTextAlignment(.center)
                    .font(.primary(type: .body1))
                    .opacity(0.7)
                    .foregroundColor(.white)
                    .padding(.top, 16)
                    .padding(.bottom, 104)

                if isUnlockInProgress {
                    ActivityIndicator()
                        .frame(width: 50, height: 50)
                        .padding(.bottom, 155)
                }
                else {
                    Spacer()
                    Spacer()
                }
                AlternativeUnlockOptionsView(alternative1: "QR", onAlternaive1: {
                    onSwitchToQR()
                }, alternative2: "PIN") {
                    onSwitchToPIN()
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
    }
}

struct NFCUnlockView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                NFCUnlockView(onCancelUnlock: {}, onUnlockSuccessful: {}, onSwitchToPIN: {}, onSwitchToQR: {}, viewModel: UnlockViewModel())
                    .previewDevice(device)
            }
        }
    }
}
