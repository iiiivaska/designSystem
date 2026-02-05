// DSTypographyScale.swift
// DesignSystem
//
// Raw typography tokens - font sizes and weights.
// These are "raw material" with no semantic meaning.

import Foundation

// MARK: - Font Size Scale

/// Raw font size scale in points.
///
/// Based on the Apple Human Interface Guidelines with additions
/// for design system-specific sizes. All values are in points (pt).
///
/// ## Scale Overview
/// | Token | Size | Typical Usage |
/// |-------|------|---------------|
/// | largeTitle | 36 | Large navigation titles |
/// | title | 29 | Primary titles |
/// | headline | 22 | Section headings |
/// | body | 17 | Body text |
/// | callout | 16 | Supporting text |
/// | subheadline | 15 | Row subtitles |
/// | footnote | 13 | Helper text |
/// | caption1 | 12 | Captions |
/// | caption2 | 11 | Small labels |
/// | mono | 16 | Monospace text |
public enum DSFontSize {
    /// Large navigation title - 36pt
    ///
    /// Used for prominent page titles in iOS navigation.
    public static let largeTitle: CGFloat = 36
    
    /// Primary title - 29pt
    ///
    /// Used for main titles, dialog headers.
    public static let title: CGFloat = 29
    
    /// Headline - 22pt
    ///
    /// Used for section headings, card titles.
    public static let headline: CGFloat = 22
    
    /// Body text - 17pt
    ///
    /// Primary text size for content.
    public static let body: CGFloat = 17
    
    /// Callout - 16pt
    ///
    /// Supporting text, slightly smaller than body.
    public static let callout: CGFloat = 16
    
    /// Subheadline - 15pt
    ///
    /// Secondary text, row subtitles, descriptions.
    public static let subheadline: CGFloat = 15
    
    /// Footnote - 13pt
    ///
    /// Helper text, timestamps, metadata.
    public static let footnote: CGFloat = 13
    
    /// Caption 1 - 12pt
    ///
    /// Small captions, labels.
    public static let caption1: CGFloat = 12
    
    /// Caption 2 - 11pt
    ///
    /// Smallest readable text, badges.
    public static let caption2: CGFloat = 11
    
    /// Monospace text - 16pt
    ///
    /// Code, identifiers, technical values.
    public static let mono: CGFloat = 16
    
    // MARK: - Additional UI Sizes
    
    /// Title 1 - 28pt
    ///
    /// Large titles within content.
    public static let title1: CGFloat = 28
    
    /// Title 2 - 22pt
    ///
    /// Medium titles within content.
    public static let title2: CGFloat = 22
    
    /// Title 3 - 20pt
    ///
    /// Small titles within content.
    public static let title3: CGFloat = 20
    
    // MARK: - Platform Adjustments
    
    /// macOS adjustment factor for base sizes
    ///
    /// macOS typically uses slightly smaller text.
    public static let macOSScaleFactor: CGFloat = 0.92
    
    /// watchOS adjustment factor for base sizes
    ///
    /// watchOS uses smaller screens, may need adjusted sizes.
    public static let watchOSScaleFactor: CGFloat = 0.88
}

// MARK: - Font Weight Scale

/// Raw font weight values.
///
/// Uses numeric weight values that map to system fonts.
/// - 400 = Regular
/// - 600 = Semibold
///
/// ## Weight Mapping
/// | Token | Value | System Font |
/// |-------|-------|-------------|
/// | regular | 400 | .regular |
/// | medium | 500 | .medium |
/// | semibold | 600 | .semibold |
/// | bold | 700 | .bold |
public enum DSFontWeight {
    /// Regular weight - 400
    ///
    /// Default text weight for body content.
    public static let regular: Int = 400
    
    /// Medium weight - 500
    ///
    /// Slightly emphasized text.
    public static let medium: Int = 500
    
    /// Semibold weight - 600
    ///
    /// Used for headings, buttons, emphasis.
    public static let semibold: Int = 600
    
    /// Bold weight - 700
    ///
    /// Strong emphasis, rarely used.
    public static let bold: Int = 700
}

// MARK: - Line Height Scale

/// Line height multipliers for typography.
///
/// Applied as multipliers to font size for consistent vertical rhythm.
public enum DSLineHeight {
    /// Tight line height - 1.15x
    ///
    /// Used for large titles and single-line headings.
    public static let tight: CGFloat = 1.15
    
    /// Normal line height - 1.3x
    ///
    /// Default for body text and most content.
    public static let normal: CGFloat = 1.3
    
    /// Relaxed line height - 1.5x
    ///
    /// Used for long-form content, better readability.
    public static let relaxed: CGFloat = 1.5
    
    /// Loose line height - 1.75x
    ///
    /// Very spaced out, for special layouts.
    public static let loose: CGFloat = 1.75
}

// MARK: - Letter Spacing Scale

/// Letter spacing (tracking) values in points.
///
/// Tracking adjustments for specific use cases.
public enum DSLetterSpacing {
    /// Tighter tracking - -0.5pt
    ///
    /// Used for large display text.
    public static let tighter: CGFloat = -0.5
    
    /// Tight tracking - -0.2pt
    ///
    /// Slightly condensed.
    public static let tight: CGFloat = -0.2
    
    /// Normal tracking - 0pt
    ///
    /// System default.
    public static let normal: CGFloat = 0
    
    /// Wide tracking - 0.5pt
    ///
    /// Slightly expanded.
    public static let wide: CGFloat = 0.5
    
    /// Wider tracking - 1.0pt
    ///
    /// Expanded, used for uppercase text.
    public static let wider: CGFloat = 1.0
    
    /// Caps tracking - 2.0pt to 4.0pt
    ///
    /// For section headers in uppercase.
    public static let caps: CGFloat = 2.0
}

// MARK: - Typography Scale Container

/// Complete typography scale containing all raw typography tokens.
///
/// This is the central access point for all typography tokens.
/// Values here are raw numbers - they are mapped to SwiftUI
/// fonts and text styles in the theme layer.
///
/// ## Usage
/// ```swift
/// // Access font sizes
/// let titleSize = DSTypographyScale.size.title
/// let bodySize = DSTypographyScale.size.body
///
/// // Access font weights
/// let regularWeight = DSTypographyScale.weight.regular
/// let semiboldWeight = DSTypographyScale.weight.semibold
///
/// // Access line heights
/// let normalLineHeight = DSTypographyScale.lineHeight.normal
/// ```
public enum DSTypographyScale {
    /// Font size tokens
    public static let size = DSFontSize.self
    
    /// Font weight tokens
    public static let weight = DSFontWeight.self
    
    /// Line height multipliers
    public static let lineHeight = DSLineHeight.self
    
    /// Letter spacing tokens
    public static let letterSpacing = DSLetterSpacing.self
}
