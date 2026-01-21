# Swiftic

A collection of useful Swift extensions, operators, and utilities to boost your productivity.

## Features

### 1. Comparable Extensions
Easily clamp or bound values within ranges.

```swift
// Clamping to a closed range
42.clamped(to: 0...100)       // -> 42
Int.min.clamped(to: 0...100)  // -> 0
Int.max.clamped(to: 0...100)  // -> 100

// Clamping to partial ranges
42.clamped(to: 0...)       // -> 42
42.clamped(to: ...100)     // -> 42

// Bounding between two values (handles unordered bounds)
val.bounded(between: 10, and: 5) // Equivalent to clamping to 5...10
```

### 2. Functional Helpers
Functional programming utilities including the pipe operator `|>` and `identity`.

```swift
// Pipe operator for chaining
let result = value |> mapFunction |> anotherFunction

// Handling optionals and throwing functions
let processed = try value |> throwingFunction
```

### 3. Optional Handling
A concise way to unwrap an optional or throw an error if nil.

```swift
let value: Int? = nil
enum MyError: Error { case missing }

// Throws MyError.missing because value is nil
let unwrapped = try value ?? MyError.missing
```

### 4. Development Utilities
Helpers for marking incomplete code or impossible states.

```swift
func implementMeLater() {
    todo("Need to implement this feature") // Fatal error with "[TODO]: Need to implement this feature"
}

func handleEnum(_ value: MyEnum) {
    switch value {
    case .a: print("a")
    case .b: print("b")
    @unknown default:
        unreachable() // Fatal error with "UNREACHABLE"
    }
}
```

### 5. TypedDictionary
A type-safe wrapper around dictionaries using phantom types.

```swift
// 1. Define your Namespace
struct UserInfo {
    typealias Property = ScopedProperty<Self>
}

// 2. Define keys
extension UserInfo.Property {
    static let name = Key<String>(rawValue: "name")
    static let age = Key<Int>(rawValue: "age")
}

// 3. Usage
var dic = TypedDictionary<UserInfo>()
dic[.name] = "John"
dic[.age] = 30

let name: String? = dic[.name] // Type-safe access
```

## Installation

Add this package to your project using Swift Package Manager.

```swift
dependencies: [
    .package(url: "https://github.com/your-username/Swiftic.git", from: "1.0.0")
]
```

## Requirements

- Swift 6.0+
- macOS 14.0+
- iOS 16.0+
- watchOS 9.0+
- tvOS 16.0+

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.