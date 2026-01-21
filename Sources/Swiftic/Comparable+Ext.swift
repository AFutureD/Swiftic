//
//  Comparable+Ext.swift
//  Swiftic
//
//  Created by Huanan on 2025/8/21.
//

public extension Comparable {
    /// Returns `self` if it is contained within `limits`; otherwise,
    /// returns `limits.lowerBound` or `limits.upperBound`.
    ///
    ///     42.clamped(to: 0...100)       //-> 42
    ///     Int.min.clamped(to: 0...100)  //-> 0
    ///     Int.max.clamped(to: 0...100)  //-> 100
    ///
    /// - Parameter limits: The range with which to clamp `self`.
    func clamped(to limits: ClosedRange<Self>) -> Self {
        clamped(to: limits.lowerBound...)
            .clamped(to: ...limits.upperBound)
    }

    /// Returns `self` if it is contained within `limits`; otherwise,
    /// returns `limits.lowerBound`.
    ///
    ///     42.clamped(to: 0...)       //-> 42
    ///     Int.min.clamped(to: 0...)  //-> 0
    ///     Int.max.clamped(to: 0...)  //-> Int.max
    ///
    /// - Parameter limits: The range with which to clamp `self`.
    func clamped(to limits: PartialRangeFrom<Self>) -> Self {
        limits.contains(self) ? self : limits.lowerBound
    }

    /// Returns `self` if it is contained within `limits`; otherwise,
    /// returns `limits.upperBound`.
    ///
    ///     42.clamped(to: ...100)       //-> 42
    ///     Int.min.clamped(to: ...100)  //-> Int.min
    ///     Int.max.clamped(to: ...100)  //-> 100
    ///
    /// - Parameter limits: The range with which to clamp `self`.
    func clamped(to limits: PartialRangeThrough<Self>) -> Self {
        limits.contains(self) ? self : limits.upperBound
    }
}

public extension Strideable where Stride: SignedInteger {
    /// Returns `self` if it is contained within `limits`; otherwise,
    /// returns `limits.upperBound.advanced(by: -1)`.
    ///
    ///     42.clamped(to: ..<Int.min)   //-> Fatal error!
    ///     42.clamped(to: ..<100)       //-> 42
    ///     Int.min.clamped(to: ..<100)  //-> Int.min
    ///     Int.max.clamped(to: ..<100)  //-> 99
    ///
    /// - Parameter limits: The range with which to clamp `self`.
    func clamped(to limits: PartialRangeUpTo<Self>) -> Self {
        limits.contains(self) ? self : limits.upperBound.advanced(by: -1)
    }

    /// Returns `self` if it is contained within `limits`; otherwise,
    /// returns `limits.lowerBound` or `limits.upperBound.advanced(by: -1)`.
    ///
    ///     42.clamped(to: 0..<0)         //-> Fatal error!
    ///     42.clamped(to: 0..<100)       //-> 42
    ///     Int.min.clamped(to: 0..<100)  //-> 0
    ///     Int.max.clamped(to: 0..<100)  //-> 99
    ///
    /// - Parameter limits: The *non-empty* range with which to clamp `self`.
    func clamped(to limits: Range<Self>) -> Self {
        clamped(to: limits.lowerBound...)
            .clamped(to: ..<limits.upperBound)
    }
}

public extension Comparable {
    func bounded(between lower: Self, and uppper: Self) -> Self {
        if lower < uppper {
            clamped(to: lower ... uppper)
        } else {
            clamped(to: uppper ... lower)
        }
    }
}
