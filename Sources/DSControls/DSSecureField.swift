// DSSecureField.swift
// DesignSystem
//
// Themed secure text input (password field) with validation chrome.
// Uses DSFieldSpec from theme for resolve-then-render architecture.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSSecureField

/// A themed secure text input for passwords and sensitive data.
///
/// `DSSecureField` wraps SwiftUI's `SecureField` with theme styling
/// and validation chrome from the design system.
///
/// ## Overview
///
/// ```swift
/// @State private var password = ""
///
/// DSSecureField(
///     "Password",
///     text: $password,
///     placeholder: "Enter password",
///     validation: passwordValidation,
///     isRequired: true
/// )
/// ```
///
/// ## Features
///
/// - Toggleable password visibility (show/hide)
/// - Validation states with error/warning messages
/// - Focus ring and accent border on focus
/// - Field chrome with label, helper text, and required marker
///
/// ## Accessibility
///
/// - VoiceOver reads label and validation state
/// - Show/hide toggle is accessible
/// - Required hint announced
///
/// ## Topics
///
/// ### Creating Secure Fields
///
/// - ``init(_:text:placeholder:validation:isRequired:isDisabled:helperText:showToggleVisibility:)``
public struct DSSecureField: View {
    
    // MARK: - Properties
    
    /// The field label text.
    private let label: LocalizedStringKey?
    
    /// Binding to the text value.
    @Binding private var text: String
    
    /// Placeholder text shown when empty.
    private let placeholder: LocalizedStringKey
    
    /// Current validation state.
    private let validation: DSValidationState
    
    /// Whether the field is required.
    private let isRequired: Bool
    
    /// Whether the field is disabled.
    private let isDisabled: Bool
    
    /// Optional helper text.
    private let helperText: LocalizedStringKey?
    
    /// Whether to show the visibility toggle button.
    private let showToggleVisibility: Bool
    
    // MARK: - State
    
    @FocusState private var isFocused: Bool
    @State private var isRevealed: Bool = false
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    @Environment(\.dsCapabilities) private var capabilities: DSCapabilities
    
    // MARK: - Initializer
    
    /// Creates a themed secure text field.
    ///
    /// - Parameters:
    ///   - label: Optional label text above the field.
    ///   - text: A binding to the text value.
    ///   - placeholder: Placeholder text. Defaults to empty.
    ///   - validation: Current validation state. Defaults to `.none`.
    ///   - isRequired: Whether to show a required marker. Defaults to `false`.
    ///   - isDisabled: Whether the field is disabled. Defaults to `false`.
    ///   - helperText: Optional helper text below the field.
    ///   - showToggleVisibility: Whether to show show/hide button. Defaults to `true`.
    public init(
        _ label: LocalizedStringKey? = nil,
        text: Binding<String>,
        placeholder: LocalizedStringKey = "",
        validation: DSValidationState = .none,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        helperText: LocalizedStringKey? = nil,
        showToggleVisibility: Bool = true
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.validation = validation
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.helperText = helperText
        self.showToggleVisibility = showToggleVisibility
    }
    
    // MARK: - Computed State
    
    private var controlState: DSControlState {
        var state: DSControlState = .normal
        if isDisabled { state.insert(.disabled) }
        if isFocused { state.insert(.focused) }
        return state
    }
    
    // MARK: - Body
    
    public var body: some View {
        let spec = theme.resolveField(
            variant: .default,
            state: controlState,
            validation: validation
        )
        
        DSFieldChrome(
            label: label,
            helperText: helperText,
            isRequired: isRequired,
            validation: validation
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
            // Toggle between secure and plain text
            Group {
                if isRevealed {
                    TextField(placeholder, text: $text)
                        .textFieldStyle(.plain)
                } else {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle(.plain)
                }
            }
            .font(spec.textTypography.font)
            .foregroundStyle(spec.foregroundColor)
            .focused($isFocused)
            .disabled(isDisabled)
            .tint(theme.colors.accent.primary)
            
            // Visibility toggle
            if showToggleVisibility && !text.isEmpty {
                Button {
                    isRevealed.toggle()
                } label: {
                    Image(systemName: isRevealed ? DSIconToken.Form.eyeOpen : DSIconToken.Form.eyeClosed)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(theme.colors.fg.tertiary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isRevealed ? "Hide password" : "Show password")
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
    }
}

// MARK: - String Initializer

extension DSSecureField {
    
    /// Creates a themed secure text field with plain string values.
    public init<S: StringProtocol>(
        _ label: S?,
        text: Binding<String>,
        placeholder: S = "",
        validation: DSValidationState = .none,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        helperText: S? = nil,
        showToggleVisibility: Bool = true
    ) {
        self.label = label.map { LocalizedStringKey(String($0)) }
        self._text = text
        self.placeholder = LocalizedStringKey(String(placeholder))
        self.validation = validation
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.helperText = helperText.map { LocalizedStringKey(String($0)) }
        self.showToggleVisibility = showToggleVisibility
    }
}

// MARK: - Previews

#Preview("Secure Field - Light") {
    VStack(spacing: 24) {
        DSSecureField("Password", text: .constant(""), placeholder: "Enter password", isRequired: true)
        DSSecureField("Password", text: .constant("secret123"), placeholder: "Enter password")
        DSSecureField("Password", text: .constant("weak"), placeholder: "Enter password", validation: .warning(message: "Weak password"))
        DSSecureField("Password", text: .constant(""), placeholder: "Enter password", validation: .error(message: "Password is required"), isRequired: true)
        DSSecureField("Password", text: .constant("secret"), placeholder: "Enter password", isDisabled: true)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Secure Field - Dark") {
    VStack(spacing: 24) {
        DSSecureField("Password", text: .constant(""), placeholder: "Enter password", isRequired: true)
        DSSecureField("Password", text: .constant("secret123"), placeholder: "Enter password")
        DSSecureField("Password", text: .constant("weak"), placeholder: "Enter password", validation: .warning(message: "Weak password"))
        DSSecureField("Password", text: .constant(""), placeholder: "Enter password", validation: .error(message: "Password is required"), isRequired: true)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
