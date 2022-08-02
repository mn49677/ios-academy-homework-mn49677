//
//  KeychainAccess.swift
//  TV Shows
//
//  Created by Maximilian Novak on 02.08.2022..
//

import Foundation
import KeychainAccess

class KeychainAccess {
    
    static let propertyListEncoder = PropertyListEncoder()
    static let propertyListDecoder = PropertyListDecoder()
    static let keychain = Keychain(service: Constants.App.bundleIdentifier)
    
    static func setUsername(username: String) {
        try? keychain.set(username, key: "username")
    }
    
    static func setPassword(password: String) {
        try? keychain.set(password, key: "password")
    }
    
    static func setAuthInfo(authInfo: AuthInfo) {
        let data = try? propertyListEncoder.encode(authInfo)
        if let savingData = data {
            keychain[data: Constants.Keys.authInfo] = NSData(data: savingData) as Data
        }
    }
    
    static func getUsername() -> String? {
        return try? keychain.get("username")
    }
    
    static func getPassword() -> String? {
        return try? keychain.get("password")
    }
    
    static func getAuthInfo() -> AuthInfo? {
        guard let retrievedData = keychain[data: Constants.Keys.authInfo] else { return nil }
        let data = try? propertyListDecoder.decode(AuthInfo.self, from: retrievedData)
        return data
    }
    
}
