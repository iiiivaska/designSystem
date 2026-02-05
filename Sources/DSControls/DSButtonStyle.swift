// DSButtonStyle.swift
// DesignSystem
//
// SwiftUI ButtonStyle implementation for DSButton.
// Handles press state detection and spec-based rendering.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSButtonStyleModifier

/// A SwiftUI `ButtonStyle` that applies ``DSButtonSpec`` styling.
///
/// This style resolves the button's appearance from the theme based
/// on variant, size, and current interaction state. It handles
/// pressed state detection and animates transitions.
///
/// ## Overview
///
/// `DSButtonStyleModifier` is used internally by ``DSButton``.
/// You typically don't create this directly — use ``DSButton`` instead.
///
/// ## Resolve-then-Render
///
/// 1. The style detects whether the button is pressed via `configuration.isPressed`
/// 2. It builds a ``DSControlState`` combining pressed, disabled, and loading flags
/// 3. It resolves a ``DSButtonSpec`` from the theme
/// 4. It renders the button using the spec's concrete values
///
/// ## Topics
///
/// ### Resolution
///
/// - ``DSButtonSpec``
/// - ``DSButtonVariant``
/// - ``DSButtonSize``
public struct DSButtonStyleModifier: ButtonStyle {
    
    // MARK: - Properties
    
    /// The current theme.
    let theme: DSTheme
    
    /// The button variant.
    let variant: DSButtonVariant
    
    /// The button size.
    let size: DSButtonSize
    
    /// The base control state (without pressed).
    let controlState: DSControlState
    
    /// Whether the button stretches to full width.
    let fullWidth: Bool
    
    // MARK: - ButtonStyle
    
    public func makeBody(configuration: Configuration) -> some View {
        let resolvedState = resolveState(isPressed: configuration.isPressed)
        let spec = theme.resolveButton(
            variant: variant,
            size: size,
            state: resolvedState
        )
        
        configuration.label
            .font(spec.typography.font)
            .foregroundStyle(spec.foregroundColor)
            .padding(.horizontal, spec.horizontalPadding)
            .padding(.vertical, spec.verticalPadding)
            .frame(height: spec.height)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(
                RoundedRectangle(cornerRadius: spec.cornerRadius, style: .continuous)
                    .fill(spec.backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: spec.cornerRadius, style: .continuous)
                    .stroke(spec.borderColor, lineWidth: spec.borderWidth)
            )
            .shadow(
                color: spec.shadow.color,
                radius: spec.shadow.radius,
                x: spec.shadow.x,
                y: spec.shadow.y
            )
            .opacity(spec.opacity)
            .scaleEffect(spec.scaleEffect)
            .animation(spec.animation, value: configuration.isPressed)
            .animation(spec.animation, value: controlState)
            .contentShape(RoundedRectangle(cornerRadius: spec.cornerRadius, style: .continuous))
    }
    
    // MARK: - State Resolution
    
    /// Combines the base control state with the pressed flag from ButtonStyle.
    ///
    /// - Parameter isPressed: Whether the button is currently pressed.
    /// - Returns: The combined control state.
    private func resolveState(isPressed: Bool) -> DSControlState {
        var state = controlState
        if isPressed {
            state.insert(.pressed)
        }
        return state
    }
}
