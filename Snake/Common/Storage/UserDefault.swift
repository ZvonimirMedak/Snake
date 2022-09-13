//
//  UserDefault.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Foundation

@propertyWrapper
final class UserDefault<Value> where Value: Codable {
    let key: UserStorage.DefaultsKeys
    let defaultValue: Value
    let container: UserDefaults

    init(_ key: UserStorage.DefaultsKeys, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = userDefaults
    }

    var wrappedValue: Value {
        get { container.value(ofType: Value.self, forKey: key) ?? defaultValue }
        set { container.set(value: newValue, forKey: key) }
    }
}

// MARK: - Extensions

// MARK: - Value getting & setting

private extension UserDefaults {

    func value<Value: Decodable>(
        ofType type: Value.Type,
        forKey key: UserStorage.DefaultsKeys,
        decoder: JSONDecoder = JSONDecoder()
    ) -> Value? {
        let key = key.rawValue

        if let object = object(forKey: key) as? Value {
            return object
        }
        guard let data = data(forKey: key) else { return nil }

        return try? decoder.decode(Value.self, from: data)
    }

    func set<Value: Encodable>(value: Value?, forKey key: UserStorage.DefaultsKeys, encoder: JSONEncoder = JSONEncoder()) {
        let key = key.rawValue

        if value == nil {
            set(nil, forKey: key)
            return
        }

        switch value {
        case let string as String:
            set(string, forKey: key)
        case let bool as Bool:
            set(bool, forKey: key)
        default:
            let data = try? encoder.encode(value)
            set(data, forKey: key)
        }
    }
}
