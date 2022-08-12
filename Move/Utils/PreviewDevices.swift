//
//  PreviewDevices.swift
//  Move
//
//  Created by Daria Andrioaie on 12.08.2022.
//

import Foundation
import SwiftUI

extension PreviewDevice: Identifiable {
   public var id: String {self.rawValue}
}

extension PreviewProvider {
    static var iphone8: PreviewDevice {
        PreviewDevice(rawValue: "iPhone 8")
    }
    static var iphone13: PreviewDevice {
        PreviewDevice(rawValue: "iPhone 13")
    }
    
    static var devices: [PreviewDevice] {
        [iphone13, iphone8]
    }
}
