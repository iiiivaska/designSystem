// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// Platform-agnostic foundation types and abstractions for the Design System.
///
/// DSCore provides the foundational data types used throughout the Design System.
/// This module contains no SwiftUI views — only pure, testable data types.
///
/// ## Overview
///
/// DSCore defines several categories of types:
///
/// - **Platform Detection**: ``DSPlatform`` and ``DSDeviceFormFactor`` for runtime platform identification
/// - **Input Modes**: ``DSInputMode`` and ``DSInputContext`` for adapting to different input methods
/// - **Accessibility**: ``DSAccessibilityPolicy`` and ``DSDynamicTypeSize`` for accessibility settings
/// - **Control States**: ``DSControlState``, ``DSInteractionState``, and ``DSSelectionState``
/// - **Validation**: ``DSValidationState``, ``DSValidationSeverity``, and ``DSValidationRule``
/// - **Environment**: SwiftUI environment keys for dependency injection
/// - **Type Erasure**: Helpers for heterogeneous view collections
///
/// ## Usage
///
/// Access current platform information:
///
/// ```swift
/// let platform = DSCore.currentPlatform
/// if platform.isMobile {
///     // Mobile-specific logic
/// }
/// ```
///
/// ## Topics
///
/// ### Module Information
///
/// - ``DSCore/version``
/// - ``DSCore/currentPlatform``
/// - ``DSCore/currentFormFactor``
///
/// ### Platform Detection
///
/// - ``DSPlatform``
/// - ``DSDeviceFormFactor``
///
/// ### Input Handling
///
/// - ``DSInputMode``
/// - ``DSInputSource``
/// - ``DSInputContext``
///
/// ### Accessibility
///
/// - ``DSAccessibilityPolicy``
/// - ``DSDynamicTypeSize``
/// - ``DSAccessibilityAdjustments``
///
/// ### Control States
///
/// - ``DSControlState``
/// - ``DSControlStateTransition``
/// - ``DSInteractionState``
/// - ``DSSelectionState``
///
/// ### Validation
///
/// - ``DSValidationState``
/// - ``DSValidationSeverity``
/// - ``DSFieldValidationResult``
/// - ``DSFormValidationResult``
/// - ``DSValidationRule``
///
/// ### Environment
///
/// - ``DSDensity``
/// - ``DSAnimationContext``
/// - ``DSThemeProtocol``
/// - ``DSCapabilitiesProtocol``
public enum DSCore {
    
    /// Current version of the Design System.
    ///
    /// Use this to verify compatibility or display version information.
    public static let version = "0.1.0"
    
    /// The current runtime platform.
    ///
    /// This is a convenience accessor for ``DSPlatform/current``.
    ///
    /// ```swift
    /// switch DSCore.currentPlatform {
    /// case .iOS:
    ///     print("Running on iOS")
    /// case .macOS:
    ///     print("Running on macOS")
    /// default:
    ///     break
    /// }
    /// ```
    public static var currentPlatform: DSPlatform {
        DSPlatform.current
    }
    
    /// The current device form factor.
    ///
    /// This is a convenience accessor for ``DSDeviceFormFactor/current``.
    public static var currentFormFactor: DSDeviceFormFactor {
        DSDeviceFormFactor.current
    }
}
