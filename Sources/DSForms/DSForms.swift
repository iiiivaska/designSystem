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
/// The DSForms module provides form containers, sections, row components,
/// and a validation system for building structured input forms across
/// iOS, macOS, and watchOS.
///
/// ## Key Components
///
/// - ``DSForm``: Main form container with keyboard avoidance
/// - ``DSFormSection``: Section grouping with header/footer
/// - ``DSFormRow``: Flexible row layout with slot-based architecture
/// - ``DSSectionHeader``: Styled section header with optional icon
/// - ``DSSectionFooter``: Styled section footer with description text
/// - ``DSFormConfiguration``: Configuration for form behavior
/// - ``DSFormLayoutMode``: Layout mode selection (auto/fixed)
/// - ``DSFormValidationDisplayMode``: How validation is displayed
///
/// ## Validation
///
/// - ``DSValidationView``: Standalone validation message display
/// - ``DSFormValidationContext``: Observable form-level validation state
/// - ``DSValidationSummary``: Banner summarizing all validation issues
/// - ``DSFormValidatedRow``: Row with automatic validation display
/// - ``DSRequiredMarker``: Required field indicator (asterisk)
///
/// ## Usage
///
/// ```swift
/// import DSForms
///
/// @StateObject private var validation = DSFormValidationContext()
///
/// DSForm {
///     DSValidationSummary(context: validation)
///
///     DSFormSection("Account") {
///         DSFormValidatedRow("Name", fieldId: "name", isRequired: true) {
///             DSTextField("Enter name", text: $name)
///         }
///         DSFormValidatedRow("Email", fieldId: "email", isRequired: true) {
///             DSTextField("Enter email", text: $email)
///         }
///     }
/// }
/// .dsFormValidation(validation)
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
/// ### Rows
///
/// - ``DSFormRow``
/// - ``DSFormValidatedRow``
///
/// ### Validation
///
/// - ``DSValidationView``
/// - ``DSValidationViewStyle``
/// - ``DSFormValidationContext``
/// - ``DSValidationSummary``
/// - ``DSRequiredMarker``
/// - ``DSRequiredMarkerSize``
///
/// ### Layout Configuration
///
/// - ``DSFormLayoutMode``
/// - ``DSFormValidationDisplayMode``
public enum DSForms {
    /// Current version of the forms module.
    public static let version = "0.1.0"
}
