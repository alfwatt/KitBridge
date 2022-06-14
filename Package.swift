// swift-tools-version:5.0

import PackageDescription

let package = Package(
	name: "KitBridge",
/*	platforms: [
		.macOS(.v10_10),
		.iOS(.v10),
		.tvOS(.v10)
	], */
	products: [
		.library(
			name: "KitBridge",
			targets: ["KitBridge", "KitBridgeSwift"]
		)
	],
	targets: [
		.target(
			name: "KitBridge",
			path: "Sources/KitBridge"
		),
		.target(
			name: "KitBridgeSwift",
			path: "Sources/Swift"
		)		
	]
)