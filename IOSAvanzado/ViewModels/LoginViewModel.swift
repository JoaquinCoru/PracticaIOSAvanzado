//
//  LoginViewModel.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 13/9/22.
//

import Foundation


final class LoginViewModel {
    
    //MARK: Variables
    private var network: NetworkModel
    private var keyChain: KeyChainHelper
    private let service = "DragonBall"
    private let account = "Joaquin"
    
    init(network: NetworkModel = NetworkModel(), keyChain: KeyChainHelper = KeyChainHelper.standar) {
        self.network = network
        self.keyChain = keyChain
    }
    
    //MARK: call service

    func callLoginService(user: String, password: String, completion: ((String?, Error?) -> Void)? = nil) {
        network.login(
            user: user,
            password: password,
            completion: completion
        )
    }

    func saveToken(token: String) {
        let data = Data(token.utf8)
        keyChain.save( item: data, service: service, account: account)
    }
    
    func readToken()->String{
     
        let data = keyChain.read(service: service, account: account)
        
        guard let data = data else{
            return ""
        }
        
        let token = String(decoding: data, as: UTF8.self)
        
        return token
    }
    
    func callHeroService(){
        let data = keyChain.read(service: service, account: account)
        let token = String(decoding: data ?? Data(), as: UTF8.self)

        self.network.getHeroes { heroes, _ in

            var heroesWithCoordinate: [HeroService] = heroes
            
            for (inde, hero) in heroesWithCoordinate.enumerated() {
                self.network.getLocalizacionHeroe(id:hero.id, completion: { coordenates, error in
                    if error != nil {
                        return
                    }
                    
                    if coordenates.isEmpty {
//                        self.goToSaveHero(inde: inde, heroesWithCoordinate: heroesWithCoordinate)
                        return
                    }
                    
                    let lastCoordenate = coordenates.last
                    
                    heroesWithCoordinate[inde].latitud = Double(lastCoordenate?.latitud ?? "0.0") ?? 0.0
                    heroesWithCoordinate[inde].longitude = Double(lastCoordenate?.longitud ?? "0.0") ?? 0.0
                    
//                    self.goToSaveHero(inde: inde, heroesWithCoordinate: heroesWithCoordinate)
                })
            }
        }
    }
}


