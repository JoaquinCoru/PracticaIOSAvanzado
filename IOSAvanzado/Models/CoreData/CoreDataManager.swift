//
//  CoreDataManager.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 1/9/22.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IOSAvanzado")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        context.saveContext()
    }

    
    func fetchHeroes() -> [CDHero] {
        let fetchRequest = CDHero.createFetchRequest()
        
        let sort = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedStandardCompare))
        fetchRequest.sortDescriptors = [sort]
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("El error obteniendo Heroes \(error)")
        }
        return []
    }
    
    func fetchHero(id: String) -> CDHero? {
        let fetchRequest = CDHero.createFetchRequest()
        let predicate = NSPredicate(format: "id == '\(id)'")
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 1
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            print("El error obteniendo Heroes \(error)")
        }
        
        return nil
    }
    
    func fetchLocations(for heroId:String) -> [CDLocation] {
        let fetchRequest = CDLocation.createFetchRequest()
        let predicate = NSPredicate(format: "hero.id == %@", heroId)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("El error obteniendo Locations \(error)")
        }
        return []
    }
    
    func deleteAll() {
        let cdHeros = fetchHeroes()
        cdHeros.forEach { context.delete($0)}
        saveContext()
    }
}

extension NSManagedObjectContext {
    func saveContext() {
        guard hasChanges else { return }
        do {
            try save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
