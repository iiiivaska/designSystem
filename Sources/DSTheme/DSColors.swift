// DSColors.swift
// DesignSystem
//
// Semantic color roles for the design system.
// Components use these roles, not raw tokens.

import SwiftUI
import DSTokens

// MARK: - Background Colors

/// Semantic background color roles.
///
/// Background colors define the layering of UI surfaces. Each role
/// represents a specific purpose in the visual hierarchy.
///
/// ## Overview
///
/// | Role | Purpose |
/// |------|---------|
/// | ``canvas`` | Root background (window/screen) |
/// | ``surface`` | Content area background |
/// | ``surfaceElevated`` | Elevated content (cards, panels) |
/// | ``card`` | Card/container background |
///
/// ## Usage
///
/// ```swift
/// struct MyView: View {
///     @Environment(\.dsTheme) private var theme
///
///     var body: some View {
///         Rectangle()
///             .fill(theme.colors.bg.canvas)
///     }
/// }
/// ```
public struct DSBackgroundColors: Sendable, Equatable {
    
    /// Root/window background color.
    ///
    /// The base layer color for the entire screen or window.
    /// - Light: N1 (#F7F8FA)
    /// - Dark: D0 (#0B0E14)
    public let canvas: Color
    
    /// Content area background.
    ///
    /// Primary content surface, sits above canvas.
    /// - Light: N0 (#FFFFFF)
    /// - Dark: D1 (#0F131C)
    public let surface: Color
    
    /// Elevated surface background.
    ///
    /// Surfaces with visual elevation (shadow or border).
    /// - Light: N0 (#FFFFFF)
    /// - Dark: D2 (#151B26)
    public let surfaceElevated: Color
    
    /// Card/container background.
    ///
    /// Background for card components and grouped content.
    /// - Light: N0 (#FFFFFF)
    /// - Dark: D3 (#1B2331)
    public let card: Color
    
    /// Creates a new background colors instance.
    ///
    /// - Parameters:
    ///   - canvas: Root background color
    ///   - surface: Content area background
    ///   - surfaceElevated: Elevated surface background
    ///   - card: Card/container background
    public init(
        canvas: Color,
        surface: Color,
        surfaceElevated: Color,
        card: Color
    ) {
        self.canvas = canvas
        self.surface = surface
        self.surfaceElevated = surfaceElevated
        self.card = card
    }
}

// MARK: - Foreground Colors

/// Semantic foreground color roles.
///
/// Foreground colors define text and icon colors at different
/// levels of visual hierarchy.
///
/// ## Overview
///
/// | Role | Purpose | Contrast |
/// |------|---------|----------|
/// | ``primary`` | Main content | High |
/// | ``secondary`` | Supporting content | Medium |
/// | ``tertiary`` | Hints, metadata | Low |
/// | ``disabled`` | Inactive elements | Very low |
///
/// ## Usage
///
/// ```swift
/// Text("Title")
///     .foregroundStyle(theme.colors.fg.primary)
/// Text("Description")
///     .foregroundStyle(theme.colors.fg.secondary)
/// ```
public struct DSForegroundColors: Sendable, Equatable {
    
    /// Primary text/icon color.
    ///
    /// Highest contrast for main content, titles, and body text.
    /// - Light: N9 (#131824)
    /// - Dark: D8 (#E7ECF5)
    public let primary: Color
    
    /// Secondary text/icon color.
    ///
    /// Medium contrast for supporting text and descriptions.
    /// - Light: N7 (#5D6678)
    /// - Dark: D7 (#A7B0C3)
    public let secondary: Color
    
    /// Tertiary text/icon color.
    ///
    /// Low contrast for hints, metadata, and less important content.
    /// - Light: N6 (#8F98AA)
    /// - Dark: D6 (#6C7790)
    public let tertiary: Color
    
    /// Disabled text/icon color.
    ///
    /// Very low contrast for inactive/disabled elements.
    /// - Light: N6 with 50% opacity
    /// - Dark: D6 with 55% opacity
    public let disabled: Color
    
    /// Creates a new foreground colors instance.
    ///
    /// - Parameters:
    ///   - primary: Primary text/icon color
    ///   - secondary: Secondary text/icon color
    ///   - tertiary: Tertiary text/icon color
    ///   - disabled: Disabled text/icon color
    public init(
        primary: Color,
        secondary: Color,
        tertiary: Color,
        disabled: Color
    ) {
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
        self.disabled = disabled
    }
}

// MARK: - Border Colors

/// Semantic border and separator color roles.
///
/// Border colors provide visual separation and containment.
///
/// ## Overview
///
/// | Role | Purpose |
/// |------|---------|
/// | ``subtle`` | Light borders, card edges |
/// | ``strong`` | Emphasized borders, focused fields |
/// | ``separator`` | List dividers, sections |
public struct DSBorderColors: Sendable, Equatable {
    
    /// Subtle border color.
    ///
    /// Light borders for cards and containers.
    /// - Light: N3 (#E6E9EF)
    /// - Dark: D4 (#243042) with 55% opacity
    public let subtle: Color
    
    /// Strong border color.
    ///
    /// Emphasized borders for active states.
    /// - Light: N4 (#D7DCE5)
    /// - Dark: D4 (#243042)
    public let strong: Color
    
    /// Separator color.
    ///
    /// Dividers between list items and sections.
    /// - Light: N3 (#E6E9EF)
    /// - Dark: D4 (#243042) with 45% opacity
    public let separator: Color
    
    /// Creates a new border colors instance.
    ///
    /// - Parameters:
    ///   - subtle: Subtle border color
    ///   - strong: Strong border color
    ///   - separator: Separator color
    public init(
        subtle: Color,
        strong: Color,
        separator: Color
    ) {
        self.subtle = subtle
        self.strong = strong
        self.separator = separator
    }
}

