//
//  GameInterfaces.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.02.2022..
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import SceneKit
import ARKit
import CombineExt

protocol GameWireframeInterface: WireframeInterface {
    func navigateToUserForm(score: Float, userActionRelay: PassthroughRelay<UserForm.Action>)
    func navigateToHighscores()
    func navigateToHome()
}

protocol GameViewInterface: ViewInterface {
}

protocol GamePresenterInterface: PresenterInterface {
    func configure(with output: Game.ViewOutput) -> Game.ViewInput
}

protocol GameInteractorInterface: InteractorInterface {
    var snakeNode: SnakeNode? { get }
    var currentArenaNode: SCNNode? { get }
    var foodNode: FoodNode? { get }
    var gameSpeedUpdateInterval: TimeInterval { get }
    func makeArena(with position: SCNVector3, isStart: Bool, time: Int?) -> SCNNode
    func makeGameStartedNode(using arenaNodePosition: SCNVector3) -> SCNNode
    func makeFoodNode() -> FoodNode?
    func updateScoreNode(currentScore: Float)
    func calculateNewScore(with currentScore: Float) -> Float
}

enum Game {

    struct ViewOutput {
        let willRenderScene: Signal<ARHitTestResult?>
        let startGame: Signal<Void>
        let contactAction: Signal<SCNPhysicsContact>
        let snakeTurningAction: Signal<SnakeTurning>
    }

    struct ViewInput {
        let arenaSetup: Driver<SCNNode?>
    }

    struct Input {
        let gameManager: GameManaging
        let userStorage: DefaultsStorageInterface
    }
}
