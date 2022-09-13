//
//  OnboardingViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 01.09.2022.
//

import Foundation

struct OnboardingData {
    let imagePath: String
    let headline: String
    let description: String
    let orderNumber: Int
}

enum OnboardingState: Equatable, CaseIterable {
    static func == (lhs: OnboardingState, rhs: OnboardingState) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    case safety
    case scan
    case ride
    case parking
    case rules
    
    var identifier: String {
        switch self {
        case .safety: return "safety"
        case .scan: return "scan"
        case .ride: return "ride"
        case .parking: return "parking"
        case .rules: return "rules"
        }
    }
}

class OnboardingViewModel: ObservableObject {

    let totalNumberOfStates = 5
    
    @Published var state: OnboardingState? = .safety
    
    func getViewData(state: OnboardingState) -> OnboardingData {
        switch state {
        case .safety:
            return OnboardingData(imagePath: "safety", headline: "Safety", description: "Please wear a helmet and protect yourself while riding.", orderNumber: 0)
        case .scan:
            return OnboardingData(imagePath: "scan", headline: "Scan", description: "Scan the QR code or NFC sticker on top of the scooter to unlock and ride.", orderNumber: 1)
        case .ride:
            return OnboardingData(imagePath: "ride", headline: "Ride", description: "Step on the scooter with one foot and kick off the ground. When the scooter starts to coast, push the right throttle to accelerate.", orderNumber: 2)
        case .parking:
            return OnboardingData(imagePath: "parking", headline: "Parking", description: "If convenient, park at a bike rack. If not, park close to the edge of the sidewalk closest to the street. Do not block sidewalks, doors or ramps.", orderNumber: 3)
        case .rules:
            return OnboardingData(imagePath: "rules", headline: "Rules", description: "You must be 18 years or and older with a valid driving licence to operate a scooter. Please follow all street signs, signals and markings, and obey local traffic laws.", orderNumber: 4)
        }
    }
    
    func getNextState(after state: OnboardingState) -> OnboardingState? {
        switch state {
        case .safety:
            return .scan
        case .scan:
            return .ride
        case .ride:
            return .parking
        case .parking:
            return .rules
        case .rules:
            return nil
        }
    }
}

