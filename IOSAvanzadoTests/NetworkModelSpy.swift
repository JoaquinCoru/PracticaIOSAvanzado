//
//  NetworkModelSpy.swift
//  IOSAvanzadoTests
//
//  Created by Joaquín Corugedo Rodríguez on 5/9/22.
//

import Foundation
@testable import IOSAvanzado

class NetWorkModelSpy: NetworkModel {

    override func login(user: String, password: String, completion: ((String?, NetworkError?) -> Void)? = nil) {
        if(user == "Joaquin") {
            completion?("miToken", nil)
            return
        }
        
        completion?(nil, nil)
    }
}
