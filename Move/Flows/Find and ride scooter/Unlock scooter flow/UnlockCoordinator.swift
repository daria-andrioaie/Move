//
//  UnlockCoordinator.swift
//  Move
//
//  Created by Daria Andrioaie on 26.09.2022.
//

import SwiftUI

enum UnlockMethod {
    case PINUnlock
    case QRUnlock
    case NFCUnlock
    case finishedUnlock
}

struct UnlockCoordinator: View {
    @State var state: UnlockMethod?
    
    let onCancelUnlock: () -> Void
    let onUnlockFinished: () -> Void
    
    @StateObject var viewModel = UnlockViewModel()
    
    init(initialUnlock: UnlockMethod, onCancelUnlock: @escaping () -> Void, onUnlockFinished: @escaping () -> Void) {
        self.state = initialUnlock
        self.onCancelUnlock = onCancelUnlock
        self.onUnlockFinished = onUnlockFinished
    }
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: PINUnlockView(onCancelUnlock: onCancelUnlock, onUnlockSuccessful: {
                    state = .finishedUnlock
                }, onSwitchToNFC: {
                    state = .NFCUnlock
                }, onSwitchToQR: {
                    state = .QRUnlock
                }, viewModel: viewModel)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true), tag: .PINUnlock, selection: $state) {
                    EmptyView()
                }
                
                NavigationLink(destination: QRUnlockView(onCancelUnlock: onCancelUnlock, onUnlockSuccessful: {
                    state = .finishedUnlock
                }, onSwitchToPIN: {
                    state = .PINUnlock
                }, onSwitchToNFC: {
                    state = .NFCUnlock
                }, viewModel: viewModel)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true), tag: .QRUnlock, selection: $state) {
                    EmptyView()
                }
                
                NavigationLink(destination: NFCUnlockView(onCancelUnlock: onCancelUnlock, onUnlockSuccessful: {
                    state = .finishedUnlock
                }, onSwitchToPIN: {
                    state = .PINUnlock
                }, onSwitchToQR: {
                    state = .QRUnlock
                }, viewModel: viewModel)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true), tag: .NFCUnlock, selection: $state) {
                    EmptyView()
                }
                
                NavigationLink(destination: SuccessfulUnlockView(onUnlockFinished: onUnlockFinished)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true), tag: .finishedUnlock, selection: $state) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct UnlockCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        UnlockCoordinator(initialUnlock: .PINUnlock, onCancelUnlock: {}, onUnlockFinished: {})
    }
}
