// DSListRowSpec.swift
// DesignSystem
//
// List/settings row component specification.
// Pure data — no SwiftUI views.

import SwiftUI
import DSCore

// MARK: - List Row Style

/// Visual style for list rows.
///
/// ## Styles
///
/// | Style | Usage |
/// |-------|-------|
/// | ``plain`` | Standard navigation/info row |
/// | ``prominent`` | Highlighted or action row |
/// | ``destructive`` | Delete/sign-out actions |
public enum DSListRowStyle: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Standard row style with default colors.
    case plain
    
    /// Prominent row with accent-tinted appearance.
    case prominent
    
    /// Destructive row with danger-colored text.
    case destructive
}

// MARK: - DSListRowSpec

/// Resolved list row specification with concrete styling values.
///
/// `DSListRowSpec` contains all visual properties needed to render
/// a list or settings row, including typography, colors, spacing,
/// and accessory styling.
///
/// ## Overview
///
/// List rows appear in settings screens, navigation lists, and
/// form sections. They adapt to platform capabilities for sizing
/// and interaction feedback.
///
/// ## Properties
///
/// | Category | Properties |
/// |----------|-----------|
/// | Colors | ``backgroundColor``, ``pressedBackgroundColor``, ``titleColor``, ``valueColor``, ``accessoryColor`` |
/// | Sizing | ``minHeight``, ``horizontalPadding``, ``verticalPadding`` |
/// | Typography | ``titleTypography``, ``subtitleTypography``, ``valueTypography`` |
/// | Separator | ``separatorColor``, ``separatorInsets`` |
/// | Accessory | ``accessorySize``, ``accessoryColor`` |
///
/// ## Usage
///
/// ```swift
/// let spec = DSListRowSpec.resolve(
///     theme: theme,
///     style: .plain,
///     state: .normal,
///     capabilities: capabilities
/// )
///
/// HStack(spacing: spec.horizontalPadding) {
///     VStack(alignment: .leading) {
///         Text(title)
///             .font(spec.titleTypography.font)
///             .foregroundStyle(spec.titleColor)
///         if let subtitle {
///             Text(subtitle)
///                 .font(spec.subtitleTypography.font)
///                 .foregroundStyle(spec.subtitleTypography.color)
///         }
///     }
///     Spacer()
///     Text(value)
///         .font(spec.valueTypography.font)
///         .foregroundStyle(spec.valueColor)
///     Image(systemName: "chevron.right")
///         .foregroundStyle(spec.accessoryColor)
///         .font(.system(size: spec.accessorySize))
/// }
/// .frame(minHeight: spec.minHeight)
/// .padding(.horizontal, spec.horizontalPadding)
/// .padding(.vertical, spec.verticalPadding)
/// ```
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:style:state:capabilities:)``
///
/// ### Configuration
///
/// - ``DSListRowStyle``
public struct DSListRowSpec: DSSpec {
    
    // MARK: - Colors
    
    /// Row background color.
    public let backgroundColor: Color
    
    /// Background color when pressed.
    public let pressedBackgroundColor: Color
    
    /// Title text color.
    public let titleColor: Color
    
    /// Value/detail text color.
    public let valueColor: Color
    
    /// Accessory icon color (chevron, etc.).
    public let accessoryColor: Color
    
    // MARK: - Sizing
    
    /// Minimum row height (touch target compliance).
    public let minHeight: CGFloat
    
    /// Horizontal padding (leading/trailing).
    public let horizontalPadding: CGFloat
    
    /// Vertical padding (top/bottom).
    public let verticalPadding: CGFloat
    
    // MARK: - Typography
    
    /// Title text style.
    public let titleTypography: DSTextStyle
    
    /// Subtitle text style.
    public let subtitleTypography: DSTextStyle
    
    /// Value/detail text style.
    public let valueTypography: DSTextStyle
    
    // MARK: - Separator
    
    /// Separator line color.
    public let separatorColor: Color
    
    /// Separator leading/trailing insets.
    public let separatorInsets: EdgeInsets
    
    // MARK: - Accessory
    
    /// Accessory icon size.
    public let accessorySize: CGFloat
    
    // MARK: - Effects
    
    /// Overall opacity (reduced when disabled).
    public let opacity: CGFloat
    
    // MARK: - Initialization
    
