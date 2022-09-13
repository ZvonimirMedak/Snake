//
//  SnakeButton.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import UIKit
import Combine
import CombineCocoa

final class SnakeButton: BaseButton {

    enum Theme {
        case primary
        case secondary
        case tertiary
    }

    enum Size {
        case small
        case large
    }

    // MARK: - Public properties -

    @IBInspectable var cornerRadius: CGFloat = 12 {
        didSet { layoutIfNeeded() }
    }

    override var isEnabled: Bool {
        didSet { configure(forState: isEnabled ? .normal : .disabled) }
    }

    override var intrinsicContentSize: CGSize {
        let height: CGFloat
        switch size {
        case .large:
            height = 50
        case .small:
            height = 30
        }
        /// Additional horizontal content insets, add to intrinsic size so we don't break the current layout
        let horizontalContentInsets: CGFloat = 16

        var contentSize = super.intrinsicContentSize
        contentSize.height = height
        contentSize.width += horizontalContentInsets
        return contentSize
    }

    // MARK: - Private properties -

    private var currentState: State = .normal
    private var theme: Theme = .primary
    private var size: Size = .large
    private var cancellables: Set<AnyCancellable> = []

    /// Gradient layer of the button, which acts as the base layer for the control.
    private var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }

    // MARK: - Lifecycle -

    override class var layerClass: AnyClass { CAGradientLayer.self }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: .allCorners, radius: cornerRadius)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(for: theme, size: size)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(for: theme, size: size)
    }

    private func updateBackgroundColor(with gradientColors: [UIColor]) {
        gradientLayer.colors = gradientColors.map(\.cgColor)
        gradientLayer.locations = [0, 0.4, 0.8]
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
}

// MARK: - Extensions -

// MARK: - Configuration

extension SnakeButton {

    func configure(for theme: Theme, size: Size = .large) {
        self.theme = theme
        self.size = size
        setTitleColor(theme.titleColor, for: .normal)
        updateBackgroundColor(with: theme.backgroundColor())
        handle(titleLabelUsing: size)
    }

    func configure(with didSelect: @escaping () -> Void) {
        cancellables = []
        self.tapPublisher
            .sink(receiveValue: didSelect)
            .store(in: &cancellables)
    }

    func change(theme: Theme, shouldAnimate: Bool = false) {
        configure(for: theme, size: size)
        guard shouldAnimate else {
            animate(isSelected: false)
            return
        }
        animate(isSelected: true)
    }
}

// MARK: - Utility

private extension SnakeButton {

    func configure(forState state: State, shouldUseAnimation: Bool = true) {
        guard currentState != state else { return }
        currentState = state
        alpha = 0
        let transform: CGAffineTransform = .init(scaleX: 0.95, y: 0.95)
        animate(transform)

        configure(colorVariationFor: theme, state: state, shouldUseAnimation: shouldUseAnimation)
    }

    private func configure(colorVariationFor theme: Theme, state: State, shouldUseAnimation: Bool) {
        let color = theme.backgroundColor(for: state)

        let applyVariation: () -> Void = { [unowned self] in
            updateBackgroundColor(with: color)
            transform = .identity
            alpha = 1
        }

        let animationHandler: () -> Void = {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: [.curveEaseOut, .allowUserInteraction],
                animations: applyVariation
            )
        }
        shouldUseAnimation ? animationHandler() : applyVariation()
    }
}

// MARK: - Handlers

private extension SnakeButton {

    func handle(titleLabelUsing size: Size) {
        switch size {
        case .large:
            titleLabel?.font = .boldSystemFont(ofSize: 24)
        case .small:
            titleLabel?.font = .boldSystemFont(ofSize: 16)
        }
    }
}

// MARK: - Utility

private extension SnakeButton.Theme {

    func backgroundColor() -> [UIColor] {
        switch self {
        case .primary:
            return [.green.withAlphaComponent(0.5), .green, .green.withAlphaComponent(0.5)]
        case .secondary:
            return [.brown.withAlphaComponent(0.5), .brown, .brown.withAlphaComponent(0.5)]
        case .tertiary:
            return []
        }
    }

    func backgroundColor(for state: UIControl.State) -> [UIColor] {
        guard case .disabled = state else {
            return backgroundColor()
        }
        return [.darkGray.withAlphaComponent(0.5), .darkGray, .darkGray.withAlphaComponent(0.5)]
    }
}

// MARK: SnakeButton.Theme utility

private extension SnakeButton.Theme {

    var titleColor: UIColor {
        switch self {
        case .primary, .secondary:
            return .white
        case .tertiary:
            return .black
        }
    }
}
