//
//  Combine+Utility.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.02.2022..
//

import Foundation
import Combine

// MARK: - Utility publishers -

extension Publisher {

    func mapToVoid() -> Publishers.Map<Self, Void> {
        return map { _ in () }
    }

    func map<T>(to value: T) -> Publishers.Map<Self, T> {
        return map { _ in value }
    }

    func eraseError() -> Publishers.MapError<Self, Error> {
        return mapError { $0 as Error }
    }

    func ignoreError() -> Publishers.Catch<Self, Empty<Self.Output, Never>> {
        return self.catch { _ in Empty<Output, Never>() }
    }

    /// Prefixes elements of a sequence for the given `predicate` while also including the value at which the `prefix` operator stops.
    func inclusivePrefix(while predicate: @escaping (Self.Output) -> Bool) -> AnyPublisher<Self.Output, Failure> {
        let shared = share(replay: 1)
        // In order to get a prefix that's inclusive, we need to make use of the `share(replay:)` operator
        // First, we prefix as usual until we get all of the elements we want, for the given predicate.
        // Next, we make use of the replayed sequence to get the first value which doesn't fulfill the predicate requirement.
        return shared
            .prefix(while: predicate)
            .append(shared.first { !predicate($0) })
            .eraseToAnyPublisher()
    }
}

// MARK: Weak assign

extension Publisher {

    func assignWeakifed<T: AnyObject> (
        on object: T,
        errorAt errorSubject: PassthroughSubject<Error, Never>? = nil,
        valueAt valueKeyPath: ReferenceWritableKeyPath<T, Self.Output?>? = nil
    ) -> AnyCancellable {
        return sink(
            receiveValue: { [weak object] in
                guard let keyPath = valueKeyPath else { return }
                object?[keyPath: keyPath] = $0
            },
            receiveError: { errorSubject?.send($0) }
        )
    }

    func sink(
        receiveValue: @escaping ((Self.Output) -> Void),
        receiveError: @escaping ((Self.Failure) -> Void)
    ) -> AnyCancellable {
        return sink(
            receiveCompletion: { result in
                guard case .failure(let error) = result else { return }
                receiveError(error)
            },
            receiveValue: receiveValue
        )
    }
}

extension Publisher where Self.Failure == Never {

    func assignWeakified<T: AnyObject>(on object: T, at keyPath: ReferenceWritableKeyPath<T, Self.Output>) -> AnyCancellable {
        return sink { [weak object] in object?[keyPath: keyPath] = $0 }
    }
}

// MARK: - Utility operators

extension AnyPublisher {

    static func just(_ value: Output) -> AnyPublisher<Output, Failure> {
        return Just(value)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }

    static func error(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error)
            .eraseToAnyPublisher()
    }
}
