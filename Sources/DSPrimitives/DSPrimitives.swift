// DSPrimitives.swift
// DesignSystem
//
// Primitive UI components: DSText, DSIcon, DSSurface, DSCard, DSDivider, DSLoader, DSProgress.
// These are the basic building blocks using theme tokens.
//
// ## Overview
//
// The DSPrimitives module provides foundational UI components that
// serve as building blocks for controls and composite views.
//
// ### Text
//
// - ``DSText``: Role-based text component using theme typography
// - ``DSTextRole``: Typography roles (system and component)
//
// ### Icons
//
// - ``DSIcon``: SF Symbols wrapper with theme integration
// - ``DSIconSize``: Icon size variants (small, medium, large, xl)
// - ``DSIconColor``: Icon color modes (semantic and custom)
// - ``DSIconToken``: Common SF Symbol name constants
//
// ### Surfaces
//
// - ``DSSurface``: Semantic background container with theme colors
// - ``DSSurfaceRole``: Background role enum (canvas, surface, surfaceElevated, card)
// - ``DSCard``: Elevated card with shadow, border, and glass effect
// - ``DSDivider``: Themed horizontal/vertical divider
// - ``DSDividerOrientation``: Divider orientation (horizontal, vertical)
//
// ### Loading (Planned)
//
// - `DSLoader`: Indeterminate spinner
// - `DSProgress`: Progress bar and ring

import SwiftUI
import DSCore
import DSTheme

/// DSPrimitives module namespace.
///
/// Provides foundational UI components for the design system.
///
/// ## Topics
///
/// ### Text Components
///
/// - ``DSText``
/// - ``DSTextRole``
///
/// ### Icon Components
///
/// - ``DSIcon``
/// - ``DSIconSize``
/// - ``DSIconColor``
/// - ``DSIconToken``
///
/// ### Surface Components
///
/// - ``DSSurface``
/// - ``DSSurfaceRole``
/// - ``DSCard``
/// - ``DSDivider``
/// - ``DSDividerOrientation``
public enum DSPrimitivesModule {
    /// Current version of the primitives module.
    public static let version = "0.1.0"
}
