// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SwiftShogi",
    products: [
        .library(
            name: "SwiftShogi",
            targets: ["SwiftShogi"]),
    ],
    targets: [
        .target(name: "SwiftShogi"),
        .testTarget(
            name: "SwiftShogiTests",
            dependencies: ["SwiftShogi"]),
    ]
)