    /// Creates a list row spec with explicit values.
    public init(
        backgroundColor: Color,
        pressedBackgroundColor: Color,
        titleColor: Color,
        valueColor: Color,
        accessoryColor: Color,
        minHeight: CGFloat,
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat,
        titleTypography: DSTextStyle,
        subtitleTypography: DSTextStyle,
        valueTypography: DSTextStyle,
        separatorColor: Color,
        separatorInsets: EdgeInsets,
        accessorySize: CGFloat,
        opacity: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.pressedBackgroundColor = pressedBackgroundColor
        self.titleColor = titleColor
        self.valueColor = valueColor
        self.accessoryColor = accessoryColor
        self.minHeight = minHeight
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.titleTypography = titleTypography
        self.subtitleTypography = subtitleTypography
        self.valueTypography = valueTypography
        self.separatorColor = separatorColor
        self.separatorInsets = separatorInsets
        self.accessorySize = accessorySize
        self.opacity = opacity
    }
}

// MARK: - Resolution

extension DSListRowSpec {
    
    /// Resolves a list row spec from theme, style, state, and capabilities.
    ///
    /// - Parameters:
    ///   - theme: The current design system theme.
    ///   - style: The row visual style (plain, prominent, destructive).
    ///   - state: The current interaction state.
    ///   - capabilities: The current platform capabilities.
    /// - Returns: A fully resolved ``DSListRowSpec``.
    public static func resolve(
        theme: DSTheme,
        style: DSListRowStyle,
        state: DSControlState,
        capabilities: DSCapabilities
    ) -> DSListRowSpec {
        let isDisabled = state.contains(.disabled)
        let isPressed = state.contains(.pressed)
        
        // Background
        let backgroundColor: Color = .clear
        let pressedBackgroundColor: Color = theme.colors.accent.primary.opacity(0.06)
        
        // Colors per style
        let titleColor: Color
        let valueColor: Color
        let accessoryColor: Color
        
        switch style {
        case .plain:
            titleColor = isDisabled ? theme.colors.fg.disabled : theme.colors.fg.primary
            valueColor = isDisabled ? theme.colors.fg.disabled : theme.colors.fg.secondary
            accessoryColor = theme.colors.fg.tertiary
            
        case .prominent:
            titleColor = isDisabled ? theme.colors.fg.disabled : theme.colors.accent.primary
            valueColor = isDisabled ? theme.colors.fg.disabled : theme.colors.fg.secondary
            accessoryColor = theme.colors.accent.primary.opacity(0.6)
            
        case .destructive:
            titleColor = isDisabled ? theme.colors.fg.disabled : theme.colors.state.danger
            valueColor = isDisabled ? theme.colors.fg.disabled : theme.colors.fg.secondary
            accessoryColor = theme.colors.state.danger.opacity(0.6)
        }
        
        // Sizing
        let minHeight: CGFloat
        if capabilities.prefersLargeTapTargets {
            minHeight = theme.spacing.rowHeight.default
        } else {
            minHeight = theme.spacing.rowHeight.compact
        }
        
        let horizontalPadding = theme.spacing.padding.l
        let verticalPadding = theme.spacing.padding.m
        
        // Typography
        let titleTypography = DSTextStyle(
            font: theme.typography.component.rowTitle.font,
            color: titleColor,
            weight: theme.typography.component.rowTitle.weight,
            size: theme.typography.component.rowTitle.size
        )
        
        let subtitleTypography = DSTextStyle(
            font: theme.typography.system.subheadline.font,
            color: theme.colors.fg.secondary,
            weight: theme.typography.system.subheadline.weight,
            size: theme.typography.system.subheadline.size
        )
        
        let valueTypography = DSTextStyle(
            font: theme.typography.component.rowValue.font,
            color: valueColor,
            weight: theme.typography.component.rowValue.weight,
            size: theme.typography.component.rowValue.size
        )
        
        // Separator
        let separatorColor = theme.colors.border.separator
        let separatorInsets = EdgeInsets(
            top: 0,
            leading: horizontalPadding,
            bottom: 0,
            trailing: 0
        )
        
        // Accessory
        let accessorySize: CGFloat = 13
        
        // Opacity
        let opacity: CGFloat = isDisabled ? 0.5 : 1.0
        
        return DSListRowSpec(
            backgroundColor: isPressed ? pressedBackgroundColor : backgroundColor,
            pressedBackgroundColor: pressedBackgroundColor,
            titleColor: titleColor,
            valueColor: valueColor,
            accessoryColor: accessoryColor,
            minHeight: minHeight,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            titleTypography: titleTypography,
            subtitleTypography: subtitleTypography,
            valueTypography: valueTypography,
            separatorColor: separatorColor,
            separatorInsets: separatorInsets,
            accessorySize: accessorySize,
            opacity: opacity
        )
    }
}
