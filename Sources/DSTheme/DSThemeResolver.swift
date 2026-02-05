// DSThemeResolver.swift
// DesignSystem
//
// Theme resolver that maps raw tokens to semantic roles based on
// variant, accessibility policy, density, and platform capabilities.

import SwiftUI
import DSCore
import DSTokens

// MARK: - Theme Resolver

/// Resolves raw design tokens into a complete semantic theme.
///
/// `DSThemeResolver` is the central mechanism for creating themed configurations.
/// It takes raw tokens and applies various modifiers (variant, accessibility,
/// density, platform) to produce a complete `DSTheme`.
///
/// ## Overview
///
/// The resolver is the **only** place where:
/// - Light/dark variant selection happens
/// - High contrast adjustments are applied
/// - Reduce motion settings affect animations
/// - Dynamic type scales typography
/// - Density affects spacing
/// - Platform differences are considered
///
/// ## Usage
///
/// ```swift
/// // Basic resolution
/// let theme = DSThemeResolver.resolve(
///     variant: .dark,
///     accessibility: accessibility,
///     density: .compact
/// )
///
/// // Using input struct
/// let input = DSThemeResolverInput(
///     variant: .light,
///     accessibility: .default,
///     density: .regular
/// )
/// let theme = DSThemeResolver.resolve(input)
/// ```
///
/// ## Topics
///
/// ### Resolution Input
///
/// - ``DSThemeResolverInput``
///
/// ### Resolution Methods
///
/// - ``resolve(_:)``
/// - ``resolve(variant:accessibility:density:)``
///
/// ### Category Resolvers
///
/// - ``resolveColors(variant:accessibility:)``
/// - ``resolveTypography(colors:accessibility:)``
/// - ``resolveSpacing(density:accessibility:)``
/// - ``resolveRadii()``
/// - ``resolveShadows(variant:accessibility:)``
/// - ``resolveMotion(accessibility:)``
public enum DSThemeResolver {
    
    // MARK: - Main Resolution
    
    /// Resolves a complete theme from input configuration.
    ///
    /// This is the primary entry point for theme resolution. It takes
    /// all configuration in a single input struct and produces a
    /// complete, resolved theme.
    ///
    /// - Parameter input: The resolution input configuration.
    /// - Returns: A fully resolved `DSTheme`.
    public static func resolve(_ input: DSThemeResolverInput) -> DSTheme {
        resolve(
            variant: input.variant,
            accessibility: input.accessibility,
            density: input.density
        )
    }
    
    /// Resolves a complete theme from individual parameters.
    ///
    /// - Parameters:
    ///   - variant: Theme variant (light/dark).
    ///   - accessibility: Accessibility settings to apply.
    ///   - density: UI density setting.
    /// - Returns: A fully resolved `DSTheme`.
    public static func resolve(
        variant: DSThemeVariant,
        accessibility: DSAccessibilityPolicy = .default,
        density: DSDensity = .regular
    ) -> DSTheme {
        // Resolve each category
        let colors = resolveColors(
            variant: variant,
            accessibility: accessibility
        )
        
        let typography = resolveTypography(
            colors: colors,
            accessibility: accessibility
        )
        
        let spacing = resolveSpacing(
            density: density,
            accessibility: accessibility
        )
        
        let radii = resolveRadii()
        
        let shadows = resolveShadows(
            variant: variant,
            accessibility: accessibility
        )
        
        let motion = resolveMotion(
            accessibility: accessibility
        )
        
        return DSTheme(
            variant: variant,
            density: density,
            colors: colors,
            typography: typography,
            spacing: spacing,
            radii: radii,
            shadows: shadows,
            motion: motion
        )
    }
    
    // MARK: - Color Resolution
    
