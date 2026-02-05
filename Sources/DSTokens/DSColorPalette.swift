// DSColorPalette.swift
// DesignSystem
//
// Raw color tokens - hex values for all palettes.
// These are "raw material" with no semantic meaning.

import Foundation

// MARK: - Color Hex Value

/// A raw hex color value represented as a string.
///
/// Use this type alias for clarity when working with raw color tokens.
/// Format: "#RRGGBB" (6-character hex with # prefix)
///
/// ## Example
/// ```swift
/// let white: DSColorHex = "#FFFFFF"
/// let black: DSColorHex = "#000000"
/// ```
public typealias DSColorHex = String

// MARK: - Light Neutrals

/// Light neutral color palette (N0-N9).
///
/// Used as the foundation for light theme backgrounds, text, and borders.
/// Values progress from lightest (N0 = white) to darkest (N9 = near-black).
///
/// ## Overview
/// | Token | Hex | Usage |
/// |-------|-----|-------|
/// | N0 | #FFFFFF | Primary backgrounds |
/// | N1 | #F7F8FA | Canvas background |
/// | N2 | #F1F3F6 | Secondary surfaces |
/// | N3 | #E6E9EF | Subtle borders, separators |
/// | N4 | #D7DCE5 | Strong borders |
/// | N5 | #B9C0CE | Disabled states |
/// | N6 | #8F98AA | Tertiary text |
/// | N7 | #5D6678 | Secondary text |
/// | N8 | #2D3442 | Headlines |
/// | N9 | #131824 | Primary text |
public enum DSLightNeutrals {
    /// White - primary backgrounds, cards
    public static let n0: DSColorHex = "#FFFFFF"
    
    /// Off-white - canvas background
    public static let n1: DSColorHex = "#F7F8FA"
    
    /// Light gray - secondary surfaces
    public static let n2: DSColorHex = "#F1F3F6"
    
    /// Light gray - subtle borders, separators
    public static let n3: DSColorHex = "#E6E9EF"
    
    /// Gray - strong borders
    public static let n4: DSColorHex = "#D7DCE5"
    
    /// Gray - muted elements, disabled
    public static let n5: DSColorHex = "#B9C0CE"
    
    /// Gray - tertiary text, hints
    public static let n6: DSColorHex = "#8F98AA"
    
    /// Dark gray - secondary text
    public static let n7: DSColorHex = "#5D6678"
    
    /// Near-black - headlines
    public static let n8: DSColorHex = "#2D3442"
    
    /// Near-black - primary text
    public static let n9: DSColorHex = "#131824"
    
    /// All light neutral colors indexed by level (0-9)
    public static let all: [DSColorHex] = [n0, n1, n2, n3, n4, n5, n6, n7, n8, n9]
}

// MARK: - Dark Neutrals

/// Dark neutral color palette (D0-D9).
///
/// Used as the foundation for dark theme backgrounds, text, and borders.
/// Values progress from darkest (D0 = near-black) to lightest (D9 = white).
/// Slightly warmer/deeper tones for glass effects.
///
/// ## Overview
/// | Token | Hex | Usage |
/// |-------|-----|-------|
/// | D0 | #0B0E14 | Base background |
/// | D1 | #0F131C | Surface |
/// | D2 | #151B26 | Surface elevated |
/// | D3 | #1B2331 | Cards |
/// | D4 | #243042 | Border/separator strong |
/// | D5 | #3A465C | Muted border |
/// | D6 | #6C7790 | Tertiary text |
/// | D7 | #A7B0C3 | Secondary text |
/// | D8 | #E7ECF5 | Primary text |
/// | D9 | #FFFFFF | White |
public enum DSDarkNeutrals {
    /// Near-black - base background
    public static let d0: DSColorHex = "#0B0E14"
    
    /// Dark - surface background
    public static let d1: DSColorHex = "#0F131C"
    
    /// Dark - surface elevated
    public static let d2: DSColorHex = "#151B26"
    
    /// Dark - card background
    public static let d3: DSColorHex = "#1B2331"
    
