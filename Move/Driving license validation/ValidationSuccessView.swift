//
//  ValidationSuccessView.swift
//  Move
//
//  Created by Daria Andrioaie on 18.08.2022.
//

import SwiftUI

struct ValidationSuccessView: View {
    var body: some View {
        ZStack {
            PurpleBackgroundView()
            VStack {
                Spacer()
                Image("check-circle")
                Text("We've succesfully validated your \ndriving license")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .font(.primary(type: .heading1))
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Spacer()
                FormButton(title: "Find scooters", isEnabled: true, action: {})
                    .padding(.bottom, 12)
            }
            
        }
    }
}

struct ValidationSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                ValidationSuccessView()
                    .previewDevice(device)
            }
        }
    }
}
