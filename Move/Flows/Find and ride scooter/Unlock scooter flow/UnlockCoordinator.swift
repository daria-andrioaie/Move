//
//  UnlockCoordinator.swift
//  Move
//
//  Created by Daria Andrioaie on 26.09.2022.
//

import SwiftUI

enum UnlockCoordinatorState {
    case PINUnlock
    case QRUnlock
    case NFCUnlock
    case finishedUnlock
}

struct UnlockCoordinator: View {
    @Binding var state: UnlockCoordinatorState?
    
    let onCancelUnlock: () -> Void
    let onUnlockFinished: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: PINUnlockView(onCancelUnlock: onCancelUnlock, onUnlockSuccessful: {
                    state = .finishedUnlock
                }, onSwitchToNFC: {
                    state = .NFCUnlock
                }, onSwitchToQR: {
                    state = .QRUnlock
                })
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
                })
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
                })
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
    }
}

struct UnlockCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        UnlockCoordinator(state: .constant(.PINUnlock), onCancelUnlock: {}, onUnlockFinished: {})
    }
}
