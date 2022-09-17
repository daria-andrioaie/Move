//
//  AlternativeUnlockOptionsView.swift
//  Move
//
//  Created by Daria Andrioaie on 17.09.2022.
//

import SwiftUI

struct AlternativeUnlockButton: View {
    let unlockMethod: String
    let onPress: () -> Void
    var body: some View {
        Button {
            onPress()
        } label: {
            Text(unlockMethod)
                .font(.primary(type: .button1))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.white)
                    .opacity(0.2))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 1)
                }
        }

    }
}

struct AlternativeUnlockOptionsView: View {
    let alternative1: String
    let onAlternaive1: () -> Void
    let alternative2: String
    let onAlternaive2: () -> Void

    
    var body: some View {
        VStack {
            Text("Alternately you can unlock using")
                .font(.primary(type: .body1))
                .foregroundColor(.white)
                .padding(.bottom, 24)
            HStack {
                AlternativeUnlockButton(unlockMethod: alternative1, onPress: onAlternaive1)
                Text("or")
                    .padding(.horizontal, 21)
                    .font(.primary(type: .button1))
                    .foregroundColor(.white)
                AlternativeUnlockButton(unlockMethod: alternative2, onPress: onAlternaive2)
            }
        }
    }
}

struct AlternativeUnlockOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                AlternativeUnlockOptionsView(alternative1: "123", onAlternaive1: {}, alternative2: "NFC", onAlternaive2: {})
                    .previewDevice(device)
            }
        }
    }
}
