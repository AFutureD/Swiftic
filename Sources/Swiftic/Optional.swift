//
//  Assert.swift
//  Swiftic
//
//  Created by Huanan on 2025/11/23.
//

/// Unwraps an optional value or throws the provided error.
///
/// This operator provides a concise way to turn an optional into a non-optional by
/// throwing a caller-specified error when the value is `nil`.
///
/// - Parameters:
///   - optional: The optional value to unwrap.
///   - error: An autoclosure that produces the error to throw when `optional` is `nil`.
/// - Returns: The unwrapped value.
/// - Throws: `E` if `optional` is `nil`.
///
/// ## Example
/// ```swift
/// enum Err: Error { case some }
///
/// let foo: Int? = 1
/// let bar: Int = try foo ?? Err.some
/// ```
@discardableResult
public func ?? <T, E: Error>(
    optional: consuming T?,
    error: @autoclosure () -> E
) throws(E) -> T where T: ~Copyable {
    guard let ret = optional else {
        throw error()
    }
    return ret
}
