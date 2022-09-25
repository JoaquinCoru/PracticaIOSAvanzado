//
//  CDHero+CoreDataClass.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 24/9/22.
//
//

import Foundation
import CoreData

@objc(CDHero)
public class CDHero: NSManagedObject {

}

extension CDHero {
    static func create(from hero: Hero, context: NSManagedObjectContext) -> CDHero {
        let cdHero = CDHero(context: context)
        cdHero.id = hero.id
        cdHero.name = hero.name
        cdHero.favorite = hero.favorite
        cdHero.heroDescription = hero.description
        cdHero.photoUrl = hero.photo
        
        return cdHero
    }
    
    var hero: Hero {
        Hero(photo: self.photoUrl ?? URL(string: "http://www.example.com")!,
             id: self.id,
             favorite: self.favorite,
             name: self.name,
             description: self.heroDescription ?? "")
    }
}
