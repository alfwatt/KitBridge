// swift-tools-version:5.10

import PackageDescription

let package = Package(
	name: "KitBridge",
    platforms: [.macOS(.v10_14), .iOS(.v14), .tvOS(.v14)],
	products: [
        .executable(name: "colorist", targets: ["colorist"]),
        .library(name: "KitBridge", type: .dynamic, targets: ["KitBridge", "KitBridgeSwift"])
	],
	targets: [
        .executableTarget(name: "colorist", dependencies: ["KitBridge"]),
		.target(
			name: "KitBridge"
		),
        .target(
            name: "KitBridgeSwift",
            dependencies: ["KitBridge"]
        )
	]
)