// MARK: - Accent Colors

/// Semantic accent color roles.
///
/// Accent colors provide brand identity and call attention
/// to interactive elements.
///
/// ## Overview
///
/// | Role | Purpose |
/// |------|---------|
/// | ``primary`` | Main brand accent (Teal) |
/// | ``secondary`` | Secondary accent (Indigo) |
public struct DSAccentColors: Sendable, Equatable {
    
    /// Primary accent color.
    ///
    /// Main brand color for buttons, links, and highlights.
    /// - Light: Teal 500 (#0BAEA3)
    /// - Dark: TealDark A (#17BDB0) - "dusty" variant
    public let primary: Color
    
    /// Secondary accent color.
    ///
    /// Alternative accent for dashboard elements and variety.
    /// - Light: Indigo 600 (#4F46E5)
    /// - Dark: IndigoDark A (#6D72F7)
    public let secondary: Color
    
    /// Creates a new accent colors instance.
    ///
    /// - Parameters:
    ///   - primary: Primary accent color
    ///   - secondary: Secondary accent color
    public init(
        primary: Color,
        secondary: Color
    ) {
        self.primary = primary
        self.secondary = secondary
    }
}

// MARK: - State Colors

/// Semantic state color roles.
///
/// State colors communicate feedback and status to users.
///
/// ## Overview
///
/// | Role | Purpose |
/// |------|---------|
/// | ``success`` | Positive outcomes, confirmations |
/// | ``warning`` | Cautions, attention needed |
/// | ``danger`` | Errors, destructive actions |
/// | ``info`` | Neutral information |
public struct DSStateColors: Sendable, Equatable {
    
    /// Success state color.
    ///
    /// Positive outcomes, completed actions, valid inputs.
    /// - Light: Green 500 (#22C55E)
    /// - Dark: GreenDark A (#4ADE80)
    public let success: Color
    
    /// Warning state color.
    ///
    /// Cautions, attention needed, non-critical issues.
    /// - Light: Yellow 500 (#F59E0B)
    /// - Dark: YellowDark A (#F6C453)
    public let warning: Color
    
    /// Danger state color.
    ///
    /// Errors, destructive actions, critical issues.
    /// - Light: Red 500 (#EF4444)
    /// - Dark: RedDark A (#F87171)
    public let danger: Color
    
    /// Info state color.
    ///
    /// Neutral information, tips, help content.
    /// - Light: Blue 500 (#3B82F6)
    /// - Dark: BlueDark A (#60A5FA)
    public let info: Color
    
    /// Creates a new state colors instance.
    ///
    /// - Parameters:
    ///   - success: Success state color
    ///   - warning: Warning state color
    ///   - danger: Danger state color
    ///   - info: Info state color
    public init(
        success: Color,
        warning: Color,
        danger: Color,
        info: Color
    ) {
        self.success = success
        self.warning = warning
        self.danger = danger
        self.info = info
    }
}

// MARK: - DSColors Container

/// Complete semantic color system.
///
/// `DSColors` contains all color roles organized by category.
/// Components use these semantic roles rather than raw tokens.
///
/// ## Color Categories
///
/// - ``bg``: Background colors for surfaces and containers
/// - ``fg``: Foreground colors for text and icons
/// - ``border``: Border and separator colors
/// - ``accent``: Brand and highlight colors
/// - ``state``: Feedback and status colors
/// - ``focusRing``: Focus indicator color
///
/// ## Usage
///
/// ```swift
/// @Environment(\.dsTheme) private var theme
///
/// var body: some View {
///     Text("Hello")
///         .foregroundStyle(theme.colors.fg.primary)
///         .background(theme.colors.bg.surface)
/// }
/// ```
///
/// ## Topics
///
/// ### Background
///
/// - ``DSBackgroundColors``
///
/// ### Foreground
///
/// - ``DSForegroundColors``
///
/// ### Borders
///
/// - ``DSBorderColors``
///
/// ### Accents
///
/// - ``DSAccentColors``
///
/// ### States
///
/// - ``DSStateColors``
public struct DSColors: Sendable, Equatable {
    
    /// Background color roles.
    public let bg: DSBackgroundColors
    
    /// Foreground color roles.
    public let fg: DSForegroundColors
    
    /// Border and separator color roles.
    public let border: DSBorderColors
    
    /// Accent color roles.
    public let accent: DSAccentColors
    
    /// State color roles.
    public let state: DSStateColors
    
    /// Focus ring color.
    ///
    /// Used for keyboard focus indicators.
    /// - Light: Teal 300 (#2FE3D2) with ~70% opacity
    /// - Dark: TealDark Glow (#25D8C9) with ~55% opacity
    public let focusRing: Color
    
    /// Creates a new colors container.
    ///
    /// - Parameters:
    ///   - bg: Background color roles
    ///   - fg: Foreground color roles
    ///   - border: Border and separator color roles
    ///   - accent: Accent color roles
    ///   - state: State color roles
    ///   - focusRing: Focus ring color
    public init(
        bg: DSBackgroundColors,
        fg: DSForegroundColors,
        border: DSBorderColors,
        accent: DSAccentColors,
        state: DSStateColors,
        focusRing: Color
    ) {
        self.bg = bg
        self.fg = fg
        self.border = border
        self.accent = accent
        self.state = state
        self.focusRing = focusRing
    }
}

// MARK: - Color Helpers

/// Extension to create Color from hex string.
extension Color {
    
    /// Creates a Color from a hex string.
    ///
    /// - Parameter hex: Hex color string (e.g., "#FFFFFF" or "FFFFFF")
    /// - Returns: A Color instance, or clear if invalid
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
