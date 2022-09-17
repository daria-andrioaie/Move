//
//  UnlockHeaderView.swift
//  Move
//
//  Created by Daria Andrioaie on 17.09.2022.
//

import SwiftUI

struct UnlockHeaderView: View {
    let headerTitle: String
    let showLightbulb: Bool
    let onCancelUnlock: () -> Void
    
    
    var body: some View {
        HStack {
            Button {
                onCancelUnlock()
            } label: {
                Image("close")
            }
            Spacer()
            Text(headerTitle)
                .foregroundColor(.white)
                .font(.primary(type: .navbarTitle))
            Spacer()
            Button {
                print("open lantern")
            } label: {
                Image("lightbulb")
                    .opacity(showLightbulb ? 1 : 0)
            }
            .disabled(!showLightbulb)
        }
        .padding(.horizontal, 24)
        .padding(.top, 34)
    }
}

struct UnlockHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        UnlockHeaderView(headerTitle: "Unlock Scooter", showLightbulb: false, onCancelUnlock: {})
    }
}
