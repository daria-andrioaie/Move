//
//  FontsExtensions.swift
//  Move
//
//  Created by Daria Andrioaie on 10.08.2022.
//

import Foundation
import SwiftUI

struct Fonts {
    struct Primary {
        
        enum Weights: String {
            case bold = "BaiJamjuree-Bold"
            case regular = "BaiJamjuree-Regular"
            case medium = "BaiJamjuree-Medium"
        }
    }
}

extension Font {
    static func primary(_ weight: Fonts.Primary.Weights, size: CGFloat) -> Font {
        .custom(weight.rawValue, size: size)
    }
}


