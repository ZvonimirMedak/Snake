//
//  GameManager.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.02.2022..
//

import Foundation
import ARKit
import CombineExt

// MARK: - Constants extension -

private extension Constants {
    enum GameManager {
        static let bottomAngle = SCNVector3(0, 90.degreesToRadians, 0)
        static let topAngle = SCNVector3(0, -90.degreesToRadians, 0)
    }
}

protocol GameManaging {
    var snakeNode: SnakeNode? { get }
    var currentArenaNode: SCNNode? { get }
    var currentFoodNode: FoodNode? { get }
    var scoreNode: SCNNode? { get set }
    func makeArenaNode(using position: SCNVector3, isStart: Bool, time: Int?) -> SCNNode
    func makeGameStartedNode(using arenaNodePosition: SCNVector3) -> SCNNode
    func makeFoodNode() -> FoodNode?
    func updateScoreNode(currentScore: Float)
    func calculateNewScore(with currentScore: Float) -> Float
}

final class GameManager: NSObject {

    // MARK: - Public properties -

    var scoreNode: SCNNode?

    // MARK: - Private properties -

    private var arenaNode: SCNNode?
    private var snakeFocalNode: SnakeNode?
    private var foodNode: FoodNode?
    private let userStorage: DefaultsStorageInterface = UserStorage.instance
}

// MARK: - Extensions -

// MARK: GameManaging conformance

extension GameManager: GameManaging {

    var snakeNode: SnakeNode? {
        snakeFocalNode
    }

    var currentArenaNode: SCNNode? {
        arenaNode
    }

    var currentFoodNode: FoodNode? {
        foodNode
    }

    func makeArenaNode(using position: SCNVector3, isStart: Bool = false, time: Int? = nil) -> SCNNode {
        let arenaCenterNode = makeArenaWithWalls(for: position)
        if isStart {
            let startGameNode = makeStartGameNode()
            startGameNode.position = SCNVector3(position.x - 0.1, position.y + 0.4, position.z)
            arenaCenterNode.addChildNode(startGameNode)
        } else if let time = time {
            let countdownNode = makeCountdownNode(time: time)
            countdownNode.position = SCNVector3(position.x, position.y + 0.4, position.z)
            arenaCenterNode.addChildNode(countdownNode)
        }
        return arenaCenterNode
    }

    func makeGameStartedNode(using arenaNodePosition: SCNVector3) -> SCNNode {
        let arenaCenterNode = makeArenaWithWalls(for: arenaNodePosition)
        guard let snakeNode = makeSnakeNode(position: arenaNodePosition),
              let foodNode = makeFoodNode()
        else { return SCNNode() }

        arenaCenterNode.addChildNode(snakeNode)
        arenaCenterNode.addChildNode(foodNode)
        updateScoreNode(currentScore: 0)

        return arenaCenterNode
    }

    func makeFoodNode() -> FoodNode? {
        guard let arenaNode = arenaNode, let snakeNode = snakeNode else { return nil }
        let arenaWallDistanceFromCenter = userStorage.arenaSize.wallDistance - 0.05
        var foodNode: FoodNode
        repeat {
            let x = Float.random(in: (arenaNode.position.x - arenaWallDistanceFromCenter) ... (arenaNode.position.x + arenaWallDistanceFromCenter))
            let z = Float.random(in: (arenaNode.position.z - arenaWallDistanceFromCenter) ... (arenaNode.position.z + arenaWallDistanceFromCenter))
            foodNode = FoodNode()
            foodNode.position = SCNVector3(x, arenaNode.position.y, z)
        } while snakeNode.bodyNodes.contains(where: { segmentNode -> Bool in
            return (segmentNode.worldPosition.x - 0.05 ... segmentNode.worldPosition.x + 0.05).contains(foodNode.position.x)
            && (segmentNode.worldPosition.z - 0.05 ... segmentNode.worldPosition.z + 0.05).contains(foodNode.position.z)
        })
        foodNode.runAction(SCNAction.rotation(time: 5))
        self.foodNode = foodNode
        return foodNode
    }