    /// Resolves semantic colors from tokens.
    ///
    /// - Parameters:
    ///   - variant: Theme variant determining base palette.
    ///   - accessibility: Accessibility settings for contrast adjustments.
    /// - Returns: Resolved semantic colors.
    public static func resolveColors(
        variant: DSThemeVariant,
        accessibility: DSAccessibilityPolicy
    ) -> DSColors {
        let isDark = variant == .dark
        let highContrast = accessibility.increasedContrast
        
        // Background colors
        let bg = resolveBackgroundColors(isDark: isDark)
        
        // Foreground colors with optional contrast boost
        let fg = resolveForegroundColors(
            isDark: isDark,
            highContrast: highContrast
        )
        
        // Border colors with optional contrast boost
        let border = resolveBorderColors(
            isDark: isDark,
            highContrast: highContrast
        )
        
        // Accent colors (dusty variants in dark mode)
        let accent = resolveAccentColors(isDark: isDark)
        
        // State colors
        let state = resolveStateColors(isDark: isDark)
        
        // Focus ring
        let focusRing = resolveFocusRingColor(
            isDark: isDark,
            highContrast: highContrast
        )
        
        return DSColors(
            bg: bg,
            fg: fg,
            border: border,
            accent: accent,
            state: state,
            focusRing: focusRing
        )
    }
    
    // MARK: - Typography Resolution
    
    /// Resolves semantic typography from tokens.
    ///
    /// - Parameters:
    ///   - colors: Resolved colors for text styling.
    ///   - accessibility: Accessibility settings for dynamic type.
    /// - Returns: Resolved semantic typography.
    public static func resolveTypography(
        colors: DSColors,
        accessibility: DSAccessibilityPolicy
    ) -> DSTypography {
        let scaleFactor = accessibility.dynamicTypeSize.scaleFactor
        let isBold = accessibility.isBoldTextEnabled
        
        // System typography
        let system = resolveSystemTypography(
            colors: colors,
            scaleFactor: scaleFactor,
            isBold: isBold
        )
        
        // Component typography
        let component = resolveComponentTypography(
            colors: colors,
            scaleFactor: scaleFactor,
            isBold: isBold
        )
        
        return DSTypography(system: system, component: component)
    }
    
    // MARK: - Spacing Resolution
    
    /// Resolves semantic spacing from tokens.
    ///
    /// - Parameters:
    ///   - density: UI density setting.
    ///   - accessibility: Accessibility settings for spacing adjustments.
    /// - Returns: Resolved semantic spacing.
    public static func resolveSpacing(
        density: DSDensity,
        accessibility: DSAccessibilityPolicy
    ) -> DSSpacing {
        let spacingTokens = DSSpacingScale.named
        let multiplier = density.spacingMultiplier
        
        // Apply additional scaling for accessibility sizes
        let accessibilityMultiplier: CGFloat = accessibility.dynamicTypeSize.isAccessibilitySize ? 1.15 : 1.0
        let totalMultiplier = multiplier * accessibilityMultiplier
        
        // Base padding roles
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
        
        // Gap roles
        let gap = DSGapRoles(
            row: DSComponentSpacing.rowGap * totalMultiplier,
            section: DSComponentSpacing.sectionGap * totalMultiplier,
            stack: spacingTokens.s * totalMultiplier,
            inline: spacingTokens.xs * totalMultiplier,
            dashboard: DSComponentSpacing.dashboardBlockGap * totalMultiplier
        )
        
        // Insets roles
        let screenInset = spacingTokens.l * totalMultiplier
        let cardInset = DSComponentSpacing.cardPadding * totalMultiplier
        let sectionInset = spacingTokens.l * totalMultiplier
        
        let insets = DSInsetsRoles(
            screen: EdgeInsets(
                top: screenInset,
                leading: screenInset,
                bottom: screenInset,
                trailing: screenInset
            ),
            card: EdgeInsets(
                top: cardInset,
                leading: cardInset,
                bottom: cardInset,
                trailing: cardInset
            ),
            section: EdgeInsets(
                top: sectionInset,
                leading: sectionInset,
                bottom: sectionInset,
                trailing: sectionInset
            )
        )
        
        // Row height roles
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
    
    // MARK: - Radii Resolution
    
    /// Resolves semantic radii from tokens.
    ///
    /// - Returns: Resolved semantic radii.
    public static func resolveRadii() -> DSRadii {
        DSRadii()
    }
    
    // MARK: - Shadows Resolution
    
    /// Resolves semantic shadows from tokens.
    ///
    /// - Parameters:
    ///   - variant: Theme variant for shadow opacity.
    ///   - accessibility: Accessibility settings for border visibility.
    /// - Returns: Resolved semantic shadows.
    public static func resolveShadows(
        variant: DSThemeVariant,
        accessibility: DSAccessibilityPolicy
    ) -> DSShadows {
        let isDark = variant == .dark
        let highContrast = accessibility.increasedContrast
        let reduceTransparency = accessibility.reduceTransparency
        
        // Elevation roles
        let elevation = resolveElevationRoles(
            isDark: isDark,
            reduceTransparency: reduceTransparency
        )
        
        // Stroke roles with optional contrast boost
        let stroke = resolveStrokeRoles(
            isDark: isDark,
            highContrast: highContrast
        )
        
        // Component shadow roles
        let component = resolveComponentShadowRoles(
            isDark: isDark,
            reduceTransparency: reduceTransparency
        )
        
        return DSShadows(
            elevation: elevation,
            stroke: stroke,
            component: component
        )
    }
    
    // MARK: - Motion Resolution
    
    /// Resolves semantic motion/animation from tokens.
    ///
    /// - Parameter accessibility: Accessibility settings for reduce motion.
    /// - Returns: Resolved semantic motion.
    public static func resolveMotion(
        accessibility: DSAccessibilityPolicy
    ) -> DSMotion {
        if accessibility.reduceMotion {
            return .reducedMotion
        }
        return .standard
    }
}

// MARK: - Private Color Resolution

private extension DSThemeResolver {
    
