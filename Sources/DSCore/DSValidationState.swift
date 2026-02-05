import Foundation

// MARK: - DSValidationState

/// Represents the validation state of an input field.
///
/// `DSValidationState` is used by form fields to display validation
/// feedback to users.
///
/// ## Overview
///
/// ```swift
/// @State private var validation: DSValidationState = .none
///
/// TextField("Email", text: $email)
///     .onChange(of: email) { _, newValue in
///         validation = validateEmail(newValue)
///     }
///
/// if let message = validation.message {
///     Text(message)
///         .foregroundStyle(validation.hasError ? .red : .orange)
/// }
/// ```
///
/// ## Topics
///
/// ### State Cases
///
/// - ``none``
/// - ``validating``
/// - ``success(message:)``
/// - ``warning(message:)``
/// - ``error(message:)``
///
/// ### Properties
///
/// - ``isValid``
/// - ``hasError``
/// - ``hasWarning``
/// - ``hasMessage``
/// - ``message``
/// - ``isValidating``
/// - ``severity``
public enum DSValidationState: Sendable, Equatable, Hashable {
    
    /// No validation has been performed or is required.
    case none
    
    /// Validation is in progress (async validation).
    case validating
    
    /// Validation passed successfully.
    ///
    /// - Parameter message: Optional success message to display.
    case success(message: String? = nil)
    
    /// Validation failed with a warning (non-blocking).
    ///
    /// - Parameter message: Warning message to display.
    case warning(message: String)
    
    /// Validation failed with an error (blocking).
    ///
    /// - Parameter message: Error message to display.
    case error(message: String)
    
    // MARK: - Convenience Properties
    
    /// Whether this represents a valid state.
    ///
    /// Returns `true` for ``none``, ``success(message:)``, and ``warning(message:)``.
    ///
    /// - Note: Warnings are considered valid because they are non-blocking.
    public var isValid: Bool {
        switch self {
        case .none, .success, .warning:
            return true
        case .validating, .error:
            return false
        }
    }
    
    /// Whether this state has an error.
    public var hasError: Bool {
        if case .error = self { return true }
        return false
    }
    
    /// Whether this state has a warning.
    public var hasWarning: Bool {
        if case .warning = self { return true }
        return false
    }
    
    /// Whether this state has a message to display.
    public var hasMessage: Bool {
        message != nil
    }
    
    /// The validation message, if any.
    ///
    /// Returns `nil` for ``none`` and ``validating``.
    public var message: String? {
        switch self {
        case .none, .validating:
            return nil
        case .success(let message):
            return message
        case .warning(let message), .error(let message):
            return message
        }
    }
    
    /// Whether validation is in progress.
    public var isValidating: Bool {
        if case .validating = self { return true }
        return false
    }
    
    /// The severity level of this validation state.
    ///
    /// - SeeAlso: ``DSValidationSeverity``
    public var severity: DSValidationSeverity {
        switch self {
        case .none, .validating:
            return .none
        case .success:
            return .success
        case .warning:
            return .warning
        case .error:
            return .error
        }
    }
}

// MARK: - DSValidationSeverity

/// The severity level of a validation state.
///
/// Severity levels are `Comparable`, with ``error`` being the highest severity.
///
/// ## Usage
///
/// ```swift
/// let highestSeverity = validationResults
///     .map(\.severity)
///     .max() ?? .none
///
/// if highestSeverity >= .warning {
///     // Show warning icon
/// }
/// ```
///
/// ## Topics
///
/// ### Severity Levels
///
/// - ``none``
/// - ``success``
/// - ``warning``
/// - ``error``
///
/// ### Properties
///
/// - ``symbolName``
public enum DSValidationSeverity: String, Sendable, Equatable, Hashable, CaseIterable, Comparable {
    
    /// No validation status.
    case none
    
    /// Validation passed.
    case success
    
    /// Warning (non-blocking).
    case warning
    
    /// Error (blocking).
    case error
    
    private var order: Int {
        switch self {
        case .none: return 0
        case .success: return 1
        case .warning: return 2
        case .error: return 3
        }
    }
    
    public static func < (lhs: DSValidationSeverity, rhs: DSValidationSeverity) -> Bool {
        lhs.order < rhs.order
    }
    
