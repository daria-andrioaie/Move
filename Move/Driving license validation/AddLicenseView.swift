//
//  AddLicenseView.swift
//  Move
//
//  Created by Daria Andrioaie on 11.08.2022.
//

import SwiftUI

struct AddLicenseView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Image("driving-license-scan")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("Before you can start riding")
                    .font(.primary(type: .heading1))
                    .foregroundColor(Color("PrimaryBlue"))
                    .frame(width: 307)
                    .padding(.horizontal, 24)
                Text("Please take a photo or upload the front side of your driving license so we can make sure that it is valid.")
                    .font(.primary(type: .body2))
                    .foregroundColor(Color("PrimaryBlue"))
                    .frame(width: 327)
                    .padding(.horizontal, 24)
                Button(action: {
                    
                }) {
                    Text("Add driving license")
                }
                .frame(width: 327)
                .largeActiveButton()
                .padding(.horizontal, 24)
        
            }
        }
        .navigationTitle("Driving License")
    }
}

struct AddLicenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddLicenseView()
    }
}