    static func resolveBackgroundColors(isDark: Bool) -> DSBackgroundColors {
        DSBackgroundColors(
            canvas: Color(hex: isDark ? DSDarkNeutrals.d1 : DSLightNeutrals.n1),
            surface: Color(hex: isDark ? DSDarkNeutrals.d2 : DSLightNeutrals.n0),
            surfaceElevated: Color(hex: isDark ? DSDarkNeutrals.d3 : DSLightNeutrals.n0),
            card: Color(hex: isDark ? DSDarkNeutrals.d3 : DSLightNeutrals.n0)
        )
    }
    
    static func resolveForegroundColors(
        isDark: Bool,
        highContrast: Bool
    ) -> DSForegroundColors {
        // In high contrast mode, push primary text darker/lighter
        let primaryHex: DSColorHex
        let secondaryHex: DSColorHex
        let tertiaryHex: DSColorHex
        
        if highContrast {
            // High contrast: maximize text visibility
            if isDark {
                primaryHex = DSDarkNeutrals.d9 // Pure white
                secondaryHex = DSDarkNeutrals.d8
                tertiaryHex = DSDarkNeutrals.d7
            } else {
                primaryHex = DSLightNeutrals.n9 // Near black
                secondaryHex = DSLightNeutrals.n8
                tertiaryHex = DSLightNeutrals.n7
            }
        } else {
            // Normal contrast
            primaryHex = isDark ? DSDarkNeutrals.d8 : DSLightNeutrals.n9
            secondaryHex = isDark ? DSDarkNeutrals.d7 : DSLightNeutrals.n7
            tertiaryHex = isDark ? DSDarkNeutrals.d6 : DSLightNeutrals.n6
        }
        
        let disabledOpacity = isDark ? 0.55 : 0.5
        
        return DSForegroundColors(
            primary: Color(hex: primaryHex),
            secondary: Color(hex: secondaryHex),
            tertiary: Color(hex: tertiaryHex),
            disabled: Color(hex: tertiaryHex).opacity(disabledOpacity)
        )
    }
    
    static func resolveBorderColors(
        isDark: Bool,
        highContrast: Bool
    ) -> DSBorderColors {
        // In high contrast mode, use more visible borders
        let subtleOpacity: Double
        let separatorOpacity: Double
        
        if highContrast {
            subtleOpacity = isDark ? 0.8 : 1.0
            separatorOpacity = isDark ? 0.7 : 1.0
        } else {
            subtleOpacity = isDark ? 0.55 : 1.0
            separatorOpacity = isDark ? 0.45 : 1.0
        }
        
        let subtleHex = isDark ? DSDarkNeutrals.d4 : DSLightNeutrals.n3
        let strongHex = isDark ? DSDarkNeutrals.d5 : DSLightNeutrals.n4
        
        return DSBorderColors(
            subtle: Color(hex: subtleHex).opacity(subtleOpacity),
            strong: Color(hex: strongHex),
            separator: Color(hex: subtleHex).opacity(separatorOpacity)
        )
    }
    
