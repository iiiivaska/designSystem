// DSToggleSpec.swift
// DesignSystem
//
// Toggle/switch component specification.
// Pure data — no SwiftUI views.

import SwiftUI
import DSCore

// MARK: - DSToggleSpec

/// Resolved toggle specification with concrete styling values.
///
/// `DSToggleSpec` contains all visual properties needed to render
/// a toggle/switch control, resolved for the current state.
///
/// ## Overview
///
/// The spec handles on/off states, disabled appearance, and
/// hover feedback. It provides colors for both the track and thumb.
///
/// ## Properties
///
/// | Category | Properties |
/// |----------|-----------|
/// | Track | ``trackColor``, ``trackWidth``, ``trackHeight``, ``trackCornerRadius`` |
/// | Thumb | ``thumbColor``, ``thumbSize``, ``thumbShadow`` |
/// | Border | ``trackBorderColor``, ``trackBorderWidth`` |
/// | Effects | ``opacity`` |
/// | Animation | ``animation`` |
///
/// ## Usage
///
/// ```swift
/// let spec = DSToggleSpec.resolve(
///     theme: theme,
///     isOn: true,
///     state: .normal
/// )
///
/// Capsule()
///     .fill(spec.trackColor)
///     .frame(width: spec.trackWidth, height: spec.trackHeight)
///     .overlay(
///         Circle()
///             .fill(spec.thumbColor)
///             .frame(width: spec.thumbSize, height: spec.thumbSize)
///             .shadow(color: spec.thumbShadow.color, radius: spec.thumbShadow.radius),
///         alignment: isOn ? .trailing : .leading
///     )
/// ```
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:isOn:state:)``
public struct DSToggleSpec: DSSpec {
    
    // MARK: - Track
    
    /// Track fill color (changes based on on/off state).
    public let trackColor: Color
    
    /// Track width.
    public let trackWidth: CGFloat
    
    /// Track height.
    public let trackHeight: CGFloat
    
    /// Track corner radius.
    public let trackCornerRadius: CGFloat
    
    /// Track border color.
    public let trackBorderColor: Color
    
    /// Track border width.
    public let trackBorderWidth: CGFloat
    
    // MARK: - Thumb
    
    /// Thumb circle color.
    public let thumbColor: Color
    
    /// Thumb diameter.
    public let thumbSize: CGFloat
    
    /// Thumb shadow.
    public let thumbShadow: DSShadowStyle
    
    // MARK: - Effects
    
    /// Overall opacity (reduced when disabled).
    public let opacity: CGFloat
    
    // MARK: - Animation
    
    /// Animation for toggle transitions.
    public let animation: Animation?
    
    // MARK: - Initialization
    
    /// Creates a toggle spec with explicit values.
    public init(
        trackColor: Color,
        trackWidth: CGFloat,
        trackHeight: CGFloat,
        trackCornerRadius: CGFloat,
        trackBorderColor: Color,
        trackBorderWidth: CGFloat,
        thumbColor: Color,
        thumbSize: CGFloat,
        thumbShadow: DSShadowStyle,
        opacity: CGFloat,
        animation: Animation?
    ) {
        self.trackColor = trackColor
        self.trackWidth = trackWidth
        self.trackHeight = trackHeight
        self.trackCornerRadius = trackCornerRadius
        self.trackBorderColor = trackBorderColor
        self.trackBorderWidth = trackBorderWidth
        self.thumbColor = thumbColor
        self.thumbSize = thumbSize
        self.thumbShadow = thumbShadow
        self.opacity = opacity
        self.animation = animation
    }
}

// MARK: - Resolution

extension DSToggleSpec {
    
    /// Resolves a toggle spec from theme, on/off state, and interaction state.
    ///
    /// - Parameters:
    ///   - theme: The current design system theme.
    ///   - isOn: Whether the toggle is in the "on" position.
    ///   - state: The current interaction state.
    /// - Returns: A fully resolved ``DSToggleSpec``.
    public static func resolve(
        theme: DSTheme,
        isOn: Bool,
        state: DSControlState
    ) -> DSToggleSpec {
        let isDisabled = state.contains(.disabled)
        
        // Track color
        let trackColor: Color
        if isDisabled {
            trackColor = isOn
                ? theme.colors.accent.primary.opacity(0.4)
                : theme.colors.bg.surfaceElevated
        } else {
            trackColor = isOn
                ? theme.colors.accent.primary
                : theme.colors.bg.surfaceElevated
        }
        
        // Track border
        let trackBorderColor: Color
        let trackBorderWidth: CGFloat
        if isOn {
            trackBorderColor = .clear
            trackBorderWidth = 0
        } else {
            trackBorderColor = theme.colors.border.subtle
            trackBorderWidth = 1.0
        }
        
        // Thumb
        let thumbColor: Color = .white
        let thumbSize: CGFloat = 27
        let thumbShadow = DSShadowStyle(color: Color.black.opacity(0.15), y: 1, radius: 2)
        
        // Track dimensions
        let trackWidth: CGFloat = 51
        let trackHeight: CGFloat = 31
        let trackCornerRadius: CGFloat = trackHeight / 2
        
        // Opacity
        let opacity: CGFloat = isDisabled ? 0.5 : 1.0
        
        return DSToggleSpec(
            trackColor: trackColor,
            trackWidth: trackWidth,
            trackHeight: trackHeight,
            trackCornerRadius: trackCornerRadius,
            trackBorderColor: trackBorderColor,
            trackBorderWidth: trackBorderWidth,
            thumbColor: thumbColor,
            thumbSize: thumbSize,
            thumbShadow: thumbShadow,
            opacity: opacity,
            animation: theme.motion.component.toggle
        )
    }
}
