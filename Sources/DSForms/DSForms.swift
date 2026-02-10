// DSForms.swift
// DesignSystem
//
// Form containers, sections, rows, and validation system.
// Provides DSForm, DSFormSection, DSFormRow with slot-based architecture.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives
import DSControls

// MARK: - Re-exports

// Re-export configuration types
@_exported import enum DSCore.DSFormRowLayout

/// DSForms module namespace.
///
/// The DSForms module provides form containers, sections, and row components
/// for building structured input forms across iOS, macOS, and watchOS.
///
/// ## Key Components
///
/// - ``DSForm``: Main form container with keyboard avoidance
/// - ``DSFormSection``: Section grouping with header/footer
/// - ``DSSectionHeader``: Styled section header with optional icon
/// - ``DSSectionFooter``: Styled section footer with description text
/// - ``DSFormConfiguration``: Configuration for form behavior
/// - ``DSFormLayoutMode``: Layout mode selection (auto/fixed)
/// - ``DSFormValidationDisplayMode``: How validation is displayed
///
/// ## Usage
///
/// ```swift
/// import DSForms
///
/// DSForm {
///     DSFormSection("Account") {
///         DSTextField("Name", text: $name)
///         DSTextField("Email", text: $email)
///     }
///
///     DSFormSection("Privacy", footer: "Your data is encrypted.") {
///         DSToggle("Analytics", isOn: $analytics)
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Form Container
///
/// - ``DSForm``
/// - ``DSFormConfiguration``
///
/// ### Sections
///
/// - ``DSFormSection``
/// - ``DSSectionHeader``
/// - ``DSSectionFooter``
/// - ``DSFormSectionStyle``
///
/// ### Layout Configuration
///
/// - ``DSFormLayoutMode``
/// - ``DSFormValidationDisplayMode``
public enum DSForms {
    /// Current version of the forms module.
    public static let version = "0.1.0"
}
