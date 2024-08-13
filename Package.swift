// swift-tools-version:5.10

import PackageDescription

let package = Package(
	name: "KitBridge",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v14),
        .tvOS(.v14)
    ],
	products: [
		.library(
			name: "KitBridge",
			targets: ["KitBridge"]
		)
	],
	targets: [
		.target(
			name: "KitBridge",
			path: "Sources/KitBridge"
		)
	]
)
