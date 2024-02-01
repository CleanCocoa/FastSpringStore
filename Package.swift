// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FastSpringStore",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .library(
            name: "FastSpringClassicStore",
            targets: ["FastSpringClassicStore"]
        )
    ],
    dependencies: [
        .package(name: "TrialLicense", url: "https://github.com/CleanCocoa/TrialLicensing.git", .upToNextMajor(from: "3.2.0")),
    ],
    targets: [
        .binaryTarget(
            name: "FsprgEmbeddedStore",
            url: "https://github.com/DivineDominion/FsprgEmbeddedStoreMac/releases/download/2.0.0/FsprgEmbeddedStore.xcframework.zip",
            checksum: "f105f849e252ee77023aa2df99bd043f6624b4fc8748b37947aab8d3b82a3d9c"
        ),
        .target(
            name: "FastSpringClassicStore",
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
