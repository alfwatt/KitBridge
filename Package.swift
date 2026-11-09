// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "KitBridge",
    platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17), .watchOS(.v10), .visionOS(.v26)],
    products: [
        .executable(name: "colorist", targets: ["colorist"]),
        .library(name: "KitBridge", type: .dynamic, targets: ["KitBridge"])
    ],
    targets: [
        .executableTarget(name: "colorist", dependencies: ["KitBridge"]),
        .target(name: "KitBridge"),
        .testTarget(name: "KitBridgeTests", dependencies: ["KitBridge"])
    ]
)
