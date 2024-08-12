// swift-tools-version:5.0

import PackageDescription

let package = Package(
	name: "KitBridge",
    platforms: [
        .macOS(.v14),
        .iOS(.v15),
        .tvOS(.v15)
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
