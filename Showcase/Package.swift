// swift-tools-version: 6.2
// Showcase apps for the Design System

import PackageDescription

let package = Package(
    name: "Showcase",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .watchOS(.v26)
    ],
    products: [
        // Shared showcase components
        .library(
            name: "ShowcaseCore",
            targets: ["ShowcaseCore"]
        ),
    ],
    dependencies: [
        // Local Design System package
        .package(path: ".."),
    ],
    targets: [
        // MARK: - Shared Core
        
        /// Shared demo data and navigation components
        .target(
            name: "ShowcaseCore",
            dependencies: [
                .product(name: "DSBase", package: "DesignSystem"),
                .product(name: "DSFormsKit", package: "DesignSystem"),
                .product(name: "DSSettingsKit", package: "DesignSystem"),
            ],
            path: "ShowcaseCore"
        ),
        
        // MARK: - Platform Apps (built via Xcode project)
        
        // Note: iOS, macOS, and watchOS app targets are defined in the 
        // Xcode project (Showcase.xcodeproj) which references this package.
        // The Swift source files for each app are in:
        // - ShowcaseiOS/
        // - ShowcasemacOS/
        // - ShowcasewatchOS/
    ]
)
