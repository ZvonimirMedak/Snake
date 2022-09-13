//
//  DirectionManager.swift
//  Snake
//
//  Created by Zvonimir Medak on 23.05.2022..
//

import Foundation
import UIKit

typealias CameraPosition = (x: Float, z: Float)

protocol DirectionManaging {
    static func turnDirection(
        using cameraPosition: CameraPosition,
        snakeDirection: Direction,
        swipeDirection: Direction
    ) -> DirectionManager.TurnDirection?
}

final class DirectionManager: DirectionManaging {

    enum TurnDirection {
        case left
        case right
    }
    
    static func turnDirection(
        using cameraPosition: CameraPosition,
        snakeDirection: Direction,
        swipeDirection: Direction
    ) -> TurnDirection? {
        let cameraDirection = cameraDirection(using: cameraPosition)
        
        switch (cameraDirection, snakeDirection, swipeDirection){
        case (.down, .up, .right):
            return .left
        case (.down, .up, .left):
            return .right
        case (.down, .right, .up):
            return .right
        case (.down, .right, .down):
            return .left
        case (.down, .down, .right):
            return .right
        case (.down, .down, .left):
            return .left
        case (.down, .left, .up):
            return .left
        case (.down, .left, .down):
            return .right

        case (.left, .up, .up):
            return .right
        case (.left, .up, .down):
            return .left
        case (.left, .right, .right):
            return .right
        case (.left, .right, .left):
            return .left
        case (.left, .down, .up):
            return .left
        case (.left, .down, .down):
            return .right
        case (.left, .left, .right):
            return .left
        case (.left, .left, .left):
            return .right

        case (.right, .up, .up):
            return .left
        case (.right, .up, .down):
            return .right
        case (.right, .right, .right):
            return .left
        case (.right, .right, .left):
            return .right
        case (.right, .down, .up):
            return .right
        case (.right, .down, .down):
            return .left
        case (.right, .left, .right):
            return .right
        case (.right, .left, .left):
            return .left

        case (.up, .up, .right):
            return .right
        case (.up, .up, .left):
            return .left
        case (.up, .right, .up):
            return .left
        case (.up, .right, .down):
            return .right
        case (.up, .down, .right):
            return .left
        case (.up, .down, .left):
            return .right
        case (.up, .left, .up):
            return .right
        case (.up, .left, .down):
             return .left
        default:
            return nil
        }
    }
}

// MARK: - Extensions -

// MARK: - Utility

private extension DirectionManager {

    static func cameraDirection(using cameraPosition: CameraPosition) -> Direction {
        var cameraDirection: Direction = .up

        if cameraPosition.z > 0 && (-0.5 ... 0.5).contains(cameraPosition.x) {
            cameraDirection = .up
        } else if cameraPosition.z < 0 && (-0.5 ... 0.5).contains(cameraPosition.x){
            cameraDirection = .down
        } else if cameraPosition.x > 0.5 {
            cameraDirection = .right
        } else if cameraPosition.x < 0.5 {
            cameraDirection = .left
        }

        return cameraDirection
    }
}
