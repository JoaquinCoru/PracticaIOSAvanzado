//
//  HeroServices.swift
//  AppleMaps
//
//  Created by Salvador Martínez Landrian on 1/9/22.
//

import Foundation

struct HeroService: Decodable {
    let photo: URL
    let id: String
    let favorite: Bool
    let name: String
    let description: String
    var latitud: Double?
    var longitude: Double?
}
