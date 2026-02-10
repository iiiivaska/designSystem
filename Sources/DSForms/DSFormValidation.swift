// DSFormValidation.swift
// DesignSystem
//
// Form-level validation state container and propagation system.
// Provides environment-based validation, summary banner, and field registration.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSFormValidationContext

/// Observable validation context for an entire form.
///
/// `DSFormValidationContext` manages validation state for multiple fields
/// within a form. It provides methods to register, update, and query
/// field validation states, and propagates changes through the environment.
///
/// ## Overview
///
/// ```swift
/// @StateObject private var validation = DSFormValidationContext()
///
/// DSForm {
///     DSFormSection("Account") {
///         DSFormRow("Name") {
///             DSTextField("Name", text: $name)
///         }
///         .dsFieldValidation(validation.state(for: "name"))
///     }
/// }
/// .dsFormValidation(validation)
/// ```
///
/// ## Registering Field Validation
///
/// ```swift
/// // Set validation state for a field
/// validation.set(.error(message: "Required"), for: "email")
///
/// // Clear a field's validation
/// validation.clear(for: "email")
///
/// // Check if the entire form is valid
/// if validation.isFormValid {
///     submitForm()
/// }
/// ```
///
/// ## Topics
///
/// ### State Management
///
/// - ``set(_:for:)``
/// - ``clear(for:)``
/// - ``clearAll()``
/// - ``state(for:)``
///
/// ### Querying
///
/// - ``isFormValid``
/// - ``allErrors``
/// - ``allWarnings``
/// - ``highestSeverity``
/// - ``fieldIds``
///
/// ### Validation
///
/// - ``validate(_:for:rules:)``
/// - ``validateAll()``
@MainActor
public final class DSFormValidationContext: ObservableObject {
    
    // MARK: - Published Properties
    
    /// All registered field validation states.
    @Published public private(set) var fieldStates: [String: DSValidationState] = [:]
    
    /// Whether validation results should be shown.
    ///
    /// Set to `true` when the user first attempts to submit the form
    /// or interacts with a field. This prevents showing errors before
    /// the user has had a chance to fill in the form.
    @Published public var showValidation: Bool = false
    
    // MARK: - Initializer
    
    /// Creates a new empty form validation context.
    public init() {}
    
    // MARK: - State Management
    
    /// Sets the validation state for a specific field.
    ///
    /// - Parameters:
    ///   - state: The ``DSValidationState`` to set.
    ///   - fieldId: The unique identifier for the field.
    public func set(_ state: DSValidationState, for fieldId: String) {
        fieldStates[fieldId] = state
    }
    
    /// Clears the validation state for a specific field.
    ///
    /// - Parameter fieldId: The field identifier to clear.
    public func clear(for fieldId: String) {
        fieldStates.removeValue(forKey: fieldId)
    }
    
    /// Clears all field validation states.
    public func clearAll() {
        fieldStates.removeAll()
    }
    
    /// Returns the validation state for a specific field.
    ///
    /// - Parameter fieldId: The field identifier to query.
    /// - Returns: The field's ``DSValidationState``, or `.none` if not registered.
    public func state(for fieldId: String) -> DSValidationState {
        fieldStates[fieldId] ?? .none
    }
    
    /// Returns the effective state (respects `showValidation` flag).
    ///
    /// When ``showValidation`` is `false`, always returns `.none`.
    /// This prevents showing errors before the user has interacted.
    ///
    /// - Parameter fieldId: The field identifier to query.
    /// - Returns: The effective validation state.
    public func effectiveState(for fieldId: String) -> DSValidationState {
        guard showValidation else { return .none }
        return state(for: fieldId)
    }
    
    // MARK: - Querying
    
    /// Whether all registered fields pass validation.
    ///
    /// Returns `true` if there are no error states in the form.
    /// Note: Fields with `.warning` states are considered valid.
    public var isFormValid: Bool {
        fieldStates.values.allSatisfy { $0.isValid }
    }
    
    /// All field IDs with error states.
    public var allErrors: [(fieldId: String, message: String)] {
        fieldStates
            .filter { $0.value.hasError }
            .compactMap { key, value in
                value.message.map { (fieldId: key, message: $0) }
            }
            .sorted { $0.fieldId < $1.fieldId }
    }
    
