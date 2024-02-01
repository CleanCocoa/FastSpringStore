// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FastSpringStore",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .library(
            name: "FastSpringStore",
            targets: ["FastSpringStore"]
        )
    ],
    dependencies: [
        .package(name: "TrialLicense", url: "https://github.com/CleanCocoa/TrialLicensing.git", .upToNextMajor(from: "3.2.0")),
    ],
    targets: [
        .binaryTarget(
            name: "FsprgEmbeddedStore",
            path: "../Carthage/Build/FsprgEmbeddedStore.xcframework"
        ),
        .target(
            name: "FastSpringStore",
            dependencies: [
                "TrialLicense",
                .target(name: "FsprgEmbeddedStore"),
            ],
            resources: [
                .copy("FastSpringStoreWindowController.xib"),
            ]
        )
    ]
)
