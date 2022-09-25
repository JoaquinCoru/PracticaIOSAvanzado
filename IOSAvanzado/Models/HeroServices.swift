//
//  HeroServices.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 1/9/22.
//

import Foundation

struct Hero: Decodable{
    let photo: URL
    let id: String
    let favorite: Bool
    let name: String
    let description: String
}
