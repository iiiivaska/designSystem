// DSShadowScale.swift
// DesignSystem
//
// Raw shadow tokens - elevation and depth.
// These are "raw material" with no semantic meaning.

import Foundation

// MARK: - Shadow Definition

/// A raw shadow definition containing all parameters.
///
/// Represents a single shadow layer with offset, blur, spread, and opacity.
/// Can be used with both light and dark themes (opacity varies).
public struct DSShadowDefinition: Equatable, Sendable {
    /// Horizontal shadow offset in points
    public let x: CGFloat
    
    /// Vertical shadow offset in points
    public let y: CGFloat
    
    /// Shadow blur radius in points
    public let blur: CGFloat
    
    /// Shadow spread radius in points (optional, default 0)
    public let spread: CGFloat
    
    /// Shadow opacity for light theme (0.0 - 1.0)
    public let opacityLight: CGFloat
    
    /// Shadow opacity for dark theme (0.0 - 1.0)
    public let opacityDark: CGFloat
    
    /// Shadow color as hex (typically black)
    public let color: DSColorHex
    
    /// Creates a new shadow definition.
    ///
    /// - Parameters:
    ///   - x: Horizontal offset
    ///   - y: Vertical offset
    ///   - blur: Blur radius
    ///   - spread: Spread radius (default 0)
    ///   - opacityLight: Opacity for light theme
    ///   - opacityDark: Opacity for dark theme
    ///   - color: Shadow color hex (default black)
    public init(
        x: CGFloat = 0,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat = 0,
        opacityLight: CGFloat,
        opacityDark: CGFloat,
        color: DSColorHex = "#000000"
    ) {
        self.x = x
        self.y = y
        self.blur = blur
        self.spread = spread
        self.opacityLight = opacityLight
        self.opacityDark = opacityDark
        self.color = color
    }
}

// MARK: - Shadow Scale

/// Raw shadow scale for elevation levels.
///
/// Based on soft, diffused shadows matching the design references.
/// Dark theme uses higher opacity for visible depth on dark backgrounds.
///
/// ## Scale Overview
/// | Token | Y | Blur | Light Opacity | Dark Opacity | Usage |
/// |-------|---|------|---------------|--------------|-------|
/// | none | 0 | 0 | 0 | 0 | Flat elements |
/// | subtle | 2 | 8 | 0.04 | 0.08 | Very subtle lift |
/// | small | 4 | 12 | 0.06 | 0.10 | Hovered elements |
/// | medium | 6 | 18 | 0.08 | 0.12 | Cards |
/// | large | 14 | 40 | 0.12 | 0.18 | Overlays, modals |
/// | extraLarge | 24 | 64 | 0.16 | 0.24 | Popovers |
public enum DSShadow {
    /// No shadow (level 0)
    ///
    /// Flat elements, no elevation.
    public static let none = DSShadowDefinition(
        y: 0,
        blur: 0,
        opacityLight: 0,
        opacityDark: 0
    )
    
    /// Subtle shadow
    ///
    /// Very subtle lift for interactive states.
    public static let subtle = DSShadowDefinition(
        y: 2,
        blur: 8,
        opacityLight: 0.04,
        opacityDark: 0.08
    )
    
    /// Small shadow
    ///
    /// Hover states, slight elevation.
    public static let small = DSShadowDefinition(
        y: 4,
        blur: 12,
        opacityLight: 0.06,
        opacityDark: 0.10
    )
    
    /// Medium shadow (level 1) - Cards
    ///
    /// Default card elevation, primary containers.
    /// Matches reference: y=6, blur=18
    public static let medium = DSShadowDefinition(
        y: 6,
        blur: 18,
        opacityLight: 0.08,
        opacityDark: 0.12
    )
    
    /// Large shadow (level 2) - Overlays
    ///
    /// Modal sheets, dropdown menus, floating elements.
    /// Matches reference: y=14, blur=40
    public static let large = DSShadowDefinition(
        y: 14,
        blur: 40,
        opacityLight: 0.12,
        opacityDark: 0.18
    )
    
    /// Extra large shadow
    ///
    /// Popovers, maximum elevation.
    public static let extraLarge = DSShadowDefinition(
        y: 24,
        blur: 64,
        opacityLight: 0.16,
        opacityDark: 0.24
    )
}

