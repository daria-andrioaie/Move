//
//  ScooterMapView.swift
//  Move
//
//  Created by Daria Andrioaie on 07.09.2022.
//

import SwiftUI
import MapKit

struct ScooterMapView: UIViewRepresentable {
    let viewModel: ScooterMapViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        return viewModel.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {

    }
}
