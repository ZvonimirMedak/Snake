//
//  CheckboxView.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import UIKit
import Combine
import CombineCocoa
import CombineExt
import SnapKit

// MARK: - Constants -

private extension Constants {
    static let checkboxButtonSize = 24
}

final class CheckboxView: UIView {

    // MARK: - Public properties -

    var text: String {
        get { textLabel?.text ?? "" }
        set { textLabel?.text = newValue }
    }

    var isSelected: Bool {
        get { checkboxButton.isSelected }
        set { handleSelectionChange(newValue: newValue, oldValue: checkboxButton.isSelected) }
    }

    var selectionChangedPublisher: Signal<Bool> {
        selectionRelay.asSignal()
    }

    var tapPublisher: Signal<Void> {
        checkboxButton.tapPublisher.asSignal()
    }

    // MARK: - Private properties -

    private var containerView: UIStackView!
    private var checkboxButton: UIButton!
    private var textLabel: UILabel?

    private let selectionRelay = CurrentValueRelay<Bool>(false)

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle -

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func configure(with contentView: UIView) {
        containerView.removeFromSuperview()
        setupUI(contentView: contentView)
    }

    func configure(with didSelect: @escaping (Bool) -> Void) {
        selectionRelay
            .sink(receiveValue: didSelect)
            .store(in: &cancellables)
    }
}

// MARK: - Extensions -

// MARK: - UI setup

private extension CheckboxView {

    func setupUI(contentView: UIView? = nil) {
        let checkboxContainerView = setupCheckboxContainerView()
        let contentView = contentView ?? setupTextLabel()
        let mainContainerView = setupContainerView(
            using: checkboxContainerView,
            contentView: contentView
        )

        addSubview(mainContainerView)
        containerView = mainContainerView
        mainContainerView.snp.makeConstraints { $0.edges.equalTo(self) }

        handle(selection: checkboxButton.tapPublisher.asDriver())
    }

    func setupCheckboxContainerView() -> UIStackView {
        let size = Constants.checkboxButtonSize
        checkboxButton = UIButton(type: .custom)
        checkboxButton.adjustsImageWhenHighlighted = false
        checkboxButton.setImage(UIImage(named: "checked-checkbox"), for: .selected)
        checkboxButton.setImage(UIImage(named: "unchecked-checkbox"), for: .normal)

        let spacerView = UIView()
        let stackview = UIStackView(arrangedSubviews: [checkboxButton, spacerView])
        stackview.axis = .vertical

        checkboxButton.snp.makeConstraints { $0.height.width.equalTo(size) }

        return stackview
    }

    func setupContainerView(
        using checkboxContainerView: UIStackView,
        contentView: UIView
    ) -> UIStackView {
        let stackview = UIStackView(arrangedSubviews: [checkboxContainerView, contentView])
        stackview.alignment = .center
        stackview.axis = .horizontal
        stackview.spacing = 16

        contentView.snp.makeConstraints { $0.height.equalTo(stackview) }

        return stackview
    }

    func setupTextLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }
}

// MARK: - Handlers

private extension CheckboxView {

    func handle(selection: Driver<Void>) {
        selection
            .map { [unowned self] in isSelected }
            .map(!)
            .handleEvents(receiveOutput: { [unowned self] in isSelected = $0 })
            .selectionHapticFeedback()
            .eraseToAnyPublisher()
            .bind(to: selectionRelay)
            .store(in: &cancellables)
    }
}

// MARK: - Animation

private extension CheckboxView {

    func handleSelectionChange(newValue: Bool, oldValue: Bool) {
        checkboxButton.isSelected = newValue

        guard newValue != oldValue else { return }
        animate(.init(scaleX: 1.2, y: 1.2))
    }

    func animate(_ transform: CGAffineTransform, isCompletion: Bool = false) {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.65,
            options: [.curveEaseInOut, .allowUserInteraction, .transitionCrossDissolve],
            animations: { self.checkboxButton.transform = transform },
            completion: { _ in
                guard !isCompletion else { return }
                self.animate(.identity, isCompletion: true)
            }
        )
    }
}

