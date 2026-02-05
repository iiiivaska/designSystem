// DSSliderSpec.swift
// DesignSystem
//
// Slider component specification.
// Pure data — no SwiftUI views.

import SwiftUI
import DSCore

// MARK: - DSSliderSpec

/// Resolved slider specification with concrete styling values.
///
/// `DSSliderSpec` contains all visual properties needed to render
/// a slider control, resolved for the current state.
///
/// ## Overview
///
/// The spec handles normal, pressed, and disabled states, as well as
/// discrete vs continuous modes. It provides colors and dimensions
/// for both the track and thumb.
///
/// ## Properties
///
/// | Category | Properties |
/// |----------|-----------|
/// | Track | ``trackColor``, ``trackActiveColor``, ``trackHeight``, ``trackCornerRadius`` |
/// | Thumb | ``thumbColor``, ``thumbSize``, ``thumbShadow``, ``thumbBorderColor``, ``thumbBorderWidth`` |
/// | Ticks | ``tickColor``, ``tickSize`` |
/// | Effects | ``opacity`` |
/// | Animation | ``animation`` |
///
/// ## Usage
///
/// ```swift
/// let spec = DSSliderSpec.resolve(
///     theme: theme,
///     state: .normal
/// )
///
/// // Track
/// GeometryReader { geometry in
///     RoundedRectangle(cornerRadius: spec.trackCornerRadius)
///         .fill(spec.trackColor)
///         .frame(height: spec.trackHeight)
///         .overlay(alignment: .leading) {
///             RoundedRectangle(cornerRadius: spec.trackCornerRadius)
///                 .fill(spec.trackActiveColor)
///                 .frame(width: fillWidth)
///         }
///         .overlay {
///             Circle()
///                 .fill(spec.thumbColor)
///                 .frame(width: spec.thumbSize, height: spec.thumbSize)
///                 .shadow(color: spec.thumbShadow.color, radius: spec.thumbShadow.radius)
///                 .offset(x: thumbOffset)
///         }
/// }
/// ```
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:state:)``
public struct DSSliderSpec: DSSpec {
    
    // MARK: - Track
    
    /// Track background color (unfilled portion).
    public let trackColor: Color
    
    /// Track active/filled color.
    public let trackActiveColor: Color
    
    /// Track height.
    public let trackHeight: CGFloat
    
    /// Track corner radius.
    public let trackCornerRadius: CGFloat
    
    // MARK: - Thumb
    
    /// Thumb fill color.
    public let thumbColor: Color
    
    /// Thumb diameter.
    public let thumbSize: CGFloat
    
    /// Thumb shadow.
    public let thumbShadow: DSShadowStyle
    
    /// Thumb border color.
    public let thumbBorderColor: Color
    
    /// Thumb border width.
    public let thumbBorderWidth: CGFloat
    
    // MARK: - Ticks (for discrete mode)
    
    /// Tick mark color.
    public let tickColor: Color
    
    /// Tick mark diameter.
    public let tickSize: CGFloat
    
    // MARK: - Effects
    
    /// Overall opacity (reduced when disabled).
    public let opacity: CGFloat
    
    // MARK: - Animation
    
    /// Animation for slider interactions.
    public let animation: Animation?
    
    // MARK: - Initialization
    
    /// Creates a slider spec with explicit values.
    public init(
        trackColor: Color,
        trackActiveColor: Color,
        trackHeight: CGFloat,
        trackCornerRadius: CGFloat,
        thumbColor: Color,
        thumbSize: CGFloat,
        thumbShadow: DSShadowStyle,
        thumbBorderColor: Color,
        thumbBorderWidth: CGFloat,
        tickColor: Color,
        tickSize: CGFloat,
        opacity: CGFloat,
        animation: Animation?
    ) {
        self.trackColor = trackColor
        self.trackActiveColor = trackActiveColor
        self.trackHeight = trackHeight
        self.trackCornerRadius = trackCornerRadius
        self.thumbColor = thumbColor
        self.thumbSize = thumbSize
        self.thumbShadow = thumbShadow
        self.thumbBorderColor = thumbBorderColor
        self.thumbBorderWidth = thumbBorderWidth
        self.tickColor = tickColor
        self.tickSize = tickSize
        self.opacity = opacity
        self.animation = animation
    }
}

// MARK: - Resolution

extension DSSliderSpec {
    
    /// Resolves a slider spec from theme and interaction state.
    ///
    /// - Parameters:
    ///   - theme: The current design system theme.
    ///   - state: The current interaction state.
    /// - Returns: A fully resolved ``DSSliderSpec``.
    public static func resolve(
        theme: DSTheme,
        state: DSControlState
    ) -> DSSliderSpec {
        let isDisabled = state.contains(.disabled)
        let isPressed = state.contains(.pressed)
        
        // Track colors
        let trackColor = theme.colors.bg.surfaceElevated
        let trackActiveColor: Color
        if isDisabled {
            trackActiveColor = theme.colors.accent.primary.opacity(0.4)
        } else {
            trackActiveColor = theme.colors.accent.primary
        }
        
        // Track dimensions
        let trackHeight: CGFloat = 4
        let trackCornerRadius: CGFloat = trackHeight / 2
        
        // Thumb
        let thumbColor: Color = .white
        let thumbSize: CGFloat = isPressed ? 28 : 24
        let thumbShadow = DSShadowStyle(color: Color.black.opacity(0.2), y: 1, radius: 3)
        let thumbBorderColor = theme.colors.border.subtle
        let thumbBorderWidth: CGFloat = 0.5
        
        // Ticks
        let tickColor = theme.colors.fg.tertiary
        let tickSize: CGFloat = 4
        
        // Opacity
        let opacity: CGFloat = isDisabled ? 0.5 : 1.0
        
        return DSSliderSpec(
            trackColor: trackColor,
            trackActiveColor: trackActiveColor,
            trackHeight: trackHeight,
            trackCornerRadius: trackCornerRadius,
            thumbColor: thumbColor,
            thumbSize: thumbSize,
            thumbShadow: thumbShadow,
            thumbBorderColor: thumbBorderColor,
            thumbBorderWidth: thumbBorderWidth,
            tickColor: tickColor,
            tickSize: tickSize,
            opacity: opacity,
            animation: theme.motion.spring.snappy
        )
    }
}