    /// All field IDs with warning states.
    public var allWarnings: [(fieldId: String, message: String)] {
        fieldStates
            .filter { $0.value.hasWarning }
            .compactMap { key, value in
                value.message.map { (fieldId: key, message: $0) }
            }
            .sorted { $0.fieldId < $1.fieldId }
    }
    
    /// The highest severity among all registered fields.
    public var highestSeverity: DSValidationSeverity {
        fieldStates.values.map(\.severity).max() ?? .none
    }
    
    /// All registered field identifiers.
    public var fieldIds: Set<String> {
        Set(fieldStates.keys)
    }
    
    /// The count of fields with errors.
    public var errorCount: Int {
        fieldStates.values.filter(\.hasError).count
    }
    
    /// The count of fields with warnings.
    public var warningCount: Int {
        fieldStates.values.filter(\.hasWarning).count
    }
    
    // MARK: - Rule-Based Validation
    
    /// Validates a value against a set of rules and updates the field state.
    ///
    /// Applies each rule in order and stops at the first failure.
    ///
    /// ```swift
    /// validation.validate(email, for: "email", rules: [.required, .email])
    /// ```
    ///
    /// - Parameters:
    ///   - value: The value to validate.
    ///   - fieldId: The field identifier to update.
    ///   - rules: An array of ``DSValidationRule`` instances.
    /// - Returns: The resulting ``DSValidationState``.
    @discardableResult
    public func validate<Value>(
        _ value: Value,
        for fieldId: String,
        rules: [DSValidationRule<Value>]
    ) -> DSValidationState {
        for rule in rules {
            let result = rule.apply(to: value)
            if result.hasError || result.hasWarning {
                set(result, for: fieldId)
                return result
            }
        }
        set(.none, for: fieldId)
        return .none
    }
    
    /// Enables validation display and returns whether the form is valid.
    ///
    /// Call this when the user taps the submit button. It sets
    /// ``showValidation`` to `true` so all validation messages become
    /// visible, then returns the form validity.
    ///
    /// ```swift
    /// func submitTapped() {
    ///     if validation.validateAll() {
    ///         // Form is valid, proceed
    ///     }
    /// }
    /// ```
    ///
    /// - Returns: `true` if the form is valid.
    @discardableResult
    public func validateAll() -> Bool {
        showValidation = true
        return isFormValid
    }
    
    /// Converts to a ``DSFormValidationResult`` for snapshot use.
    ///
    /// - Returns: A ``DSFormValidationResult`` containing all field results.
    public func toResult() -> DSFormValidationResult {
        let results = fieldStates.map { key, value in
            DSFieldValidationResult(state: value, fieldId: key)
        }
        return DSFormValidationResult(fieldResults: results)
    }
}

// MARK: - Environment Key

/// Environment key for form validation context.
private struct DSFormValidationContextKey: EnvironmentKey {
    static let defaultValue: DSFormValidationContext? = nil
}

extension EnvironmentValues {
    
    /// The current form validation context, if any.
    ///
    /// Set by ``DSForm`` or the ``dsFormValidation(_:)`` modifier.
    public var dsFormValidationContext: DSFormValidationContext? {
        get { self[DSFormValidationContextKey.self] }
        set { self[DSFormValidationContextKey.self] = newValue }
    }
}

// MARK: - Field Validation Environment Key

/// Environment key for per-field validation state.
private struct DSFieldValidationKey: EnvironmentKey {
    static let defaultValue: DSValidationState = .none
}

extension EnvironmentValues {
    
    /// The current field-level validation state.
    ///
    /// Set by the ``dsFieldValidation(_:)`` modifier on rows or fields.
    public var dsFieldValidation: DSValidationState {
        get { self[DSFieldValidationKey.self] }
        set { self[DSFieldValidationKey.self] = newValue }
    }
}

// MARK: - View Modifiers

extension View {
    
    /// Injects a form validation context into the view hierarchy.
    ///
    /// All child views (form rows, fields) can access the validation
    /// context through the environment.
    ///
    /// ```swift
    /// @StateObject private var validation = DSFormValidationContext()
    ///
    /// DSForm {
    ///     // Form content
    /// }
    /// .dsFormValidation(validation)
    /// ```
    ///
    /// - Parameter context: The ``DSFormValidationContext`` to inject.
    /// - Returns: A view with the validation context in its environment.
    public func dsFormValidation(_ context: DSFormValidationContext) -> some View {
        environment(\.dsFormValidationContext, context)
            .environmentObject(context)
    }
    
