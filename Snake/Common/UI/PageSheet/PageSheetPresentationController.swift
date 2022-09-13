//
//  PageSheetPresentationController.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//

import UIKit

private extension Constants {
    /// Used to adjust height and origin of the container view.
    ///
    /// This is used so that the spring animation doesn't move the entire frame of the view outside of the bottom bounds.
    static let containerViewSizeAdjustment: CGFloat = 10
}

final class PageSheetPresentationController: UIPresentationController {

    // MARK: - Private properties -

    private var dimmingView: UIView?

    // MARK: - Lifecycle -

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupUI()
    }
}

// MARK: - Extensions -

// MARK: - UIPresentationController overrides

extension PageSheetPresentationController {

    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView else { return }
        containerView?.insertSubview(dimmingView, at: 0)

        if let bounds = containerView?.bounds {
            dimmingView.frame = bounds
        }

        presentingViewController.view.isUserInteractionEnabled = false

        let transitionCoordinator = presentedViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { _ in
            dimmingView.alpha = 1
        })
    }

    override func dismissalTransitionWillBegin() {
        let transitionCoordinator = presentedViewController.transitionCoordinator

        transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            dimmingView?.alpha = 0
        })
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        presentingViewController.view.isUserInteractionEnabled = true
        super.dismissalTransitionDidEnd(completed)
    }

    override var presentedView: UIView? {
        let view = super.presentedView
        view?.frame = frameOfPresentedViewInContainerView
        return view
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let containerSize = containerView?.bounds.size ?? .zero
        let size = size(
            forChildContentContainer: presentedViewController,
            withParentContainerSize: containerSize
        )
        let origin = CGPoint(
            x: 0,
            y: containerSize.height - size.height + Constants.containerViewSizeAdjustment
        )
        return .init(origin: origin, size: size)
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let height = container.preferredContentSize.height + Constants.containerViewSizeAdjustment
        return CGSize(width: parentSize.width, height: height)
    }
}

// MARK: - UI setup

private extension PageSheetPresentationController {

    func setupUI() {
        dimmingView = UIView()
        dimmingView?.translatesAutoresizingMaskIntoConstraints = false
        dimmingView?.backgroundColor = UIColor(white: 0, alpha: 0.7)
        dimmingView?.alpha = 0
        setupTapGestureRecognizer()
    }

    func setupTapGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        dimmingView?.addGestureRecognizer(gestureRecognizer)
    }
}

// MARK: - Handlers

private extension PageSheetPresentationController {

    @objc
    func handleDismissal() {
        presentedViewController.dismiss(animated: true)
    }
}
