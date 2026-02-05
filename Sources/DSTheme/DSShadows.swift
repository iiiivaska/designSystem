// DSShadows.swift
// DesignSystem
//
// Semantic shadow and elevation roles for the design system.
// Components use these roles for consistent depth and elevation.

import SwiftUI
import DSTokens

// MARK: - Shadow Style

/// A resolved shadow style ready for SwiftUI.
///
/// Contains all parameters needed to render a shadow,
/// already resolved for the current theme variant.
///
/// ## Usage
///
/// ```swift
/// Rectangle()
///     .shadow(
///         color: style.color,
///         radius: style.radius,
///         x: style.x,
///         y: style.y
///     )
/// ```
public struct DSShadowStyle: Sendable, Equatable {
    
    /// Shadow color with appropriate opacity.
    public let color: Color
    
    /// Horizontal shadow offset.
    public let x: CGFloat
    
    /// Vertical shadow offset.
    public let y: CGFloat
    
    /// Shadow blur radius.
    public let radius: CGFloat
    
    /// Creates a new shadow style.
    ///
    /// - Parameters:
    ///   - color: Shadow color with opacity
    ///   - x: Horizontal offset
    ///   - y: Vertical offset
    ///   - radius: Blur radius
    public init(
        color: Color,
        x: CGFloat = 0,
        y: CGFloat,
        radius: CGFloat
    ) {
        self.color = color
        self.x = x
        self.y = y
        self.radius = radius
    }
    
    /// No shadow.
    public static let none = DSShadowStyle(
        color: .clear,
        y: 0,
        radius: 0
    )
    
    /// Creates a shadow style from a definition and theme variant.
    ///
    /// - Parameters:
    ///   - definition: Raw shadow definition
    ///   - isDark: Whether dark theme is active
    /// - Returns: A resolved shadow style
    public static func from(
        _ definition: DSShadowDefinition,
        isDark: Bool
    ) -> DSShadowStyle {
        let opacity = isDark ? definition.opacityDark : definition.opacityLight
        return DSShadowStyle(
            color: Color(hex: definition.color).opacity(opacity),
            x: definition.x,
            y: definition.y,
            radius: definition.blur / 2 // SwiftUI radius is half of blur
        )
    }
}

// MARK: - Elevation Roles

/// Semantic elevation roles defining visual depth.
///
/// Elevation roles provide consistent shadow styling
/// across the design system, creating visual hierarchy.
///
/// ## Overview
///
/// | Role | Y Offset | Blur | Usage |
/// |------|----------|------|-------|
/// | ``flat`` | 0 | 0 | No elevation |
/// | ``subtle`` | 2 | 8 | Slight lift |
/// | ``raised`` | 4 | 12 | Hover states |
/// | ``elevated`` | 6 | 18 | Cards |
/// | ``overlay`` | 14 | 40 | Overlays, modals |
/// | ``floating`` | 24 | 64 | Popovers |
public struct DSElevationRoles: Sendable, Equatable {
    
    /// No elevation (flat).
    ///
    /// Elements with no shadow, may use stroke only.
    public let flat: DSShadowStyle
    
    /// Subtle elevation.
    ///
    /// Very slight lift for interactive states.
    public let subtle: DSShadowStyle
    
    /// Raised elevation.
    ///
    /// Hover states, slight depth.
    public let raised: DSShadowStyle
    
    /// Elevated elements.
    ///
    /// Default card elevation, primary containers.
    public let elevated: DSShadowStyle
    
    /// Overlay elevation.
    ///
    /// Modal sheets, dropdown menus, floating elements.
    public let overlay: DSShadowStyle
    
    /// Floating elevation.
    ///
    /// Popovers, maximum elevation.
    public let floating: DSShadowStyle
    
    /// Creates a new elevation roles instance.
    public init(
        flat: DSShadowStyle,
        subtle: DSShadowStyle,
        raised: DSShadowStyle,
        elevated: DSShadowStyle,
        overlay: DSShadowStyle,
        floating: DSShadowStyle
    ) {
        self.flat = flat
        self.subtle = subtle
        self.raised = raised
        self.elevated = elevated
        self.overlay = overlay
        self.floating = floating
    }
}

// MARK: - Border Style

/// A resolved border style ready for SwiftUI.
///
/// Contains width and color for border rendering.
public struct DSBorderStyle: Sendable, Equatable {
    
    /// Border width in points.
    public let width: CGFloat
    
    /// Border color with appropriate opacity.
    public let color: Color
    
    /// Creates a new border style.
    ///
    /// - Parameters:
    ///   - width: Border width
    ///   - color: Border color
    public init(width: CGFloat, color: Color) {
        self.width = width
        self.color = color
    }
    
    /// No border.
    public static let none = DSBorderStyle(width: 0, color: .clear)
    
    /// Creates a border style from a definition, base color, and theme variant.
    ///
    /// - Parameters:
    ///   - definition: Raw border definition
    ///   - baseColor: Base border color from theme
    ///   - isDark: Whether dark theme is active
    /// - Returns: A resolved border style
    public static func from(
        _ definition: DSBorderDefinition,
        baseColor: Color,
        isDark: Bool
    ) -> DSBorderStyle {
        let opacity = isDark ? definition.opacityDark : definition.opacityLight
        return DSBorderStyle(
            width: definition.width,
            color: baseColor.opacity(opacity)
        )
    }
}

