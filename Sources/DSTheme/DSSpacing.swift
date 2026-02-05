// DSSpacing.swift
// DesignSystem
//
// Semantic spacing roles for the design system.
// Components use these roles for consistent layout.

import SwiftUI
import DSCore
import DSTokens

// MARK: - Padding Roles

/// Semantic padding roles for component interiors.
///
/// Padding roles define consistent internal spacing within
/// components and containers.
///
/// ## Overview
///
/// | Role | Regular | Usage |
/// |------|---------|-------|
/// | ``xxs`` | 2pt | Micro padding |
/// | ``xs`` | 4pt | Icon-to-text gaps |
/// | ``s`` | 8pt | Inline spacing |
/// | ``m`` | 12pt | Component padding |
/// | ``l`` | 16pt | Section padding |
/// | ``xl`` | 24pt | Large gaps |
/// | ``xxl`` | 32pt | Section separators |
public struct DSPaddingRoles: Sendable, Equatable {
    
    /// Extra extra small padding (2pt).
    ///
    /// Micro spacing for very tight layouts.
    public let xxs: CGFloat
    
    /// Extra small padding (4pt).
    ///
    /// Icon-to-text gaps, badge padding.
    public let xs: CGFloat
    
    /// Small padding (8pt).
    ///
    /// Inline spacing, list item gaps.
    public let s: CGFloat
    
    /// Medium padding (12pt).
    ///
    /// Component internal padding, row spacing.
    public let m: CGFloat
    
    /// Large padding (16pt).
    ///
    /// Card padding, section padding, standard gaps.
    public let l: CGFloat
    
    /// Extra large padding (24pt).
    ///
    /// Large gaps between sections.
    public let xl: CGFloat
    
    /// Extra extra large padding (32pt).
    ///
    /// Section separators, large margins.
    public let xxl: CGFloat
    
    /// Creates a new padding roles instance.
    public init(
        xxs: CGFloat,
        xs: CGFloat,
        s: CGFloat,
        m: CGFloat,
        l: CGFloat,
        xl: CGFloat,
        xxl: CGFloat
    ) {
        self.xxs = xxs
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
        self.xxl = xxl
    }
    
    /// Creates padding roles with a density multiplier.
    ///
    /// - Parameters:
    ///   - base: Base padding values
    ///   - density: Density setting to apply
    /// - Returns: Adjusted padding roles
    public static func withDensity(_ base: DSPaddingRoles, density: DSDensity) -> DSPaddingRoles {
        let multiplier = density.spacingMultiplier
        return DSPaddingRoles(
            xxs: base.xxs * multiplier,
            xs: base.xs * multiplier,
            s: base.s * multiplier,
            m: base.m * multiplier,
            l: base.l * multiplier,
            xl: base.xl * multiplier,
            xxl: base.xxl * multiplier
        )
    }
}

// MARK: - Gap Roles

/// Semantic gap roles for spacing between elements.
///
/// Gap roles define consistent spacing between components,
/// list items, and sections.
///
/// ## Overview
///
/// | Role | Purpose |
/// |------|---------|
/// | ``row`` | Between form/list rows |
/// | ``section`` | Between grouped sections |
/// | ``stack`` | Between stacked elements |
/// | ``inline`` | Between inline elements |
public struct DSGapRoles: Sendable, Equatable {
    
    /// Gap between rows in lists/forms.
    ///
    /// - Regular: 12pt
    /// - Compact: 10pt
    public let row: CGFloat
    
    /// Gap between sections.
    ///
    /// - Regular: 24pt
    /// - Compact: 20pt
    public let section: CGFloat
    
    /// Gap between stacked elements.
    ///
    /// - Default: 8pt
    public let stack: CGFloat
    
    /// Gap between inline elements.
    ///
    /// - Default: 4pt
    public let inline: CGFloat
    
    /// Gap between dashboard blocks.
    ///
    /// - Regular: 16pt
    /// - Spacious: 24pt
    public let dashboard: CGFloat
    
    /// Creates a new gap roles instance.
    public init(
        row: CGFloat,
        section: CGFloat,
        stack: CGFloat,
        inline: CGFloat,
        dashboard: CGFloat
    ) {
        self.row = row
        self.section = section
        self.stack = stack
        self.inline = inline
        self.dashboard = dashboard
    }
}

