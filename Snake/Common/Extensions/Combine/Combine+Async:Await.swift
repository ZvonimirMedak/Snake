//
//  Combine+Async:Await.swift
//  Snake
//
//  Created by Zvonimir Medak on 21.06.2022..
//

import Combine
import CombineExt

extension AnyPublisher {

    /// Create a new publisher for the given async task, returning output and finishing or erroring in case of a failure. Work can be cancelled as well.
    /// - Parameters:
    ///     - task: A work task that needs to be executed and converted into `AnyPublisher`.
    ///     - cancellationHandler: A handler that is called if a publisher needs to cancel, used to terminate pending work.
    /// - Returns: An `AnyPublisher` once the async task finished with `Output` constrained to the type of the returned value of the async task.
    static func createAsync(
        task: @escaping () async throws -> Output,
        cancellationHandler: (() -> Void)? = nil
    ) -> AnyPublisher<Output, Failure> where Failure == Error {
        return AnyPublisher.create { subscriber in
            Task {
                do {
                    let output = try await task()
                    subscriber.send(output)
                    subscriber.send(completion: .finished)
                } catch {
                    subscriber.send(completion: .failure(error))
                }
            }
            return AnyCancellable { cancellationHandler?() }
        }
    }

    /// Create a new publisher for the given async task, returning output and finishing or erroring in case of a failure. Work can be cancelled as well.
    /// - Parameters:
    ///     - task: A work task that needs to be executed and converted into `AnyPublisher`.
    ///     - cancellationHandler: A handler that is called if a publisher needs to cancel, used to terminate pending work.
    /// - Returns: An `AnyPublisher` once the async task finished with `Output` constrained to the type of the returned value of the async task. Error will not be thrown in this case.
    static func createAsyncResult(
        task: @escaping () async throws -> Output,
        cancellationHandler: (() -> Void)? = nil
    ) -> AnyPublisher<Result<Output, Failure>, Never> where Failure == Error {
        return AnyPublisher
            .createAsync(task: task, cancellationHandler: cancellationHandler)
            .mapToResult()
    }
}
