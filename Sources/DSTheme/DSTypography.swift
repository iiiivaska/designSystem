// DSTypography.swift
// DesignSystem
//
// Semantic typography roles for the design system.
// Components use these roles for consistent text styling.

import SwiftUI
import DSTokens

// MARK: - Text Style Definition

/// A complete text style definition.
///
/// Encapsulates all properties needed to style text consistently.
/// Used by semantic typography roles to provide complete styling.
///
/// ## Usage
///
/// ```swift
/// Text("Hello")
///     .font(style.font)
///     .foregroundStyle(style.color)
/// ```
public struct DSTextStyle: Sendable, Equatable {
    
    /// The font to use for this text style.
    public let font: Font
    
    /// The default color for this text style.
    public let color: Color
    
    /// The font weight.
    public let weight: Font.Weight
    
    /// The font size in points.
    public let size: CGFloat
    
    /// Optional letter spacing (tracking).
    public let letterSpacing: CGFloat?
    
    /// Line height multiplier (optional, uses system default if nil).
    public let lineHeightMultiplier: CGFloat?
    
    /// Whether to use monospace font design.
    public let isMonospace: Bool
    
    /// Creates a new text style.
    ///
    /// - Parameters:
    ///   - font: The font to use
    ///   - color: Default text color
    ///   - weight: Font weight
    ///   - size: Font size in points
    ///   - letterSpacing: Optional letter spacing
    ///   - lineHeightMultiplier: Optional line height multiplier
    ///   - isMonospace: Whether to use monospace design
    public init(
        font: Font,
        color: Color,
        weight: Font.Weight = .regular,
        size: CGFloat,
        letterSpacing: CGFloat? = nil,
        lineHeightMultiplier: CGFloat? = nil,
        isMonospace: Bool = false
    ) {
        self.font = font
        self.color = color
        self.weight = weight
        self.size = size
        self.letterSpacing = letterSpacing
        self.lineHeightMultiplier = lineHeightMultiplier
        self.isMonospace = isMonospace
    }
    
    /// Creates a system font-based text style.
    ///
    /// Convenience initializer for common system font configurations.
    ///
    /// - Parameters:
    ///   - size: Font size in points
    ///   - weight: Font weight
    ///   - color: Text color
    ///   - design: Font design (default, monospaced, rounded, serif)
    ///   - letterSpacing: Optional letter spacing
    /// - Returns: A new text style
    public static func system(
        size: CGFloat,
        weight: Font.Weight,
        color: Color,
        design: Font.Design = .default,
        letterSpacing: CGFloat? = nil
    ) -> DSTextStyle {
        DSTextStyle(
            font: .system(size: size, weight: weight, design: design),
            color: color,
            weight: weight,
            size: size,
            letterSpacing: letterSpacing,
            isMonospace: design == .monospaced
        )
    }
}

// MARK: - System Text Styles

/// System text style roles following Apple HIG.
///
/// These roles map to standard iOS/macOS text styles with
/// Dynamic Type support.
///
/// ## Overview
///
/// | Role | Size | Weight | Usage |
/// |------|------|--------|-------|
/// | ``largeTitle`` | 34 | Bold | Large navigation titles |
/// | ``title1`` | 28 | Semibold | Primary titles |
/// | ``title2`` | 22 | Semibold | Section headers |
/// | ``title3`` | 20 | Semibold | Subsection headers |
/// | ``headline`` | 17 | Semibold | Emphasized content |
/// | ``body`` | 17 | Regular | Main content |
/// | ``callout`` | 16 | Regular | Supporting text |
/// | ``subheadline`` | 15 | Regular | Secondary content |
/// | ``footnote`` | 13 | Regular | Small text, helpers |
/// | ``caption1`` | 12 | Regular | Captions |
/// | ``caption2`` | 11 | Regular | Smallest text |
public struct DSSystemTypography: Sendable, Equatable {
    
    /// Large title style (34pt bold).
    ///
    /// Used for prominent page titles in iOS navigation.
    public let largeTitle: DSTextStyle
    
    /// Title 1 style (28pt semibold).
    ///
    /// Primary titles within content.
    public let title1: DSTextStyle
    
    /// Title 2 style (22pt semibold).
    ///
    /// Section headers and card titles.
    public let title2: DSTextStyle
    
    /// Title 3 style (20pt semibold).
    ///
    /// Subsection headers.
    public let title3: DSTextStyle
    
    /// Headline style (17pt semibold).
    ///
    /// Emphasized content, row titles.
    public let headline: DSTextStyle
    
    /// Body style (17pt regular).
    ///
    /// Main content, paragraphs.
    public let body: DSTextStyle
    
    /// Callout style (16pt regular).
    ///
    /// Supporting text, slightly smaller than body.
    public let callout: DSTextStyle
    
    /// Subheadline style (15pt regular).
    ///
    /// Secondary content, row subtitles.
    public let subheadline: DSTextStyle
    
    /// Footnote style (13pt regular).
    ///
    /// Small text, helper messages, timestamps.
    public let footnote: DSTextStyle
    
    /// Caption 1 style (12pt regular).
    ///
    /// Captions, small labels.
    public let caption1: DSTextStyle
    
