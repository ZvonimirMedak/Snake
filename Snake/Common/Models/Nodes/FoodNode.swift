//
//  FoodNode.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//

import Foundation
import ARKit

public class FoodNode: SCNNode {

   override public init() {
        super.init()
        createFood()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createFood(){
        let node = SCNNode()
        let cylinder = SCNCylinder(radius: 0.02, height: 0.005)
        let physicsShape = SCNPhysicsShape(geometry: cylinder, options: nil)
        let physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        node.geometry = cylinder
        cylinder.firstMaterial?.diffuse.contents = UIColor.yellow
        cylinder.firstMaterial?.isDoubleSided = true
        node.physicsBody = physicsBody
        node.physicsBody?.categoryBitMask = ContactCategory.food.rawValue
        node.physicsBody?.contactTestBitMask = ContactCategory.snakeHead.rawValue
        node.physicsBody?.collisionBitMask = ContactCategory.snakeHead.rawValue
        node.eulerAngles = SCNVector3(x: 0, y: 0, z: 90)
        node.runAction(.rotation(time: 5))
        addChildNode(node)
    }
}
