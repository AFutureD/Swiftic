//
//  TypedDictionary.swift
//  FaceYoga
//
//  Created by Huanan on 2025/12/11.
//

// MARK: KDAnyPropertyKey

public class AnyPropertyKey: RawRepresentable, Hashable, @unchecked Sendable {
    public let rawValue: String

    public required init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public class ScopedProperty<Root>: AnyPropertyKey, @unchecked Sendable {}

public class PropertyKey<Root, Value>: ScopedProperty<Root>, @unchecked Sendable {}

extension ScopedProperty {
    typealias Key<Value> = PropertyKey<Root, Value>
}

// MARK: TypedDictionary

/// TypedDictionary
///
/// Usage:
///
/// 1. define your Namespace first.
/// ```swift
/// struct YourNamespace {
///     typealias Property = ScopedProperty<Self>
/// }
/// ```
///
/// 2. define your property keys
/// ```swift
/// extension YourNamespace.Property {
///     static let name = Key<String>(rawValue: "name")
/// }
///
/// // or
///
/// extension ScopedProperty<YourNamespace> {
///     static let name = Key<String>(rawValue: "name")
/// }
/// ```
///
/// 3. Access Property By Key
/// ```swift
/// var dic = TypedDictionary<YourNamespace>()
/// dic[.name] = "John"
/// let a = dic[.name]
///
public struct TypedDictionary<Scope> {
    public typealias Key = ScopedProperty<Scope>
    public typealias Value = Any

    private var store: [Key.RawValue: Value] = [:]

    init(_ store: [Key: Value]) {
        self.store = .init(uniqueKeysWithValues: store.map { ($0.rawValue, $1) })
    }

    subscript<T>(key: PropertyKey<Scope, T>) -> T? {
        get {
            store[key.rawValue] as? T
        }
        set {
            store[key.rawValue] = newValue
        }
    }
}

extension TypedDictionary: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(.init(uniqueKeysWithValues: elements))
    }
}
