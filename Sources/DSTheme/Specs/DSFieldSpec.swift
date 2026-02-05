// DSFieldSpec.swift
// DesignSystem
//
// Text field component specification with variants and states.
// Pure data — no SwiftUI views.

import SwiftUI
import DSCore

// MARK: - Field Variant

/// Visual variant for text fields.
///
/// ## Variants
///
/// | Variant | Usage |
/// |---------|-------|
/// | ``default`` | Standard text input |
/// | ``search`` | Search bar with rounded corners |
public enum DSFieldVariant: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Standard text input field.
    ///
    /// Rectangular shape with subtle border.
    case `default`
    
    /// Search field with more rounded corners.
    ///
    /// Typically paired with a search icon.
    case search
}

// MARK: - DSFieldSpec

/// Resolved text field specification with concrete styling values.
///
/// `DSFieldSpec` contains all visual properties needed to render
/// a text field, already resolved for a specific variant and state.
///
/// ## Overview
///
/// The spec handles all visual states including normal, focused,
/// error, warning, and disabled, providing appropriate colors and
/// borders for each.
///
/// ## Properties
///
/// | Category | Properties |
/// |----------|-----------|
/// | Colors | ``backgroundColor``, ``foregroundColor``, ``placeholderColor``, ``borderColor`` |
/// | Sizing | ``height``, ``horizontalPadding``, ``verticalPadding``, ``cornerRadius``, ``borderWidth`` |
/// | Typography | ``textTypography``, ``placeholderTypography`` |
/// | Focus | ``focusRingColor``, ``focusRingWidth`` |
/// | Animation | ``animation`` |
///
/// ## Usage
///
/// ```swift
/// let spec = DSFieldSpec.resolve(
///     theme: theme,
///     variant: .default,
///     state: .normal,
///     validation: .none
/// )
///
/// TextField("Placeholder", text: $text)
///     .font(spec.textTypography.font)
///     .foregroundStyle(spec.foregroundColor)
///     .padding(.horizontal, spec.horizontalPadding)
///     .frame(height: spec.height)
///     .background(spec.backgroundColor)
///     .clipShape(RoundedRectangle(cornerRadius: spec.cornerRadius))
///     .overlay(
///         RoundedRectangle(cornerRadius: spec.cornerRadius)
///             .stroke(spec.borderColor, lineWidth: spec.borderWidth)
///     )
/// ```
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:variant:state:validation:)``
///
/// ### Configuration
///
/// - ``DSFieldVariant``
public struct DSFieldSpec: DSSpec {
    
    // MARK: - Colors
    
    /// Field background color.
    public let backgroundColor: Color
    
    /// Input text color.
    public let foregroundColor: Color
    
    /// Placeholder text color.
    public let placeholderColor: Color
    
    /// Border/stroke color.
    public let borderColor: Color
    
    /// Border width in points.
    public let borderWidth: CGFloat
    
    // MARK: - Focus
    
    /// Focus ring color (shown when field is focused).
    public let focusRingColor: Color
    
    /// Focus ring width.
    public let focusRingWidth: CGFloat
    
    // MARK: - Sizing
    
    /// Field height in points.
    public let height: CGFloat
    
    /// Horizontal content padding.
    public let horizontalPadding: CGFloat
    
    /// Vertical content padding.
    public let verticalPadding: CGFloat
    
    /// Corner radius.
    public let cornerRadius: CGFloat
    
    // MARK: - Typography
    
    /// Text style for input text.
    public let textTypography: DSTextStyle
    
    /// Text style for placeholder text.
    public let placeholderTypography: DSTextStyle
    
    // MARK: - Effects
    
    /// Overall opacity (reduced when disabled).
    public let opacity: CGFloat
    
    // MARK: - Animation
    
    /// Animation for state transitions.
    public let animation: Animation?
    
    // MARK: - Initialization
    
    /// Creates a field spec with explicit values.
    public init(
        backgroundColor: Color,
        foregroundColor: Color,
        placeholderColor: Color,
        borderColor: Color,
        borderWidth: CGFloat,
        focusRingColor: Color,
        focusRingWidth: CGFloat,
        height: CGFloat,
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat,
        cornerRadius: CGFloat,
        textTypography: DSTextStyle,
        placeholderTypography: DSTextStyle,
        opacity: CGFloat,
        animation: Animation?
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.placeholderColor = placeholderColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.focusRingColor = focusRingColor
        self.focusRingWidth = focusRingWidth
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
        self.textTypography = textTypography
        self.placeholderTypography = placeholderTypography
        self.opacity = opacity
        self.animation = animation
    }
}

