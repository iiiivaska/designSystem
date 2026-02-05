// DSRadiusScale.swift
// DesignSystem
//
// Raw corner radius tokens.
// These are "raw material" with no semantic meaning.

import Foundation

// MARK: - Radius Scale

/// Raw corner radius scale in points.
///
/// Provides consistent rounding across the design system.
/// Larger radii create softer, more modern appearances.
///
/// ## Scale Overview
/// | Token | Value | Typical Usage |
/// |-------|-------|---------------|
/// | none | 0 | No rounding |
/// | xs | 4 | Small chips, badges |
/// | s | 6 | Small controls |
/// | m | 10 | Fields, small cards |
/// | l | 14 | Default cards |
/// | xl | 18 | Large panels, modals |
/// | xxl | 24 | Hero containers |
/// | full | 9999 | Pill shapes |
public enum DSRadius {
    /// No radius - 0pt
    ///
    /// Sharp corners, rarely used in modern UI.
    public static let none: CGFloat = 0
    
    /// Extra small radius - 4pt
    ///
    /// Very subtle rounding for small elements.
    public static let xs: CGFloat = 4
    
    /// Small radius - 6pt
    ///
    /// Small controls, badges, chips.
    public static let s: CGFloat = 6
    
    /// Medium radius - 10pt
    ///
    /// Text fields, small cards, buttons.
    public static let m: CGFloat = 10
    
    /// Large radius - 14pt
    ///
    /// Default card radius, standard containers.
    public static let l: CGFloat = 14
    
    /// Alternative large radius - 16pt
    ///
    /// Slightly larger, for platforms preferring rounder corners.
    public static let lAlt: CGFloat = 16
    
    /// Extra large radius - 18pt
    ///
    /// Large panels, modal sheets.
    public static let xl: CGFloat = 18
    
    /// Extra extra large radius - 24pt
    ///
    /// Hero containers, glass panels.
    public static let xxl: CGFloat = 24
    
    /// Maximum/pill radius - 9999pt
    ///
    /// Creates fully rounded (pill) shapes.
    public static let full: CGFloat = 9999
}

// MARK: - Numbered Radius Scale

/// Numbered radius scale matching the guidelines.
///
/// Uses r.1 through r.5 notation for quick reference.
public enum DSRadiusNumbered {
    /// r.1 = 6pt - Small controls, badges
    public static let r1: CGFloat = 6
    
    /// r.2 = 10pt - Fields, small cards
    public static let r2: CGFloat = 10
    
    /// r.3 = 14pt - Cards default
    public static let r3: CGFloat = 14
    
    /// r.4 = 18pt - Large panels, modals
    public static let r4: CGFloat = 18
    
    /// r.5 = 24pt - Hero containers, glass panels
    public static let r5: CGFloat = 24
}

// MARK: - Component Radius Recommendations

/// Recommended radius values for common components.
///
/// These are guideline values - actual radii are determined
/// by component specs in the theme layer.
public enum DSComponentRadius {
    // MARK: - Controls
    
    /// Button corner radius (small)
    public static let buttonSmall: CGFloat = DSRadius.s // 6pt
    
    /// Button corner radius (medium)
    public static let buttonMedium: CGFloat = DSRadius.m // 10pt
    
    /// Button corner radius (large)
    public static let buttonLarge: CGFloat = DSRadiusNumbered.r3 // 14pt
    
    // MARK: - Fields
    
    /// Text field corner radius
    public static let textField: CGFloat = DSRadius.m // 10pt
    
    /// Search field corner radius (more rounded)
    public static let searchField: CGFloat = DSRadiusNumbered.r3 // 14pt
    
    // MARK: - Containers
    
    /// Card corner radius (default)
    public static let card: CGFloat = DSRadiusNumbered.r3 // 14pt
    
    /// Card corner radius (compact)
    public static let cardCompact: CGFloat = DSRadius.m // 10pt
    
    /// Modal/sheet corner radius
    public static let modal: CGFloat = DSRadiusNumbered.r4 // 18pt
    
    /// Glass panel corner radius
    public static let glassPanel: CGFloat = DSRadiusNumbered.r5 // 24pt
    
    // MARK: - Small Elements
    
    /// Badge corner radius
    public static let badge: CGFloat = DSRadius.s // 6pt
    
    /// Chip corner radius (fully rounded)
    public static let chip: CGFloat = DSRadius.full
    
    /// Toggle thumb radius
    public static let toggleThumb: CGFloat = DSRadius.full
    
    // MARK: - Platform Specific
    
    /// iOS typical card radius
    public static let iOSCard: CGFloat = DSRadiusNumbered.r3 // 14pt
    
    /// macOS typical card radius (slightly smaller)
    public static let macOSCard: CGFloat = DSRadius.m // 10pt
    
    /// watchOS card radius
    public static let watchOSCard: CGFloat = DSRadiusNumbered.r3 // 14pt
}

// MARK: - Radius Scale Container

/// Complete radius scale containing all raw corner radius tokens.
///
/// This is the central access point for all radius tokens.
/// Values here are raw points - they are mapped to component
/// radii in the theme layer.
///
/// ## Usage
/// ```swift
/// // Access named radius
/// let cardRadius = DSRadiusScale.named.l // 14pt
/// let fieldRadius = DSRadiusScale.named.m // 10pt
///
/// // Access numbered radius
/// let r3 = DSRadiusScale.numbered.r3 // 14pt
///
/// // Access component recommendations
/// let buttonRadius = DSRadiusScale.component.buttonMedium
/// ```
public enum DSRadiusScale {
    /// Named radius tokens (none, xs, s, m, l, xl, xxl, full)
    public static let named = DSRadius.self
    
    /// Numbered radius tokens (r.1 through r.5)
    public static let numbered = DSRadiusNumbered.self
    
    /// Component-specific radius recommendations
    public static let component = DSComponentRadius.self
}
