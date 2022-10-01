// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TwitterCounterPackage",
    platforms: [
        .iOS(.v13),
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TwitterCounterPackage",
            targets: ["TwitterCounterPackage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Reachability", url: "https://github.com/ashleymills/Reachability.swift", .upToNextMajor(from: "5.1.0")),
        .package(name: "TwitterAPIKit", url: "https://github.com/mironal/TwitterAPIKit", .upToNextMajor(from: "0.2.2")),
          .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.5.0")),

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TwitterCounterPackage",
            dependencies: ["Reachability", "TwitterAPIKit", "RxSwift"],
            path: "Sources"),
        .testTarget(
            name: "TwitterCounterPackageTests",
            dependencies: ["TwitterCounterPackage"]),
    ]
)
