//
//  GameWireframe.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.02.2022..
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Combine
import CombineExt

final class GameWireframe: BaseWireframe<GameViewController> {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard.game

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: GameViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = GameInteractor(input: Game.Input(gameManager: GameManager(), userStorage: UserStorage.instance))
        let presenter = GamePresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension GameWireframe: GameWireframeInterface {

    func navigateToUserForm(score: Float, userActionRelay: PassthroughRelay<UserForm.Action>) {
        let navigationController = UINavigationController()
        navigationController.setRootWireframe(UserFormWireframe(score: score, userActionRelay: userActionRelay))
        navigationController.modalPresentationStyle = .fullScreen

        viewController.present(navigationController, animated: true)
    }

    func navigateToHighscores() {
        dismiss()
        navigationController?.pushWireframe(HighscoresWireframe())
    }

    func navigateToHome() {
        dismiss()
        navigationController?.setRootWireframe(HomeWireframe(), animated: true)
    }
}