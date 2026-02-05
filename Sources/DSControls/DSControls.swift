// DSControls.swift
// DesignSystem
//
// Interactive controls: DSButton, DSToggle, DSTextField, DSPicker, DSStepper, DSSlider.
// Controls use specs from theme and primitives for rendering.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

/// Interactive control components for the Design System.
///
/// `DSControls` provides themed interactive controls that follow the
/// resolve-then-render architecture. Each control resolves its styling
/// from the theme's component specs.
///
/// ## Overview
///
/// Controls are the primary interactive elements users interact with.
/// They handle input, provide feedback, and maintain consistent styling
/// across the application.
///
/// ## Available Controls
///
/// | Control | Description |
/// |---------|-------------|
/// | ``DSButton`` | Primary interactive button with variants |
/// | ``DSToggle`` | Toggle/switch control with theme accent |
/// | ``DSCheckbox`` | Checkbox with intermediate state support |
///
/// ## Topics
///
/// ### Buttons
///
/// - ``DSButton``
/// - ``DSButtonStyleModifier``
///
/// ### Toggles
///
/// - ``DSToggle``
/// - ``DSCheckbox``
/// - ``DSCheckboxState``
public enum DSControls {
    /// Current version of the controls module
    public static let version = "0.1.0"
}
