//
//  HomePresenter.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation
import Combine
import CombineExt

final class HomePresenter {

    // MARK: - Private properties -

    private unowned let view: HomeViewInterface
    private let interactor: HomeInteractorInterface
    private let wireframe: HomeWireframeInterface

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle -

    init(
        view: HomeViewInterface,
        interactor: HomeInteractorInterface,
        wireframe: HomeWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension HomePresenter: HomePresenterInterface {

    func configure(with output: Home.ViewOutput) -> Home.ViewInput {

        handle(settingsAction: output.settingsAction)
        handle(playAction: output.playAction)
        handle(highscoresAction: output.highscoresAction)

        return Home.ViewInput()
    }
}

// MARK: - Helpers

private extension HomePresenter {

    func makeSettingsInformationInput() -> PageSheet.Input {
        let labelConfiguration = LabelConfigurator(text: "Have you set you preferred settings before you start your game? You can set game speed and arena size. If you haven't check out what it's all about in the settings.")
        let playButtonConfigurator = ButtonConfigurator(
            text: "Play anyway",
            theme: .primary,
            size: .small,
            didSelect: { [unowned wireframe] in
                wireframe.dismiss()
                wireframe.navigateToGame()
            }
        )
        let buttonConfigurator = ButtonConfigurator(
            text: "Settings",
            theme: .secondary,
            size: .small,
            didSelect: { [unowned wireframe] in
                wireframe.dismiss()
                wireframe.navigateToSettings()
            }
        )
        let didSelectCheckboxHandler: (Bool) -> Void = { [unowned interactor] in
            interactor.update(shouldShowSettingsInformation: !$0)
        }
        let checkboxConfigurator = CheckboxConfigurator(text: "Don't show this again", didSelect: didSelectCheckboxHandler)
        return .init(configurators: [labelConfiguration, checkboxConfigurator, playButtonConfigurator, buttonConfigurator])
    }
}


// MARK: - Handlers

private extension HomePresenter {

    func handle(settingsAction: Signal<Void>) {
        settingsAction
            .sink(receiveValue: { [unowned wireframe] in wireframe.navigateToSettings() })
            .store(in: &cancellables)
    }

    func handle(highscoresAction: Signal<Void>) {
        highscoresAction
            .sink(receiveValue: { [unowned wireframe] in wireframe.navigateToHighscores() })
            .store(in: &cancellables)
    }

    func handle(playAction: Signal<Void>) {
        let navigationHandler: () -> Void = { [unowned self] in
            guard interactor.shouldShowSettingsInformation else {
                wireframe.navigateToGame()
                return
            }
            let input = makeSettingsInformationInput()
            UISelectionFeedbackGenerator().prepareAndGenerateFeedback()
            wireframe.navigateToSettingsInformation(input: input)
        }
        playAction
            .sink(receiveValue: navigationHandler)
            .store(in: &cancellables)
    }
}
