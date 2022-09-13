//
//  SnakeNode.swift
//  Snake
//
//  Created by Zvonimir Medak on 09.05.2022..
//

import SceneKit

final class SnakeNode: SCNNode {

    // MARK: - Public properties -

    var snake: Snake
    var bodyNodes: [SnakeSegmentNode] = []

    // MARK: - Private properties -

    private var lastBodySegment: SIMD2<Float32>?
    private var arenaLength: Float

    // MARK: - Init -

    public init(snake: Snake, arenaLength: Float) {
        self.snake = snake
        self.arenaLength = arenaLength
        super.init()
        initializeBodyNodes()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
}

// MARK: - Extensions -

// MARK: - Interaction

extension SnakeNode {

    public func turnLeft() {
        let value = (snake.moveDirection.rawValue + 1) % 4
        guard let direction = Direction(rawValue: value) else { return }
        snake.moveDirection = direction
        rotateHeadNode(direction: .left)
    }

    public func turnRight() {
        let value = (snake.moveDirection.rawValue - 1 + 4) % 4
        guard let direction = Direction(rawValue: value) else { return }
        snake.moveDirection = direction
        rotateHeadNode(direction: .right)
    }

    public func move() {
        guard let snakeHead = snake.headPosition else { return }
        var newBody = [SIMD2<Float32>(x: snakeHead.x + snake.moveDirection.float32.x, y: snakeHead.y + snake.moveDirection.float32.y)]
        lastBodySegment = snake.body.removeLast()
        newBody.append(contentsOf: snake.body)
        snake.body = newBody
        updateNodes()
    }

    public func grow() {
        guard let lastBodySegment = lastBodySegment, let lastNode = bodyNodes.last else { return }
        snake.body += [lastBodySegment]
        let newNode = createNewNode(position: lastBodySegment, lastNodeDirection: lastNode.direction)
        bodyNodes += [newNode]
        addChildNode(newNode)
        updateNodes()
    }
}

// MARK: - Node creation

private extension SnakeNode {

    func initializeBodyNodes() {
        snake.body = [
            SIMD2<Float32>(snake.arenaPosition.x, snake.arenaPosition.z),
            SIMD2<Float32>(snake.arenaPosition.x, snake.arenaPosition.z + 0.025),
            SIMD2<Float32>(snake.arenaPosition.x, snake.arenaPosition.z + 0.05),
            SIMD2<Float32>(snake.arenaPosition.x, snake.arenaPosition.z + 0.075)
        ]

        snake.body
            .enumerated()
            .forEach { index, position in
                guard position == snake.body.first else {
                    bodyNodes += [SnakeSegmentNode(position: position, direction: .up, arenaYPosition: snake.arenaPosition.y, nodeNumber: index)]
                    return
                }
                bodyNodes += [SnakeSegmentNode(position: position, direction: .up, type: .head, arenaYPosition: snake.arenaPosition.y, nodeNumber: index)]
            }

        bodyNodes.forEach(addChildNode(_:))
        updateNodes()
    }
}

// MARK: - Node updates

private extension SnakeNode {

    func createNewNode(position: SIMD2<Float32>, lastNodeDirection: Direction) -> SnakeSegmentNode{
        let newNode = SnakeSegmentNode(
            position: position,
            direction: lastNodeDirection,
            arenaYPosition: snake.arenaPosition.y,
            nodeNumber: bodyNodes.endIndex
        )
        newNode.physicsBody?.isAffectedByGravity = false
        newNode.physicsBody?.categoryBitMask = ContactCategory.snake.rawValue
        newNode.physicsBody?.collisionBitMask = ContactCategory.snakeHead.rawValue
        newNode.physicsBody?.contactTestBitMask = ContactCategory.snakeHead.rawValue
        return newNode
    }

    func updateNodes() {
        bodyNodes = bodyNodes.sorted()
        bodyNodes
            .enumerated()
            .forEach { index, node in
                let postition = snake.body[index]
                node.position = SCNVector3(Float(postition.x), snake.arenaPosition.y, Float(postition.y))
                let moveAction = SCNAction.move(to: SCNVector3(Float(postition.x), snake.arenaPosition.y, Float(postition.y)), duration: 0.1)
                node.runAction(moveAction)
            }
    }
}

// MARK: - Rotation

private extension SnakeNode {

    func rotateHeadNode(direction: Direction){
        guard let headNode = bodyNodes.first else { return }
        switch direction{
        case .left:
            let value = (headNode.direction.rawValue + 1) % 4
            guard let newDirection = Direction(rawValue: value) else { return }
            headNode.direction = newDirection
            rotateNode(node: headNode, angle: direction.turnAngle)
        case .right:
            let value = (headNode.direction.rawValue - 1 + 4) % 4
            guard let newDirection = Direction(rawValue: value) else { return }
            headNode.direction = newDirection
            rotateNode(node: headNode, angle: direction.turnAngle)
        default:
            break
        }
    }

    func rotateNode(node: SnakeSegmentNode, angle: CGFloat){
        let rotationAction = SCNAction.rotateBy(x: 0, y: angle, z: 0, duration: 0.25)
        node.runAction(rotationAction)
    }
}
