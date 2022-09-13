//
//  Progressable.swift
//  Snake
//
//  Created by Zvonimir Medak on 22.06.2022..
//

import Foundation

protocol Progressable: AnyObject {
    func showLoading(animated: Bool)
    func hideLoading(animated: Bool)
    func showSuccess(animated: Bool)
    func showFailure(with error: Error)

    func showFailure(with title: String?, message: String?)
}

extension Progressable {

    func showSuccess(animated: Bool = true) {
        showSuccess(animated: animated)
    }

    func showLoading(animated: Bool = true) {
        showLoading(animated: animated)
    }
    func hideLoading(animated: Bool = true) {
        hideLoading(animated: animated)
    }

    func showFailure(with error: Error) {}
    func showFailure(with title: String?, message: String?) {}
}

/// A type that's used to determine what shape of loading needs to be shown during an asynchronous request.
enum ProgressableLoadingType {
    /// A loading type that will show a default HUD loader in the center of the screen. If `blocking` is set, the underlying view interaction will be blocked.
    /// Parameter `blocking` defaults to `true`.
    case centered(blocking: Bool = true)
}
