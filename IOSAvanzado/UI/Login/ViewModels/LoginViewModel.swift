//
//  LoginViewModel.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 13/9/22.
//

import Foundation
import KeychainSwift

final class LoginViewModel {
    
    
    private var networkModel: NetworkModel
    private var keychain: KeychainSwift
    
    var onLogin: (() -> Void)?
    var onError: ((String, NetworkError?) -> Void)?
    
    //MARK: Variables

    private let dataManager = CoreDataManager()
    
    init(networkModel: NetworkModel = NetworkModel(),
         keychain: KeychainSwift = KeychainSwift(),
         onLogin: (() -> Void)? = nil,
         onError: ((String, NetworkError?) -> Void)? = nil
    ) {
        self.networkModel = networkModel
        self.keychain = keychain
        self.onLogin = onLogin
        self.onError = onError
    }
    
    //MARK: call service

    func login(with user: String, password: String, completion: ((String?, Error?) -> Void)? = nil) {
        networkModel.login(
            user: user,
            password: password) { [weak self] token, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.onError?("There was an error", error)
                        return
                    }
                    guard let token = token, !token.isEmpty else {
                        self?.onError?("There is no token", nil)
                      return
                    }
                    self?.keychain.set(token, forKey: "KCToken")
                    self?.onLogin?()
                }
            }
    }
}


