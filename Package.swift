// swift-tools-version: 6.2


import PackageDescription


let package = Package(
    name: "TrailingClosureIllustrations",
    platforms: [
        .iOS(.v26),
        .macOS(.v26)
    ],
    products: [
        .library(
            name: "TrailingClosureIllustrations",
            targets: ["TrailingClosureIllustrations"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/lopsae/preview-utilities.git", branch: "feature/documentation-second-batch")
    ],
    targets: [
        .target(
            name: "TrailingClosureIllustrations",
            dependencies: [
                .product(name: "PreviewUtilities", package: "preview-utilities")
            ],
            path: "sources"
        ),
        .testTarget(
            name: "Renders",
            dependencies: [
                "TrailingClosureIllustrations"
            ],
            path: "renders",
            exclude: [
                "Renders.xctestplan",
            ]
        )
    ]
)


// Target settings.
for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(contentsOf: [
        // https://developer.apple.com/documentation/xcode/build-settings-reference#Approachable-Concurrency
        // https://developer.apple.com/documentation/xcode/build-settings-reference#Approachable-Concurrency
        // https://useyourloaf.com/blog/approachable-concurrency-in-swift-packages/
        // https://www.avanderlee.com/concurrency/approachable-concurrency-in-swift-6-2-a-clear-guide/

        .defaultIsolation(MainActor.self),

        // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),

        // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0470-isolated-conformances.md
        .enableUpcomingFeature("InferIsolatedConformances")
    ])
    target.swiftSettings = settings
}
