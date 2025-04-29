//
//  KeychainService.swift
//  CryptoWallet
//
//  Created by Дмитрий Любченко on 29.04.2025.
//

import Foundation
import Security

final class KeychainService {
    
    static let shared = KeychainService()
    
    private let service = "com.RickAndMorty.CryptoWallet"
    private let account = "userCredentials"
    
    func save(login: String, password: String) -> Bool {
        let credentials: [String: String] = ["login": login, "password": password]
        
        guard let data = try? JSONEncoder().encode(credentials) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecValueData as String   : data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func load() -> (login: String, password: String)? {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let credentials = try? JSONDecoder().decode([String: String].self, from: data),
              let login = credentials["login"],
              let password = credentials["password"] else {
            return nil
        }
        
        return (login, password)
    }
    
    func delete() {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
