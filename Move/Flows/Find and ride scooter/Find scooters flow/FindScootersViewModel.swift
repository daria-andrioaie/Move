//
//  FindScootersViewModel.swift
//  Move
//
//  Created by Daria Andrioaie on 13.09.2022.
//

import Foundation

class FindScootersViewModel: ObservableObject{
    @Published var selectedScooterAnnotation: ScooterAnnotation?
    var mapViewModel: ScooterMapViewModel = .init()
    
    init() {
        mapViewModel.onSelectedScooter = { scooter in
            withAnimation {
                self.selectedScooterAnnotation = scooter
            }
        }
        mapViewModel.onDeselectedScooter = {
            withAnimation {
                self.selectedScooterAnnotation = nil
            }
        }
    }
    
    func centerMapOnUserLocation() {
        mapViewModel.centerMapOnUserLocation()
    }
    
    func loadScooters() {
        mapViewModel.getAllScooters()
    }
}
