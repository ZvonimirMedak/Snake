//
//  SettingsWireframe.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Combine
import CombineExt

final class SettingsWireframe: BaseWireframe<SettingsViewController> {

    // MARK: - Private properties -

    private let storyboard = UIStoryboard.settings

    // MARK: - Module setup -

    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: SettingsViewController.self)
        super.init(viewController: moduleViewController)

        let interactor = SettingsInteractor(input: .init(userStorage: UserStorage.instance))
        let presenter = SettingsPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension SettingsWireframe: SettingsWireframeInterface {

    func navigateToGameRules(configurators: [ComponentConfigurable]) {
        let wireframe = PageSheetWireframe(input: .init(configurators: configurators))
        navigationController?.present(wireframe.viewController, animated: true)
    }
}