    static func resolveAccentColors(isDark: Bool) -> DSAccentColors {
        // Dark theme uses "dusty" variants with reduced saturation
        DSAccentColors(
            primary: Color(hex: isDark ? DSTealAccent.tealDarkA : DSTealAccent.teal500),
            secondary: Color(hex: isDark ? DSIndigoAccent.indigoDarkA : DSIndigoAccent.indigo600)
        )
    }
    
    static func resolveStateColors(isDark: Bool) -> DSStateColors {
        DSStateColors(
            success: Color(hex: isDark ? DSGreenState.greenDarkA : DSGreenState.green500),
            warning: Color(hex: isDark ? DSYellowState.yellowDarkA : DSYellowState.yellow500),
            danger: Color(hex: isDark ? DSRedState.redDarkA : DSRedState.red500),
            info: Color(hex: isDark ? DSBlueState.blueDarkA : DSBlueState.blue500)
        )
    }
    
    static func resolveFocusRingColor(
        isDark: Bool,
        highContrast: Bool
    ) -> Color {
        let opacity: Double = highContrast ? 0.9 : (isDark ? 0.55 : 0.7)
        let hex = isDark ? DSTealAccent.tealDarkGlow : DSTealAccent.teal300
        return Color(hex: hex).opacity(opacity)
    }
}

// MARK: - Private Typography Resolution

private extension DSThemeResolver {
    
    static func resolveSystemTypography(
        colors: DSColors,
        scaleFactor: CGFloat,
        isBold: Bool
    ) -> DSSystemTypography {
        // Apply scale factor to base sizes
        let largeTitleSize = DSFontSize.largeTitle * scaleFactor
        let title1Size = DSFontSize.title1 * scaleFactor
        let title2Size = DSFontSize.title2 * scaleFactor
        let title3Size = DSFontSize.title3 * scaleFactor
        let headlineSize = DSFontSize.headline * scaleFactor
        let bodySize = DSFontSize.body * scaleFactor
        let calloutSize = DSFontSize.callout * scaleFactor
        let subheadlineSize = DSFontSize.subheadline * scaleFactor
        let footnoteSize = DSFontSize.footnote * scaleFactor
        let caption1Size = DSFontSize.caption1 * scaleFactor
        let caption2Size = DSFontSize.caption2 * scaleFactor
        
        // Adjust weights for bold text preference
        let regularWeight: Font.Weight = isBold ? .medium : .regular
        let semiboldWeight: Font.Weight = isBold ? .bold : .semibold
        let boldWeight: Font.Weight = isBold ? .heavy : .bold
        
        return DSSystemTypography(
            largeTitle: .system(
                size: largeTitleSize,
                weight: boldWeight,
                color: colors.fg.primary
            ),
            title1: .system(
                size: title1Size,
                weight: boldWeight,
                color: colors.fg.primary
            ),
            title2: .system(
                size: title2Size,
                weight: semiboldWeight,
                color: colors.fg.primary
            ),
            title3: .system(
                size: title3Size,
                weight: semiboldWeight,
                color: colors.fg.primary
            ),
            headline: .system(
                size: headlineSize,
                weight: semiboldWeight,
                color: colors.fg.primary
            ),
            body: .system(
                size: bodySize,
                weight: regularWeight,
                color: colors.fg.primary
            ),
            callout: .system(
                size: calloutSize,
                weight: regularWeight,
                color: colors.fg.secondary
            ),
            subheadline: .system(
                size: subheadlineSize,
                weight: regularWeight,
                color: colors.fg.secondary
            ),
            footnote: .system(
                size: footnoteSize,
                weight: regularWeight,
                color: colors.fg.tertiary
            ),
            caption1: .system(
                size: caption1Size,
                weight: regularWeight,
                color: colors.fg.tertiary
            ),
            caption2: .system(
                size: caption2Size,
                weight: regularWeight,
                color: colors.fg.tertiary
            )
        )
    }
    