// MARK: - Numbered Shadow Scale

/// Numbered shadow scale matching the guidelines.
///
/// Uses shadow.0, shadow.1, shadow.2 notation.
public enum DSShadowNumbered {
    /// shadow.0 - No shadow (flat)
    public static let shadow0 = DSShadow.none
    
    /// shadow.1 - Cards
    public static let shadow1 = DSShadow.medium
    
    /// shadow.2 - Overlays
    public static let shadow2 = DSShadow.large
}

// MARK: - Component Shadow Recommendations

/// Recommended shadows for common components.
///
/// These are guideline values - actual shadows are determined
/// by component specs in the theme layer.
public enum DSComponentShadow {
    /// Card shadow (default)
    public static let card = DSShadow.medium
    
    /// Card shadow (flat - stroke only)
    public static let cardFlat = DSShadow.none
    
    /// Card shadow (raised - hover state)
    public static let cardRaised = DSShadow.large
    
    /// Button shadow (optional)
    public static let button = DSShadow.subtle
    
    /// Modal/sheet shadow
    public static let modal = DSShadow.large
    
    /// Popover shadow
    public static let popover = DSShadow.extraLarge
    
    /// Dropdown/menu shadow
    public static let dropdown = DSShadow.large
    
    /// Tooltip shadow
    public static let tooltip = DSShadow.small
}

// MARK: - Border Definition

/// A raw border definition for stroke styling.
///
/// Used alongside shadows for elevated elements.
public struct DSBorderDefinition: Equatable, Sendable {
    /// Border width in points
    public let width: CGFloat
    
    /// Border opacity for light theme
    public let opacityLight: CGFloat
    
    /// Border opacity for dark theme
    public let opacityDark: CGFloat
    
    /// Creates a new border definition.
    public init(
        width: CGFloat,
        opacityLight: CGFloat,
        opacityDark: CGFloat
    ) {
        self.width = width
        self.opacityLight = opacityLight
        self.opacityDark = opacityDark
    }
}

// MARK: - Border Scale

/// Raw border definitions for strokes.
///
/// Border colors are applied from the theme's border tokens.
public enum DSBorder {
    /// Default stroke - 1px with subtle opacity
    public static let `default` = DSBorderDefinition(
        width: 1,
        opacityLight: 1.0,
        opacityDark: 0.55
    )
    
    /// Strong stroke - 1px with full opacity
    public static let strong = DSBorderDefinition(
        width: 1,
        opacityLight: 1.0,
        opacityDark: 1.0
    )
    
    /// Separator - 1px with reduced opacity
    public static let separator = DSBorderDefinition(
        width: 1,
        opacityLight: 1.0,
        opacityDark: 0.45
    )
    
    /// Focus ring - 2px
    public static let focusRing = DSBorderDefinition(
        width: 2,
        opacityLight: 0.7,
        opacityDark: 0.55
    )
    
    /// Glass border - 1px for glass effect panels
    public static let glass = DSBorderDefinition(
        width: 1,
        opacityLight: 0.3,
        opacityDark: 0.7
    )
}

// MARK: - Shadow Scale Container

/// Complete shadow scale containing all raw shadow and border tokens.
///
/// This is the central access point for all elevation tokens.
/// Values here are raw definitions - they are converted to
/// SwiftUI shadows in the theme layer.
///
/// ## Usage
/// ```swift
/// // Access named shadows
/// let cardShadow = DSShadowScale.named.medium
/// let overlayShadow = DSShadowScale.named.large
///
/// // Access numbered shadows
/// let shadow1 = DSShadowScale.numbered.shadow1 // Cards
///
/// // Access component recommendations
/// let modalShadow = DSShadowScale.component.modal
///
/// // Access border definitions
/// let defaultBorder = DSShadowScale.border.default
/// ```
public enum DSShadowScale {
    /// Named shadow tokens (none, subtle, small, medium, large, extraLarge)
    public static let named = DSShadow.self
    
    /// Numbered shadow tokens (shadow.0, shadow.1, shadow.2)
    public static let numbered = DSShadowNumbered.self
    
    /// Component-specific shadow recommendations
    public static let component = DSComponentShadow.self
    
    /// Border definitions
    public static let border = DSBorder.self
}
