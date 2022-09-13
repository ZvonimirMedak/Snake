//
//  BaseWireframe+Progressable.swift
//  Snake
//
//  Created by Zvonimir Medak on 22.06.2022..
//

import UIKit
import MBProgressHUD

extension BaseWireframe: Progressable {

    private var hudParentView: UIView {
        viewController.view
    }

    // MARK: - Public methods -

    // MARK: - Show/hide

    func showLoading(animated: Bool) {
        showHUDLoading(blocking: true, animated: animated)
    }

    func hideLoading(animated: Bool) {
        MBProgressHUD.hide(for: hudParentView, animated: animated)
    }

    // MARK: - Failure handling

    func showFailure(with error: Error) {
        showFailure(with: nil, message: error.localizedDescription)
    }

    func showFailure(with title: String?, message: String?) {
        let actions: [UIAlertAction] = [
            .init(title: "OK", style: .default)
        ]
        openAlert(title: title, message: message, actions: actions)

        UINotificationFeedbackGenerator().prepareAndGenerateFeedback(for: .error)
    }
}

private extension BaseWireframe {

    func showHUDLoading(blocking: Bool, animated: Bool) {
        // Remove if previously added so we don't need to take care about multiple async calls to show loading
        MBProgressHUD.hide(for: hudParentView, animated: animated)
        let hud = MBProgressHUD.showAdded(to: hudParentView, animated: animated)
        hud.isUserInteractionEnabled = blocking
    }
}