    static func resolveComponentTypography(
        colors: DSColors,
        scaleFactor: CGFloat,
        isBold: Bool
    ) -> DSComponentTypography {
        let bodySize = DSFontSize.body * scaleFactor
        let footnoteSize = DSFontSize.footnote * scaleFactor
        let caption1Size = DSFontSize.caption1 * scaleFactor
        let monoSize = DSFontSize.mono * scaleFactor
        
        let regularWeight: Font.Weight = isBold ? .medium : .regular
        let semiboldWeight: Font.Weight = isBold ? .bold : .semibold
        
        return DSComponentTypography(
            buttonLabel: .system(
                size: bodySize,
                weight: semiboldWeight,
                color: colors.fg.primary
            ),
            fieldText: .system(
                size: bodySize,
                weight: regularWeight,
                color: colors.fg.primary
            ),
            fieldPlaceholder: .system(
                size: bodySize,
                weight: regularWeight,
                color: colors.fg.tertiary
            ),
            helperText: .system(
                size: footnoteSize,
                weight: regularWeight,
                color: colors.fg.secondary
            ),
            rowTitle: .system(
                size: bodySize,
                weight: regularWeight,
                color: colors.fg.primary
            ),
            rowValue: .system(
                size: bodySize,
                weight: regularWeight,
                color: colors.fg.secondary
            ),
            sectionHeader: .system(
                size: footnoteSize,
                weight: semiboldWeight,
                color: colors.fg.secondary,
                letterSpacing: DSLetterSpacing.caps
            ),
            badgeText: .system(
                size: caption1Size,
                weight: semiboldWeight,
                color: colors.fg.primary
            ),
            monoText: .system(
                size: monoSize,
                weight: regularWeight,
                color: colors.fg.primary,
                design: .monospaced
            )
        )
    }
}

// MARK: - Private Shadow Resolution

private extension DSThemeResolver {
    
    static func resolveElevationRoles(
        isDark: Bool,
        reduceTransparency: Bool
    ) -> DSElevationRoles {
        // When reduce transparency is on, minimize shadow visibility
        let shadowMultiplier: Double = reduceTransparency ? 0.3 : 1.0
        
        return DSElevationRoles(
            flat: .none,
            subtle: adjustedShadow(
                DSShadowStyle.from(DSShadow.subtle, isDark: isDark),
                multiplier: shadowMultiplier
            ),
            raised: adjustedShadow(
                DSShadowStyle.from(DSShadow.small, isDark: isDark),
                multiplier: shadowMultiplier
            ),
            elevated: adjustedShadow(
                DSShadowStyle.from(DSShadow.medium, isDark: isDark),
                multiplier: shadowMultiplier
            ),
            overlay: adjustedShadow(
                DSShadowStyle.from(DSShadow.large, isDark: isDark),
                multiplier: shadowMultiplier
            ),
            floating: adjustedShadow(
                DSShadowStyle.from(DSShadow.extraLarge, isDark: isDark),
                multiplier: shadowMultiplier
            )
        )
    }
    
    static func adjustedShadow(
        _ style: DSShadowStyle,
        multiplier: Double
    ) -> DSShadowStyle {
        guard multiplier < 1.0 else { return style }
        return DSShadowStyle(
            color: style.color.opacity(multiplier),
            x: style.x,
            y: style.y,
            radius: style.radius
        )
    }
    