    /// Sets the validation state for this field or row.
    ///
    /// Child views can read this from the environment to display
    /// validation feedback:
    ///
    /// ```swift
    /// DSFormRow("Email") {
    ///     DSTextField("Email", text: $email)
    /// }
    /// .dsFieldValidation(.error(message: "Invalid email"))
    /// ```
    ///
    /// - Parameter state: The ``DSValidationState`` for this field.
    /// - Returns: A view with the field validation state set.
    public func dsFieldValidation(_ state: DSValidationState) -> some View {
        environment(\.dsFieldValidation, state)
    }
}

// MARK: - DSValidationSummary

/// A summary view displaying all validation errors and warnings in a form.
///
/// `DSValidationSummary` renders a banner with all current validation
/// issues from a ``DSFormValidationContext``. It is typically placed at
/// the top of a form.
///
/// ## Overview
///
/// ```swift
/// @StateObject private var validation = DSFormValidationContext()
///
/// DSForm {
///     DSValidationSummary(context: validation)
///
///     DSFormSection("Account") {
///         // Form rows...
///     }
/// }
/// .dsFormValidation(validation)
/// ```
///
/// ## Behavior
///
/// - Shows nothing when there are no errors/warnings
/// - Shows nothing when ``DSFormValidationContext/showValidation`` is `false`
/// - Lists all errors first, then warnings
/// - Animates appearance/disappearance
///
/// ## Topics
///
/// ### Creating a Summary
///
/// - ``init(context:showWarnings:)``
public struct DSValidationSummary: View {
    
    // MARK: - Properties
    
    /// The validation context to summarize.
    @ObservedObject private var context: DSFormValidationContext
    
    /// Whether to include warnings in the summary.
    private let showWarnings: Bool
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    
    // MARK: - Initializer
    
