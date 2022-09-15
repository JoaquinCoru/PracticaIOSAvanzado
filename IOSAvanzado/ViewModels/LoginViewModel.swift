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
    }
}


