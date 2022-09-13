//
//  SnakeSegmentNode.swift
//  Snake
//
//  Created by Zvonimir Medak on 10.05.2022..
//

import Foundation
import SceneKit

final class SnakeSegmentNode: SCNNode {

    // MARK: - Public properties -

    var direction: Direction
    let nodeNumber: Int

    // MARK: - Private properties -

    private let type: SnakeSegmentType
    private let snakePosition: SIMD2<Float32>
    private let arenaYPosition: Float

    // MARK: - Init -

    init(position: SIMD2<Float32>, direction: Direction, type: SnakeSegmentType = .body, arenaYPosition: Float, nodeNumber: Int) {
        self.type = type
        self.snakePosition = position
        self.direction = direction
        self.arenaYPosition = arenaYPosition
        self.nodeNumber = nodeNumber
        super.init()
        createSnake()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
}

// MARK: - Extensions -

private extension SnakeSegmentNode {

    private func createSnake(){
        var node: SCNNode
        switch type {
        case .body:
            node = SCNNode()
            let sphere = SCNSphere(radius: 0.02)
            node.geometry = sphere
            node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: sphere, options: nil))
            if nodeNumber < 3 {
                node.physicsBody?.categoryBitMask = ContactCategory.nothing.rawValue
            }
        case .head:
            node = SCNNode()
            let cone = SCNCone(topRadius: 0.0, bottomRadius: 0.02, height: 0.04)
            let phyisicsGeometry = SCNBox(width: 0.04, height: 0.04, length: 0.04, chamferRadius: 0)
            node.geometry = cone
            let physicsShape = SCNPhysicsShape(geometry: phyisicsGeometry)
            let physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
            physicsBody.isAffectedByGravity = false
            node.geometry = cone
            node.physicsBody = physicsBody
            node.physicsBody?.categoryBitMask = ContactCategory.snakeHead.rawValue
            node.physicsBody?.contactTestBitMask = ContactCategory.arena.rawValue
            node.physicsBody?.collisionBitMask = ContactCategory.arena.rawValue
        }

        node.eulerAngles.x = direction.nodeXAngle
        node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "snakeSkin")
        position = SCNVector3(Float(snakePosition.x), arenaYPosition, Float(snakePosition.y))

        addChildNode(node)
    }
}

// MARK: - Comparable conformance

extension SnakeSegmentNode: Comparable {
    static func < (lhs: SnakeSegmentNode, rhs: SnakeSegmentNode) -> Bool {
        lhs.type.rawValue < rhs.type.rawValue
    }
}
