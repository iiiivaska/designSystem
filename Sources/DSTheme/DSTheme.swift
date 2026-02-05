// DSTheme.swift
// DesignSystem
//
// Theme container with semantic color, typography, and spacing roles.
// The theme resolver maps raw tokens to semantic roles based on variant and accessibility.

import SwiftUI
import DSCore
import DSTokens

// MARK: - Theme Variant

/// Theme color scheme variant.
///
/// Determines which color palette to use.
public enum DSThemeVariant: String, Sendable, Equatable, CaseIterable {
    /// Light color scheme.
    case light
    
    /// Dark color scheme.
    case dark
    
    /// Creates a variant from system color scheme.
    ///
    /// - Parameter colorScheme: SwiftUI color scheme
    public init(from colorScheme: ColorScheme) {
        switch colorScheme {
        case .dark:
            self = .dark
        case .light:
            self = .light
        @unknown default:
            self = .light
        }
    }
}

// MARK: - DSTheme

/// Main theme container with semantic design roles.
///
/// `DSTheme` is the central container for all semantic design values.
/// Components access these values through the SwiftUI environment.
///
/// ## Overview
///
/// The theme contains semantic roles organized into categories:
///
/// - ``colors``: Background, foreground, accent, and state colors
/// - ``typography``: System and component text styles
/// - ``spacing``: Padding, gaps, insets, and row heights
/// - ``radii``: Corner radius values
/// - ``shadows``: Elevation and border styles
/// - ``motion``: Animation timing and springs
///
/// ## Environment Access
///
/// Components access the theme through the environment:
///
/// ```swift
/// struct MyView: View {
///     @Environment(\.dsTheme) private var theme
///
///     var body: some View {
///         Text("Hello")
///             .font(theme.typography.system.body.font)
///             .foregroundStyle(theme.colors.fg.primary)
///     }
/// }
/// ```
///
/// ## Theme Application
///
/// Apply a theme to a view hierarchy:
///
/// ```swift
/// ContentView()
///     .dsTheme(.light)
/// ```
///
/// ## Topics
///
/// ### Semantic Categories
///
/// - ``DSColors``
/// - ``DSTypography``
/// - ``DSSpacing``
/// - ``DSRadii``
/// - ``DSShadows``
/// - ``DSMotion``
///
/// ### Component Styles
///
/// - ``DSComponentStyles``
/// - ``componentStyles``
/// - ``resolveButton(variant:size:state:)``
/// - ``resolveField(variant:state:validation:)``
/// - ``resolveToggle(isOn:state:)``
/// - ``resolveFormRow(layoutMode:capabilities:)``
/// - ``resolveCard(elevation:)``
/// - ``resolveListRow(style:state:capabilities:)``
///
/// ### Configuration
///
/// - ``DSThemeVariant``
/// - ``init(variant:density:reduceMotion:)``
/// - ``init(variant:accessibility:density:)``
public struct DSTheme: Sendable, Equatable, DSThemeProtocol {
    
    // MARK: - DSThemeProtocol
    
    /// Unique identifier for the theme.
    public var id: String {
        "\(variant.rawValue)-\(density.rawValue)"
    }
    
