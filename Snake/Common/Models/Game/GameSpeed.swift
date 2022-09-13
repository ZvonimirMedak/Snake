//
//  GameSpeed.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Foundation

enum GameSpeed: String, Codable {
    case slow
    case normal
    case fast
}

// MARK: - Extensions -

// MARK: - Utility

extension GameSpeed {

    var updateInterval: TimeInterval {
        switch self {
        case .slow:
            return 0.1
        case .normal:
            return 0.08
        case .fast:
            return 0.05
        }
    }
}

