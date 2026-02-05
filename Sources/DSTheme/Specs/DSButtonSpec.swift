// DSButtonSpec.swift
// DesignSystem
//
// Button component specification with variants, sizes, and states.
// Pure data — no SwiftUI views.

import SwiftUI
import DSCore

// MARK: - Button Variant

/// Visual variant for buttons.
///
/// Each variant provides a different level of visual emphasis,
/// following a clear hierarchy from most to least prominent.
///
/// ## Hierarchy
///
/// | Variant | Emphasis | Usage |
/// |---------|----------|-------|
/// | ``primary`` | Highest | Main CTA, submit actions |
/// | ``secondary`` | Medium | Secondary actions |
/// | ``tertiary`` | Low | Inline actions, less prominent |
/// | ``destructive`` | High (danger) | Delete, remove, sign out |
///
/// ## Usage
///
/// ```swift
/// let spec = DSButtonSpec.resolve(
///     theme: theme,
///     variant: .primary,
///     size: .medium,
///     state: .normal
/// )
/// ```
public enum DSButtonVariant: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Filled accent button for primary actions.
    ///
    /// Uses the accent primary color as background with white foreground.
    case primary
    
    /// Outlined button for secondary actions.
    ///
    /// Uses a subtle background with accent-colored text.
    case secondary
    
    /// Text-only button for tertiary/inline actions.
    ///
    /// Minimal chrome, accent-colored text only.
    case tertiary
    
    /// Red-themed button for destructive actions.
    ///
    /// Uses the danger color to signal irreversible actions.
    case destructive
}

// MARK: - Button Size

/// Size preset for buttons.
///
/// Determines height, padding, typography, and corner radius.
///
/// ## Sizes
///
/// | Size | Height | Corner Radius | Typography |
/// |------|--------|---------------|------------|
/// | ``small`` | 32pt | 6pt | Footnote semibold |
/// | ``medium`` | 40pt | 10pt | Body semibold |
/// | ``large`` | 48pt | 14pt | Body semibold |
public enum DSButtonSize: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Small button (32pt height).
    ///
    /// For inline actions, toolbars, compact layouts.
    case small
    
    /// Medium button (40pt height).
    ///
    /// Standard size for most button placements.
    case medium
    
    /// Large button (48pt height).
    ///
    /// Full-width CTAs, prominent actions.
    case large
}

// MARK: - DSButtonSpec

/// Resolved button specification with concrete styling values.
///
/// `DSButtonSpec` contains all visual properties needed to render
/// a button, already resolved for a specific variant, size, and state.
///
/// ## Overview
///
/// The spec is produced by calling ``resolve(theme:variant:size:state:)``
/// and contains concrete `Color`, `CGFloat`, and `DSTextStyle` values
/// that can be applied directly to SwiftUI views.
///
/// ## Properties
///
/// | Category | Properties |
/// |----------|-----------|
/// | Colors | ``backgroundColor``, ``foregroundColor``, ``borderColor`` |
/// | Sizing | ``height``, ``horizontalPadding``, ``verticalPadding``, ``cornerRadius``, ``borderWidth`` |
/// | Typography | ``typography`` |
/// | Effects | ``shadow``, ``opacity``, ``scaleEffect`` |
/// | Animation | ``animation`` |
///
/// ## Usage
///
/// ```swift
/// let spec = DSButtonSpec.resolve(
///     theme: theme,
///     variant: .primary,
///     size: .medium,
///     state: .normal
/// )
///
/// Text(label)
///     .font(spec.typography.font)
///     .foregroundStyle(spec.foregroundColor)
///     .padding(.horizontal, spec.horizontalPadding)
///     .frame(height: spec.height)
///     .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
///     .opacity(spec.opacity)
///     .scaleEffect(spec.scaleEffect)
/// ```
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:variant:size:state:)``
///
/// ### Configuration
///
/// - ``DSButtonVariant``
/// - ``DSButtonSize``
public struct DSButtonSpec: DSSpec {
    
    // MARK: - Colors
    
    /// Button background fill color.
    public let backgroundColor: Color
    
    /// Text and icon foreground color.
    public let foregroundColor: Color
    
    /// Border/stroke color (clear for filled buttons).
    public let borderColor: Color
    
    /// Border width in points.
    public let borderWidth: CGFloat
    
