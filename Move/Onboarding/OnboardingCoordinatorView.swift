//
//  OnboardingCoordinatorView.swift
//  Move
//
//  Created by Daria Andrioaie on 09.08.2022.
//

import SwiftUI


struct OnboardingCoordinatorView: View {
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
                OnboardingCoordinatorView(onFinished: {})
                    .previewDevice(device)
            }
        }
    }
}