    func updateScoreNode(currentScore: Float) {
        guard let arenaNode = arenaNode else { return }
        let score: Float = currentScore
        let text = SCNText(string: "\(score)", extrusionDepth: 0.1)
        let scoreNode = setupTextNode(text)
        scoreNode.position = SCNVector3(x: arenaNode.position.x, y: arenaNode.position.y + 0.4, z: arenaNode.position.z)
        self.scoreNode?.removeFromParentNode()
        self.scoreNode = scoreNode
        arenaNode.addChildNode(scoreNode)
    }

    func calculateNewScore(with currentScore: Float) -> Float {
        let scoreAddition = calculateScore(for: userStorage.gameSpeed) * calculateScore(for: userStorage.arenaSize)
        return currentScore + scoreAddition
    }
}

// MARK: - Node creation

private extension GameManager {

    func makeWallNode(using relativePosition: SCNVector3, rotationAngle: SCNVector3? = nil) -> SCNNode {
        let wallNode = SCNNode(geometry: SCNBox(width: 0.01, height: 0.1, length: userStorage.arenaSize.wallLength, chamferRadius: 0))
        wallNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "jungle")
        wallNode.geometry?.firstMaterial?.isDoubleSided = true
        wallNode.position = relativePosition
        wallNode.eulerAngles = rotationAngle ?? SCNVector3()
        wallNode.physicsBody = SCNPhysicsBody.static()
        wallNode.physicsBody?.categoryBitMask = ContactCategory.arena.rawValue
        wallNode.physicsBody?.collisionBitMask = ContactCategory.snakeHead.rawValue
        wallNode.physicsBody?.contactTestBitMask = ContactCategory.snakeHead.rawValue
        return wallNode
    }

    func makeStartGameNode() -> SCNNode {
        let text = SCNText(string: "Start game", extrusionDepth: 0.1)
        return setupTextNode(text)
    }

    func makeCountdownNode(time: Int) -> SCNNode {
        let timeText = SCNText(string: "\(time)", extrusionDepth: 0.1)
        return setupTextNode(timeText)
    }

    func makeArenaWithWalls(for position: SCNVector3) -> SCNNode {
        let arenaCenterNode = SCNNode()
        arenaCenterNode.position = position
        let arenaWallDistanceFromCenter = userStorage.arenaSize.wallDistance
        arenaCenterNode.addChildNodes(
            makeWallNode(using: SCNVector3(position.x - arenaWallDistanceFromCenter, position.y, position.z)),
            makeWallNode(using: SCNVector3(position.x + arenaWallDistanceFromCenter, position.y, position.z)),
            makeWallNode(using: SCNVector3(position.x, position.y, position.z + arenaWallDistanceFromCenter), rotationAngle: Constants.GameManager.bottomAngle),
            makeWallNode(using: SCNVector3(position.x, position.y, position.z - arenaWallDistanceFromCenter), rotationAngle: Constants.GameManager.topAngle)
        )
        arenaNode = arenaCenterNode
        return arenaCenterNode
    }

    func makeSnakeNode(position: SCNVector3) -> SCNNode? {
        guard let arenaNode = arenaNode else { return nil }
        let snake = Snake(moveDirection: .up, speed: userStorage.gameSpeed, arenaPosition: arenaNode.position)
        let focalNode = SnakeNode(snake: snake, arenaLength: Float(userStorage.arenaSize.wallLength))
        snakeFocalNode = focalNode
        return focalNode
    }
}

// MARK: - Utility

private extension GameManager {

    func setupTextNode(_ text: SCNText) -> SCNNode {
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = UIColor.yellow
        let textNode = SCNNode(geometry: text)
        textNode.castsShadow = true
        let fontSize = Float(0.04)
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
        return textNode
    }
}

// MARK: - Calculations

private extension GameManager {

    func calculateScore(for gameSpeed: GameSpeed) -> Float {
        switch gameSpeed {
        case .slow:
            return 1
        case .normal:
            return 2
        case .fast:
            return 6
        }
    }

    func calculateScore(for arenaSize: ArenaSize) -> Float {
        switch arenaSize {
        case .small:
            return 3
        case .medium:
            return 2
        case .large:
            return 1
        }
    }
}