    /// Dark gray - strong borders, separators
    public static let d4: DSColorHex = "#243042"
    
    /// Gray - muted borders
    public static let d5: DSColorHex = "#3A465C"
    
    /// Gray - tertiary text
    public static let d6: DSColorHex = "#6C7790"
    
    /// Light gray - secondary text, hints
    public static let d7: DSColorHex = "#A7B0C3"
    
    /// Off-white - primary text on dark
    public static let d8: DSColorHex = "#E7ECF5"
    
    /// White
    public static let d9: DSColorHex = "#FFFFFF"
    
    /// All dark neutral colors indexed by level (0-9)
    public static let all: [DSColorHex] = [d0, d1, d2, d3, d4, d5, d6, d7, d8, d9]
}

// MARK: - Accent: Teal

/// Teal accent color palette - the primary brand accent.
///
/// Used for primary actions, links, focus states, and brand elements.
/// Includes dark-safe variants with reduced saturation for dark theme.
///
/// ## Overview
/// - Standard palette: 50-900 (light to dark)
/// - Dark-safe variants: TealDark A/B/Glow
public enum DSTealAccent {
    // MARK: Standard Palette
    
    /// Lightest teal - backgrounds
    public static let teal50: DSColorHex = "#E6FFFB"
    
    /// Very light teal
    public static let teal100: DSColorHex = "#BFF9F0"
    
    /// Light teal
    public static let teal200: DSColorHex = "#7FF0E2"
    
    /// Medium-light teal
    public static let teal300: DSColorHex = "#2FE3D2"
    
    /// Medium teal
    public static let teal400: DSColorHex = "#16C7B9"
    
    /// Primary teal (light theme primary)
    public static let teal500: DSColorHex = "#0BAEA3"
    
    /// Medium-dark teal (pressed state light)
    public static let teal600: DSColorHex = "#079389"
    
    /// Dark teal
    public static let teal700: DSColorHex = "#057870"
    
    /// Very dark teal
    public static let teal800: DSColorHex = "#045E58"
    
    /// Darkest teal
    public static let teal900: DSColorHex = "#033E3A"
    
    // MARK: Dark-Safe Variants
    
    /// Dark theme primary accent - "dusty" teal with reduced saturation
    public static let tealDarkA: DSColorHex = "#17BDB0"
    
    /// Dark theme pressed/active state
    public static let tealDarkB: DSColorHex = "#0E8E84"
    
    /// Dark theme glow effect - only for small accents (icons, charts)
    public static let tealDarkGlow: DSColorHex = "#25D8C9"
}

// MARK: - Accent: Indigo

/// Indigo accent color palette - secondary brand accent.
///
/// Used for dashboard elements, secondary actions, and macOS sidebar highlights.
/// Includes dark-safe variants with reduced saturation.
public enum DSIndigoAccent {
    // MARK: Standard Palette
    
    /// Light indigo
    public static let indigo200: DSColorHex = "#C7D2FE"
    
    /// Medium-light indigo
    public static let indigo300: DSColorHex = "#A5B4FC"
    
    /// Medium indigo
    public static let indigo400: DSColorHex = "#818CF8"
    
    /// Primary indigo
    public static let indigo500: DSColorHex = "#6366F1"
    
    /// Dark indigo (light theme secondary accent)
    public static let indigo600: DSColorHex = "#4F46E5"
    
    // MARK: Dark-Safe Variants
    
    /// Dark theme indigo - slightly muted
    public static let indigoDarkA: DSColorHex = "#6D72F7"
    
    /// Dark theme indigo pressed
    public static let indigoDarkB: DSColorHex = "#4A4FE6"
}

// MARK: - State: Green / Success

/// Green color palette for success states.
///
/// Used for success messages, positive indicators, and confirmations.
/// Includes dark-safe variants.
public enum DSGreenState {
    // MARK: Standard Palette
    
    /// Light green - backgrounds
    public static let green300: DSColorHex = "#86EFAC"
    
    /// Primary green (light theme success)
    public static let green500: DSColorHex = "#22C55E"
    
    /// Dark green
    public static let green700: DSColorHex = "#15803D"
    
