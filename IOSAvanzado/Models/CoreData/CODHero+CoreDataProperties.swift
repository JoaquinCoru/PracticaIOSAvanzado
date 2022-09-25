//
//  CODHero+CoreDataProperties.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 24/9/22.
//
//

import Foundation
import CoreData


extension CODHero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CODHero> {
        return NSFetchRequest<CODHero>(entityName: "CODHero")
    }

    @NSManaged public var favorite: Bool
    @NSManaged public var heroDescription: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var photoUrl: URL?

}

extension CODHero : Identifiable {

}
