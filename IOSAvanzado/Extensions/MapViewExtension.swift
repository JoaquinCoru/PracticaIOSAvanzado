//
//  MapViewExtension.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 25/9/22.
//

import Foundation
import MapKit

extension MKMapView {
    func centerToLocation(location: CLLocation, regionRadius: CLLocationDistance = 1000000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )

        self.setRegion(coordinateRegion, animated: true)
    }
}