    /// Human-readable name for the theme.
    public var displayName: String {
        switch variant {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
    
    // MARK: - Version
    
    /// Current version of the theme system.
    public static let version = "0.1.0"
    
    // MARK: - Properties
    
    /// The theme variant (light/dark).
    public let variant: DSThemeVariant
    
    /// Whether this is a dark theme.
    public var isDark: Bool { variant == .dark }
    
    /// Current density setting.
    public let density: DSDensity
    
    /// Semantic color roles.
    public let colors: DSColors
    
    /// Semantic typography roles.
    public let typography: DSTypography
    
    /// Semantic spacing roles.
    public let spacing: DSSpacing
    
    /// Semantic corner radius roles.
    public let radii: DSRadii
    
    /// Semantic shadow and elevation roles.
    public let shadows: DSShadows
    
    /// Semantic animation roles.
    public let motion: DSMotion
    
    /// Component style resolvers.
    ///
    /// The registry of spec resolvers for each component type.
    /// Override individual resolvers to customize component styling:
    ///
    /// ```swift
    /// var styles = DSComponentStyles.default
    /// styles.button = DSButtonStyleResolver(id: "custom") { theme, variant, size, state in
    ///     // Custom button spec resolution
    /// }
    /// let theme = DSTheme(variant: .light, componentStyles: styles)
    /// ```
    public let componentStyles: DSComponentStyles
    
    // MARK: - Initializers
    
    /// Creates a theme with all semantic categories.
    ///
    /// - Parameters:
    ///   - variant: Theme variant (light/dark)
    ///   - density: UI density setting
    ///   - colors: Semantic colors
    ///   - typography: Semantic typography
    ///   - spacing: Semantic spacing
    ///   - radii: Semantic radii
    ///   - shadows: Semantic shadows
    ///   - motion: Semantic motion
    ///   - componentStyles: Component style resolvers (default: `.default`)
    public init(
        variant: DSThemeVariant,
        density: DSDensity,
        colors: DSColors,
        typography: DSTypography,
        spacing: DSSpacing,
        radii: DSRadii,
        shadows: DSShadows,
        motion: DSMotion,
        componentStyles: DSComponentStyles = .default
    ) {
        self.variant = variant
        self.density = density
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.radii = radii
        self.shadows = shadows
        self.motion = motion
        self.componentStyles = componentStyles
    }
    
    /// Creates a theme from tokens with variant and accessibility settings.
    ///
    /// This is the primary factory method for creating themes.
    /// It resolves raw tokens into semantic roles based on the
    /// provided settings.
    ///
    /// - Parameters:
    ///   - variant: Theme variant (light/dark)
    ///   - density: UI density (default: `.regular`)
    ///   - reduceMotion: Whether to reduce animations (default: `false`)
    ///   - componentStyles: Component style resolvers (default: `.default`)
    public init(
        variant: DSThemeVariant,
        density: DSDensity = .regular,
        reduceMotion: Bool = false,
        componentStyles: DSComponentStyles = .default
    ) {
        self.variant = variant
        self.density = density
        
        // Resolve colors from tokens
        self.colors = DSTheme.resolveColors(variant: variant)
        
        // Resolve typography (uses colors for text color)
        self.typography = DSTheme.resolveTypography(
            colors: self.colors
        )
        
        // Resolve spacing with density
        self.spacing = DSTheme.resolveSpacing(density: density)
        
        // Resolve radii from tokens
        self.radii = DSRadii()
        
        // Resolve shadows for variant
        self.shadows = DSTheme.resolveShadows(variant: variant)
        
        // Resolve motion with accessibility
        self.motion = reduceMotion ? .reducedMotion : .standard
        
        // Component style resolvers
        self.componentStyles = componentStyles
    }
    
    /// Creates a theme from tokens with full accessibility support.
    ///
    /// This is the preferred factory method for creating themes with
    /// full accessibility integration, including dynamic type, high
    /// contrast, reduce motion, and bold text support.
    ///
    /// - Parameters:
    ///   - variant: Theme variant (light/dark)
    ///   - accessibility: Accessibility settings to apply
    ///   - density: UI density (default: `.regular`)
    ///   - componentStyles: Component style resolvers (default: `.default`)
    public init(
        variant: DSThemeVariant,
        accessibility: DSAccessibilityPolicy,
        density: DSDensity = .regular,
        componentStyles: DSComponentStyles = .default
    ) {
        let resolved = DSThemeResolver.resolve(
            variant: variant,
            accessibility: accessibility,
            density: density
        )
        
        self.variant = resolved.variant
        self.density = resolved.density
        self.colors = resolved.colors
        self.typography = resolved.typography
        self.spacing = resolved.spacing
        self.radii = resolved.radii
        self.shadows = resolved.shadows
        self.motion = resolved.motion
        self.componentStyles = componentStyles
    }
    
    /// Creates a theme from resolver input.
    ///
    /// - Parameters:
    ///   - input: The resolver input configuration.
    ///   - componentStyles: Component style resolvers (default: `.default`)
    public init(
        from input: DSThemeResolverInput,
        componentStyles: DSComponentStyles = .default
    ) {
        self.init(
            variant: input.variant,
            accessibility: input.accessibility,
            density: input.density,
            componentStyles: componentStyles
        )
    }
    
    /// Creates a default light theme.
    public init() {
        self.init(variant: .light, componentStyles: .default)
    }
    
    // MARK: - Factory Methods
    
    /// Light theme with standard settings.
    public static let light = DSTheme(variant: .light)
    
    /// Dark theme with standard settings.
    public static let dark = DSTheme(variant: .dark)
    
    /// Light theme with accessibility support.
    ///
    /// - Parameter accessibility: Accessibility settings to apply.
    /// - Returns: A light theme with accessibility adjustments.
    public static func light(
        accessibility: DSAccessibilityPolicy,
        density: DSDensity = .regular
    ) -> DSTheme {
        DSTheme(
            variant: .light,
            accessibility: accessibility,
            density: density
        )
    }
    
    /// Dark theme with accessibility support.
    ///
    /// - Parameter accessibility: Accessibility settings to apply.
    /// - Returns: A dark theme with accessibility adjustments.
    public static func dark(
        accessibility: DSAccessibilityPolicy,
        density: DSDensity = .regular
    ) -> DSTheme {
        DSTheme(
            variant: .dark,
            accessibility: accessibility,
            density: density
        )
    }
    
    /// Creates a theme matching the system appearance.
    ///
    /// - Parameters:
    ///   - colorScheme: System color scheme
    ///   - density: UI density
    ///   - reduceMotion: Whether to reduce animations
    /// - Returns: A theme matching system settings
    public static func system(
        colorScheme: ColorScheme,
        density: DSDensity = .regular,
        reduceMotion: Bool = false
    ) -> DSTheme {
        DSTheme(
            variant: DSThemeVariant(from: colorScheme),
            density: density,
            reduceMotion: reduceMotion
        )
    }
    
    /// Creates a theme matching the system appearance with full accessibility.
    ///
    /// - Parameters:
    ///   - colorScheme: System color scheme.
    ///   - accessibility: Accessibility settings.
    ///   - density: UI density.
    /// - Returns: A theme matching system settings with accessibility.
    public static func system(
        colorScheme: ColorScheme,
        accessibility: DSAccessibilityPolicy,
        density: DSDensity = .regular
    ) -> DSTheme {
        DSTheme(
            variant: DSThemeVariant(from: colorScheme),
            accessibility: accessibility,
            density: density
        )
    }
}

// MARK: - Spec Resolution Convenience

extension DSTheme {
    
    /// Resolves a button spec using this theme's component styles.
    ///
    /// This is a convenience wrapper around
    /// `componentStyles.button.resolve(theme:variant:size:state:)`.
    ///
    /// - Parameters:
    ///   - variant: Button variant.
    ///   - size: Button size.
    ///   - state: Current interaction state.
    /// - Returns: A fully resolved ``DSButtonSpec``.
    public func resolveButton(
        variant: DSButtonVariant,
        size: DSButtonSize,
        state: DSControlState
    ) -> DSButtonSpec {
        componentStyles.button.resolve(theme: self, variant: variant, size: size, state: state)
    }
    
    /// Resolves a field spec using this theme's component styles.
    ///
    /// This is a convenience wrapper around
    /// `componentStyles.field.resolve(theme:variant:state:validation:)`.
    ///
    /// - Parameters:
    ///   - variant: Field variant.
    ///   - state: Current interaction state.
    ///   - validation: Current validation state.
    /// - Returns: A fully resolved ``DSFieldSpec``.
    public func resolveField(
        variant: DSFieldVariant,
        state: DSControlState,
        validation: DSValidationState = .none
    ) -> DSFieldSpec {
        componentStyles.field.resolve(theme: self, variant: variant, state: state, validation: validation)
    }
    
    /// Resolves a toggle spec using this theme's component styles.
    ///
    /// This is a convenience wrapper around
    /// `componentStyles.toggle.resolve(theme:isOn:state:)`.
    ///
    /// - Parameters:
    ///   - isOn: Whether the toggle is on.
    ///   - state: Current interaction state.
    /// - Returns: A fully resolved ``DSToggleSpec``.
    public func resolveToggle(
        isOn: Bool,
        state: DSControlState
    ) -> DSToggleSpec {
        componentStyles.toggle.resolve(theme: self, isOn: isOn, state: state)
    }
    
    /// Resolves a form row spec using this theme's component styles.
    ///
    /// This is a convenience wrapper around
    /// `componentStyles.formRow.resolve(theme:layoutMode:capabilities:)`.
    ///
    /// - Parameters:
    ///   - layoutMode: Layout mode (auto or fixed).
    ///   - capabilities: Platform capabilities.
    /// - Returns: A fully resolved ``DSFormRowSpec``.
    public func resolveFormRow(
        layoutMode: DSFormRowLayoutMode = .auto,
        capabilities: DSCapabilities
    ) -> DSFormRowSpec {
        componentStyles.formRow.resolve(theme: self, layoutMode: layoutMode, capabilities: capabilities)
    }
    
    /// Resolves a card spec using this theme's component styles.
    ///
    /// This is a convenience wrapper around
    /// `componentStyles.card.resolve(theme:elevation:)`.
    ///
    /// - Parameter elevation: Card elevation level.
    /// - Returns: A fully resolved ``DSCardSpec``.
    public func resolveCard(
        elevation: DSCardElevation
    ) -> DSCardSpec {
        componentStyles.card.resolve(theme: self, elevation: elevation)
    }
    
    /// Resolves a list row spec using this theme's component styles.
    ///
    /// This is a convenience wrapper around
    /// `componentStyles.listRow.resolve(theme:style:state:capabilities:)`.
    ///
    /// - Parameters:
    ///   - style: Row visual style.
    ///   - state: Current interaction state.
    ///   - capabilities: Platform capabilities.
    /// - Returns: A fully resolved ``DSListRowSpec``.
    public func resolveListRow(
        style: DSListRowStyle,
        state: DSControlState,
        capabilities: DSCapabilities
    ) -> DSListRowSpec {
        componentStyles.listRow.resolve(theme: self, style: style, state: state, capabilities: capabilities)
    }
}

// MARK: - Token Resolution

extension DSTheme {
    
    /// Resolves semantic colors from tokens for the given variant.
    static func resolveColors(variant: DSThemeVariant) -> DSColors {
        let isDark = variant == .dark
        
        // Background colors (matching DSBackgroundColors structure)
        let bg = DSBackgroundColors(
            canvas: Color(hex: isDark ? DSDarkNeutrals.d1 : DSLightNeutrals.n1),
            surface: Color(hex: isDark ? DSDarkNeutrals.d2 : DSLightNeutrals.n0),
            surfaceElevated: Color(hex: isDark ? DSDarkNeutrals.d3 : DSLightNeutrals.n0),
            card: Color(hex: isDark ? DSDarkNeutrals.d3 : DSLightNeutrals.n0)
        )
        
        // Foreground colors (matching DSForegroundColors structure)
        let fg = DSForegroundColors(
            primary: Color(hex: isDark ? DSDarkNeutrals.d8 : DSLightNeutrals.n9),
            secondary: Color(hex: isDark ? DSDarkNeutrals.d7 : DSLightNeutrals.n7),
            tertiary: Color(hex: isDark ? DSDarkNeutrals.d6 : DSLightNeutrals.n6),
            disabled: Color(hex: isDark ? DSDarkNeutrals.d6 : DSLightNeutrals.n6).opacity(isDark ? 0.55 : 0.5)
        )
        
        // Border colors (matching DSBorderColors structure)
        let border = DSBorderColors(
            subtle: Color(hex: isDark ? DSDarkNeutrals.d4 : DSLightNeutrals.n3).opacity(isDark ? 0.55 : 1.0),
            strong: Color(hex: isDark ? DSDarkNeutrals.d4 : DSLightNeutrals.n4),
            separator: Color(hex: isDark ? DSDarkNeutrals.d4 : DSLightNeutrals.n3).opacity(isDark ? 0.45 : 1.0)
        )
        
        // Accent colors (matching DSAccentColors structure)
        let accent = DSAccentColors(
            primary: Color(hex: isDark ? DSTealAccent.tealDarkA : DSTealAccent.teal500),
            secondary: Color(hex: isDark ? DSIndigoAccent.indigoDarkA : DSIndigoAccent.indigo600)
        )
        
        // State colors (matching DSStateColors structure)
        let state = DSStateColors(
            success: Color(hex: isDark ? DSGreenState.greenDarkA : DSGreenState.green500),
            warning: Color(hex: isDark ? DSYellowState.yellowDarkA : DSYellowState.yellow500),
            danger: Color(hex: isDark ? DSRedState.redDarkA : DSRedState.red500),
            info: Color(hex: isDark ? DSBlueState.blueDarkA : DSBlueState.blue500)
        )
        
        // Focus ring
        let focusRing = Color(hex: isDark ? DSTealAccent.tealDarkGlow : DSTealAccent.teal300)
            .opacity(isDark ? 0.55 : 0.7)
        
        return DSColors(
            bg: bg,
            fg: fg,
            border: border,
            accent: accent,
            state: state,
            focusRing: focusRing
        )
    }
    
    /// Resolves semantic typography from tokens.
    static func resolveTypography(colors: DSColors) -> DSTypography {
        // System typography
        let system = DSSystemTypography(
            largeTitle: .system(
                size: DSFontSize.largeTitle,
                weight: .bold,
                color: colors.fg.primary
            ),
            title1: .system(
                size: DSFontSize.title1,
                weight: .bold,
                color: colors.fg.primary
            ),
            title2: .system(
                size: DSFontSize.title2,
                weight: .semibold,
                color: colors.fg.primary
            ),
            title3: .system(
                size: DSFontSize.title3,
                weight: .semibold,
                color: colors.fg.primary
            ),
            headline: .system(
                size: DSFontSize.headline,
                weight: .semibold,
                color: colors.fg.primary
            ),
            body: .system(
                size: DSFontSize.body,
                weight: .regular,
                color: colors.fg.primary
            ),
            callout: .system(
                size: DSFontSize.callout,
                weight: .regular,
                color: colors.fg.secondary
            ),
            subheadline: .system(
                size: DSFontSize.subheadline,
                weight: .regular,
                color: colors.fg.secondary
            ),
            footnote: .system(
                size: DSFontSize.footnote,
                weight: .regular,
                color: colors.fg.tertiary
            ),
            caption1: .system(
                size: DSFontSize.caption1,
                weight: .regular,
                color: colors.fg.tertiary
            ),
            caption2: .system(
                size: DSFontSize.caption2,
                weight: .regular,
                color: colors.fg.tertiary
            )
        )
        
        // Component typography (matching DSComponentTypography structure)
        let component = DSComponentTypography(
            buttonLabel: .system(
                size: DSFontSize.body,
                weight: .semibold,
                color: colors.fg.primary
            ),
            fieldText: .system(
                size: DSFontSize.body,
                weight: .regular,
                color: colors.fg.primary
            ),
            fieldPlaceholder: .system(
                size: DSFontSize.body,
                weight: .regular,
                color: colors.fg.tertiary
            ),
            helperText: .system(
                size: DSFontSize.footnote,
                weight: .regular,
                color: colors.fg.secondary
            ),
            rowTitle: .system(
                size: DSFontSize.body,
                weight: .regular,
                color: colors.fg.primary
            ),
            rowValue: .system(
                size: DSFontSize.body,
                weight: .regular,
                color: colors.fg.secondary
            ),
            sectionHeader: .system(
                size: DSFontSize.footnote,
                weight: .semibold,
                color: colors.fg.secondary,
                letterSpacing: DSLetterSpacing.caps
            ),
            badgeText: .system(
                size: DSFontSize.caption1,
                weight: .semibold,
                color: colors.fg.primary
            ),
            monoText: .system(
                size: DSFontSize.mono,
                weight: .regular,
                color: colors.fg.primary,
                design: .monospaced
            )
        )
        
        return DSTypography(system: system, component: component)
    }
    
    /// Resolves semantic spacing from tokens with density adjustment.
    static func resolveSpacing(density: DSDensity) -> DSSpacing {
        // Access raw spacing tokens via DSSpacingScale to avoid name collision
        // with the semantic DSSpacing struct in this module
        let spacingTokens = DSSpacingScale.named
        
        // Base padding roles (matching DSPaddingRoles structure)
        let basePadding = DSPaddingRoles(
            xxs: spacingTokens.xxs,
            xs: spacingTokens.xs,
            s: spacingTokens.s,
            m: spacingTokens.m,
            l: spacingTokens.l,
            xl: spacingTokens.xl,
            xxl: spacingTokens.xxl
        )
        
        // Apply density
        let padding = DSPaddingRoles.withDensity(basePadding, density: density)
        
        // Gap roles (matching DSGapRoles structure)
        let gap = DSGapRoles(
            row: DSComponentSpacing.rowGap * density.spacingMultiplier,
            section: DSComponentSpacing.sectionGap * density.spacingMultiplier,
            stack: spacingTokens.s * density.spacingMultiplier,
            inline: spacingTokens.xs * density.spacingMultiplier,
            dashboard: DSComponentSpacing.dashboardBlockGap * density.spacingMultiplier
        )
        
        // Insets roles (matching DSInsetsRoles structure)
        let screenInset = spacingTokens.l * density.spacingMultiplier
        let cardInset = DSComponentSpacing.cardPadding * density.spacingMultiplier
        let sectionInset = spacingTokens.l * density.spacingMultiplier
        
        let insets = DSInsetsRoles(
            screen: EdgeInsets(top: screenInset, leading: screenInset, bottom: screenInset, trailing: screenInset),
            card: EdgeInsets(top: cardInset, leading: cardInset, bottom: cardInset, trailing: cardInset),
            section: EdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
        )
        
        // Row height roles (matching DSRowHeightRoles structure)
        let rowHeight = DSRowHeightRoles(
            minimum: DSRowHeight.iOSMinimum * density.controlHeightMultiplier,
            default: DSRowHeight.iOSDefault * density.controlHeightMultiplier,
            compact: DSRowHeight.macOSCompact * density.controlHeightMultiplier,
            large: DSRowHeight.watchOSDefault * density.controlHeightMultiplier
        )
        
        return DSSpacing(
            padding: padding,
            gap: gap,
            insets: insets,
            rowHeight: rowHeight
        )
    }
    
    /// Resolves semantic shadows from tokens for the given variant.
    static func resolveShadows(variant: DSThemeVariant) -> DSShadows {
        let isDark = variant == .dark
        
        // Elevation roles (matching DSElevationRoles structure)
        let elevation = DSElevationRoles(
            flat: .none,
            subtle: DSShadowStyle.from(DSShadow.subtle, isDark: isDark),
            raised: DSShadowStyle.from(DSShadow.small, isDark: isDark),
            elevated: DSShadowStyle.from(DSShadow.medium, isDark: isDark),
            overlay: DSShadowStyle.from(DSShadow.large, isDark: isDark),
            floating: DSShadowStyle.from(DSShadow.extraLarge, isDark: isDark)
        )
        
        // Get border colors
        let subtleBorderColor = Color(hex: isDark ? DSDarkNeutrals.d4 : DSLightNeutrals.n3)
        let strongBorderColor = Color(hex: isDark ? DSDarkNeutrals.d4 : DSLightNeutrals.n4)
        let focusRingColor = Color(hex: isDark ? DSTealAccent.tealDarkGlow : DSTealAccent.teal300)
        
        // Stroke roles (matching DSStrokeRoles structure)
        let stroke = DSStrokeRoles(
            default: DSBorderStyle.from(DSBorder.default, baseColor: subtleBorderColor, isDark: isDark),
            strong: DSBorderStyle.from(DSBorder.strong, baseColor: strongBorderColor, isDark: isDark),
            separator: DSBorderStyle.from(DSBorder.separator, baseColor: subtleBorderColor, isDark: isDark),
            focusRing: DSBorderStyle.from(DSBorder.focusRing, baseColor: focusRingColor, isDark: isDark),
            glass: DSBorderStyle.from(DSBorder.glass, baseColor: subtleBorderColor, isDark: isDark)
        )
        
        // Component shadow roles (matching DSComponentShadowRoles structure)
        let component = DSComponentShadowRoles(
            card: DSShadowStyle.from(DSComponentShadow.card, isDark: isDark),
            cardFlat: .none,
            cardRaised: DSShadowStyle.from(DSComponentShadow.cardRaised, isDark: isDark),
            button: DSShadowStyle.from(DSComponentShadow.button, isDark: isDark),
            modal: DSShadowStyle.from(DSComponentShadow.modal, isDark: isDark),
            popover: DSShadowStyle.from(DSComponentShadow.popover, isDark: isDark),
            dropdown: DSShadowStyle.from(DSComponentShadow.dropdown, isDark: isDark),
            tooltip: DSShadowStyle.from(DSComponentShadow.tooltip, isDark: isDark)
        )
        
        return DSShadows(
            elevation: elevation,
            stroke: stroke,
            component: component
        )
    }
}

// MARK: - Environment Key

private struct DSThemeKey: EnvironmentKey {
    static let defaultValue = DSTheme()
}

public extension EnvironmentValues {
    /// The current design system theme
    var dsTheme: DSTheme {
        get { self[DSThemeKey.self] }
        set { self[DSThemeKey.self] = newValue }
    }
}

public extension View {
    /// Applies a design system theme to the view hierarchy
    /// - Parameter theme: The theme to apply
    /// - Returns: A view with the theme applied
    func dsTheme(_ theme: DSTheme) -> some View {
        environment(\.dsTheme, theme)
    }
}
