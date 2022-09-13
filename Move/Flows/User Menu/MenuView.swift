//
//  MenuView.swift
//  Move
//
//  Created by Daria Andrioaie on 13.09.2022.
//

import SwiftUI

struct HeaderView: View {
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            Button {
                // TODO: add slide animation when returning to authentication screen
                onBack()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primaryPurple)
                    .frame(width: 36, height: 36)

            }
            Spacer()
            Text("Hi conor!")
                .foregroundColor(.primaryPurple)
                .font(.primary(type: .navbarTitle))
            Spacer()
            Image("avatar")
                .foregroundColor(.primaryPurple)
        }
        .padding(.top, 24)
    }
}

struct HistoryPreview: View {
    var body: some View {
        Text("History")
    }
}

struct GeneralSettingsView: View {
    var body: some View {
        Text("General settings")
    }
}

struct LegalLinksView: View {
    var body: some View {
        Text("Legal links")
    }
}

struct RateUsView: View {
    var body: some View {
        Text("rate us")
    }
}

struct MenuView: View {
    let onBack: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(onBack: onBack)
            HistoryPreview()
            GeneralSettingsView()
            LegalLinksView()
            RateUsView()
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 24)
        .overlay(alignment: .bottomTrailing) {
            Image("scooter-menu")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(onBack: {})
    }
}
