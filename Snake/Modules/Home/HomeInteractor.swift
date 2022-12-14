//
//  HomeInteractor.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class HomeInteractor {

    // MARK: - Private properties -

    private let input: Home.Input

    // MARK: - Init -

    init(input: Home.Input) {
        self.input = input
    }
}

// MARK: - Extensions -

extension HomeInteractor: HomeInteractorInterface {

    var shouldShowSettingsInformation: Bool {
        input.userStorage.shouldShowSettingsInformation
    }

    func update(shouldShowSettingsInformation: Bool) {
        input.userStorage.shouldShowSettingsInformation = shouldShowSettingsInformation
    }
}
