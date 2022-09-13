//
//  Encodable+asJSONObject.swift
//  Snake
//
//  Created by Zvonimir Medak on 25.06.2022..
//

import Foundation

extension Encodable {

    var JSONObject: [String: Any]? {
        guard let encodedData = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: encodedData) as? [String: Any]
    }
}
