//
//  MenuView.swift
//  Move
//
//  Created by Daria Andrioaie on 13.09.2022.
//

import SwiftUI

struct HeaderView: View {
    let onBack: () -> Void
    let headerTitle: String
    
    var body: some View {
        HStack {
            Button {
                // TODO: add slide animation when returning to map screen
                onBack()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primaryPurple)
                    .frame(width: 36, height: 36)

            }
            Spacer()
            Text(headerTitle)
                .foregroundColor(.primaryPurple)
                .font(.primary(type: .navbarTitle))
            Spacer()
            Image(systemName: "chevron.left")
                .frame(width: 36, height: 36)
                .opacity(0)
//            Image("avatar-male")
//                .foregroundColor(.primaryPurple)
//                .cornerRadius(10)
//                .padding(.trailing, 2)
        }
        .padding(.top, 20)
    }
}

struct HistoryPreview: View {
    var body: some View {
        ZStack {
            Image("ScooterViewRectangleBackground")
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            HStack {
                VStack(alignment: .leading, spacing: 7) {
                    Text("History")
                        .font(.primary(type: .button1))
                        .foregroundColor(.white)
                    Text("Total rides: 12")
                        .font(.primary(type: .body1))
                        .foregroundColor(.neutralPurple)
                }
                Spacer()
                Button {
                    print("see all rides")
                } label: {
                    HStack {
                        Text("See all")
                        Image("chevron-right")
                    }
                    .padding(.horizontal, 18)
                    .activeButton()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
//            .padding(.vertical, 15)
        }
        .padding(.vertical, 4)
        .background(RoundedRectangle(cornerRadius: 29)
            .foregroundColor(.primaryPurple))
    }
}

struct GeneralSettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Image("settings")
                Text("General Settings")
                    .foregroundColor(.primaryBlue)
                    .font(.primary(type: .button1))
            }
            VStack(alignment: .leading, spacing: 30) {
                Button {
                    print("go to account")
                } label: {
                    Text("Account")
                        .foregroundColor(.primaryBlue)
                        .font(.primary(type: .button2))
                }
                Button {
                    print("change password")
                } label: {
                    Text("Change password")
                        .foregroundColor(.primaryBlue)
                        .font(.primary(type: .button2))
                }
            }
            .padding(.leading, 30)
        }
    }
}

struct LegalLinksView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Image("legal-flag")
                Text("Legal")
                    .foregroundColor(.primaryBlue)
                    .font(.primary(type: .button1))
            }
            VStack(alignment: .leading, spacing: 30) {
                Button {
                    print("go to tapptitude")
                } label: {
                    Text("Terms and Conditions")
                        .foregroundColor(.primaryBlue)
                        .font(.primary(type: .button2))
                }
                Button {
                    print("go to tapptitude")
                } label: {
                    Text("Privacy Policy")
                        .foregroundColor(.primaryBlue)
                        .font(.primary(type: .button2))
                }
            }
            .padding(.leading, 30)
        }
    }
}

struct RateUsView: View {
    var body: some View {
        HStack {
            Image("star")
            Button {
                    print("rate Move")
            } label: {
                Text("Rate us")
                    .foregroundColor(.primaryBlue)
                    .font(.primary(type: .button1))
            }
        }
    }
}

struct MenuView: View {
    let onBack: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HeaderView(onBack: onBack, headerTitle: "Hi conor!")
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
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: UIScreen.main.bounds.height * 4/7)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                MenuView(onBack: {})
                    .previewDevice(device)
            }
        }
    }
}
