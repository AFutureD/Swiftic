// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swiftic",
    platforms: [.macOS(.v13), .iOS(.v16), .watchOS(.v9), .tvOS(.v16)],
    products: [
        .library(
            name: "Swiftic",
            targets: ["Swiftic"]
        ),
    ],
    targets: [
        .target(
            name: "Swiftic"
        ),
    ]
)
