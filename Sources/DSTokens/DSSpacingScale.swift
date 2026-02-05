// DSSpacingScale.swift
// DesignSystem
//
// Raw spacing tokens - padding, margins, gaps.
// These are "raw material" with no semantic meaning.

import Foundation

// MARK: - Spacing Scale

/// Raw spacing scale in points.
///
/// Based on a 4pt grid system for consistent spatial rhythm.
/// All values are multiples of 4.
///
/// ## Scale Overview
/// | Token | Value | Typical Usage |
/// |-------|-------|---------------|
/// | xxs | 2 | Micro spacing |
/// | xs | 4 | Icon-to-text gaps |
/// | s | 8 | Inline spacing |
/// | m | 12 | Component padding |
/// | l | 16 | Section padding |
/// | xl | 24 | Large gaps |
/// | xxl | 32 | Section separators |
/// | xxxl | 48 | Page margins |
/// | max | 64 | Maximum spacing |
public enum DSSpacing {
    /// Extra extra small - 2pt
    ///
    /// Micro spacing for very tight layouts.
    public static let xxs: CGFloat = 2
    
    /// Extra small - 4pt (1 grid unit)
    ///
    /// Icon-to-text gaps, badge padding.
    public static let xs: CGFloat = 4
    
    /// Small - 6pt
    ///
    /// Alternative small spacing for compact layouts.
    public static let sCompact: CGFloat = 6
    
    /// Small - 8pt (2 grid units)
    ///
    /// Inline spacing, list item gaps.
    public static let s: CGFloat = 8
    
    /// Medium - 12pt (3 grid units)
    ///
    /// Component internal padding, row spacing.
    public static let m: CGFloat = 12
    
    /// Large - 16pt (4 grid units)
    ///
    /// Card padding, section padding, standard gaps.
    public static let l: CGFloat = 16
    
    /// Extra large - 20pt (5 grid units)
    ///
    /// Comfortable padding for larger components.
    public static let xlCompact: CGFloat = 20
    
    /// Extra large - 24pt (6 grid units)
    ///
    /// Large gaps between sections.
    public static let xl: CGFloat = 24
    
    /// Extra extra large - 32pt (8 grid units)
    ///
    /// Section separators, large margins.
    public static let xxl: CGFloat = 32
    
    /// Extra extra extra large - 40pt (10 grid units)
    ///
    /// Very large spacing.
    public static let xxxl: CGFloat = 40
    
    /// Ultra - 48pt (12 grid units)
    ///
    /// Page margins, screen padding.
    public static let ultra: CGFloat = 48
    
    /// Maximum - 64pt (16 grid units)
    ///
    /// Maximum standard spacing.
    public static let max: CGFloat = 64
}

// MARK: - Numeric Spacing Scale

/// Numeric spacing scale matching the guidelines.
///
/// Uses numbered tokens (space.1, space.2, etc.) for programmatic access.
public enum DSSpacingNumeric {
    /// space.1 = 4pt
    public static let space1: CGFloat = 4
    
    /// space.2 = 8pt
    public static let space2: CGFloat = 8
    
    /// space.3 = 12pt
    public static let space3: CGFloat = 12
    
    /// space.4 = 16pt
    public static let space4: CGFloat = 16
    
    /// space.5 = 20pt
    public static let space5: CGFloat = 20
    
    /// space.6 = 24pt
    public static let space6: CGFloat = 24
    
    /// space.8 = 32pt
    public static let space8: CGFloat = 32
    
    /// space.10 = 40pt
    public static let space10: CGFloat = 40
    
    /// space.12 = 48pt
    public static let space12: CGFloat = 48
    
