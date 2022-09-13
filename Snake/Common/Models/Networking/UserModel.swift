//
//  UserData.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Foundation

struct UserModel: Codable {

    var nickname: String
    var name: String?
    var email: String?
    var score: Float

    // MARK: - Empty state -

    static let empty: UserModel = UserModel(nickname: "", name: nil, email: nil, score: 0)

    // MARK: - Init -

    init(nickname: String, name: String?, email: String?, score: Float) {
        self.nickname = nickname
        self.name = name
        self.email = email
        self.score = score
    }

    init?(nickname: String?, name: String?, email: String?, score: Float?) {
        guard let nickname = nickname, let score = score else {
            return nil
        }
        self.nickname = nickname
        self.name = name
        self.email = email
        self.score = score
    }

    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(Self.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}
