//
//  UserDefaults.swift
//  TV Shows
//
//  Created by Maximilian Novak on 02.08.2022..
//

import Foundation

// MARK: - Extensions for saving object to UserDefaults

extension UserDefaults {
    
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw SavableObjectError.unableToEncode
        }
    }
        
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw SavableObjectError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw SavableObjectError.unableToDecode
        }
    }
}

enum SavableObjectError : Error {
    case unableToDecode
    case noValue
    case unableToEncode
}