    static func resolveStrokeRoles(
        isDark: Bool,
        highContrast: Bool
    ) -> DSStrokeRoles {
        // Get border colors
        let subtleBorderColor = Color(hex: isDark ? DSDarkNeutrals.d4 : DSLightNeutrals.n3)
        let strongBorderColor = Color(hex: isDark ? DSDarkNeutrals.d5 : DSLightNeutrals.n4)
        let focusRingColor = Color(hex: isDark ? DSTealAccent.tealDarkGlow : DSTealAccent.teal300)
        
        // Adjust widths for high contrast
        let defaultWidth: CGFloat = highContrast ? 1.5 : 1.0
        let strongWidth: CGFloat = highContrast ? 2.0 : 1.0
        let focusRingWidth: CGFloat = highContrast ? 3.0 : 2.0
        
        let defaultOpacity: Double = highContrast ? 0.9 : (isDark ? 0.55 : 1.0)
        let strongOpacity: Double = highContrast ? 1.0 : 1.0
        let separatorOpacity: Double = highContrast ? 0.8 : (isDark ? 0.45 : 1.0)
        let focusOpacity: Double = highContrast ? 1.0 : (isDark ? 0.55 : 0.7)
        let glassOpacity: Double = isDark ? 0.3 : 0.0
        
        return DSStrokeRoles(
            default: DSBorderStyle(
                width: defaultWidth,
                color: subtleBorderColor.opacity(defaultOpacity)
            ),
            strong: DSBorderStyle(
                width: strongWidth,
                color: strongBorderColor.opacity(strongOpacity)
            ),
            separator: DSBorderStyle(
                width: 1.0,
                color: subtleBorderColor.opacity(separatorOpacity)
            ),
            focusRing: DSBorderStyle(
                width: focusRingWidth,
                color: focusRingColor.opacity(focusOpacity)
            ),
            glass: DSBorderStyle(
                width: 1.0,
                color: subtleBorderColor.opacity(glassOpacity)
            )
        )
    }
    
    static func resolveComponentShadowRoles(
        isDark: Bool,
        reduceTransparency: Bool
    ) -> DSComponentShadowRoles {
        let shadowMultiplier: Double = reduceTransparency ? 0.3 : 1.0
        
        return DSComponentShadowRoles(
            card: adjustedShadow(
                DSShadowStyle.from(DSComponentShadow.card, isDark: isDark),
                multiplier: shadowMultiplier
            ),
            cardFlat: .none,
            cardRaised: adjustedShadow(
                DSShadowStyle.from(DSComponentShadow.cardRaised, isDark: isDark),
                multiplier: shadowMultiplier
            ),
            button: adjustedShadow(
                DSShadowStyle.from(DSComponentShadow.button, isDark: isDark),
                multiplier: shadowMultiplier
            ),
            modal: adjustedShadow(
                DSShadowStyle.from(DSComponentShadow.modal, isDark: isDark),
                multiplier: shadowMultiplier
            ),
            popover: adjustedShadow(
                DSShadowStyle.from(DSComponentShadow.popover, isDark: isDark),
                multiplier: shadowMultiplier
            ),
            dropdown: adjustedShadow(
                DSShadowStyle.from(DSComponentShadow.dropdown, isDark: isDark),
                multiplier: shadowMultiplier
            ),
            tooltip: adjustedShadow(
                DSShadowStyle.from(DSComponentShadow.tooltip, isDark: isDark),
                multiplier: shadowMultiplier
            )
        )
    }
}

// MARK: - Theme Resolver Input

/// Configuration input for theme resolution.
///
/// `DSThemeResolverInput` bundles all parameters needed to resolve
/// a theme, making it easy to pass around and modify configurations.
///
/// ## Usage
///
/// ```swift
/// var input = DSThemeResolverInput.light
/// input.density = .compact
/// input.accessibility = myAccessibilityPolicy
///
/// let theme = DSThemeResolver.resolve(input)
/// ```
public struct DSThemeResolverInput: Sendable, Equatable {
    
    /// The theme variant (light/dark).
    public var variant: DSThemeVariant
    
    /// Accessibility settings to apply.
    public var accessibility: DSAccessibilityPolicy
    
    /// UI density setting.
    public var density: DSDensity
    
    /// Creates a new resolver input.
    ///
    /// - Parameters:
    ///   - variant: Theme variant. Defaults to `.light`.
    ///   - accessibility: Accessibility settings. Defaults to `.default`.
    ///   - density: UI density. Defaults to `.regular`.
    public init(
        variant: DSThemeVariant = .light,
        accessibility: DSAccessibilityPolicy = .default,
        density: DSDensity = .regular
    ) {
        self.variant = variant
        self.accessibility = accessibility
        self.density = density
    }
    
    /// Default light theme input.
    public static let light = DSThemeResolverInput(variant: .light)
    
    /// Default dark theme input.
    public static let dark = DSThemeResolverInput(variant: .dark)
}
