//
//  Combine+Progressable.swift
//  Snake
//
//  Created by Zvonimir Medak on 22.06.2022..
//

import Foundation
import Combine

extension Publisher {

    /// Shows loading on subscribe event
    func handleShowLoading(
        with progressable: Progressable,
        animated: Bool = true
    ) -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.main)
            .handleEvents(receiveSubscription: { [unowned progressable] _ in progressable.showLoading(animated: animated) })
            .eraseToAnyPublisher()
    }

    /// Hides loading on first next event or completed event
    func handleHideLoading(
        with progressable: Progressable,
        animated: Bool = true
    ) -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.main)
            .handleEvents(
                receiveOutput: { [unowned progressable] _ in progressable.hideLoading(animated: animated) },
                receiveCompletion: { [unowned progressable] _ in progressable.hideLoading(animated: animated) }
            )
            .eraseToAnyPublisher()
    }

    /// Shows loading on subscribe event and hides loading on
    /// first next event or completed event
    func handleLoading(
        with progressable: Progressable,
        animated: Bool = true
    ) -> AnyPublisher<Output, Failure> {
        handleShowLoading(with: progressable, animated: animated)
            .handleHideLoading(with: progressable, animated: animated)
            .eraseToAnyPublisher()
    }

    /// Shows failure on error event.
    func handleShowFailure(
        with progressable: Progressable,
        animated: Bool = true
    ) -> AnyPublisher<Output, Failure> {
        let completionHandler: (Subscribers.Completion<Self.Failure>) -> Void = { [unowned progressable] completion in
            guard case .failure(let error) = completion else { return }
            progressable.hideLoading(animated: animated)
            progressable.showFailure(with: error)
        }
        return receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: completionHandler)
            .eraseToAnyPublisher()
    }

    /// Shows loading on subscribe event, hides loading on next
    /// event or error event and shows failure on error event.
    func handleLoadingAndError(
        with progressable: Progressable,
        animated: Bool = true
    ) -> AnyPublisher<Output, Failure> {
        handleLoading(with: progressable, animated: animated)
            .handleShowFailure(with: progressable, animated: animated)
    }

    /// Shows loading on subscribe event, hides loading on next
    /// event or error event and shows failure on error event.
    func handleShowLoadingAndError(
        with progressable: Progressable,
        animated: Bool = true
    ) -> AnyPublisher<Output, Failure> {
        handleShowLoading(with: progressable, animated: animated)
            .handleEvents(receiveCompletion: { completion in
                guard case .failure = completion else { return }
                progressable.hideLoading(animated: animated)
            })
            .handleShowFailure(with: progressable, animated: animated)
    }

    /// Shows loading on subscribe event, hides loading on next
    /// event or error event and shows failure on error event.
    func handleHideLoadingAndShowError(
        with progressable: Progressable,
        type: ProgressableLoadingType = .centered(),
        animated: Bool = true
    ) -> AnyPublisher<Output, Failure> {
        handleHideLoading(with: progressable, animated: animated)
            .handleShowFailure(with: progressable, animated: animated)
    }
}
