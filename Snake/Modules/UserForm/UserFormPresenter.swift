//
//  UserFormPresenter.swift
//  Snake
//
//  Created by Zvonimir Medak on 22.06.2022..
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation
import Combine
import CombineExt

final class UserFormPresenter {

    // MARK: - Private properties -

    private unowned let view: UserFormViewInterface
    private let interactor: UserFormInteractorInterface
    private let wireframe: UserFormWireframeInterface

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle -

    init(
        view: UserFormViewInterface,
        interactor: UserFormInteractorInterface,
        wireframe: UserFormWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension UserFormPresenter: UserFormPresenterInterface {

    func configure(with output: UserForm.ViewOutput) -> UserForm.ViewInput {
        let userModel = handle(userDataUsing: output.nickname, name: output.name, email: output.email)

        handle(saveAction: output.saveAction, userModel: userModel)
        handle(skipAction: output.skipAction)
        let isSaveActionEnabled = handle(isSaveActionEnabledUsing: userModel)

        return UserForm.ViewInput(isSaveActionEnabled: isSaveActionEnabled)
    }
}

// MARK: - Handlers

private extension UserFormPresenter {

    func handle(saveAction: Signal<Void>, userModel: Driver<UserModel>) {
        let saveUserResultRequestHandler: (UserModel) -> Driver<Void> = { [unowned self] in
            interactor
                .save(userModel: $0)
                .handleLoadingAndError(with: wireframe)
                .asDriverOnErrorComplete()
        }
        saveAction
            .withLatestFrom(userModel)
            .flatMap(saveUserResultRequestHandler)
            .sink(receiveValue: { [unowned wireframe] in wireframe.navigateToResult(userAction: .done) })
            .store(in: &cancellables)
    }

    func handle(skipAction: Signal<Void>) {
        skipAction
            .sink(receiveValue: { [unowned wireframe] in wireframe.navigateToResult(userAction: .skip) })
            .store(in: &cancellables)
    }

    func handle(
        userDataUsing nickname: Driver<String?>,
        name: Driver<String?>,
        email: Driver<String?>
    ) -> Driver<UserModel> {
        Publishers
            .CombineLatest3(nickname, name, email)
            .map { [unowned interactor] in ($0.0, $0.1, $0.2, interactor.score) }
            .compactMap(UserModel.init)
            .asDriver()
    }

    func handle(isSaveActionEnabledUsing userModel: Driver<UserModel>) -> Driver<Bool> {
        userModel
            .map { $0.nickname.isNotBlank }
            .asDriver()
    }
}
