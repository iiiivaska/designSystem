// DSRadii.swift
// DesignSystem
//
// Semantic corner radius roles for the design system.
// Components use these roles for consistent rounding.

import SwiftUI
import DSTokens

// MARK: - Radius Roles

/// Semantic corner radius roles for UI components.
///
/// Radius roles provide consistent corner rounding across
/// the design system. Values are chosen to create a cohesive
/// visual language while respecting platform conventions.
///
/// ## Overview
///
/// | Role | Value | Usage |
/// |------|-------|-------|
/// | ``none`` | 0 | Sharp corners |
/// | ``xs`` | 4 | Micro elements |
/// | ``s`` | 6 | Small controls, badges |
/// | ``m`` | 10 | Fields, small cards |
/// | ``l`` | 14 | Default cards |
/// | ``xl`` | 18 | Large panels, modals |
/// | ``xxl`` | 24 | Hero containers |
/// | ``full`` | 9999 | Pill shapes |
public struct DSRadiusRoles: Sendable, Equatable {
    
    /// No radius (sharp corners).
    ///
    /// Rarely used in modern UI.
    public let none: CGFloat
    
    /// Extra small radius (4pt).
    ///
    /// Very subtle rounding for micro elements.
    public let xs: CGFloat
    
    /// Small radius (6pt).
    ///
    /// Small controls, badges, chips.
    public let s: CGFloat
    
    /// Medium radius (10pt).
    ///
    /// Text fields, small cards, buttons.
    public let m: CGFloat
    
    /// Large radius (14pt).
    ///
    /// Default card radius, standard containers.
    public let l: CGFloat
    
    /// Extra large radius (18pt).
    ///
    /// Large panels, modal sheets.
    public let xl: CGFloat
    
    /// Extra extra large radius (24pt).
    ///
    /// Hero containers, glass panels.
    public let xxl: CGFloat
    
    /// Full/pill radius (9999pt).
    ///
    /// Creates fully rounded (pill) shapes.
    public let full: CGFloat
    
    /// Creates a new radius roles instance.
    public init(
        none: CGFloat = 0,
        xs: CGFloat = 4,
        s: CGFloat = 6,
        m: CGFloat = 10,
        l: CGFloat = 14,
        xl: CGFloat = 18,
        xxl: CGFloat = 24,
        full: CGFloat = 9999
    ) {
        self.none = none
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
        self.xxl = xxl
        self.full = full
    }
}

// MARK: - Component Radius Roles

/// Component-specific corner radius roles.
///
/// These roles provide semantic mapping for specific
/// UI components, making it easy to maintain consistency.
///
/// ## Overview
///
/// | Role | Default | Component |
/// |------|---------|-----------|
/// | ``button`` | 10pt | Button corners |
/// | ``buttonSmall`` | 6pt | Small button corners |
/// | ``buttonLarge`` | 14pt | Large button corners |
/// | ``field`` | 10pt | Text field corners |
/// | ``card`` | 14pt | Card corners |
/// | ``modal`` | 18pt | Modal/sheet corners |
/// | ``badge`` | 6pt | Badge corners |
/// | ``chip`` | full | Chip/tag corners |
public struct DSComponentRadiusRoles: Sendable, Equatable {
    
    /// Button corner radius.
    ///
    /// Standard button rounding.
    public let button: CGFloat
    
    /// Small button corner radius.
    public let buttonSmall: CGFloat
    
    /// Large button corner radius.
    public let buttonLarge: CGFloat
    
    /// Text field corner radius.
    public let field: CGFloat
    
    /// Search field corner radius.
    ///
    /// Typically more rounded than standard fields.
    public let searchField: CGFloat
    
    /// Card corner radius.
    public let card: CGFloat
    
    /// Compact card corner radius.
    public let cardCompact: CGFloat
    
    /// Modal/sheet corner radius.
    public let modal: CGFloat
    
    /// Popover corner radius.
    public let popover: CGFloat
    
    /// Badge corner radius.
    public let badge: CGFloat
    
    /// Chip/tag corner radius (fully rounded).
    public let chip: CGFloat
    
    /// Toggle thumb corner radius (fully rounded).
    public let toggleThumb: CGFloat
    
    /// Creates a new component radius roles instance.
    public init(
        button: CGFloat = 10,
        buttonSmall: CGFloat = 6,
        buttonLarge: CGFloat = 14,
        field: CGFloat = 10,
        searchField: CGFloat = 14,
        card: CGFloat = 14,
        cardCompact: CGFloat = 10,
        modal: CGFloat = 18,
        popover: CGFloat = 18,
        badge: CGFloat = 6,
        chip: CGFloat = 9999,
        toggleThumb: CGFloat = 9999
    ) {
        self.button = button
        self.buttonSmall = buttonSmall
        self.buttonLarge = buttonLarge
        self.field = field
        self.searchField = searchField
        self.card = card
        self.cardCompact = cardCompact
        self.modal = modal
        self.popover = popover
        self.badge = badge
        self.chip = chip
        self.toggleThumb = toggleThumb
    }
}

// MARK: - DSRadii Container

/// Complete semantic radius system.
///
/// `DSRadii` contains all corner radius roles organized by category.
/// Components use these semantic roles for consistent rounding.
///
/// ## Categories
///
/// - ``scale``: General radius scale (xs to full)
/// - ``component``: Component-specific radii
///
/// ## Usage
///
/// ```swift
/// @Environment(\.dsTheme) private var theme
///
/// var body: some View {
///     RoundedRectangle(cornerRadius: theme.radii.component.card)
///         .fill(theme.colors.bg.card)
/// }
/// ```
///
/// ## Topics
///
/// ### Radius Categories
///
/// - ``DSRadiusRoles``
/// - ``DSComponentRadiusRoles``
public struct DSRadii: Sendable, Equatable {
    
    /// General radius scale.
    public let scale: DSRadiusRoles
    
    /// Component-specific radii.
    public let component: DSComponentRadiusRoles
    
    /// Creates a new radii container.
    ///
    /// - Parameters:
    ///   - scale: General radius scale
    ///   - component: Component-specific radii
    public init(
        scale: DSRadiusRoles,
        component: DSComponentRadiusRoles
    ) {
        self.scale = scale
        self.component = component
    }
    
    /// Creates a radii container with default values.
    public init() {
        self.scale = DSRadiusRoles()
        self.component = DSComponentRadiusRoles()
    }
}
