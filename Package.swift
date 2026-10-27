// swift-tools-version: 5.9
import PackageDescription

// Apple framework code must be compiled on macOS. Linux tests exercise only Core.
var products: [Product] = [.library(name: "TapDrumCore", targets: ["TapDrumCore"])]
var targets: [Target] = [
    .target(name: "TapDrumCore"),
    .testTarget(name: "TapDrumCoreTests", dependencies: ["TapDrumCore"])
]
#if os(macOS)
products.append(.executable(name: "TapDrum", targets: ["TapDrumApp"]))
targets.append(.executableTarget(name: "TapDrumApp", dependencies: ["TapDrumCore"]))
#endif

let package = Package(
    name: "TapDrum",
    platforms: [.macOS(.v14)],
    products: products,
    targets: targets,
    swiftLanguageVersions: [.v5]
)
