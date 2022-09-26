//
//  Annotation.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 26/9/22.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
  let coordinate: CLLocationCoordinate2D
  let name: String
  let heroDescription: String
  let image: URL
  
    init(hero:Hero, coordenate:HeroCoordenates) {
        coordinate = CLLocationCoordinate2D(latitude: Double(coordenate.latitud) ?? 0.0, longitude: Double(coordenate.longitud) ?? 0.0)
        name = hero.name
        heroDescription = hero.description
        image = hero.photo
  }
}
