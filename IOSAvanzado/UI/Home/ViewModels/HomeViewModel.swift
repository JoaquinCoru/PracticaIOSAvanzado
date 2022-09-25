//
//  HomeViewModel.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 18/9/22.
//

import Foundation
import KeychainSwift

final class HomeViewModel{
    private var networkModel: NetworkModel
    private var keychain: KeychainSwift
    
    private(set) var content: [Hero] = []
    
    var onSuccess: (() -> Void)?
    var onError: ((String, NetworkError?) -> Void)?
    
    init(networkModel: NetworkModel = NetworkModel(),
         keychain: KeychainSwift = KeychainSwift(),
         onSuccess: (() -> Void)? = nil,
         onError: ((String, NetworkError?) -> Void)? = nil) {
        self.networkModel = networkModel
        self.keychain = keychain
        self.onSuccess = onSuccess
        self.onError = onError
    }
    
    func viewDidLoad() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadHeroes()
            self?.keychain.delete("KCToken")
        }
    }
    
    
    func loadHeroes() {
        let cdHeroes = CoreDataManager.shared.fetchHeroes()
        
        guard let date = LocalDataModel.getSyncDate(),
              date.addingTimeInterval(84960) > Date(),
              !cdHeroes.isEmpty
        else {
            print("Do network call")
            guard let token = keychain.get("KCToken") else { return }
            networkModel.token = token
            networkModel.getHeroes { [weak self] heroes, error in
                if let error {
                    self?.onError?("There was an error", error)
                } else {
                    self?.content = heroes
                    self?.save(heroes: heroes)
                    
                    let group = DispatchGroup()
                    
                    heroes.forEach { hero in
                        group.enter()
                        self?.downloadLocations(for: hero) {
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: DispatchQueue.global()) {
                        LocalDataModel.saveSyncDate(date: Date())
                        let cdHeroes = CoreDataManager.shared.fetchHeroes()
                        self?.content = cdHeroes.map { $0.hero }
                        self?.onSuccess?()
                    
                    }
                }
            }
            return
        }
        
        print("Heroes from CD")
        content = cdHeroes.map { $0.hero }
        
        
        for cdHero in cdHeroes{
            let locations = CoreDataManager.shared.fetchLocations(for: cdHero.id)
            if (!locations.isEmpty){
                print("Localizaciones \(cdHero.name) : \(locations.count)")
            }

        }
        onSuccess?()
    }
    
    func downloadLocations(for hero:Hero, completion: @escaping ()->Void){
        let cdLocations = CoreDataManager.shared.fetchLocations(for: hero.id)
        
        if cdLocations.isEmpty {
            print("Do locations network call")
            guard let token = keychain.get("KCToken") else { return }
            
            networkModel.token = token
            networkModel.getLocations(heroId: hero.id) { [weak self] locations, error in
                if let error {
                    self?.onError?("There was an error", error)
                } else {
                    
                    self?.save(locations:locations, for: hero)
                }
                completion()
            }
        }else{
            completion()
        }
        
        
    }
    
    func save(heroes: [Hero]) {
        let _ = heroes.map { CDHero.create(from: $0, context: CoreDataManager.shared.context) }
        CoreDataManager.shared.saveContext()
    }
    
    func save(locations:[HeroCoordenates], for hero:Hero){
        guard let cdHero = CoreDataManager.shared.fetchHero(id: hero.id) else {
            print("no hero")
            return
        }
        
        _ = locations.map{
            CDLocation.create(from: $0, for: cdHero, context: CoreDataManager.shared.context)}
            
            CoreDataManager.shared.saveContext()
    }
    
    
}
