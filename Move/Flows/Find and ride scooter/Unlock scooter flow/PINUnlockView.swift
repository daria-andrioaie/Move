//
//  PINUnlockView.swift
//  Move
//
//  Created by Daria Andrioaie on 17.09.2022.
//

import SwiftUI

struct PINUnlockView: View {
    let onCancelUnlock: () -> Void
    var body: some View {
        ZStack {
            PurpleBackgroundView()
            VStack {
                UnlockHeaderView(headerTitle: "Enter serial number", showLightbulb: false, onCancelUnlock: onCancelUnlock)
                
                Text("Enter the scooter's serial number")
                    .multilineTextAlignment(.center)
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .padding(.top, 55)
                Text("You can find it on the \nscooter’s front panel")
                    .multilineTextAlignment(.center)
                    .font(.primary(type: .body1))
                    .opacity(0.7)
                    .foregroundColor(.white)
                    .padding(.top, 16)

                Spacer()
                AlternativeUnlockOptionsView(alternative1: "QR", onAlternaive1: {
                    print("go to QR")
                }, alternative2: "NFC") {
                    print("go to NFC")
                }
                
                Spacer()

            }
            .frame(maxHeight: .infinity)
        }
    }
}

struct PINUnlockView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                PINUnlockView(onCancelUnlock: {})
                    .previewDevice(device)
            }
        }
    }
}
