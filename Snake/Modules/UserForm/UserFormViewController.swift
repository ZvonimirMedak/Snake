//
//  UserFormViewController.swift
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
import CombineCocoa

final class UserFormViewController: UIViewController {

    // MARK: - IBOutlets -

    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var saveButton: SnakeButton!
    @IBOutlet weak var skipButton: SnakeButton!

    // MARK: - Public properties -

    var presenter: UserFormPresenterInterface!

    // MARK: - Private properties -

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Extensions -

extension UserFormViewController: UserFormViewInterface {
}

// MARK: - View setup

private extension UserFormViewController {

    func setupView() {
        setupUI()

        let output = UserForm.ViewOutput(
            nickname: nicknameTextField.textPublisher.asDriver(),
            name: nameTextField.textPublisher.asDriver(),
            email: emailTextField.textPublisher.asDriver(),
            saveAction: saveButton.tapPublisher.asSignal(),
            skipAction: skipButton.tapPublisher.asSignal()
        )

        let input = presenter.configure(with: output)

        handle(isSaveActionEnabled: input.isSaveActionEnabled)
    }
}

// MARK: - UI setup

private extension UserFormViewController {

    func setupUI() {
        skipButton.configure(for: .tertiary)
    }
}

// MARK: - Handlers

private extension UserFormViewController {

    func handle(isSaveActionEnabled: Signal<Bool>) {
        isSaveActionEnabled
            .assignWeakified(on: saveButton, at: \.isEnabled)
            .store(in: &cancellables)
    }
}
