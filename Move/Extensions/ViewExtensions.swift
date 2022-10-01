//
//  ViewExtensions.swift
//  Move
//
//  Created by Daria Andrioaie on 01.10.2022.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
