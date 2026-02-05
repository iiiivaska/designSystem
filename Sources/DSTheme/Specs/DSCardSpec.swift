// DSCardSpec.swift
// DesignSystem
//
// Card component specification with elevation levels.
// Pure data — no SwiftUI views.

import SwiftUI

// MARK: - Card Elevation

/// Elevation level for cards.
///
/// Determines the visual depth through shadow intensity,
/// border treatment, and optional glass effect.
///
/// ## Elevation Levels
///
/// | Level | Shadow | Usage |
/// |-------|--------|-------|
/// | ``flat`` | None | Subtle cards with border only |
/// | ``raised`` | Subtle | Standard cards |
/// | ``elevated`` | Medium | Prominent cards, panels |
/// | ``overlay`` | Strong | Modal overlays, floating panels |
public enum DSCardElevation: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// No shadow, border only.
    ///
    /// For subtle card containers that blend with the background.
    case flat
    
    /// Subtle shadow for standard cards.
    ///
    /// The most common elevation for content cards.
    case raised
    
    /// Medium shadow for prominent elements.
    ///
    /// Panels, selected items, expanded sections.
    case elevated
    
    /// Strong shadow for overlays.
    ///
    /// Modal sheets, floating menus, popovers.
    case overlay
}

// MARK: - DSCardSpec

/// Resolved card specification with concrete styling values.
///
/// `DSCardSpec` contains all visual properties needed to render
/// a card container, resolved for a specific elevation level.
///
/// ## Overview
///
/// Cards combine background color, border, shadow, and corner
/// radius to create layered surfaces. Dark theme cards can
/// additionally use glass effects (material backgrounds).
///
/// ## Properties
///
/// | Category | Properties |
/// |----------|-----------|
/// | Colors | ``backgroundColor``, ``borderColor`` |
/// | Border | ``borderWidth`` |
/// | Shape | ``cornerRadius`` |
/// | Shadow | ``shadow`` |
/// | Layout | ``padding`` |
/// | Glass | ``usesGlassEffect``, ``glassBorderColor`` |
///
/// ## Usage
///
/// ```swift
/// let spec = DSCardSpec.resolve(
///     theme: theme,
///     elevation: .raised
/// )
///
/// content
///     .padding(spec.padding)
///     .background(spec.backgroundColor)
///     .clipShape(RoundedRectangle(cornerRadius: spec.cornerRadius))
///     .shadow(
///         color: spec.shadow.color,
///         radius: spec.shadow.radius,
///         x: spec.shadow.x,
///         y: spec.shadow.y
///     )
///     .overlay(
///         RoundedRectangle(cornerRadius: spec.cornerRadius)
///             .stroke(spec.borderColor, lineWidth: spec.borderWidth)
///     )
/// ```
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:elevation:)``
///
/// ### Configuration
///
/// - ``DSCardElevation``
public struct DSCardSpec: DSSpec {
    
    // MARK: - Colors
    
    /// Card background color.
    public let backgroundColor: Color
    
    /// Card border color.
    public let borderColor: Color
    
    /// Card border width.
    public let borderWidth: CGFloat
    
    // MARK: - Shape
    
    /// Corner radius.
    public let cornerRadius: CGFloat
    
    // MARK: - Shadow
    
    /// Card shadow.
    public let shadow: DSShadowStyle
    
    // MARK: - Layout
    
    /// Internal card padding.
    public let padding: EdgeInsets
    
    // MARK: - Glass Effect (Dark Theme)
    
    /// Whether to use a glass/material background effect.
    ///
    /// Typically true for dark theme elevated cards.
    public let usesGlassEffect: Bool
    
    /// Border color for glass effect cards.
    public let glassBorderColor: Color
    
    // MARK: - Initialization
    
    /// Creates a card spec with explicit values.
    public init(
        backgroundColor: Color,
        borderColor: Color,
        borderWidth: CGFloat,
        cornerRadius: CGFloat,
        shadow: DSShadowStyle,
        padding: EdgeInsets,
        usesGlassEffect: Bool,
        glassBorderColor: Color
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.padding = padding
        self.usesGlassEffect = usesGlassEffect
        self.glassBorderColor = glassBorderColor
    }
}

// MARK: - Resolution

extension DSCardSpec {
    
    /// Resolves a card spec from theme and elevation level.
    ///
    /// - Parameters:
    ///   - theme: The current design system theme.
    ///   - elevation: The card elevation level.
    /// - Returns: A fully resolved ``DSCardSpec``.
    public static func resolve(
        theme: DSTheme,
        elevation: DSCardElevation
    ) -> DSCardSpec {
        let isDark = theme.isDark
        
        // Background
        let backgroundColor: Color
        switch elevation {
        case .flat:
            backgroundColor = theme.colors.bg.card
        case .raised:
            backgroundColor = theme.colors.bg.card
        case .elevated:
            backgroundColor = theme.colors.bg.surfaceElevated
        case .overlay:
            backgroundColor = theme.colors.bg.surfaceElevated
        }
        
        // Border
        let borderColor: Color
        let borderWidth: CGFloat
        switch elevation {
        case .flat:
            borderColor = theme.colors.border.subtle
            borderWidth = theme.shadows.stroke.default.width
        case .raised:
            borderColor = isDark ? theme.colors.border.subtle : .clear
            borderWidth = isDark ? theme.shadows.stroke.default.width : 0
        case .elevated:
            borderColor = isDark ? theme.colors.border.subtle : .clear
            borderWidth = isDark ? theme.shadows.stroke.default.width : 0
        case .overlay:
            borderColor = isDark ? theme.colors.border.subtle : .clear
            borderWidth = isDark ? theme.shadows.stroke.default.width : 0
        }
        
        // Shadow
        let shadow: DSShadowStyle
        switch elevation {
        case .flat:
            shadow = theme.shadows.component.cardFlat
        case .raised:
            shadow = theme.shadows.component.card
        case .elevated:
            shadow = theme.shadows.component.cardRaised
        case .overlay:
            shadow = theme.shadows.elevation.overlay
        }
        
        // Corner radius
        let cornerRadius = theme.radii.component.card
        
        // Padding
        let padding = theme.spacing.insets.card
        
        // Glass effect: only for dark theme elevated/overlay cards
        let usesGlassEffect = isDark && (elevation == .elevated || elevation == .overlay)
        let glassBorderColor = isDark
            ? theme.shadows.stroke.glass.color
            : .clear
        
        return DSCardSpec(
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            cornerRadius: cornerRadius,
            shadow: shadow,
            padding: padding,
            usesGlassEffect: usesGlassEffect,
            glassBorderColor: glassBorderColor
        )
    }
}
