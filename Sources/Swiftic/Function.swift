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

// MARK: Playgrounds

import Playgrounds

#Playground {
    do {
        enum Kind: String {
            case foo
            case bar
        }

        let rawValue: String? = "bar"
        let _: String? = rawValue |> identity(_:)

        let bar: Kind = rawValue |> Kind.init(rawValue:) ?? .foo
        assert(bar == .bar)
    }

    do {
        enum Kind: Int {
            case none = 0
            case foo = 1
            case bar = 2
        }

        let rawValue: String? = "100"
        let kind: Kind = rawValue |> Int.init |> Kind.init(rawValue:) ?? .none
        assert(kind == .none)
    }

    do {
        enum Err: Error {
            case some
        }

        enum Kind {
            case good
            case bad
        }

        let rawValue: Int? = -100
        let _: Kind = try rawValue |> {
            if $0 < 0 { throw Err.some }
            return $0 >= 100 ? .good : .bad
        } ?? .bad
    } catch {
        print(String(reflecting: error))
    }
}