    /// Creates a validation summary view.
    ///
    /// - Parameters:
    ///   - context: The ``DSFormValidationContext`` to summarize.
    ///   - showWarnings: Whether to include warnings. Defaults to `true`.
    public init(
        context: DSFormValidationContext,
        showWarnings: Bool = true
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.showWarnings = showWarnings
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if context.showValidation && hasIssues {
                summaryContent
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(theme.motion.component.validationAppear, value: context.showValidation)
        .animation(theme.motion.component.validationAppear, value: context.errorCount)
    }
    
    // MARK: - Content
    
    private var summaryContent: some View {
        VStack(alignment: .leading, spacing: theme.spacing.padding.s) {
            // Header
            HStack(spacing: theme.spacing.padding.xs) {
                Image(systemName: headerIcon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(headerColor)
                
                Text(headerText)
                    .font(theme.typography.component.helperText.font)
                    .fontWeight(.semibold)
                    .foregroundStyle(headerColor)
                
                Spacer()
            }
            
            // Error list
            if !context.allErrors.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(context.allErrors, id: \.fieldId) { error in
                        issueRow(
                            message: error.message,
                            icon: DSValidationSeverity.error.symbolName,
                            color: theme.colors.state.danger
                        )
                    }
                }
            }
            
            // Warning list
            if showWarnings && !context.allWarnings.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(context.allWarnings, id: \.fieldId) { warning in
                        issueRow(
                            message: warning.message,
                            icon: DSValidationSeverity.warning.symbolName,
                            color: theme.colors.state.warning
                        )
                    }
                }
            }
        }
        .padding(.horizontal, theme.spacing.padding.m)
        .padding(.vertical, theme.spacing.padding.m)
        .background(headerColor.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: theme.radii.scale.s))
        .overlay(
            RoundedRectangle(cornerRadius: theme.radii.scale.s)
                .strokeBorder(headerColor.opacity(0.2), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }
    
    private func issueRow(message: String, icon: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(color)
                .frame(width: 14, height: 14)
            
            Text(message)
                .font(theme.typography.component.helperText.font)
                .foregroundStyle(theme.colors.fg.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Helpers
    
    private var hasIssues: Bool {
        !context.allErrors.isEmpty || (showWarnings && !context.allWarnings.isEmpty)
    }
    
    private var headerIcon: String {
        context.allErrors.isEmpty
            ? DSValidationSeverity.warning.symbolName
            : DSValidationSeverity.error.symbolName
    }
    
    private var headerColor: Color {
        context.allErrors.isEmpty
            ? theme.colors.state.warning
            : theme.colors.state.danger
    }
    
    private var headerText: String {
        let errorCount = context.errorCount
        let warningCount = context.warningCount
        
        if errorCount > 0 && warningCount > 0 && showWarnings {
            return "\(errorCount) error\(errorCount == 1 ? "" : "s") and \(warningCount) warning\(warningCount == 1 ? "" : "s")"
        } else if errorCount > 0 {
            return "\(errorCount) error\(errorCount == 1 ? "" : "s") found"
        } else {
            return "\(warningCount) warning\(warningCount == 1 ? "" : "s")"
        }
    }
    
    private var accessibilityLabel: String {
        var parts: [String] = []
        
        if !context.allErrors.isEmpty {
            parts.append("Errors: " + context.allErrors.map(\.message).joined(separator: ". "))
        }
        
        if showWarnings && !context.allWarnings.isEmpty {
            parts.append("Warnings: " + context.allWarnings.map(\.message).joined(separator: ". "))
        }
        
        return parts.joined(separator: ". ")
    }
}

// MARK: - DSFormValidatedRow

/// A form row wrapper that automatically displays validation state.
///
/// `DSFormValidatedRow` wraps a ``DSFormRow`` and adds validation
/// display based on the form configuration's validation display mode.
///
/// ## Overview
///
/// ```swift
/// DSFormValidatedRow(
///     title: "Email",
///     fieldId: "email",
///     isRequired: true
/// ) {
///     DSTextField("Enter email", text: $email)
/// }
/// ```
///
/// ## Topics
///
/// ### Creating a Validated Row
///
/// - ``init(title:fieldId:isRequired:layout:control:)``
public struct DSFormValidatedRow<Control: View>: View {
    
    // MARK: - Properties
    
    /// The row title.
    private let title: LocalizedStringKey
    
    /// The field identifier for validation lookup.
    private let fieldId: String
    
    /// Whether the field is required.
    private let isRequired: Bool
    
    /// Optional layout override.
    private let layout: DSFormRowLayout?
    
    /// The control content.
    private let control: Control
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    @Environment(\.dsFormValidationContext) private var validationContext
    @Environment(\.dsFormConfiguration) private var formConfig: DSFormConfiguration
    
    // MARK: - Initializer
    
    /// Creates a validated form row.
    ///
    /// - Parameters:
    ///   - title: The row title.
    ///   - fieldId: The field identifier for validation lookup.
    ///   - isRequired: Whether to show a required marker. Defaults to `false`.
    ///   - layout: Optional layout override.
    ///   - control: The control content.
    public init(
        _ title: LocalizedStringKey,
        fieldId: String,
        isRequired: Bool = false,
        layout: DSFormRowLayout? = nil,
        @ViewBuilder control: () -> Control
    ) {
        self.title = title
        self.fieldId = fieldId
        self.isRequired = isRequired
        self.layout = layout
        self.control = control()
    }
    
    // MARK: - Body
    
    public var body: some View {
        let validationState = resolvedValidation
        let showMessage = shouldShowValidation(validationState)
        
        DSFormRow(layout: layout) {
            HStack(spacing: 2) {
                DSText(title, role: .rowTitle)
                if isRequired {
                    DSRequiredMarker()
                }
            }
        } control: {
            control
                .environment(\.dsFieldValidation, validationState)
        } footer: {
            if showMessage {
                DSValidationView(state: validationState)
            }
        }
    }
    
    // MARK: - Private
    
    private var resolvedValidation: DSValidationState {
        validationContext?.effectiveState(for: fieldId) ?? .none
    }
    
    private func shouldShowValidation(_ state: DSValidationState) -> Bool {
        guard state.hasMessage || state.isValidating else { return false }
        
        switch formConfig.validationDisplay {
        case .inline, .below:
            return true
        case .summary:
            // In summary mode, individual rows don't show messages
            // but still show border colors via environment
            return false
        case .hidden:
            return false
        }
    }
}

// MARK: - String Convenience

extension DSFormValidatedRow {
    
    /// Creates a validated form row with a string title.
    ///
    /// - Parameters:
    ///   - title: The row title string.
    ///   - fieldId: The field identifier for validation lookup.
    ///   - isRequired: Whether to show a required marker. Defaults to `false`.
    ///   - layout: Optional layout override.
    ///   - control: The control content.
    public init<S: StringProtocol>(
        _ title: S,
        fieldId: String,
        isRequired: Bool = false,
        layout: DSFormRowLayout? = nil,
        @ViewBuilder control: () -> Control
    ) {
        self.title = LocalizedStringKey(String(title))
        self.fieldId = fieldId
        self.isRequired = isRequired
        self.layout = layout
        self.control = control()
    }
}

// MARK: - Previews
#if !os(watchOS)
#Preview("Validation Context - Light") {
    ValidationContextPreview()
        .dsTheme(.light)
}

#Preview("Validation Context - Dark") {
    ValidationContextPreview()
        .dsTheme(.dark)
        .preferredColorScheme(.dark)
}

