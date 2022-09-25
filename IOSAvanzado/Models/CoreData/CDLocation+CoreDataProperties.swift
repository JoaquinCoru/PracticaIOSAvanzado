//
//  CDLocation+CoreDataProperties.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 25/9/22.
//
//

import Foundation
import CoreData


extension CDLocation {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CDLocation> {
        return NSFetchRequest<CDLocation>(entityName: "CDLocation")
    }

    @NSManaged public var id: String
    @NSManaged public var latitud: String
    @NSManaged public var longitud: String
    @NSManaged public var hero: CDHero

}

extension CDLocation : Identifiable {

}