    // MARK: - Sizing
    
    /// Button height in points.
    public let height: CGFloat
    
    /// Horizontal content padding.
    public let horizontalPadding: CGFloat
    
    /// Vertical content padding.
    public let verticalPadding: CGFloat
    
    /// Corner radius.
    public let cornerRadius: CGFloat
    
    // MARK: - Typography
    
    /// Text style for the button label.
    public let typography: DSTextStyle
    
    // MARK: - Effects
    
    /// Shadow applied to the button.
    public let shadow: DSShadowStyle
    
    /// Overall opacity (reduced when disabled).
    public let opacity: CGFloat
    
    /// Scale effect (reduced when pressed).
    public let scaleEffect: CGFloat
    
    // MARK: - Animation
    
    /// Animation for state transitions.
    public let animation: Animation?
    
    // MARK: - Initialization
    
    /// Creates a button spec with explicit values.
    public init(
        backgroundColor: Color,
        foregroundColor: Color,
        borderColor: Color,
        borderWidth: CGFloat,
        height: CGFloat,
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat,
        cornerRadius: CGFloat,
        typography: DSTextStyle,
        shadow: DSShadowStyle,
        opacity: CGFloat,
        scaleEffect: CGFloat,
        animation: Animation?
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
        self.typography = typography
        self.shadow = shadow
        self.opacity = opacity
        self.scaleEffect = scaleEffect
        self.animation = animation
    }
}

// MARK: - Resolution

extension DSButtonSpec {
    
    /// Resolves a button spec from theme, variant, size, and state.
    ///
    /// This is the primary entry point for obtaining button styling.
    /// Components call this method to get concrete values for rendering.
    ///
    /// - Parameters:
    ///   - theme: The current design system theme.
    ///   - variant: The button variant (primary, secondary, tertiary, destructive).
    ///   - size: The button size (small, medium, large).
    ///   - state: The current interaction state.
    /// - Returns: A fully resolved ``DSButtonSpec``.
    public static func resolve(
        theme: DSTheme,
        variant: DSButtonVariant,
        size: DSButtonSize,
        state: DSControlState
    ) -> DSButtonSpec {
        let colors = resolveColors(theme: theme, variant: variant, state: state)
        let sizing = resolveSizing(theme: theme, size: size)
        let typography = resolveTypography(theme: theme, size: size, foregroundColor: colors.foreground)
        let effects = resolveEffects(theme: theme, variant: variant, state: state)
        
        return DSButtonSpec(
            backgroundColor: colors.background,
            foregroundColor: colors.foreground,
            borderColor: colors.border,
            borderWidth: colors.borderWidth,
            height: sizing.height,
            horizontalPadding: sizing.horizontalPadding,
            verticalPadding: sizing.verticalPadding,
            cornerRadius: sizing.cornerRadius,
            typography: typography,
            shadow: effects.shadow,
            opacity: effects.opacity,
            scaleEffect: effects.scaleEffect,
            animation: theme.motion.component.buttonPress
        )
    }
}

// MARK: - Private Resolution Helpers

private extension DSButtonSpec {
    
    struct ResolvedColors {
        let background: Color
        let foreground: Color
        let border: Color
        let borderWidth: CGFloat
    }
    
    struct ResolvedSizing {
        let height: CGFloat
        let horizontalPadding: CGFloat
        let verticalPadding: CGFloat
        let cornerRadius: CGFloat
    }
    
    struct ResolvedEffects {
        let shadow: DSShadowStyle
        let opacity: CGFloat
        let scaleEffect: CGFloat
    }
    
    // MARK: Colors
    
