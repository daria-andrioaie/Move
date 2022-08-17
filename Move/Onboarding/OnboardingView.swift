//
//  OnboardingCoordinatorView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI

struct SingleOnboardingView: View {
    let viewData: OnboardingStateData
    let totalNumberOfStates: Int
    let onNext: () -> Void
    let onSkip: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                Image(viewData.imagePath)
                    .resizable()
                    .scaledToFill()
//                    .frame(height: geometry.size.height * 8/10)
                    .frame(height: UIScreen.main.bounds.height * 5.5/10)
                    .clipped()
                HStack {
                    Text(viewData.headline)
                        .font(.primary(type: .heading1))
                        .foregroundColor(.primaryBlue)
                    Spacer()
                    Button("Skip") {
                        onSkip()
                    }
                    .font(.primary(.semiBold, size: 14))
                    .foregroundColor(.neutralPurple)
                }
                .padding(.horizontal, 24)
                
                Text(viewData.description)
                    .font(.primary(type: .body2))
                    .foregroundColor(.primaryBlue)
                    .padding(.top, 12)
                    .alignLeadingWithHorizontalPadding()
                    
                Spacer()
                HStack {
                    ForEach(0..<totalNumberOfStates, id: \.self) { index in
                        if index == viewData.orderNumber {
                            Capsule()
                                .frame(width: 16, height: 4)
                                .foregroundColor(.primaryBlue)
                                .padding(2)
                        }
                        else {
                            Capsule()
                                .frame(width: 4, height: 4)
                                .foregroundColor(.neutralPurple)
                                .padding(2)
                        }
                    }
                    Spacer()
                    Button(action: {
                        onNext()
                    }) {
                        HStack {
                            Text(viewData.orderNumber != totalNumberOfStates - 1 ? "Next" : "Get started")
                            Image(systemName: "arrow.right")
                        }
                        .padding(.horizontal, 16)
                        .largeActiveButton()
                    }
                }
                .padding(.horizontal, 24)
                Spacer()
            }
            .ignoresSafeArea()
            .background(.white)
        }
    }
}

struct OnboardingStateData {
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
    
    func getViewData(state: OnboardingState) -> OnboardingStateData {
        switch state {
        case .safety:
            return OnboardingStateData(imagePath: "safety", headline: "Safety", description: "Please wear a helmet and protect yourself while riding.", orderNumber: 0)
        case .scan:
            return OnboardingStateData(imagePath: "scan", headline: "Scan", description: "Scan the QR code or NFC sticker on top of the scooter to unlock and ride.", orderNumber: 1)
        case .ride:
            return OnboardingStateData(imagePath: "ride", headline: "Ride", description: "Step on the scooter with one foot and kick off the ground. When the scooter starts to coast, push the right throttle to accelerate.", orderNumber: 2)
        case .parking:
            return OnboardingStateData(imagePath: "parking", headline: "Parking", description: "If convenient, park at a bike rack. If not, park close to the edge of the sidewalk closest to the street. Do not block sidewalks, doors or ramps.", orderNumber: 3)
        case .rules:
            return OnboardingStateData(imagePath: "rules", headline: "Rules", description: "You must be 18 years or and older with a valid driving licence to operate a scooter. Please follow all street signs, signals and markings, and obey local traffic laws.", orderNumber: 4)
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

struct OnboardingView: View {
    @StateObject var viewModel = OnboardingViewModel()
    let onFinished: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(OnboardingState.allCases, id: \.self) { state in
                    NavigationLink(destination: SingleOnboardingView(viewData: viewModel.getViewData(state: state), totalNumberOfStates: viewModel.totalNumberOfStates, onNext: {
                        guard let nextState = viewModel.getNextState(after: state) else {
                            onFinished()
                            return
                        }
                        viewModel.state = nextState
                        
                    }, onSkip: {
                        onFinished()
                    })
                        .transition(.opacity.animation(.default))
                        .navigationBarBackButtonHidden(true), tag: state, selection: $viewModel.state) {
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct OnboardingCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                OnboardingView(onFinished: {})
                    .previewDevice(device)
            }
        }
    }
}