    // MARK: Dark-Safe Variants
    
    /// Dark theme success - lighter for contrast
    public static let greenDarkA: DSColorHex = "#4ADE80"
    
    /// Dark theme success pressed
    public static let greenDarkB: DSColorHex = "#22C55E"
}

// MARK: - State: Yellow / Warning

/// Yellow color palette for warning states.
///
/// Used for warning messages, caution indicators, and attention-grabbing elements.
/// Includes dark-safe variants.
public enum DSYellowState {
    // MARK: Standard Palette
    
    /// Light yellow - backgrounds
    public static let yellow300: DSColorHex = "#FDE68A"
    
    /// Primary yellow (light theme warning)
    public static let yellow500: DSColorHex = "#F59E0B"
    
    /// Dark yellow
    public static let yellow700: DSColorHex = "#B45309"
    
    // MARK: Dark-Safe Variants
    
    /// Dark theme warning - warmer tone
    public static let yellowDarkA: DSColorHex = "#F6C453"
    
    /// Dark theme warning pressed
    public static let yellowDarkB: DSColorHex = "#D89214"
}

// MARK: - State: Red / Danger

/// Red color palette for danger/error states.
///
/// Used for error messages, destructive actions, and critical alerts.
/// Includes dark-safe variants.
public enum DSRedState {
    // MARK: Standard Palette
    
    /// Light red - backgrounds
    public static let red300: DSColorHex = "#FCA5A5"
    
    /// Primary red (light theme danger)
    public static let red500: DSColorHex = "#EF4444"
    
    /// Dark red
    public static let red700: DSColorHex = "#B91C1C"
    
    // MARK: Dark-Safe Variants
    
    /// Dark theme danger - lighter for contrast
    public static let redDarkA: DSColorHex = "#F87171"
    
    /// Dark theme danger pressed
    public static let redDarkB: DSColorHex = "#EF4444"
}

// MARK: - State: Blue / Info

/// Blue color palette for informational states.
///
/// Used for info messages, neutral indicators, and links (alternative to teal).
/// Includes dark-safe variants.
public enum DSBlueState {
    // MARK: Standard Palette
    
    /// Light blue - backgrounds
    public static let blue300: DSColorHex = "#93C5FD"
    
    /// Primary blue (light theme info)
    public static let blue500: DSColorHex = "#3B82F6"
    
    /// Dark blue
    public static let blue700: DSColorHex = "#1D4ED8"
    
    // MARK: Dark-Safe Variants
    
    /// Dark theme info - lighter for contrast
    public static let blueDarkA: DSColorHex = "#60A5FA"
    
    /// Dark theme info pressed
    public static let blueDarkB: DSColorHex = "#3B82F6"
}

// MARK: - Color Palette Container

/// Complete color palette containing all raw color tokens.
///
/// This is the central access point for all color tokens in the design system.
/// Colors here are raw hex values with no semantic meaning - they are mapped
/// to semantic roles in ``DSTheme``.
///
/// ## Usage
/// ```swift
/// // Access individual palettes
/// let white = DSColorPalette.light.n0
/// let darkBg = DSColorPalette.dark.d0
/// let accent = DSColorPalette.teal.teal500
///
/// // Dark-safe accents for dark theme
/// let darkAccent = DSColorPalette.teal.tealDarkA
/// ```
public enum DSColorPalette {
    /// Light neutral colors (N0-N9)
    public static let light = DSLightNeutrals.self
    
    /// Dark neutral colors (D0-D9)
    public static let dark = DSDarkNeutrals.self
    
    /// Teal accent colors (primary brand)
    public static let teal = DSTealAccent.self
    
    /// Indigo accent colors (secondary brand)
    public static let indigo = DSIndigoAccent.self
    
    /// Green state colors (success)
    public static let green = DSGreenState.self
    
    /// Yellow state colors (warning)
    public static let yellow = DSYellowState.self
    
    /// Red state colors (danger/error)
    public static let red = DSRedState.self
    
    /// Blue state colors (info)
    public static let blue = DSBlueState.self
}
