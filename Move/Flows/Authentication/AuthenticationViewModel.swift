//
//  AuthenticationViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 01.09.2022.
//

import Foundation

protocol AuthenticationViewModelProtocol: ObservableObject {
//    @Published var requestInProgress: Bool
    func sendRequest()
}
