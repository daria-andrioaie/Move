//
//  DateExtensions.swift
//  Move
//
//  Created by Daria Andrioaie on 04.10.2022.
//

import Foundation

extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