    /// The SF Symbol name for this severity.
    ///
    /// | Severity | Symbol |
    /// |----------|--------|
    /// | ``none`` | (empty string) |
    /// | ``success`` | `checkmark.circle.fill` |
    /// | ``warning`` | `exclamationmark.triangle.fill` |
    /// | ``error`` | `xmark.circle.fill` |
    public var symbolName: String {
        switch self {
        case .none:
            return ""
        case .success:
            return "checkmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "xmark.circle.fill"
        }
    }
}

// MARK: - DSFieldValidationResult

/// Result of validating a single field value.
///
/// ## Usage
///
/// ```swift
/// let result = DSFieldValidationResult.error(
///     "Invalid email format",
///     fieldId: "email"
/// )
///
/// if result.state.hasError {
///     focusField(result.fieldId)
/// }
/// ```
///
/// ## Topics
///
/// ### Properties
///
/// - ``state``
/// - ``fieldId``
///
/// ### Factory Methods
///
/// - ``valid``
/// - ``success(message:fieldId:)``
/// - ``warning(_:fieldId:)``
/// - ``error(_:fieldId:)``
/// - ``validating(fieldId:)``
public struct DSFieldValidationResult: Sendable, Equatable {
    
    /// The validation state.
    public let state: DSValidationState
    
    /// Identifier for the validated field.
    public let fieldId: String?
    
    /// Creates a new validation result.
    ///
    /// - Parameters:
    ///   - state: The ``DSValidationState``.
    ///   - fieldId: Optional identifier for the field.
    public init(state: DSValidationState, fieldId: String? = nil) {
        self.state = state
        self.fieldId = fieldId
    }
    
    // MARK: - Factory Methods
    
    /// Creates a valid result with no message.
    public static var valid: DSFieldValidationResult {
        DSFieldValidationResult(state: .none)
    }
    
    /// Creates a success result.
    ///
    /// - Parameters:
    ///   - message: Optional success message.
    ///   - fieldId: Optional field identifier.
    public static func success(message: String? = nil, fieldId: String? = nil) -> DSFieldValidationResult {
        DSFieldValidationResult(state: .success(message: message), fieldId: fieldId)
    }
    
    /// Creates a warning result.
    ///
    /// - Parameters:
    ///   - message: Warning message.
    ///   - fieldId: Optional field identifier.
    public static func warning(_ message: String, fieldId: String? = nil) -> DSFieldValidationResult {
        DSFieldValidationResult(state: .warning(message: message), fieldId: fieldId)
    }
    
    /// Creates an error result.
    ///
    /// - Parameters:
    ///   - message: Error message.
    ///   - fieldId: Optional field identifier.
    public static func error(_ message: String, fieldId: String? = nil) -> DSFieldValidationResult {
        DSFieldValidationResult(state: .error(message: message), fieldId: fieldId)
    }
    
    /// Creates a validating (in-progress) result.
    ///
    /// - Parameter fieldId: Optional field identifier.
    public static func validating(fieldId: String? = nil) -> DSFieldValidationResult {
        DSFieldValidationResult(state: .validating, fieldId: fieldId)
    }
}

// MARK: - DSFormValidationResult

/// Aggregated validation result for an entire form.
///
/// ## Usage
///
/// ```swift
/// let formResult = DSFormValidationResult(fieldResults: [
///     .success(fieldId: "name"),
///     .error("Required", fieldId: "email"),
///     .warning("Weak password", fieldId: "password")
/// ])
///
/// if formResult.isValid {
///     submitForm()
/// } else {
///     // Focus first error
///     if let firstError = formResult.errors.first {
///         focusField(firstError.fieldId)
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Properties
///
/// - ``fieldResults``
/// - ``isValid``
/// - ``errors``
/// - ``warnings``
/// - ``highestSeverity``
///
/// ### Methods
///
/// - ``result(forFieldId:)``
///
/// ### Constants
///
/// - ``empty``
public struct DSFormValidationResult: Sendable, Equatable {
    
    /// All field validation results.
    public let fieldResults: [DSFieldValidationResult]
    
    /// Creates a new form validation result.
    ///
    /// - Parameter fieldResults: Array of ``DSFieldValidationResult`` instances.
    public init(fieldResults: [DSFieldValidationResult]) {
        self.fieldResults = fieldResults
    }
    
    /// Whether the entire form is valid.
    ///
    /// Returns `true` if all ``fieldResults`` have ``DSValidationState/isValid`` equal to `true`.
    public var isValid: Bool {
        fieldResults.allSatisfy { $0.state.isValid }
    }
    