// MARK: - Insets Roles

/// Semantic insets/margin roles for screen-level spacing.
///
/// Insets define the safe margins and padding for screens
/// and major containers.
///
/// ## Overview
///
/// | Role | Purpose |
/// |------|---------|
/// | ``screen`` | Screen edge margins |
/// | ``card`` | Card internal padding |
/// | ``section`` | Section internal padding |
public struct DSInsetsRoles: Sendable, Equatable {
    
    /// Screen edge margins.
    ///
    /// Horizontal padding from screen edges.
    /// - iOS: 16pt
    /// - macOS: 20pt
    /// - watchOS: 8pt
    public let screen: EdgeInsets
    
    /// Card internal padding.
    ///
    /// Padding inside card containers.
    /// - Regular: 16pt all sides
    /// - Compact: 12pt all sides
    public let card: EdgeInsets
    
    /// Section internal padding.
    ///
    /// Padding inside section containers.
    public let section: EdgeInsets
    
    /// Creates a new insets roles instance.
    public init(
        screen: EdgeInsets,
        card: EdgeInsets,
        section: EdgeInsets
    ) {
        self.screen = screen
        self.card = card
        self.section = section
    }
}

// MARK: - Row Height Roles

/// Semantic row height roles for list items and form rows.
///
/// Row heights ensure consistent sizing and touch targets
/// across platforms.
///
/// ## Platform Guidelines
///
/// | Platform | Minimum | Default |
/// |----------|---------|---------|
/// | iOS | 44pt | 48pt |
/// | macOS | 36pt | 44pt |
/// | watchOS | 44pt | 52pt |
public struct DSRowHeightRoles: Sendable, Equatable {
    
    /// Minimum row height (touch target compliance).
    public let minimum: CGFloat
    
    /// Default row height for standard content.
    public let `default`: CGFloat
    
    /// Compact row height for dense layouts.
    public let compact: CGFloat
    
    /// Large row height for prominent rows.
    public let large: CGFloat
    
    /// Creates a new row height roles instance.
    public init(
        minimum: CGFloat,
        default: CGFloat,
        compact: CGFloat,
        large: CGFloat
    ) {
        self.minimum = minimum
        self.default = `default`
        self.compact = compact
        self.large = large
    }
}

// MARK: - DSSpacing Container

/// Complete semantic spacing system.
///
/// `DSSpacing` contains all spacing roles organized by category.
/// Components use these semantic roles for consistent layout.
///
/// ## Categories
///
/// - ``padding``: Internal component padding
/// - ``gap``: Spacing between elements
/// - ``insets``: Screen and container margins
/// - ``rowHeight``: List row heights
///
/// ## Usage
///
/// ```swift
/// @Environment(\.dsTheme) private var theme
///
/// var body: some View {
///     VStack(spacing: theme.spacing.gap.row) {
///         ForEach(items) { item in
///             RowView(item: item)
///                 .padding(theme.spacing.padding.m)
///         }
///     }
///     .padding(theme.spacing.insets.screen)
/// }
/// ```
///
/// ## Topics
///
/// ### Spacing Categories
///
/// - ``DSPaddingRoles``
/// - ``DSGapRoles``
/// - ``DSInsetsRoles``
/// - ``DSRowHeightRoles``
public struct DSSpacing: Sendable, Equatable {
    
    /// Padding roles for component interiors.
    public let padding: DSPaddingRoles
    
    /// Gap roles for spacing between elements.
    public let gap: DSGapRoles
    
    /// Insets roles for screen-level spacing.
    public let insets: DSInsetsRoles
    
    /// Row height roles for lists and forms.
    public let rowHeight: DSRowHeightRoles
    
    /// Creates a new spacing container.
    ///
    /// - Parameters:
    ///   - padding: Padding roles
    ///   - gap: Gap roles
    ///   - insets: Insets roles
    ///   - rowHeight: Row height roles
    public init(
        padding: DSPaddingRoles,
        gap: DSGapRoles,
        insets: DSInsetsRoles,
        rowHeight: DSRowHeightRoles
    ) {
        self.padding = padding
        self.gap = gap
        self.insets = insets
        self.rowHeight = rowHeight
    }
}
