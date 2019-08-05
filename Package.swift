// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "AIFlatSwitch",
    platforms: [
        .iOS(.v8), .tvOS(.v12)
    ],
    products: [
        .library(name: "AIFlatSwitch", targets: ["AIFlatSwitch"])
    ],
    dependencies: [],
    targets: [
        .target(name: "AIFlatSwitch", path: "Sources"),
        .testTarget(name: "AIFlatSwitch-Tests", dependencies: ["AIFlatSwitch"], path: "Tests")
    ],
    swiftLanguageVersions: [.v5]
)
