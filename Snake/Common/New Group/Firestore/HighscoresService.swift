//
//  HighscoresService.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Foundation
import Combine
import FirebaseFirestore

private extension Constants {

    enum HighscoreService {
        static let players = "players"
        static let score = "score"
    }
}

protocol HighscoreServing {
    func save(userModel: UserModel) -> AnyPublisher<Void, Error>
    func getHighscores() -> AnyPublisher<[UserModel], Error>
}

final class HighscoreService: HighscoreServing {

    private lazy var firestore: Firestore = {
        Firestore.firestore()
    }()

    func save(userModel: UserModel) -> AnyPublisher<Void, Error> {
        AnyPublisher.createAsync { [unowned self] in
            try await withCheckedThrowingContinuation { continuation in
                guard let data = userModel.JSONObject else {
                    continuation.resume(throwing: SnakeError.default)
                    return
                }

                let completionHandler: (Error?) -> Void = { error in
                    guard let error = error else {
                        continuation.resume(returning: ())
                        return
                    }
                    continuation.resume(throwing: error)
                }
                firestore
                    .collection(Constants.HighscoreService.players)
                    .document()
                    .setData(data, completion: completionHandler)
            }
        }
    }

    func getHighscores() -> AnyPublisher<[UserModel], Error>  {
        let userModelBuilder: (QueryDocumentSnapshot) -> UserModel = { document in
            guard let userModel = try? UserModel(dictionary: document.data()) else {
                return .empty
            }
            return userModel
        }
        return AnyPublisher.createAsync { [unowned self] in
            return try await withCheckedThrowingContinuation({ continuation in
                let query = firestore
                    .collection(Constants.HighscoreService.players)
                    .order(by: Constants.HighscoreService.score, descending: true)
                query.getDocuments { data, error in
                    guard error.isNil, let data = data else {
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else {
                            continuation.resume(returning: [])
                        }
                        return
                    }
                    let userData = data
                        .documents
                        .map(userModelBuilder)
                    continuation.resume(returning: userData)
                }
            })
        }
    }
}
