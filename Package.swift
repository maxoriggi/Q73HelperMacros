// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Q73HelperMacros",
    platforms: [.macOS(.v11), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Q73HelperMacros",
            targets: ["Q73HelperMacros"]
        ),
        .executable(
            name: "Q73HelperMacrosClient",
            targets: ["Q73HelperMacrosClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/sindresorhus/Defaults.git", from: "8.2.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "Q73HelperMacrosSources",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "Q73HelperMacros", dependencies: ["Q73HelperMacrosSources"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "Q73HelperMacrosClient", dependencies: ["Q73HelperMacros", "Defaults"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "Q73HelperMacrosTests",
            dependencies: [
                "Q73HelperMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