    static func resolveColors(
        theme: DSTheme,
        variant: DSButtonVariant,
        state: DSControlState
    ) -> ResolvedColors {
        let isDisabled = state.contains(.disabled)
        let isPressed = state.contains(.pressed)
        let isHovered = state.contains(.hovered)
        
        var bg: Color
        var fg: Color
        var border: Color
        var borderWidth: CGFloat = 0
        
        switch variant {
        case .primary:
            bg = theme.colors.accent.primary
            fg = .white
            border = .clear
            
            if isPressed {
                bg = theme.colors.accent.primary.opacity(0.85)
            } else if isHovered {
                bg = theme.colors.accent.primary.opacity(0.9)
            }
            
        case .secondary:
            bg = theme.colors.accent.primary.opacity(0.12)
            fg = theme.colors.accent.primary
            border = theme.colors.accent.primary.opacity(0.3)
            borderWidth = 1.0
            
            if isPressed {
                bg = theme.colors.accent.primary.opacity(0.2)
            } else if isHovered {
                bg = theme.colors.accent.primary.opacity(0.16)
            }
            
        case .tertiary:
            bg = .clear
            fg = theme.colors.accent.primary
            border = .clear
            
            if isPressed {
                bg = theme.colors.accent.primary.opacity(0.1)
            } else if isHovered {
                bg = theme.colors.accent.primary.opacity(0.06)
            }
            
        case .destructive:
            bg = theme.colors.state.danger
            fg = .white
            border = .clear
            
            if isPressed {
                bg = theme.colors.state.danger.opacity(0.85)
            } else if isHovered {
                bg = theme.colors.state.danger.opacity(0.9)
            }
        }
        
        if isDisabled {
            bg = variant == .tertiary ? .clear : theme.colors.bg.surfaceElevated
            fg = theme.colors.fg.disabled
            border = isDisabled && variant == .secondary ? theme.colors.border.subtle : .clear
            borderWidth = variant == .secondary ? 1.0 : 0
        }
        
        return ResolvedColors(
            background: bg,
            foreground: fg,
            border: border,
            borderWidth: borderWidth
        )
    }
    
    // MARK: Sizing
    
    static func resolveSizing(
        theme: DSTheme,
        size: DSButtonSize
    ) -> ResolvedSizing {
        let height: CGFloat
        let horizontalPadding: CGFloat
        let verticalPadding: CGFloat
        let cornerRadius: CGFloat
        
        switch size {
        case .small:
            height = 32
            horizontalPadding = theme.spacing.padding.m
            verticalPadding = theme.spacing.padding.xs
            cornerRadius = theme.radii.component.buttonSmall
            
        case .medium:
            height = 40
            horizontalPadding = theme.spacing.padding.l
            verticalPadding = theme.spacing.padding.s
            cornerRadius = theme.radii.component.button
            
        case .large:
            height = 48
            horizontalPadding = theme.spacing.padding.xl
            verticalPadding = theme.spacing.padding.m
            cornerRadius = theme.radii.component.buttonLarge
        }
        
        return ResolvedSizing(
            height: height,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            cornerRadius: cornerRadius
        )
    }
    
    // MARK: Typography
    
    static func resolveTypography(
        theme: DSTheme,
        size: DSButtonSize,
        foregroundColor: Color
    ) -> DSTextStyle {
        let baseStyle = theme.typography.component.buttonLabel
        
        let fontSize: CGFloat
        switch size {
        case .small:
            fontSize = baseStyle.size * 0.82 // ~14pt for 17pt base
        case .medium:
            fontSize = baseStyle.size
        case .large:
            fontSize = baseStyle.size
        }
        
        return DSTextStyle(
            font: .system(size: fontSize, weight: baseStyle.weight),
            color: foregroundColor,
            weight: baseStyle.weight,
            size: fontSize
        )
    }
    
    // MARK: Effects
    
    static func resolveEffects(
        theme: DSTheme,
        variant: DSButtonVariant,
        state: DSControlState
    ) -> ResolvedEffects {
        let isDisabled = state.contains(.disabled)
        let isPressed = state.contains(.pressed)
        let isLoading = state.contains(.loading)
        
        // Shadow: only for primary/destructive in normal state
        let shadow: DSShadowStyle
        switch variant {
        case .primary, .destructive:
            shadow = (isDisabled || isPressed) ? .none : theme.shadows.component.button
        case .secondary, .tertiary:
            shadow = .none
        }
        
        // Opacity
        let opacity: CGFloat
        if isDisabled {
            opacity = 0.6
        } else if isLoading {
            opacity = 0.8
        } else {
            opacity = 1.0
        }
        
        // Scale
        let scaleEffect: CGFloat
        if isPressed {
            scaleEffect = 0.97
        } else {
            scaleEffect = 1.0
        }
        
        return ResolvedEffects(
            shadow: shadow,
            opacity: opacity,
            scaleEffect: scaleEffect
        )
    }
}