// MARK: - Stroke Roles

/// Semantic stroke/border roles.
///
/// Stroke roles provide consistent border styling
/// for various UI states and components.
///
/// ## Overview
///
/// | Role | Width | Usage |
/// |------|-------|-------|
/// | ``default`` | 1px | Default card borders |
/// | ``strong`` | 1px | Emphasized borders |
/// | ``separator`` | 1px | List dividers |
/// | ``focusRing`` | 2px | Focus indicators |
/// | ``glass`` | 1px | Glass effect panels |
public struct DSStrokeRoles: Sendable, Equatable {
    
    /// Default stroke style.
    ///
    /// Subtle border for cards and containers.
    public let `default`: DSBorderStyle
    
    /// Strong stroke style.
    ///
    /// Emphasized borders for active states.
    public let strong: DSBorderStyle
    
    /// Separator stroke style.
    ///
    /// List dividers and section separators.
    public let separator: DSBorderStyle
    
    /// Focus ring stroke style.
    ///
    /// Keyboard focus indicators.
    public let focusRing: DSBorderStyle
    
    /// Glass panel stroke style.
    ///
    /// Borders for glass effect panels in dark theme.
    public let glass: DSBorderStyle
    
    /// Creates a new stroke roles instance.
    public init(
        default: DSBorderStyle,
        strong: DSBorderStyle,
        separator: DSBorderStyle,
        focusRing: DSBorderStyle,
        glass: DSBorderStyle
    ) {
        self.default = `default`
        self.strong = strong
        self.separator = separator
        self.focusRing = focusRing
        self.glass = glass
    }
}

// MARK: - Component Shadow Roles

/// Component-specific shadow roles.
///
/// Semantic shadows for specific UI components.
public struct DSComponentShadowRoles: Sendable, Equatable {
    
    /// Card shadow.
    public let card: DSShadowStyle
    
    /// Card shadow (flat variant).
    public let cardFlat: DSShadowStyle
    
    /// Card shadow (raised/hover).
    public let cardRaised: DSShadowStyle
    
    /// Button shadow (optional).
    public let button: DSShadowStyle
    
    /// Modal/sheet shadow.
    public let modal: DSShadowStyle
    
    /// Popover shadow.
    public let popover: DSShadowStyle
    
    /// Dropdown/menu shadow.
    public let dropdown: DSShadowStyle
    
    /// Tooltip shadow.
    public let tooltip: DSShadowStyle
    
    /// Creates a new component shadow roles instance.
    public init(
        card: DSShadowStyle,
        cardFlat: DSShadowStyle,
        cardRaised: DSShadowStyle,
        button: DSShadowStyle,
        modal: DSShadowStyle,
        popover: DSShadowStyle,
        dropdown: DSShadowStyle,
        tooltip: DSShadowStyle
    ) {
        self.card = card
        self.cardFlat = cardFlat
        self.cardRaised = cardRaised
        self.button = button
        self.modal = modal
        self.popover = popover
        self.dropdown = dropdown
        self.tooltip = tooltip
    }
}

// MARK: - DSShadows Container

/// Complete semantic shadow and elevation system.
///
/// `DSShadows` contains all shadow and border roles organized
/// by category. Components use these semantic roles for
/// consistent depth and elevation.
///
/// ## Categories
///
/// - ``elevation``: Shadow elevation levels
/// - ``stroke``: Border/stroke styles
/// - ``component``: Component-specific shadows
///
/// ## Usage
///
/// ```swift
/// @Environment(\.dsTheme) private var theme
///
/// var body: some View {
///     RoundedRectangle(cornerRadius: 14)
///         .fill(theme.colors.bg.card)
///         .shadow(
///             color: theme.shadows.elevation.elevated.color,
///             radius: theme.shadows.elevation.elevated.radius,
///             y: theme.shadows.elevation.elevated.y
///         )
///         .overlay(
///             RoundedRectangle(cornerRadius: 14)
///                 .stroke(
///                     theme.shadows.stroke.default.color,
///                     lineWidth: theme.shadows.stroke.default.width
///                 )
///         )
/// }
/// ```
///
/// ## Topics
///
/// ### Shadow Categories
///
/// - ``DSShadowStyle``
/// - ``DSElevationRoles``
/// - ``DSBorderStyle``
/// - ``DSStrokeRoles``
/// - ``DSComponentShadowRoles``
public struct DSShadows: Sendable, Equatable {
    
    /// Elevation/shadow levels.
    public let elevation: DSElevationRoles
    
    /// Border/stroke styles.
    public let stroke: DSStrokeRoles
    
    /// Component-specific shadows.
    public let component: DSComponentShadowRoles
    
    /// Creates a new shadows container.
    ///
    /// - Parameters:
    ///   - elevation: Elevation roles
    ///   - stroke: Stroke roles
    ///   - component: Component shadow roles
    public init(
        elevation: DSElevationRoles,
        stroke: DSStrokeRoles,
        component: DSComponentShadowRoles
    ) {
        self.elevation = elevation
        self.stroke = stroke
        self.component = component
    }
}
