//
//  HeroServices.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 1/9/22.
//

import Foundation

struct HeroService: Decodable{
    let id: String
    let name: String
    let description: String
    let photo: URL
    let favorite: Bool
    var latitud: Double?
    var longitude: Double?
}
