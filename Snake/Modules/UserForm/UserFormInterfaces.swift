//
//  UserFormInterfaces.swift
//  Snake
//
//  Created by Zvonimir Medak on 22.06.2022..
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
import Combine
import CombineExt

protocol UserFormWireframeInterface: WireframeInterface, Progressable {
    func navigateToResult(userAction: UserForm.Action)
}

protocol UserFormViewInterface: ViewInterface {
}

protocol UserFormPresenterInterface: PresenterInterface {
    func configure(with output: UserForm.ViewOutput) -> UserForm.ViewInput
}

protocol UserFormInteractorInterface: InteractorInterface {
    var score: Float { get }
    func save(userModel: UserModel) -> AnyPublisher<Void, Error>
}

enum UserForm {

    struct ViewOutput {
        let nickname: Driver<String?>
        let name: Driver<String?>
        let email: Driver<String?>
        let saveAction: Signal<Void>
        let skipAction: Signal<Void>
    }

    struct ViewInput {
        let isSaveActionEnabled: Driver<Bool>
    }

    struct Input {
        let score: Float
        let highscoreService: HighscoreServing
    }

    enum Action {
        case done
        case skip
    }
}
