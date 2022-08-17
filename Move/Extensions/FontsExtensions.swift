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
            case semiBold = "BaiJamjuree-SemiBold"
            case regular = "BaiJamjuree-Regular"
            case medium = "BaiJamjuree-Medium"
            case light = "BaiJamjuree-Light"
        }
        
        enum Types: CGFloat {
            case heading1
            case heading2
            case body1
            case body2
            case button1
            case button2
            case smallText
        }
    }
}

extension Font {
    static func primary(_ weight: Fonts.Primary.Weights, size: CGFloat) -> Font {
        .custom(weight.rawValue, size: size)
    }
    
    static func primary(type: Fonts.Primary.Types) -> Font {
        switch type {
        case .heading1:
            return .custom(Fonts.Primary.Weights.bold.rawValue, size: 32)
        case .heading2:
            return .custom(Fonts.Primary.Weights.medium.rawValue, size: 20)
        case .body1:
            return .custom(Fonts.Primary.Weights.medium.rawValue, size: 16)
        case .body2:
            return .custom(Fonts.Primary.Weights.light.rawValue, size: 16)
        case .button1:
            return .custom(Fonts.Primary.Weights.bold.rawValue, size: 16)
        case .button2:
            return .custom(Fonts.Primary.Weights.medium.rawValue, size: 14)
        case .smallText:
            return .custom(Fonts.Primary.Weights.regular.rawValue, size: 12)
        }
    }
}


