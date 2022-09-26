//
//  RoundedCornerPath.swift
//  Move
//
//  Created by Daria Andrioaie on 26.09.2022.
//

import Foundation
import SwiftUI
import UIKit

struct RoundedCornerPath: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let bezierPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(bezierPath.cgPath)
    }
}

extension View {
    func roundedCorners(radius: CGFloat = 5, corners: UIRectCorner = .allCorners) -> some View {
        self.clipShape(RoundedCornerPath(radius: radius, corners: corners))
    }
}
