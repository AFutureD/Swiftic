//
//  Function.swift
//  Swiftic
//
//  Created by Huanan on 2024/11/11.
//

public func identity<A>(_ a: A) -> A {
    return a
}

precedencegroup PipeRight {
    associativity: left
    higherThan: NilCoalescingPrecedence
}

infix operator |>: PipeRight

public func |> <T, U, E>(
    value: T?,
    function: (T) throws(E) -> U
) throws(E) -> U? {
    guard let value else { return nil }
    return try function(value)
}

public func |> <T, U>(value: T?, function: (T) -> U?) -> U? {
    guard let value else { return nil }
    return function(value)
}

public func |> <T, U, E>(
    value: T?,
    function: (T) async throws(E) -> U
) async throws(E) -> U? {
    guard let value else { return nil }
    return try await function(value)
}

public func |> <T, U>(value: T?, function: (T) async -> U?) async -> U? {
    guard let value else { return nil }
    return await function(value)
}
