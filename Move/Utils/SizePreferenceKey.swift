//
//  SizePreferenceKey.swift
//  Move
//
//  Created by Daria Andrioaie on 30.09.2022.
//

import Foundation
import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
