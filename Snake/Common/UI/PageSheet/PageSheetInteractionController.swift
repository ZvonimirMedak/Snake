//
//  PageSheetInteractionController.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//

import UIKit

final class PageSheetInteractionController: UIPercentDrivenInteractiveTransition {

    // MARK: - Public properties

    var isInteractionInProgress = false
    var shouldUseInteractiveTransition = true

    // MARK: - Private properties

    private weak var viewController: UIViewController!

    // MARK: - Init -

    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
        setupPanGestureRecognizer(in: viewController.view)
    }
}

// MARK: - Extensions

// MARK: - UI setup

private extension PageSheetInteractionController {

    func setupPanGestureRecognizer(in view: UIView) {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDownSwipeGesture(gestureRecognizer:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
}

// MARK: - Handlers

private extension PageSheetInteractionController {

    @objc
    private func handleDownSwipeGesture(gestureRecognizer: UIPanGestureRecognizer) {
        let percentHandler: () -> CGFloat = {
            guard let view = gestureRecognizer.view else { return 0 }
            let translation = gestureRecognizer.translation(in: view).y
            let progress = translation / (view.frame.height * 3)
            return CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        }

        let beganStateHandler: () -> Void = { [unowned self] in
            guard percentHandler() > 0 else { return }
            isInteractionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
        }

        let changedStateHandler: () -> Void = { [unowned self] in
            if percentHandler() > 0 && !isInteractionInProgress {
                isInteractionInProgress = true
                viewController.dismiss(animated: true, completion: nil)
            }
            update(percentHandler())
        }

        let cancelledStateHandler: () -> Void = { [unowned self] in
            isInteractionInProgress = false
            handleFinishOrCancel(
                for: percentHandler(),
                gestureVelocityInFinishDirection: -gestureRecognizer.velocity(in: viewController.view).y
            )
        }

        switch gestureRecognizer.state {
        case .began:
            beganStateHandler()
        case .changed:
            changedStateHandler()
        case .cancelled, .ended:
            cancelledStateHandler()
        case .possible, .failed:
            cancel()
        @unknown default:
            assertionFailure("Unhandled case on GestureRecognizer.State")
            cancel()
        }
    }

    private func handleFinishOrCancel(for percentComplete: CGFloat, gestureVelocityInFinishDirection: CGFloat) {
        if percentComplete > 0.3 || gestureVelocityInFinishDirection < -150 {
            completionSpeed = 1.0
            finish()
        } else {
            completionSpeed = 0.3
            cancel()
        }
    }
}
