//
//  MenuCoordinatorView.swift
//  Move
//
//  Created by Daria Andrioaie on 15.09.2022.
//

import SwiftUI

enum MenuState {
    case menuOverview
    case historyOfRidesOverview
    case editAccount
    case changePassword
}

struct MenuCoordinatorView: View {
    let onBack: () -> Void
    let onLogout: () -> Void
    @State private var menuState: MenuState? = .menuOverview
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: MenuView(onBack: onBack, onSeeHistoryButton: {
                    menuState = .historyOfRidesOverview
                }, onEditAccountButton: {
                    menuState = .editAccount
                }, onChangePasswordButton: {
                    menuState = .changePassword
                })
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true), tag: .menuOverview, selection: $menuState) {
                    EmptyView()
                }
                NavigationLink(destination: HistoryOfRidesView(rides: [], onBack: {
                    menuState = .menuOverview
                })
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true), tag: .historyOfRidesOverview, selection: $menuState) {
                    EmptyView()
                }
                NavigationLink(destination: EditAccountView(onBack: {
                    menuState = .menuOverview
                }, onLogout: onLogout)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true), tag: .editAccount, selection: $menuState) {
                    EmptyView()
                }
                NavigationLink(destination: ChangePasswordView(onBack: {
                    menuState = .menuOverview
                })
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true), tag: .changePassword, selection: $menuState) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MenuCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                MenuCoordinatorView(onBack: {}, onLogout: {})
                    .previewDevice(device)
            }
        }
    }
}
