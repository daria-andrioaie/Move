//
//  IntExtensions.swift
//  Move
//
//  Created by Daria Andrioaie on 29.09.2022.
//

import Foundation

extension Int {
    func convertToHoursAndMinutesFormat() -> String {
        let hour: String
        if (self / 3600) / 10 == 0 {
            hour = "0\((self / 3600))"
        }
        else {
            hour = "\((self / 3600))"
        }
        
        let minute: String
        if ((self % 3600) / 60) / 10 == 0 {
            minute = "0\((self % 3600) / 60)"
        }
        else {
            minute = "\((self % 3600) / 60)"
        }
        
        return "\(hour):\(minute)"
    }
    
    func convertToHoursMinutesSecondsFormat() -> String {
        let hour: String
        if (self / 3600) / 10 == 0 {
            hour = "0\((self / 3600))"
        }
        else {
            hour = "\((self / 3600))"
        }
        
        let minute: String
        if ((self % 3600) / 60) / 10 == 0 {
            minute = "0\((self % 3600) / 60)"
        }
        else {
            minute = "\((self % 3600) / 60)"
        }
        
        let second: String
        if((self % 3600) % 60) / 10 == 0 {
            second = "0\((self % 3600) % 60)"
        }
        else {
            second = "\((self % 3600) % 60)"
        }
        
        return "\(hour):\(minute):\(second)"
    }
    
    func convertToKilometersFormat() -> String {
        let kilometers = Double(self) / 1000.0
        return String(format: "%.1f", kilometers)
    }
}
