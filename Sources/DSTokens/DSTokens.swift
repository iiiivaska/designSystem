// DSTokens.swift
// DesignSystem
//
// Raw design tokens - colors, typography, spacing, radius, shadow, motion scales.
// These are "raw material" with no semantic meaning.
//
// ## Overview
//
// DSTokens provides the foundational design primitives used throughout the design system.
// Tokens are raw values (numbers, hex strings) that carry no semantic meaning - they are
// pure "building blocks" that get mapped to semantic roles in the ``DSTheme`` layer.
//
// ## Topics
//
// ### Token Categories
//
// - ``DSColorPalette``
// - ``DSTypographyScale``
// - ``DSSpacingScale``
// - ``DSRadiusScale``
// - ``DSShadowScale``
// - ``DSMotionScale``
//
// ### Color Palettes
//
// - ``DSLightNeutrals``
// - ``DSDarkNeutrals``
// - ``DSTealAccent``
// - ``DSIndigoAccent``
// - ``DSGreenState``
// - ``DSYellowState``
// - ``DSRedState``
// - ``DSBlueState``
//
// ### Typography
//
// - ``DSFontSize``
// - ``DSFontWeight``
// - ``DSLineHeight``
// - ``DSLetterSpacing``
//
// ### Spacing
//
// - ``DSSpacing``
// - ``DSSpacingNumeric``
// - ``DSComponentSpacing``
// - ``DSRowHeight``
//
// ### Radius
//
// - ``DSRadius``
// - ``DSRadiusNumbered``
// - ``DSComponentRadius``
//
// ### Shadows & Borders
//
// - ``DSShadow``
// - ``DSShadowNumbered``
// - ``DSComponentShadow``
// - ``DSBorder``
// - ``DSShadowDefinition``
// - ``DSBorderDefinition``
//
// ### Motion
//
// - ``DSDuration``
// - ``DSSpring``
// - ``DSEasing``
// - ``DSComponentMotion``
// - ``DSSpringDefinition``
// - ``DSEasingDefinition``
// - ``DSReduceMotionAdjustment``

import Foundation

/// DSTokens module namespace.
///
/// Provides access to all raw design tokens organized by category.
/// These tokens are the foundation of the design system and should
/// not be used directly in components - instead, use semantic roles
/// from ``DSTheme``.
///
/// ## Usage
///
/// ```swift
/// // Access color tokens
/// let primaryAccent = DSTokens.colors.teal.teal500
/// let darkBg = DSTokens.colors.dark.d0
///
/// // Access typography tokens
/// let bodySize = DSTokens.typography.size.body
/// let semiboldWeight = DSTokens.typography.weight.semibold
///
/// // Access spacing tokens
/// let cardPadding = DSTokens.spacing.named.l
///
/// // Access radius tokens
/// let cardRadius = DSTokens.radius.numbered.r3
///
/// // Access shadow tokens
/// let cardShadow = DSTokens.shadow.numbered.shadow1
///
/// // Access motion tokens
/// let smoothSpring = DSTokens.motion.spring.smooth
/// ```
///
/// ## Design Principles
///
/// 1. **Raw Values Only**: Tokens contain primitive values (CGFloat, String, etc.)
///    with no SwiftUI dependencies.
///
/// 2. **No Semantic Meaning**: Token names describe what they ARE, not what they're
///    FOR. Semantic meaning is added in the theme layer.
///
/// 3. **Platform Agnostic**: Tokens work identically across iOS, macOS, and watchOS.
///
/// 4. **Accessibility Ready**: Dark-safe color variants and reduce motion tokens
///    are included for accessibility support.
public enum DSTokens {
    /// Current version of the token set
    public static let version = "0.1.0"
    
    /// Color palette tokens
    ///
    /// Contains all raw color values organized by palette:
    /// - Light neutrals (N0-N9)
    /// - Dark neutrals (D0-D9)
    /// - Accent colors (Teal, Indigo)
    /// - State colors (Green, Yellow, Red, Blue)
    public static let colors = DSColorPalette.self
    
    /// Typography scale tokens
    ///
    /// Contains font sizes, weights, line heights, and letter spacing.
    public static let typography = DSTypographyScale.self
    
    /// Spacing scale tokens
    ///
    /// Contains padding, margin, and gap values based on 4pt grid.
    public static let spacing = DSSpacingScale.self
    
    /// Radius scale tokens
    ///
    /// Contains corner radius values for all components.
    public static let radius = DSRadiusScale.self
    
    /// Shadow scale tokens
    ///
    /// Contains shadow definitions for elevation and borders.
    public static let shadow = DSShadowScale.self
    
    /// Motion scale tokens
    ///
    /// Contains animation durations, springs, and easing curves.
    public static let motion = DSMotionScale.self
}
