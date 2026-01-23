//
//  Assert.swift
//  Swiftic
//
//  Created by Huanan on 2025/11/23.
//

@discardableResult
public func require<T>(
    _ expression: @autoclosure () -> T?,
    as type: T.Type = T.self,
    message: @autoclosure () -> String = String(),
    file: String = #fileID,
    line: Int = #line
) -> T {
    expression() ?? fatalError(message())
}

@discardableResult
public func require<T, E: Error>(
    _ expression: @autoclosure () -> T?,
    as type: T.Type = T.self,
    error: @autoclosure () -> E,
    file: String = #fileID,
    line: Int = #line
) throws(E) -> T {
    try expression() ?? error()
}

public func expect<E: Error>(
    _ expression: @autoclosure () -> Bool,
    error: @autoclosure () -> E,
    file: String = #fileID,
    line: Int = #line
) throws(E) {
    if !expression() { throw error() }
}

public func expect<T, E: Error>(
    nil expression: @autoclosure () -> T?,
    as type: T.Type = T.self,
    error: @autoclosure () -> E,
    file: String = #fileID,
    line: Int = #line
) throws(E) {
    try expect(expression() == nil, error: error(), file: file, line: line)
}


// MARK: Playgrounds

import Playgrounds

#Playground {
    enum Err: Error {
        case some
    }

    do {
        let foo: Int? = 100
        let bar = require(foo)
    }

    do {
        let foo: Int? = 100
        let bar = try require(foo, error: Err.some)
    }
    
    do {
        try require(true, error: Err.some)
    }

    do {
        try expect(nil: nil, as: Bool.self, error: Err.some)
    }
}