    /// All errors in the form.
    public var errors: [DSFieldValidationResult] {
        fieldResults.filter { $0.state.hasError }
    }
    
    /// All warnings in the form.
    public var warnings: [DSFieldValidationResult] {
        fieldResults.filter { $0.state.hasWarning }
    }
    
    /// The highest severity among all field results.
    public var highestSeverity: DSValidationSeverity {
        fieldResults.map(\.state.severity).max() ?? .none
    }
    
    /// Gets the validation result for a specific field.
    ///
    /// - Parameter fieldId: The field identifier to look up.
    /// - Returns: The ``DSFieldValidationResult`` for the field, or `nil` if not found.
    public func result(forFieldId fieldId: String) -> DSFieldValidationResult? {
        fieldResults.first { $0.fieldId == fieldId }
    }
    
    /// Empty/valid form result with no field results.
    public static let empty = DSFormValidationResult(fieldResults: [])
}

// MARK: - DSValidationRule

/// A validation rule that can be applied to a value.
///
/// `DSValidationRule` encapsulates validation logic in a reusable type.
///
/// ## Usage
///
/// ```swift
/// let rules: [DSValidationRule<String>] = [.required, .email]
///
/// for rule in rules {
///     let state = rule.apply(to: email)
///     if state.hasError {
///         return state
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Creating Rules
///
/// - ``init(validate:)``
///
/// ### Applying Rules
///
/// - ``apply(to:)``
///
/// ### Built-in String Rules
///
/// - ``DSValidationRule/required``
/// - ``DSValidationRule/minLength(_:)``
/// - ``DSValidationRule/maxLength(_:)``
/// - ``DSValidationRule/email``
public struct DSValidationRule<Value>: @unchecked Sendable {
    
    /// The validation function.
    private let validate: @Sendable (Value) -> DSValidationState
    
    /// Creates a new validation rule.
    ///
    /// - Parameter validate: A closure that takes a value and returns a ``DSValidationState``.
    public init(validate: @escaping @Sendable (Value) -> DSValidationState) {
        self.validate = validate
    }
    
    /// Applies this rule to a value.
    ///
    /// - Parameter value: The value to validate.
    /// - Returns: The resulting ``DSValidationState``.
    public func apply(to value: Value) -> DSValidationState {
        validate(value)
    }
}

// MARK: - Common Validation Rules (String)

extension DSValidationRule where Value == String {
    
    /// Validates that the string is not empty.
    ///
    /// Returns ``DSValidationState/error(message:)`` with "This field is required"
    /// if the string is empty or contains only whitespace.
    public static var required: DSValidationRule<String> {
        DSValidationRule { value in
            value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? .error(message: "This field is required")
                : .none
        }
    }
    
    /// Validates minimum length.
    ///
    /// - Parameter length: Minimum required character count.
    /// - Returns: A rule that validates the string has at least `length` characters.
    public static func minLength(_ length: Int) -> DSValidationRule<String> {
        DSValidationRule { value in
            value.count < length
                ? .error(message: "Must be at least \(length) characters")
                : .none
        }
    }
    
    /// Validates maximum length.
    ///
    /// - Parameter length: Maximum allowed character count.
    /// - Returns: A rule that validates the string has at most `length` characters.
    public static func maxLength(_ length: Int) -> DSValidationRule<String> {
        DSValidationRule { value in
            value.count > length
                ? .error(message: "Must be no more than \(length) characters")
                : .none
        }
    }
    
    /// Validates email format.
    ///
    /// Uses a standard email regex pattern. Returns ``DSValidationState/none``
    /// for empty strings (use with ``required`` for non-optional emails).
    public static var email: DSValidationRule<String> {
        DSValidationRule { value in
            guard !value.isEmpty else { return .none }
            
            let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            return predicate.evaluate(with: value)
                ? .none
                : .error(message: "Invalid email address")
        }
    }
}

// MARK: - Common Validation Rules (Optional String)

extension DSValidationRule where Value == String? {
    
    /// Validates that the optional string is not nil and not empty.
    ///
    /// Returns ``DSValidationState/error(message:)`` with "This field is required"
    /// if the string is `nil`, empty, or contains only whitespace.
    public static var required: DSValidationRule<String?> {
        DSValidationRule { value in
            guard let value = value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return .error(message: "This field is required")
            }
            return .none
        }
    }
}
