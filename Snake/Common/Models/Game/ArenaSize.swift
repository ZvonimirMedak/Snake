//
//  ArenaSize.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import UIKit

enum ArenaSize: String, Codable {
    case small
    case medium
    case large
}

// MARK: - Extensions -

// MARK: - Utility

extension ArenaSize {

    var wallDistance: Float {
        switch self {
        case .small:
            return 0.3
        case .medium:
            return 0.5
        case .large:
            return 0.7
        }
    }

    var wallLength: CGFloat {
        CGFloat(wallDistance * 2)
    }
}
