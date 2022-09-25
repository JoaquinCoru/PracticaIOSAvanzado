//
//  CDLocation+CoreDataClass.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 25/9/22.
//
//

import Foundation
import CoreData

@objc(CDLocation)
public class CDLocation: NSManagedObject {
    static func create(from location:HeroCoordenates, for hero:CDHero, context:NSManagedObjectContext) -> CDLocation {
        let cdLocation = CDLocation(context: context)
        cdLocation.id = location.id
        cdLocation.latitud = location.latitud
        cdLocation.longitud = location.longitud
        cdLocation.hero = hero
        return cdLocation
    }
    
    var location:HeroCoordenates {
        HeroCoordenates(id: self.id,
                        latitud: self.latitud,
                        longitud: self.longitud)
    }
}
