//
//  HighscoresInterfaces.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Combine
import CombineExt

protocol HighscoresWireframeInterface: WireframeInterface, Progressable {
    func navigateToHome()
}

protocol HighscoresViewInterface: ViewInterface {
}

protocol HighscoresPresenterInterface: PresenterInterface {
    func configure(with output: Highscores.ViewOutput) -> Highscores.ViewInput
}

protocol HighscoresInteractorInterface: InteractorInterface {
    func save(userModel: UserModel) -> AnyPublisher<Void, Error>
    func getHighscores() -> AnyPublisher<[UserModel], Error>
}

enum Highscores {

    struct ViewOutput {
        let backAction: Signal<Void>
    }

    struct ViewInput {
        let sections: Driver<[TableSectionItem]>
    }

    struct Input {
        let highscoreService: HighscoreServing
    }
}
