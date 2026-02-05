// DSTextField.swift
// DesignSystem
//
// Themed text input control with validation chrome.
// Uses DSFieldSpec from theme for resolve-then-render architecture.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSTextField

/// A themed text input control with validation, focus ring, and field chrome.
///
/// `DSTextField` is the primary text input in the design system. It resolves
/// its styling from ``DSFieldSpec`` through the theme, providing consistent
/// appearance with built-in validation display.
///
/// ## Overview
///
/// ```swift
/// @State private var email = ""
/// @State private var validation: DSValidationState = .none
///
/// DSTextField(
///     "Email",
///     text: $email,
///     placeholder: "user@company.com",
///     validation: validation,
///     isRequired: true
/// )
/// ```
///
/// ## Variants
///
/// | Variant | Usage |
/// |---------|-------|
/// | ``DSFieldVariant/default`` | Standard text input with subtle border |
/// | ``DSFieldVariant/search`` | Search field with rounded corners |
///
/// ## States
///
/// - Normal: Default state with subtle border
/// - Focused: Accent border with optional focus ring
/// - Error: Red border with error message
/// - Warning: Yellow border with warning message
/// - Success: Green border with success message
/// - Disabled: Reduced opacity, non-interactive
///
/// ## Accessibility
///
/// - VoiceOver reads the label, placeholder, and validation messages
/// - Dynamic Type supported through theme typography
/// - Required fields announced with "Required" hint
///
/// ## Topics
///
/// ### Creating Text Fields
///
/// - ``init(_:text:placeholder:variant:validation:isRequired:isDisabled:helperText:characterLimit:)``
///
/// ### Field Chrome
///
/// - ``DSFieldChrome``
///
/// ### Styling
///
/// - ``DSFieldSpec``
/// - ``DSFieldVariant``
public struct DSTextField: View {
    
    // MARK: - Properties
    
    /// The field label text.
    private let label: LocalizedStringKey?
    
    /// Binding to the text value.
    @Binding private var text: String
    
    /// Placeholder text shown when empty.
    private let placeholder: LocalizedStringKey
    
    /// The field variant.
    private let variant: DSFieldVariant
    
    /// Current validation state.
    private let validation: DSValidationState
    
    /// Whether the field is required.
    private let isRequired: Bool
    
    /// Whether the field is disabled.
    private let isDisabled: Bool
    
    /// Optional helper text below the field.
    private let helperText: LocalizedStringKey?
    
    /// Optional character limit (nil for unlimited).
    private let characterLimit: Int?
    
    // MARK: - State
    
    @FocusState private var isFocused: Bool
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    @Environment(\.dsCapabilities) private var capabilities: DSCapabilities
    
    // MARK: - Initializer
    
    /// Creates a themed text field.
    ///
    /// - Parameters:
    ///   - label: Optional label text displayed above the field.
    ///   - text: A binding to the text value.
    ///   - placeholder: Placeholder text shown when the field is empty.
    ///   - variant: The field variant. Defaults to ``DSFieldVariant/default``.
    ///   - validation: Current validation state. Defaults to `.none`.
    ///   - isRequired: Whether to show a required marker. Defaults to `false`.
    ///   - isDisabled: Whether the field is disabled. Defaults to `false`.
    ///   - helperText: Optional helper text below the field.
    ///   - characterLimit: Optional maximum character count display. Defaults to `nil`.
    public init(
        _ label: LocalizedStringKey? = nil,
        text: Binding<String>,
        placeholder: LocalizedStringKey = "",
        variant: DSFieldVariant = .default,
        validation: DSValidationState = .none,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        helperText: LocalizedStringKey? = nil,
        characterLimit: Int? = nil
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.variant = variant
        self.validation = validation
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.helperText = helperText
        self.characterLimit = characterLimit
    }
    
    // MARK: - Computed State
    
    /// The resolved control state for spec resolution.
    private var controlState: DSControlState {
        var state: DSControlState = .normal
        if isDisabled { state.insert(.disabled) }
        if isFocused { state.insert(.focused) }
        return state
    }
    
    // MARK: - Body
    
    public var body: some View {
        let spec = theme.resolveField(
            variant: variant,
            state: controlState,
            validation: validation
        )
        
        DSFieldChrome(
            label: label,
            helperText: helperText,
            isRequired: isRequired,
            validation: validation,
            characterCount: characterLimit != nil ? text.count : nil,
            maxCharacters: characterLimit
        ) {
            fieldContent(spec: spec)
        }
        .opacity(spec.opacity)
        .animation(spec.animation, value: isFocused)
        .animation(spec.animation, value: validation)
    }
    
    // MARK: - Field Content
    
