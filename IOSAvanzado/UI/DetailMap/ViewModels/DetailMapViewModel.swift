//
//  DetailMapViewModel.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 25/9/22.
//

import Foundation
import MapKit

final class DetailMapViewModel {
    
    //MARK: Constants
    private let dataManager = CoreDataManager()
    private let locationManager = CLLocationManager()
    
    //MARK: Variable
    var annotationsForMap: [MKPointAnnotation] = []
    var locations: [CDLocation] = []
    
    func getAnnotations(heroe:Hero){
        annotationsForMap = []
        
        locations = CoreDataManager.shared.fetchLocations(for: heroe.id)
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = heroe.name
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: Double(location.latitud) ?? 0.0,
                longitude: Double(location.longitud) ?? 0.0
            )
            annotationsForMap.append(annotation)
        }
        
        NotificationCenter.default.post(name: Notification.Name("loadMap"), object: nil)
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // Show popUp to notify user
        }
    }

    private func checkLocationAuthorization() {
   
        switch locationManager.authorizationStatus {
            
        case .authorizedAlways:
            break
        default:
            locationManager.requestAlwaysAuthorization()
            break
        }
    }
    
}
