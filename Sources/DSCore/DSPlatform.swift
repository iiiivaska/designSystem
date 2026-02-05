import Foundation

// MARK: - DSPlatform

/// Represents the current runtime platform.
///
/// Use `DSPlatform` to abstract platform differences and enable capability-based
/// behavior rather than scattered `#if os()` checks throughout your codebase.
///
/// ## Overview
///
/// This is the **only** file in DSCore that uses `#if os()` conditionals.
/// All other code should query ``DSPlatform/current`` instead.
///
/// ```swift
/// let platform = DSPlatform.current
///
/// if platform.isMobile {
///     // Use mobile-optimized layout
/// }
///
/// if platform.supportsPointerInput {
///     // Enable hover states
/// }
/// ```
///
/// ## Topics
///
/// ### Getting the Current Platform
///
/// - ``current``
///
/// ### Platform Cases
///
/// - ``iOS``
/// - ``macOS``
/// - ``watchOS``
/// - ``tvOS``
/// - ``visionOS``
/// - ``unknown``
///
/// ### Platform Characteristics
///
/// - ``isMobile``
/// - ``supportsPointerInput``
/// - ``isTouchPrimary``
/// - ``isWearable``
/// - ``supportsMultipleWindows``
public enum DSPlatform: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// iOS platform (iPhone, iPad).
    case iOS
    
    /// macOS desktop platform.
    case macOS
    
    /// watchOS platform (Apple Watch).
    case watchOS
    
    /// tvOS platform (Apple TV).
    ///
    /// - Note: Reserved for future compatibility.
    case tvOS
    
    /// visionOS platform (Apple Vision Pro).
    ///
    /// - Note: Reserved for future compatibility.
    case visionOS
    
    /// Unknown or unsupported platform.
    case unknown
}

// MARK: - Platform Detection

extension DSPlatform {
    
    /// The current runtime platform.
    ///
    /// This is the single source of truth for platform detection.
    /// All platform-specific behavior should query this property
    /// rather than using `#if os()` directly.
    ///
    /// ```swift
    /// let platform = DSPlatform.current
    /// print("Running on \(platform.rawValue)")
    /// ```
    ///
    /// - Important: This is compile-time determined and cannot change at runtime.
    public static var current: DSPlatform {
        #if os(iOS)
        return .iOS
        #elseif os(macOS)
        return .macOS
        #elseif os(watchOS)
        return .watchOS
        #elseif os(tvOS)
        return .tvOS
        #elseif os(visionOS)
        return .visionOS
        #else
        return .unknown
        #endif
    }
    
    /// Whether this platform is a mobile device.
    ///
    /// Returns `true` for ``iOS`` and ``watchOS``.
    ///
    /// ```swift
    /// if DSPlatform.current.isMobile {
    ///     // Use touch-optimized controls
    /// }
    /// ```
    public var isMobile: Bool {
        switch self {
        case .iOS, .watchOS:
            return true
        case .macOS, .tvOS, .visionOS, .unknown:
            return false
        }
    }
    
    /// Whether this platform supports pointer input (mouse/trackpad).
    ///
    /// Returns `true` for ``macOS`` and ``visionOS``.
    ///
    /// - Note: iPad with trackpad support is determined by runtime capabilities,
    ///   not platform. See ``DSCapabilitiesProtocol/supportsHover``.
    public var supportsPointerInput: Bool {
        switch self {
        case .macOS, .visionOS:
            return true
        case .iOS, .watchOS, .tvOS, .unknown:
            return false
        }
    }
    
    /// Whether this platform is primarily touch-based.
    ///
    /// Returns `true` for ``iOS`` and ``watchOS``.
    public var isTouchPrimary: Bool {
        switch self {
        case .iOS, .watchOS:
            return true
        case .macOS, .tvOS, .visionOS, .unknown:
            return false
        }
    }
    
    /// Whether this platform is a wearable device.
    ///
    /// Returns `true` only for ``watchOS``.
    public var isWearable: Bool {
        self == .watchOS
    }
    
    /// Whether this platform supports multiple windows.
    ///
    /// Returns `true` for ``macOS`` and ``visionOS``.
    ///
    /// - Note: iPad split view is not considered multiple windows.
    public var supportsMultipleWindows: Bool {
        switch self {
        case .macOS, .visionOS:
            return true
        case .iOS, .watchOS, .tvOS, .unknown:
            return false
        }
    }
}

// MARK: - DSDeviceFormFactor

/// Represents the device form factor independent of platform.
///
/// Use `DSDeviceFormFactor` to adapt layouts based on physical device
/// characteristics rather than OS.
///
/// ## Overview
///
/// ```swift
/// let formFactor = DSDeviceFormFactor.current
///
/// if formFactor.isCompact {
///     // Use single-column layout
/// } else {
///     // Use multi-column layout
/// }
/// ```
///
/// - Note: This provides compile-time detection. For runtime iPad vs iPhone
///   detection, use `UIDevice.current.userInterfaceIdiom`.
///
/// ## Topics
///
/// ### Getting the Current Form Factor
///
/// - ``current``
///
/// ### Form Factor Cases
///
/// - ``phone``
/// - ``tablet``
/// - ``desktop``
/// - ``watch``
/// - ``tv``
/// - ``spatial``
/// - ``unknown``
///
/// ### Form Factor Characteristics
///
/// - ``isCompact``
/// - ``prefersLandscape``
public enum DSDeviceFormFactor: String, Sendable, Equatable, Hashable {
    
    /// Compact phone form factor.
    case phone
    
    /// Tablet or large screen form factor.
    case tablet
    
    /// Desktop computer form factor.
    case desktop
    
    /// Watch or wearable form factor.
    case watch
    
    /// TV or large display form factor.
    case tv
    
    /// Spatial computing form factor.
    case spatial
    
    /// Unknown form factor.
    case unknown
}

extension DSDeviceFormFactor {
    
    /// The current device form factor.
    ///
    /// - Note: This is compile-time only. For runtime iPad vs iPhone detection,
    ///   use `UIDevice.current.userInterfaceIdiom`.
    ///
    /// - Important: On iOS, this returns ``phone`` at compile time. Use runtime
    ///   detection for accurate iPad identification.
    public static var current: DSDeviceFormFactor {
        #if os(iOS)
        return .phone
        #elseif os(macOS)
        return .desktop
        #elseif os(watchOS)
        return .watch
        #elseif os(tvOS)
        return .tv
        #elseif os(visionOS)
        return .spatial
        #else
        return .unknown
        #endif
    }
    
    /// Whether this form factor has a compact screen.
    ///
    /// Returns `true` for ``phone`` and ``watch``.
    ///
    /// Use this to determine if a single-column layout is appropriate.
    public var isCompact: Bool {
        switch self {
        case .phone, .watch:
            return true
        case .tablet, .desktop, .tv, .spatial, .unknown:
            return false
        }
    }
    
    /// Whether this form factor typically uses landscape orientation.
    ///
    /// Returns `true` for ``desktop`` and ``tv``.
    public var prefersLandscape: Bool {
        switch self {
        case .desktop, .tv:
            return true
        case .phone, .tablet, .watch, .spatial, .unknown:
            return false
        }
    }
}
