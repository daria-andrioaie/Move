//
//  AddLicenseView.swift
//  Move
//
//  Created by Daria Andrioaie on 11.08.2022.
//

import SwiftUI

struct AddLicenseView: View {
    
    let onFinished: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button {
                        // TODO: add slide animation when returning to authentication screen
                        onBack()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primaryPurple)
                            .padding(.horizontal, 24)
                    }
                    Spacer()
                    Text("Driving License")
                        .foregroundColor(.primaryPurple)
                        .font(.primary(type: .navbarTitle))
                    Spacer()
                    Button {} label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primaryPurple)
                            .padding(.horizontal, 24)
                    }
                    .opacity(0)
                }
                .padding()
                
                Image("driving-license-scan")
                    .resizable()
                    .scaledToFill()
                    .clipped()

                Text("Before you can start riding")
                    .font(.primary(type: .heading1))
                    .foregroundColor(Color("PrimaryBlue"))
                    .alignLeadingWithHorizontalPadding()
                
                Text("Please take a photo or upload the front side of your driving license so we can make sure that it is valid.")
                    .font(.primary(type: .body2))
                    .foregroundColor(Color("PrimaryBlue"))
                    .alignLeadingWithHorizontalPadding()
                    .padding(.top, 10)
                FormButton(title: "Add driving license", isEnabled: true, action: {
                    
                })
                .padding(.top, 31)
            }
        }
    }
}

struct AddLicenseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(devices) { device in
                AddLicenseView(onFinished: {}, onBack: {})
                    .previewDevice(device)
            }
        }
    }
}