    @ViewBuilder
    private func fieldContent(spec: DSFieldSpec) -> some View {
        HStack(spacing: 8) {
            // Search icon for search variant
            if variant == .search {
                Image(systemName: DSIconToken.Action.search)
                    .font(.system(size: spec.textTypography.size))
                    .foregroundStyle(spec.placeholderColor)
            }
            
            TextField(placeholder, text: $text)
                .font(spec.textTypography.font)
                .foregroundStyle(spec.foregroundColor)
                .focused($isFocused)
                .disabled(isDisabled)
                .textFieldStyle(.plain)
                .tint(theme.colors.accent.primary)
            
            // Clear button when focused and has text
            if isFocused && !text.isEmpty && !isDisabled {
                Button {
                    text = ""
                } label: {
                    Image(systemName: DSIconToken.Form.clear)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(theme.colors.fg.tertiary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear text")
            }
            
            // Validation indicator icon
            if validation.severity != .none && !isFocused {
                Image(systemName: validation.severity.symbolName)
                    .font(.system(size: 14))
                    .foregroundStyle(validationIconColor)
            }
        }
        .padding(.horizontal, spec.horizontalPadding)
        .padding(.vertical, spec.verticalPadding)
        .frame(minHeight: spec.height)
        .background(
            RoundedRectangle(cornerRadius: spec.cornerRadius, style: .continuous)
                .fill(spec.backgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: spec.cornerRadius, style: .continuous)
                .stroke(spec.borderColor, lineWidth: spec.borderWidth)
        )
        .overlay(
            // Focus ring (outer glow)
            RoundedRectangle(cornerRadius: spec.cornerRadius + 2, style: .continuous)
                .stroke(spec.focusRingColor, lineWidth: spec.focusRingWidth)
                .padding(-2)
                .opacity(isFocused && capabilities.supportsFocusRing ? 1 : 0)
        )
        .contentShape(RoundedRectangle(cornerRadius: spec.cornerRadius, style: .continuous))
        .onTapGesture {
            if !isDisabled {
                isFocused = true
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
    }
    
    // MARK: - Validation Colors
    
    private var validationIconColor: Color {
        switch validation.severity {
        case .error: return theme.colors.state.danger
        case .warning: return theme.colors.state.warning
        case .success: return theme.colors.state.success
        case .none: return .clear
        }
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabel: String {
        var parts: [String] = []
        // Label is read by the system from the LocalizedStringKey
        if isRequired {
            parts.append("Required")
        }
        if let message = validation.message {
            let prefix: String
            switch validation.severity {
            case .error: prefix = "Error"
            case .warning: prefix = "Warning"
            case .success: prefix = "Success"
            case .none: prefix = ""
            }
            parts.append("\(prefix): \(message)")
        }
        return parts.joined(separator: ". ")
    }
    
    private var accessibilityHint: String {
        if isDisabled { return "Disabled" }
        return ""
    }
}

// MARK: - String Initializers

extension DSTextField {
    
    /// Creates a themed text field with plain string values.
    ///
    /// - Parameters:
    ///   - label: Optional label string above the field.
    ///   - text: A binding to the text value.
    ///   - placeholder: Placeholder text. Defaults to empty.
    ///   - variant: The field variant. Defaults to ``DSFieldVariant/default``.
    ///   - validation: Current validation state. Defaults to `.none`.
    ///   - isRequired: Whether to show a required marker. Defaults to `false`.
    ///   - isDisabled: Whether the field is disabled. Defaults to `false`.
    ///   - helperText: Optional helper text string.
    ///   - characterLimit: Optional maximum character count. Defaults to `nil`.
    public init<S: StringProtocol>(
        _ label: S?,
        text: Binding<String>,
        placeholder: S = "",
        variant: DSFieldVariant = .default,
        validation: DSValidationState = .none,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        helperText: S? = nil,
        characterLimit: Int? = nil
    ) {
        self.label = label.map { LocalizedStringKey(String($0)) }
        self._text = text
        self.placeholder = LocalizedStringKey(String(placeholder))
        self.variant = variant
        self.validation = validation
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.helperText = helperText.map { LocalizedStringKey(String($0)) }
        self.characterLimit = characterLimit
    }
}

// MARK: - Previews

#Preview("Default - Light") {
    VStack(spacing: 24) {
        DSTextField("Email", text: .constant(""), placeholder: "user@company.com")
        DSTextField("Name", text: .constant("John Doe"), placeholder: "Full name")
        DSTextField("Disabled", text: .constant("Cannot edit"), isDisabled: true)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Default - Dark") {
    VStack(spacing: 24) {
        DSTextField("Email", text: .constant(""), placeholder: "user@company.com")
        DSTextField("Name", text: .constant("John Doe"), placeholder: "Full name")
        DSTextField("Disabled", text: .constant("Cannot edit"), isDisabled: true)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Search Variant - Light") {
    VStack(spacing: 24) {
        DSTextField(text: .constant(""), placeholder: "Search...", variant: .search)
        DSTextField(text: .constant("SwiftUI"), placeholder: "Search...", variant: .search)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Search Variant - Dark") {
    VStack(spacing: 24) {
        DSTextField(text: .constant(""), placeholder: "Search...", variant: .search)
        DSTextField(text: .constant("SwiftUI"), placeholder: "Search...", variant: .search)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Validation States - Light") {
    VStack(spacing: 24) {
        DSTextField("Email", text: .constant("bad@"), placeholder: "Email", validation: .error(message: "Invalid email format"))
        DSTextField("Password", text: .constant("pass"), placeholder: "Password", validation: .warning(message: "Weak password"))
        DSTextField("Username", text: .constant("gooduser"), placeholder: "Username", validation: .success(message: "Username available"))
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Validation States - Dark") {
    VStack(spacing: 24) {
        DSTextField("Email", text: .constant("bad@"), placeholder: "Email", validation: .error(message: "Invalid email format"))
        DSTextField("Password", text: .constant("pass"), placeholder: "Password", validation: .warning(message: "Weak password"))
        DSTextField("Username", text: .constant("gooduser"), placeholder: "Username", validation: .success(message: "Username available"))
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Required + Helper + Count - Light") {
    VStack(spacing: 24) {
        DSTextField(
            "Bio",
            text: .constant("I'm a Swift developer"),
            placeholder: "Tell us about yourself",
            isRequired: true,
            helperText: "Write a short bio",
            characterLimit: 140
        )
    }
    .padding()
    .dsTheme(.light)
}
