//
//  PickerView.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import UIKit
import Combine
import CombineExt

final class PickerView: UIView, NibLoadable, NibOwnerLoadable {

    enum Configuration {
        case gameSpeed
        case arenaSize
    }

    enum SelectedButton {
        case first
        case second
        case third
    }

    // MARK: - IBOutlets -
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var firstButton: SnakeButton!
    @IBOutlet private weak var secondButton: SnakeButton!
    @IBOutlet private weak var thirdButton: SnakeButton!

    // MARK: - Public properties -

    var contentView: UIView?

    // MARK: - Private properties -

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Extensions -

// MARK: - Configuration

extension PickerView {

    func configure(with item: PickerViewItem) {
        cancellables = []
        titleLabel.text = item.title
        setup(buttonTitlesUsing: item.configuration)
        handle(selectedButtonRelay: item.selectedButtonRelay)
        handle(
            buttonTap: firstButton.tapPublisher.asSignal(),
            selectedButton: .first,
            selectedButtonChangeRelay: item.selectedButtonRelay
        )
        handle(
            buttonTap: secondButton.tapPublisher.asSignal(),
            selectedButton: .second,
            selectedButtonChangeRelay: item.selectedButtonRelay
        )
        handle(
            buttonTap: thirdButton.tapPublisher.asSignal(),
            selectedButton: .third,
            selectedButtonChangeRelay: item.selectedButtonRelay
        )
    }
}

// MARK: - UI setup

private extension PickerView {

    func setupUI() {
        loadNibContent()
        firstButton.configure(for: .secondary, size: .small)
        secondButton.configure(for: .secondary, size: .small)
        thirdButton.configure(for: .secondary, size: .small)
    }

    func setup(buttonTitlesUsing configuration: Configuration) {
        switch configuration {
        case .gameSpeed:
            firstButton.setTitle("Slow", for: .normal)
            secondButton.setTitle("Normal", for: .normal)
            thirdButton.setTitle("Fast", for: .normal)
        case .arenaSize:
            firstButton.setTitle("Small", for: .normal)
            secondButton.setTitle("Medium", for: .normal)
            thirdButton.setTitle("Large", for: .normal)
        }
    }
}

// MARK: - Handlers

private extension PickerView {

    func handle(selectedButtonRelay: CurrentValueRelay<SelectedButton>) {
        selectedButtonRelay
            .prefix(1)
            .map { ($0, selectedButtonRelay) }
            .sink(receiveValue: { [unowned self] in handle(themeChangeUsing: $0.0, selectedButtonChangeRelay: $0.1, isInitialSetup: true) })
            .store(in: &cancellables)
    }

    func handle(
        buttonTap: Signal<Void>,
        selectedButton: SelectedButton,
        selectedButtonChangeRelay: CurrentValueRelay<SelectedButton>
    ) {
        buttonTap
            .map { (selectedButton, selectedButtonChangeRelay) }
            .sink(receiveValue: { [unowned self] in handle(themeChangeUsing: $0.0, selectedButtonChangeRelay: $0.1) })
            .store(in: &cancellables)
    }

    func handle(
        themeChangeUsing selectedButton: SelectedButton,
        selectedButtonChangeRelay: CurrentValueRelay<SelectedButton>,
        isInitialSetup: Bool = false
    ) {
        switch selectedButton {
        case .first:
            firstButton.change(theme: .primary, shouldAnimate: true)
            secondButton.change(theme: .secondary)
            thirdButton.change(theme: .secondary)
        case .second:
            firstButton.change(theme: .secondary)
            secondButton.change(theme: .primary, shouldAnimate: true)
            thirdButton.change(theme: .secondary)
        case .third:
            firstButton.change(theme: .secondary)
            secondButton.change(theme: .secondary)
            thirdButton.change(theme: .primary, shouldAnimate: true)
        }
        guard !isInitialSetup else { return }
        selectedButtonChangeRelay.accept(selectedButton)
    }
}
