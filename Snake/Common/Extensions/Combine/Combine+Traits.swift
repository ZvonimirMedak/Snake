//
//  Combine+Traits.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.02.2022..
//

import Combine
import CombineExt

extension Publisher {

    /// Converts current Publisher sequence to `Driver`, completing on error event.
    ///
    /// - Returns: Driver - completing on error event
    func asDriverOnErrorComplete() -> Driver<Output> {
        ignoreError().asDriver()
    }

    /// Converts current Publisher sequence to `Signal`, completing on error event.
    ///
    /// - Returns: Signal - completing on error event
    func asSignalOnErrorComplete() -> Signal<Output> {
        ignoreError().asSignal()
    }
}

extension Publisher where Failure == Never {

    /// Converts current Publisher sequence to a `Driver`. Events are received on the `Main` queue, the sequence is `shared` and `replayed`.
    ///
    /// - Returns: A `Driver` publisher.
    func asDriver() -> Driver<Output> {
        eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .share(replay: 1)
    }

    /// Converts current Publisher sequence to a `Signal`. Events are received on the `Main` queue, the sequence is `shared`.
    ///
    /// - Returns: A `Signal` publisher.
    func asSignal() -> Signal<Output> {
        eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .share(replay: 0)
    }
}

typealias Driver<Output> = Publishers.Autoconnect
<Publishers.Multicast
<Publishers.ReceiveOn
<AnyPublisher<Output, Never>, DispatchQueue>, ReplaySubject<Output, Never>>>

typealias Signal<Output> = Publishers.Autoconnect
<Publishers.Multicast
<Publishers.ReceiveOn
<AnyPublisher<Output, Never>, DispatchQueue>, ReplaySubject<Output, Never>>>
