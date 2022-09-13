//
//  Direction.swift
//  Snake
//
//  Created by Zvonimir Medak on 10.05.2022..
//

import UIKit

enum Direction: Int, Equatable {
    case up
    case right
    case down
    case left
}

// MARK: - Extensions -

// MARK: - Utility

extension Direction {

    var float32: SIMD2<Float32> {
        switch self {
        case .right:
            return SIMD2<Float32>(x: 0.025, y: 0)
        case .left:
            return SIMD2<Float32>(x: -0.025, y: 0)
        case .down:
            return SIMD2<Float32>(x: 0, y: 0.025)
        case .up:
            return SIMD2<Float32>(x: 0, y: -0.025)
        }
    }

    var turnAngle: CGFloat {
        switch self {
        case .left:
            return -90.degreesToRadians
        case .right:
            return 90.degreesToRadians
        case .up, .down:
            return .leastNonzeroMagnitude
        }
    }

    var nodeXAngle: Float {
        switch self{
        case .right:
            return 0
        case .left:
            return Float(-180.degreesToRadians)
        case .up:
            return Float(-90.degreesToRadians)
        case .down:
            return Float(90.degreesToRadians)
        }
    }
}
