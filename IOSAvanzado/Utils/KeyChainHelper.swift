//
//  KeyChainHelper.swift
//  AppleMaps
//
//  Created by Joaquín Corugedo Rodríguez on 5/9/22.
//

import Foundation

final class KeyChainHelper {

    static let standar = KeyChainHelper()
    private init() {}


    func save(data: Data, service: String, account: String) {

        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        let status = SecItemAdd(query, nil)

        if status != errSecSuccess {
            print("Error: \(status)")
        }

        if status == errSecDuplicateItem {

            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            SecItemUpdate(query, attributesToUpdate)
        }
    }

    func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return (result as? Data)
    }

    func delete(service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        SecItemDelete(query)
    }


    func save<T: Codable>(item: T, service: String, account: String) {
        do {
            let data = try JSONEncoder().encode(item)
            save(data: data, service: service, account: account)
        } catch {
            //Do errors
        }
    }

    func read<T: Codable>(item: T, service: String, account: String, type: T.Type) -> T? {
        guard let data = read(service: service, account: account) else {
            return nil
        }

        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            return nil
        }
    }
}
