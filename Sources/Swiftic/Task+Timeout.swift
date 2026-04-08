//
//  Task+Timeout.swift
//  Swiftic
//
//  Created by Huanan on 2026/4/7.
//

import Foundation

/// An error thrown when a timed operation does not finish before its timeout expires.
public struct TimedOutError: Error, Equatable {}

private enum TimeoutState<T>: Sendable where T: Sendable {
    case operation(Result<T, Error>)
    case timeout(Result<Bool, Error>)
}

public extension Task {
    /// Runs an asynchronous operation until the specified deadline.
    ///
    /// The operation and a timeout task are started concurrently. If the operation
    /// completes first, its result is returned. If the deadline is reached first,
    /// this method throws ``TimedOutError``.
    ///
    /// - Parameters:
    ///   - deadline: The instant by which the operation must complete.
    ///   - tolerance: The allowed variance when waiting for the deadline.
    ///   - clock: The clock used to evaluate the deadline.
    ///   - isolation: The actor isolation inherited by the task group.
    ///   - operation: The asynchronous operation to run.
    /// - Returns: The successful result produced by `operation`.
    /// - Throws: An error thrown by `operation`, ``TimedOutError`` if the deadline
    ///   is reached first, or an error produced while waiting for the deadline.
    static func timeout<C: Clock>(
        until deadline: C.Instant,
        tolerance: C.Instant.Duration? = nil,
        clock: C = .continuous,
        isolation: isolated (any Actor)? = #isolation,
        operation: @Sendable () async throws(Failure) -> Success
    ) async throws -> Success {
        let result: Result<Success, any Error> = await withoutActuallyEscaping(operation) { operation in
            await withTaskGroup(of: TimeoutState<Success>.self, isolation: isolation) { group in

                group.addTask {
                    do {
                        let result = try await operation()
                        return .operation(.success(result))
                    } catch {
                        return .operation(.failure(error))
                    }
                }

                group.addTask {
                    do {
                        try await Task<Never, Never>.sleep(until: deadline, tolerance: tolerance, clock: clock)
                        return .timeout(.success(false))
                    } catch where Task<Never, Never>.isCancelled {
                        return .timeout(.success(true))
                    } catch {
                        return .timeout(.failure(error))
                    }
                }

                defer {
                    group.cancelAll()
                }

                for await next in group {
                    switch next {
                    case .operation(let result):
                        return result
                    case .timeout(.success(true)):
                        continue  // timeout task was cancelled
                    case .timeout(.success(false)):
                        return .failure(TimedOutError())
                    case .timeout(.failure(let error)):
                        return .failure(error)
                    }
                }

                unreachable()
            }
        }

        return try result.get()
    }
}

public extension Task {
    /// Runs an asynchronous operation for at most the specified duration.
    ///
    /// This is a convenience overload of ``timeout(until:tolerance:clock:isolation:operation:)``
    /// that computes the deadline from `clock.now` and `duration`.
    ///
    /// - Parameters:
    ///   - duration: The maximum amount of time to wait for the operation.
    ///   - tolerance: The allowed variance when waiting for the timeout.
    ///   - clock: The clock used to measure the duration.
    ///   - isolation: The actor isolation inherited by the task group.
    ///   - operation: The asynchronous operation to run.
    /// - Returns: The successful result produced by `operation`.
    /// - Throws: An error thrown by `operation`, ``TimedOutError`` if the timeout
    ///   expires first, or an error produced while waiting for the timeout.
    static func timeout<C: Clock>(
        for duration: C.Instant.Duration,
        tolerance: C.Instant.Duration? = nil,
        clock: C = .continuous,
        isolation: isolated (any Actor)? = #isolation,
        operation: @Sendable () async throws(Failure) -> Success
    ) async throws -> Success {
        try await Self.timeout(
            until: clock.now.advanced(by: duration),
            tolerance: tolerance,
            clock: clock,
            isolation: isolation,
            operation: operation
        )
    }
}
