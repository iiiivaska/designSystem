// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .watchOS(.v26)
    ],
    products: [
        // MARK: - Core Products
        
        /// Base design system with primitives and controls
        .library(
            name: "DSBase",
            targets: ["DSCore", "DSTokens", "DSTheme", "DSPrimitives", "DSControls"]
        ),
        
        /// Forms kit with form containers, rows, and validation
        .library(
            name: "DSFormsKit",
            targets: ["DSForms"]
        ),
        
        /// Settings patterns kit with pre-built settings rows
        .library(
            name: "DSSettingsKit",
            targets: ["DSSettings"]
        ),
        
        // MARK: - Platform-Specific Products
        
        /// Complete iOS bundle with platform-specific integrations
        .library(
            name: "DS_iOS",
            targets: ["DSiOSSupport"]
        ),
        
        /// Complete macOS bundle with platform-specific integrations
        .library(
            name: "DS_macOS",
            targets: ["DSmacOSSupport"]
        ),
        
        /// Complete watchOS bundle with platform-specific integrations
        .library(
            name: "DS_watchOS",
            targets: ["DSwatchOSSupport"]
        ),
    ],
    targets: [
        // MARK: - Foundation Layer
        
        /// Core types, platform abstractions, and environment keys
        .target(
            name: "DSCore",
            path: "Sources/DSCore"
        ),
        
        /// Raw design tokens (colors, typography, spacing scales)
        .target(
            name: "DSTokens",
            path: "Sources/DSTokens"
        ),
        
        // MARK: - Theme Layer
        
        /// Theme container with semantic roles and resolver
        .target(
            name: "DSTheme",
            dependencies: ["DSCore", "DSTokens"],
            path: "Sources/DSTheme"
        ),
        
        // MARK: - Component Layer
        
        /// Primitive UI components (Text, Icon, Surface, Card, Loader)
        .target(
            name: "DSPrimitives",
            dependencies: ["DSCore", "DSTheme"],
            path: "Sources/DSPrimitives"
        ),
        
        /// Interactive controls (Button, Toggle, TextField, Picker, Stepper, Slider)
        .target(
            name: "DSControls",
            dependencies: ["DSCore", "DSTheme", "DSPrimitives"],
            path: "Sources/DSControls"
        ),
        
        // MARK: - Composite Layer
        
        /// Form containers, sections, rows, and validation
        .target(
            name: "DSForms",
            dependencies: ["DSCore", "DSTheme", "DSPrimitives", "DSControls"],
            path: "Sources/DSForms"
        ),
        
        /// Settings screen patterns and pre-built rows
        .target(
            name: "DSSettings",
            dependencies: ["DSCore", "DSTheme", "DSPrimitives", "DSControls", "DSForms"],
            path: "Sources/DSSettings"
        ),
        
        // MARK: - Platform Glue (conditionally compiled)
        
        /// iOS-specific integrations (keyboard chain, sheet pickers, haptics)
        .target(
            name: "DSiOSSupport",
            dependencies: ["DSCore", "DSTheme", "DSControls", "DSForms", "DSSettings"],
            path: "Sources/DSiOSSupport"
        ),
        
        /// macOS-specific integrations (hover, focus ring, toolbar, two-column)
        .target(
            name: "DSmacOSSupport",
            dependencies: ["DSCore", "DSTheme", "DSControls", "DSForms", "DSSettings"],
            path: "Sources/DSmacOSSupport"
        ),
        
        /// watchOS-specific integrations (navigation pickers, edit screens, large targets)
        .target(
            name: "DSwatchOSSupport",
            dependencies: ["DSCore", "DSTheme", "DSControls", "DSForms", "DSSettings"],
            path: "Sources/DSwatchOSSupport"
        ),
        
        // MARK: - Test Targets
        
        .testTarget(
            name: "DSCoreTests",
            dependencies: ["DSCore"],
            path: "Tests/DSCoreTests"
        ),
        
        .testTarget(
            name: "DSTokensTests",
            dependencies: ["DSTokens"],
            path: "Tests/DSTokensTests"
        ),
        
        .testTarget(
            name: "DSThemeTests",
            dependencies: ["DSTheme"],
            path: "Tests/DSThemeTests"
        ),
        
        .testTarget(
            name: "DSControlsTests",
            dependencies: ["DSControls"],
            path: "Tests/DSControlsTests"
        ),
        
        .testTarget(
            name: "DSFormsTests",
            dependencies: ["DSForms"],
            path: "Tests/DSFormsTests"
        ),
        
        .testTarget(
            name: "DSSettingsTests",
            dependencies: ["DSSettings"],
            path: "Tests/DSSettingsTests"
        ),
    ]
)
