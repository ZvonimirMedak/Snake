//
//  PageSheetAnimationController.swift
//  Snake
//
//  Created by Zvonimir Medak on 20.06.2022..
//

import UIKit

final class PageSheetAnimationController: NSObject {

    struct AnimationParameters {
        var duration: TimeInterval = 0.6
        var springDamping: CGFloat = 0.7
        var springVelocity: CGFloat = 0.4

        static var `default` = AnimationParameters(duration: 0.6, springDamping: 0.7, springVelocity: 0.4)
    }

    // MARK: - Private properties -

    private let isPresenting: Bool
    private weak var viewController: UIViewController!

    private let animationParameters: AnimationParameters

    // MARK: - Lifecycle -

    init(isPresenting: Bool, viewController: UIViewController, animationParameters: AnimationParameters = .default) {
        self.isPresenting = isPresenting
        self.viewController = viewController
        self.animationParameters = animationParameters
    }
}

// MARK: - UIViewControllerAnimatedTransitioning conformance

extension PageSheetAnimationController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationParameters.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let viewController = transitionContext.viewController(forKey: isPresenting ? .to : .from) else {
            transitionContext.completeTransition(true)
            return
        }

        if isPresenting && viewController.view.superview == nil {
            transitionContext.containerView.addSubview(viewController.view)
        }

        let frame = transitionContext.finalFrame(for: viewController)
        viewController.view.transform = isPresenting ? CGAffineTransform(translationX: 0, y: floor(frame.height)) : .identity

        let toTransform = isPresenting ? .identity : CGAffineTransform(translationX: 0, y: floor(frame.height))
        let animationCurve: UIView.AnimationOptions = transitionContext.isInteractive ? .curveLinear : .curveEaseInOut

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: transitionContext.isInteractive ? transitionDuration(using: transitionContext) : 0,
            usingSpringWithDamping: animationParameters.springDamping,
            initialSpringVelocity: animationParameters.springVelocity,
            options: [animationCurve, .allowUserInteraction],
            animations: {
                viewController.view.transform = toTransform
            }, completion: { finished in
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
            }
        )
    }
}
