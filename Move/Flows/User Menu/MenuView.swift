//
//  MenuView.swift
//  Move
//
//  Created by Daria Andrioaie on 13.09.2022.
//

import SwiftUI

enum HeaderButtonActionType {
    case slideBack
    case slideDown
}

struct HeaderView: View {
    let buttonAction: HeaderButtonActionType?
    let onButtonPressed: () -> Void
    let headerTitle: String
    
    var body: some View {
        HStack {
            if buttonAction != nil {
                Button {
                    // TODO: add slide animation when returning to map screen
                    onButtonPressed()
                } label: {
                    Image(systemName: buttonAction == .slideBack ? "chevron.left" : "chevron.down")
                        .foregroundColor(.primaryPurple)
                        .frame(width: 36, height: 36)

                }
            }
            else {
                Image(systemName: "chevron.left")
                    .frame(width: 36, height: 36)
                    .opacity(0)
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
    let onSeeHistoryButton: () -> Void
    
    @StateObject var menuViewModel: MenuViewModel = .init()
    
    var body: some View {
        ZStack {
            Image("rectangleBackground-cardView")
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                VStack(alignment: .leading, spacing: 7) {
                    Text("History")
                        .font(.primary(type: .button1))
                        .foregroundColor(.white)
                    Text("Total rides: \(menuViewModel.numberOfRides)")
                        .font(.primary(type: .body1))
                        .foregroundColor(.neutralPurple)
                }
                Spacer()
                Button {
                    onSeeHistoryButton()
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
            .padding(.vertical, 27)
        }
        .background(RoundedRectangle(cornerRadius: 29)
            .foregroundColor(.primaryPurple))
        .shadow(radius: 10)
    }
}

struct GeneralSettingsView: View {
    let onEditAccountButton: () -> Void
    let onChnagePasswordButton: () -> Void

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
                    onEditAccountButton()
                } label: {
                    Text("Account")
                        .foregroundColor(.primaryBlue)
                        .font(.primary(type: .button2))
                }
                Button {
                    onChnagePasswordButton()
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
    let onTermsAndConditionsPressed: () -> Void
    let onPrivacyPolicyPressed: () -> Void
    
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
                    onTermsAndConditionsPressed()
                } label: {
                    Text("Terms and Conditions")
                        .foregroundColor(.primaryBlue)
                        .font(.primary(type: .button2))
                }
                Button {
                    onPrivacyPolicyPressed()
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
    let onButtonPressed: () -> Void
    
    var body: some View {
        HStack {
            Image("star")
            Button {
                onButtonPressed()
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
    let onSeeHistoryButton: () -> Void
    let onEditAccountButton: () -> Void
    let onChangePasswordButton: () -> Void
    
    func goToTapptitude() -> Void {
        let urlBrowser = URL(string: "https://tapptitude.com")
        UIApplication.shared.open(urlBrowser!, options: [:], completionHandler: nil)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HeaderView(buttonAction: .slideBack, onButtonPressed: {
                onBack()
            }, headerTitle: "Hi \(username)!")
            HistoryPreview(onSeeHistoryButton: onSeeHistoryButton)
            GeneralSettingsView(onEditAccountButton: onEditAccountButton, onChnagePasswordButton: onChangePasswordButton)
            LegalLinksView(onTermsAndConditionsPressed: goToTapptitude, onPrivacyPolicyPressed: goToTapptitude)
            RateUsView(onButtonPressed: goToTapptitude)
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
    
    var username: String {
        let userDefaultsService = UserDefaultsService()
        if let username = try? userDefaultsService.getUser().username {
            return username
        }
        else {
            return "nil"
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                MenuView(onBack: {}, onSeeHistoryButton: {}, onEditAccountButton: {}, onChangePasswordButton: {})
                    .previewDevice(device)
            }
        }
    }
}
