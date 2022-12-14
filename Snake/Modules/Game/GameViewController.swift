//
//  GameViewController.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.02.2022..
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Combine
import ARKit
import CombineExt

final class GameViewController: UIViewController {

    // MARK: - IBOutlets -

    @IBOutlet private weak var sceneView: ARSCNView!

    // MARK: - Public properties -

    var presenter: GamePresenterInterface!

    // MARK: - Private properties -

    private var configuration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

// MARK: - Extensions -

extension GameViewController: GameViewInterface {
}

// MARK: - View setup

private extension GameViewController {

    func setupView() {
        let tapGesture = makeTapGesture()
        let snakeTurningRelay = PassthroughRelay<SnakeTurning>()
        setupUI(tapGesture: tapGesture, snakeTurningRelay: snakeTurningRelay)

        let startGameAction = tapGesture.tapPublisher
            .mapToVoid()
            .asSignal()
        let willRenderScene = handle(willRenderScene: sceneView.willRenderScene.asSignal())

        let output = Game.ViewOutput(
            willRenderScene: willRenderScene,
            startGame: startGameAction,
            contactAction: sceneView.didBeginContact.asSignal(),
            snakeTurningAction: snakeTurningRelay.asSignal()
        )

        let input = presenter.configure(with: output)

        handle(arenaSetup: input.arenaSetup)
    }
}

// MARK: - UI setup

private extension GameViewController {

    func setupUI(tapGesture: UITapGestureRecognizer, snakeTurningRelay: PassthroughRelay<SnakeTurning>) {
        sceneView.session.run(configuration)
        sceneView.addGestureRecognizer(tapGesture)
        
        setupSwipeGestures(using: snakeTurningRelay)
    }
    
    func setupSwipeGestures(using snakeTurningRelay: PassthroughRelay<SnakeTurning>) {
        let swipeLeftGesture = makeSwipeGesture(for: .left)
        let swipeRightGesture = makeSwipeGesture(for: .right)
        let swipeDownGesture = makeSwipeGesture(for: .down)
        let swipeUpGesture = makeSwipeGesture(for: .up)

        handle(swipeGesture: swipeLeftGesture, with: snakeTurningRelay)
        handle(swipeGesture: swipeRightGesture, with: snakeTurningRelay)
        handle(swipeGesture: swipeDownGesture, with: snakeTurningRelay)
        handle(swipeGesture: swipeUpGesture, with: snakeTurningRelay)
    }

    func makeTapGesture() -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer()
        return tapGesture
    }

    func makeSwipeGesture(for direction: Direction) -> UISwipeGestureRecognizer {
        let swipeGesture = UISwipeGestureRecognizer()
        switch direction {
        case .up:
            swipeGesture.direction = .up
        case .down:
            swipeGesture.direction = .down
        case .left:
            swipeGesture.direction = .left
        case .right:
            swipeGesture.direction = .right
        }
        sceneView.addGestureRecognizer(swipeGesture)
        return swipeGesture
    }
}

// MARK: - Handlers

private extension GameViewController {

    func handle(willRenderScene: Signal<SCNScene>) -> Signal<ARHitTestResult?> {
        let hitTestResultBuilder: (SCNScene) -> ARHitTestResult? = { [unowned self] scene in
            let hit = sceneView.hitTest(view.center, types: .existingPlane)
            sceneView.removeAllChildNodes()
            guard ((hit.first?.anchor as? ARPlaneAnchor) != nil), let firstResult = hit.first else { return nil }
            return firstResult
        }
        return willRenderScene
            .map(hitTestResultBuilder)
            .asSignal()
    }

    func handle(arenaSetup: Driver<SCNNode?>) {
        arenaSetup
            .compactMap { $0 }
            .handleEvents(receiveOutput: { [unowned self] _ in sceneView.removeAllChildNodes() })
            .sink(receiveValue: { [unowned self] in sceneView.scene.rootNode.addChildNode($0) })
            .store(in: &cancellables)
    }
    
    func handle(swipeGesture: UISwipeGestureRecognizer, with snakeTurningRelay: PassthroughRelay<SnakeTurning>) {
        let directionHandler: (UISwipeGestureRecognizer.Direction) -> Direction = { swipeDirection in
            switch swipeDirection {
            case .up:
                return .up
            case .right:
                return .right
            case .left:
                return .left
            case .down:
                return .down
            default:
                return .up
            }
        }

        let snakeMovementBuilder: (Direction) -> SnakeTurning? = { [unowned self] swipeDirection in
            guard let pointOfView = sceneView.pointOfView?.worldFront else  { return nil }
            return .init(pointOfView: pointOfView, swipeDirection: swipeDirection)
        }
        swipeGesture
            .swipePublisher
            .map(\.direction)
            .map(directionHandler)
            .map(snakeMovementBuilder)
            .compactMap { $0 }
            .bind(to: snakeTurningRelay)
            .store(in: &cancellables)
    }
}