    /// All spacing values indexed by step (1-12)
    ///
    /// Note: Steps 7, 9, 11 are interpolated.
    public static func spacing(for step: Int) -> CGFloat {
        switch step {
        case 1: return space1
        case 2: return space2
        case 3: return space3
        case 4: return space4
        case 5: return space5
        case 6: return space6
        case 7: return 28 // interpolated
        case 8: return space8
        case 9: return 36 // interpolated
        case 10: return space10
        case 11: return 44 // interpolated
        case 12: return space12
        default: return CGFloat(step * 4)
        }
    }
}

// MARK: - Component Spacing Recommendations

/// Recommended spacing values for common component patterns.
///
/// These are guideline values - actual spacing is determined
/// by the theme layer based on density settings.
public enum DSComponentSpacing {
    // MARK: - Card Spacing
    
    /// Card internal padding (default)
    public static let cardPadding: CGFloat = DSSpacing.l // 16pt
    
    /// Card internal padding (compact)
    public static let cardPaddingCompact: CGFloat = DSSpacing.m // 12pt
    
    /// Card internal padding (spacious)
    public static let cardPaddingSpacious: CGFloat = DSSpacingNumeric.space5 // 20pt
    
    // MARK: - Section Spacing
    
    /// Space between sections
    public static let sectionGap: CGFloat = DSSpacing.xl // 24pt
    
    /// Space between sections (compact)
    public static let sectionGapCompact: CGFloat = DSSpacingNumeric.space5 // 20pt
    
    // MARK: - Row Spacing
    
    /// Space between form rows
    public static let rowGap: CGFloat = DSSpacing.m // 12pt
    
    /// Space between form rows (compact)
    public static let rowGapCompact: CGFloat = 10
    
    // MARK: - Dashboard Spacing
    
    /// Space between dashboard blocks
    public static let dashboardBlockGap: CGFloat = DSSpacing.l // 16pt
    
    /// Space between dashboard blocks (spacious)
    public static let dashboardBlockGapSpacious: CGFloat = DSSpacing.xl // 24pt
}

// MARK: - Row Heights

/// Standard row heights for list items and form rows.
///
/// Based on Apple HIG and accessibility requirements.
public enum DSRowHeight {
    /// Minimum iOS row height - 44pt
    ///
    /// Apple's minimum touch target size.
    public static let iOSMinimum: CGFloat = 44
    
    /// Default iOS row height - 48pt
    public static let iOSDefault: CGFloat = 48
    
    /// macOS compact row height - 36pt
    public static let macOSCompact: CGFloat = 36
    
    /// macOS regular row height - 44pt
    public static let macOSRegular: CGFloat = 44
    
    /// watchOS row height - 52pt
    ///
    /// Larger for easier tap targets on small screen.
    public static let watchOSDefault: CGFloat = 52
    
    /// watchOS minimum row height - 44pt
    public static let watchOSMinimum: CGFloat = 44
}

// MARK: - Spacing Scale Container

/// Complete spacing scale containing all raw spacing tokens.
///
/// This is the central access point for all spacing tokens.
/// Values here are raw points - they are used to calculate
/// semantic spacing in the theme layer.
///
/// ## Usage
/// ```swift
/// // Access semantic spacing
/// let cardPadding = DSSpacingScale.named.l // 16pt
/// let rowGap = DSSpacingScale.named.m // 12pt
///
/// // Access numeric spacing
/// let step4 = DSSpacingScale.numeric.space4 // 16pt
///
/// // Access component recommendations
/// let cardPad = DSSpacingScale.component.cardPadding
///
/// // Access row heights
/// let rowHeight = DSSpacingScale.rowHeight.iOSMinimum
/// ```
public enum DSSpacingScale {
    /// Named spacing tokens (xs, s, m, l, xl, xxl, max)
    public static let named = DSSpacing.self
    
    /// Numeric spacing tokens (space.1 through space.12)
    public static let numeric = DSSpacingNumeric.self
    
    /// Component-specific spacing recommendations
    public static let component = DSComponentSpacing.self
    
    /// Row height tokens
    public static let rowHeight = DSRowHeight.self
}