// MARK: - Resolution

extension DSFieldSpec {
    
    /// Resolves a field spec from theme, variant, state, and validation.
    ///
    /// - Parameters:
    ///   - theme: The current design system theme.
    ///   - variant: The field variant (default, search).
    ///   - state: The current interaction state.
    ///   - validation: The current validation state.
    /// - Returns: A fully resolved ``DSFieldSpec``.
    public static func resolve(
        theme: DSTheme,
        variant: DSFieldVariant,
        state: DSControlState,
        validation: DSValidationState = .none
    ) -> DSFieldSpec {
        let isDisabled = state.contains(.disabled)
        let isFocused = state.contains(.focused)
        
        // Background
        let backgroundColor = isDisabled
            ? theme.colors.bg.surfaceElevated.opacity(0.5)
            : theme.colors.bg.surface
        
        // Foreground
        let foregroundColor = isDisabled
            ? theme.colors.fg.disabled
            : theme.colors.fg.primary
        
        // Placeholder
        let placeholderColor = theme.colors.fg.tertiary
        
        // Border
        let borderInfo = resolveBorder(
            theme: theme,
            isFocused: isFocused,
            isDisabled: isDisabled,
            validation: validation
        )
        
        // Focus ring
        let focusRingColor = isFocused ? theme.colors.focusRing : .clear
        let focusRingWidth: CGFloat = isFocused ? theme.shadows.stroke.focusRing.width : 0
        
        // Sizing
        let cornerRadius: CGFloat
        switch variant {
        case .default:
            cornerRadius = theme.radii.component.field
        case .search:
            cornerRadius = theme.radii.component.searchField
        }
        
        let height: CGFloat = 40
        let horizontalPadding = theme.spacing.padding.m
        let verticalPadding = theme.spacing.padding.s
        
        // Typography
        let textTypography = DSTextStyle(
            font: theme.typography.component.fieldText.font,
            color: foregroundColor,
            weight: theme.typography.component.fieldText.weight,
            size: theme.typography.component.fieldText.size
        )
        
        let placeholderTypography = DSTextStyle(
            font: theme.typography.component.fieldPlaceholder.font,
            color: placeholderColor,
            weight: theme.typography.component.fieldPlaceholder.weight,
            size: theme.typography.component.fieldPlaceholder.size
        )
        
        // Opacity
        let opacity: CGFloat = isDisabled ? 0.6 : 1.0
        
        return DSFieldSpec(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            placeholderColor: placeholderColor,
            borderColor: borderInfo.color,
            borderWidth: borderInfo.width,
            focusRingColor: focusRingColor,
            focusRingWidth: focusRingWidth,
            height: height,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            cornerRadius: cornerRadius,
            textTypography: textTypography,
            placeholderTypography: placeholderTypography,
            opacity: opacity,
            animation: theme.motion.component.focusTransition
        )
    }
}

// MARK: - Private Resolution Helpers

private extension DSFieldSpec {
    
    struct BorderInfo {
        let color: Color
        let width: CGFloat
    }
    
    static func resolveBorder(
        theme: DSTheme,
        isFocused: Bool,
        isDisabled: Bool,
        validation: DSValidationState
    ) -> BorderInfo {
        // Validation state takes priority
        switch validation {
        case .error:
            return BorderInfo(
                color: theme.colors.state.danger,
                width: isFocused ? 2.0 : 1.5
            )
        case .warning:
            return BorderInfo(
                color: theme.colors.state.warning,
                width: isFocused ? 2.0 : 1.5
            )
        case .success:
            return BorderInfo(
                color: theme.colors.state.success,
                width: 1.0
            )
        case .none, .validating:
            break
        }
        
        // Focus state
        if isFocused {
            return BorderInfo(
                color: theme.colors.accent.primary,
                width: 2.0
            )
        }
        
        // Disabled
        if isDisabled {
            return BorderInfo(
                color: theme.colors.border.subtle.opacity(0.5),
                width: 1.0
            )
        }
        
        // Normal
        return BorderInfo(
            color: theme.colors.border.subtle,
            width: theme.shadows.stroke.default.width
        )
    }
}
