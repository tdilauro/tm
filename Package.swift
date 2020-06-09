// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tm",
    platforms: [
      .macOS(.v10_12)
    ],
    products: [
        .executable(
            name: "tm",
            targets: ["tm"]),
    ],
    dependencies: [
      .package(
        url:"https://github.com/apple/swift-argument-parser",
        .exact("0.1.0")),
    ],
    targets: [
        .target(
            name: "tm",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")],
            path: "tm/"
            ),
    ],
    swiftLanguageVersions: [
      .v5
    ]
)