    /// Caption 2 style (11pt regular).
    ///
    /// Smallest readable text, badges.
    public let caption2: DSTextStyle
    
    /// Creates a new system typography instance.
    public init(
        largeTitle: DSTextStyle,
        title1: DSTextStyle,
        title2: DSTextStyle,
        title3: DSTextStyle,
        headline: DSTextStyle,
        body: DSTextStyle,
        callout: DSTextStyle,
        subheadline: DSTextStyle,
        footnote: DSTextStyle,
        caption1: DSTextStyle,
        caption2: DSTextStyle
    ) {
        self.largeTitle = largeTitle
        self.title1 = title1
        self.title2 = title2
        self.title3 = title3
        self.headline = headline
        self.body = body
        self.callout = callout
        self.subheadline = subheadline
        self.footnote = footnote
        self.caption1 = caption1
        self.caption2 = caption2
    }
}

// MARK: - Component Text Styles

/// Component-specific text style roles.
///
/// These roles are tailored for specific UI components
/// and may vary by platform and density.
///
/// ## Overview
///
/// | Role | Purpose |
/// |------|---------|
/// | ``buttonLabel`` | Button text |
/// | ``fieldText`` | Text field input |
/// | ``fieldPlaceholder`` | Placeholder text |
/// | ``helperText`` | Field helper/error messages |
/// | ``rowTitle`` | List row primary text |
/// | ``rowValue`` | List row secondary value |
/// | ``sectionHeader`` | Section header text |
/// | ``badgeText`` | Badge/tag labels |
/// | ``monoText`` | Monospace text for codes |
public struct DSComponentTypography: Sendable, Equatable {
    
    /// Button label style.
    ///
    /// Text for button controls.
    /// - iOS: 17pt semibold (Headline)
    /// - macOS: 14-15pt semibold
    public let buttonLabel: DSTextStyle
    
    /// Field text style.
    ///
    /// Input text in text fields.
    /// - Default: Body/Callout size
    public let fieldText: DSTextStyle
    
    /// Field placeholder style.
    ///
    /// Placeholder text in empty fields.
    /// - Same size as fieldText but reduced opacity
    public let fieldPlaceholder: DSTextStyle
    
    /// Helper text style.
    ///
    /// Helper messages, validation errors below fields.
    /// - Default: Footnote size
    public let helperText: DSTextStyle
    
    /// Row title style.
    ///
    /// Primary text in list/form rows.
    /// - Default: Body/Headline (varies by density)
    public let rowTitle: DSTextStyle
    
    /// Row value style.
    ///
    /// Secondary value text in list rows.
    /// - Default: Subheadline with secondary color
    public let rowValue: DSTextStyle
    
    /// Section header style.
    ///
    /// Headers for grouped sections.
    /// - Default: Footnote semibold, optional uppercase
    public let sectionHeader: DSTextStyle
    
    /// Badge text style.
    ///
    /// Text inside badges and tags.
    /// - Default: Caption1 semibold
    public let badgeText: DSTextStyle
    
    /// Monospace text style.
    ///
    /// Code, identifiers, technical values.
    /// - Default: 16pt monospace
    public let monoText: DSTextStyle
    
    /// Creates a new component typography instance.
    public init(
        buttonLabel: DSTextStyle,
        fieldText: DSTextStyle,
        fieldPlaceholder: DSTextStyle,
        helperText: DSTextStyle,
        rowTitle: DSTextStyle,
        rowValue: DSTextStyle,
        sectionHeader: DSTextStyle,
        badgeText: DSTextStyle,
        monoText: DSTextStyle
    ) {
        self.buttonLabel = buttonLabel
        self.fieldText = fieldText
        self.fieldPlaceholder = fieldPlaceholder
        self.helperText = helperText
        self.rowTitle = rowTitle
        self.rowValue = rowValue
        self.sectionHeader = sectionHeader
        self.badgeText = badgeText
        self.monoText = monoText
    }
}

// MARK: - DSTypography Container

/// Complete semantic typography system.
///
/// `DSTypography` contains all text styles organized by category.
/// Components use these semantic roles for consistent text styling.
///
/// ## Categories
///
/// - ``system``: Standard Apple HIG text styles
/// - ``component``: Component-specific text styles
///
/// ## Usage
///
/// ```swift
/// @Environment(\.dsTheme) private var theme
///
/// var body: some View {
///     VStack {
///         Text("Title")
///             .font(theme.typography.system.title1.font)
///         Text("Body content")
///             .font(theme.typography.system.body.font)
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Text Styles
///
/// - ``DSTextStyle``
/// - ``DSSystemTypography``
/// - ``DSComponentTypography``
public struct DSTypography: Sendable, Equatable {
    
    /// System text styles following Apple HIG.
    public let system: DSSystemTypography
    
    /// Component-specific text styles.
    public let component: DSComponentTypography
    
    /// Creates a new typography container.
    ///
    /// - Parameters:
    ///   - system: System text styles
    ///   - component: Component text styles
    public init(
        system: DSSystemTypography,
        component: DSComponentTypography
    ) {
        self.system = system
        self.component = component
    }
}