#Preview("Validation Summary - Light") {
    ValidationSummaryPreview()
        .dsTheme(.light)
}

#Preview("Validation Summary - Dark") {
    ValidationSummaryPreview()
        .dsTheme(.dark)
        .preferredColorScheme(.dark)
}

#Preview("Validated Row - Light") {
    ValidatedRowPreview()
        .dsTheme(.light)
}

#Preview("Validated Row - Dark") {
    ValidatedRowPreview()
        .dsTheme(.dark)
        .preferredColorScheme(.dark)
}

// MARK: - Preview Helpers

private struct ValidationContextPreview: View {
    @StateObject private var validation = DSFormValidationContext()
    @State private var email = ""
    @State private var name = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Form Validation Context")
                    .font(.headline)
                
                // Status
                HStack {
                    Text("Valid:")
                    Text(validation.isFormValid ? "Yes" : "No")
                        .foregroundStyle(validation.isFormValid ? .green : .red)
                    Spacer()
                    Text("Errors: \(validation.errorCount)")
                }
                .font(.caption)
                
                // Fields
                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 2) {
                            Text("Name")
                                .font(.caption)
                                .fontWeight(.medium)
                            DSRequiredMarker(size: .small)
                        }
                        TextField("Enter name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: name) { _, newValue in
                                validation.validate(newValue, for: "name", rules: [.required])
                            }
                        DSValidationView(state: validation.effectiveState(for: "name"))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 2) {
                            Text("Email")
                                .font(.caption)
                                .fontWeight(.medium)
                            DSRequiredMarker(size: .small)
                        }
                        TextField("Enter email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: email) { _, newValue in
                                validation.validate(newValue, for: "email", rules: [.required, .email])
                            }
                        DSValidationView(state: validation.effectiveState(for: "email"))
                    }
                }
                
                Button("Validate All") {
                    validation.validate(name, for: "name", rules: [.required])
                    validation.validate(email, for: "email", rules: [.required, .email])
                    validation.validateAll()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Clear") {
                    validation.clearAll()
                    validation.showValidation = false
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}

private struct ValidationSummaryPreview: View {
    @StateObject private var validation = DSFormValidationContext()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Validation Summary")
                    .font(.headline)
                
                DSValidationSummary(context: validation)
                
                HStack(spacing: 8) {
                    Button("Add Errors") {
                        validation.set(.error(message: "Name is required"), for: "name")
                        validation.set(.error(message: "Invalid email format"), for: "email")
                        validation.set(.warning(message: "Password is weak"), for: "password")
                        validation.showValidation = true
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Clear") {
                        validation.clearAll()
                        validation.showValidation = false
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
    }
}

private struct ValidatedRowPreview: View {
    @StateObject private var validation = DSFormValidationContext()
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Validated Rows")
                    .font(.headline)
                
                VStack(spacing: 0) {
                    DSFormValidatedRow("Name", fieldId: "name", isRequired: true) {
                        TextField("Enter name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: name) { _, newValue in
                                validation.validate(newValue, for: "name", rules: [.required])
                            }
                    }
                    
                    DSFormValidatedRow("Email", fieldId: "email", isRequired: true) {
                        TextField("Enter email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: email) { _, newValue in
                                validation.validate(newValue, for: "email", rules: [.required, .email])
                            }
                    }
                }
                
                Button("Submit") {
                    validation.validate(name, for: "name", rules: [.required])
                    validation.validate(email, for: "email", rules: [.required, .email])
                    validation.validateAll()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .dsFormValidation(validation)
        .environment(\.dsFormResolvedLayout, .stacked)
    }
}
#endif
