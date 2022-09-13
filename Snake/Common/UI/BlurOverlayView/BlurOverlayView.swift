//
//  BlurOverlayView.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//

import Foundation
import UIKit

final class BlurOverlayView: UIView {

    // MARK: - Public properties -

    @IBInspectable var overlayEffectColor: UIColor = .white {
        didSet { setupBackgroundColor(for: backgroundEffectView) }
    }
    @IBInspectable var overlayEffectAlpha: CGFloat = 0.2 {
        didSet { setupBackgroundColor(for: backgroundEffectView) }
    }

    // MARK: - Private properties -

    private var backgroundEffectView: UIVisualEffectView?

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    convenience init(overlayEffectColor: UIColor = .white, overlayEffectAlpha: CGFloat = 0.2) {
        self.init()
        self.overlayEffectColor = overlayEffectColor
        self.overlayEffectAlpha = overlayEffectAlpha
        setupUI()
    }
}

// MARK: - Extensions -

// MARK: - UI setup

private extension BlurOverlayView {

    func setupUI() {
        // Clear the background color just in case it gets set, as our `backgroundEffectView` effectively is the background.
        // This would likely only happen through the interface builder.
        backgroundColor = .clear

        self.backgroundEffectView?.removeFromSuperview()

        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        insertSubview(effectView, at: 0)
        effectView.pinToSuperview()

        setupBackgroundColor(for: effectView)

        self.backgroundEffectView = effectView
    }

    func setupBackgroundColor(for effectView: UIVisualEffectView?) {
        effectView?.subviews.forEach {
            $0.backgroundColor = overlayEffectColor.withAlphaComponent(overlayEffectAlpha)
        }
    }
}

// MARK: - Utility

extension BlurOverlayView {

    func roundCorners(cornerRadius: CGFloat, roundedCorners: UIRectCorner) {
        backgroundEffectView?.roundCorners(corners: roundedCorners, radius: cornerRadius)
        layoutIfNeeded()
    }
}
