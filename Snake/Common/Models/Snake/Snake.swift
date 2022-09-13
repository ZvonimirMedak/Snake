//
//  Snake.swift
//  Snake
//
//  Created by Zvonimir Medak on 10.05.2022..
//

import Foundation
import SceneKit

struct Snake {
    let speed: GameSpeed
    let arenaPosition: SCNVector3
    var moveDirection: Direction
    var body: [SIMD2<Float32>] = []

    init(moveDirection: Direction, speed: GameSpeed, arenaPosition: SCNVector3) {
        self.moveDirection = moveDirection
        self.speed = speed
        self.arenaPosition = arenaPosition
    }
}

// MARK: - Extensions -

// MARK: - Helpers

extension Snake {
    
    var headPosition: SIMD2<Float32>? {
        body.first
    }
}
