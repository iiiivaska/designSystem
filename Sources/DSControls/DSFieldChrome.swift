// DSFieldChrome.swift
// DesignSystem
//
// Field chrome wrapper providing label, helper text, required marker,
// and character count around any field content.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSFieldChrome

/// A chrome wrapper that adds label, validation messages, helper text,
/// required marker, and character count around field content.
///
/// `DSFieldChrome` provides consistent field decoration for all text
/// input controls in the design system. It handles the display of
/// validation states, helper text, and optional character counting.
///
/// ## Overview
///
/// ```swift
/// DSFieldChrome(
///     label: "Email",
///     helperText: "Enter your work email",
///     isRequired: true,
///     validation: emailValidation,
///     characterCount: email.count,
///     maxCharacters: 100
/// ) {
///     TextField("user@company.com", text: $email)
/// }
/// ```
///
/// ## Features
///
/// | Feature | Description |
/// |---------|-------------|
/// | Label | Optional field label above the input |
/// | Required marker | Red asterisk for required fields |
/// | Helper text | Descriptive text below the input |
/// | Validation | Error/warning/success messages with icons |
/// | Character count | Optional count display (e.g., "42/100") |
///
/// ## Topics
///
/// ### Creating Field Chrome
///
/// - ``init(label:helperText:isRequired:validation:characterCount:maxCharacters:content:)``
public struct DSFieldChrome<Content: View>: View {
    
    // MARK: - Properties
    
    /// Optional label text displayed above the field.
    private let label: LocalizedStringKey?
    
    /// Optional helper text displayed below the field.
    private let helperText: LocalizedStringKey?
    
    /// Whether the field is required (shows asterisk).
    private let isRequired: Bool
    
    /// Current validation state.
    private let validation: DSValidationState
    
    /// Current character count (nil to hide counter).
    private let characterCount: Int?
    
    /// Maximum allowed characters (nil for unlimited).
    private let maxCharacters: Int?
    
    /// The field content view.
    private let content: Content
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    
    // MARK: - Initializer
    
    /// Creates a field chrome wrapper.
    ///
    /// - Parameters:
    ///   - label: Optional label text above the field.
    ///   - helperText: Optional helper text below the field.
    ///   - isRequired: Whether to show a required asterisk. Defaults to `false`.
    ///   - validation: The current validation state. Defaults to `.none`.
    ///   - characterCount: Current character count. Defaults to `nil` (hidden).
    ///   - maxCharacters: Maximum allowed characters. Defaults to `nil`.
    ///   - content: The field content to wrap.
    public init(
        label: LocalizedStringKey? = nil,
        helperText: LocalizedStringKey? = nil,
        isRequired: Bool = false,
        validation: DSValidationState = .none,
        characterCount: Int? = nil,
        maxCharacters: Int? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.helperText = helperText
        self.isRequired = isRequired
        self.validation = validation
        self.characterCount = characterCount
        self.maxCharacters = maxCharacters
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Label row
            if label != nil || isRequired {
                labelRow
            }
            
            // Field content
            content
            
            // Footer row (validation / helper / character count)
            if hasFooter {
                footerRow
            }
        }
    }
    
    // MARK: - Label Row
    
    private var labelRow: some View {
        HStack(spacing: 2) {
            if let label {
                Text(label)
                    .font(theme.typography.component.helperText.font)
                    .fontWeight(.medium)
                    .foregroundStyle(theme.colors.fg.secondary)
            }
            
            if isRequired {
                Text("*")
                    .font(theme.typography.component.helperText.font)
                    .foregroundStyle(theme.colors.state.danger)
                    .accessibilityLabel("Required")
            }
            
            Spacer(minLength: 0)
        }
    }
    
    // MARK: - Footer Row
    
    private var hasFooter: Bool {
        validation.hasMessage || helperText != nil || characterCount != nil
    }
    
    private var footerRow: some View {
        HStack(alignment: .top, spacing: 4) {
            // Validation message takes priority over helper text
            if validation.hasMessage {
                validationMessageView
            } else if let helperText {
                Text(helperText)
                    .font(theme.typography.component.helperText.font)
                    .foregroundStyle(theme.colors.fg.tertiary)
            }
            
            Spacer(minLength: 0)
            
            // Character count
            if let characterCount {
                characterCountView(count: characterCount)
            }
        }
    }
    
    // MARK: - Validation Message
    
    private var validationMessageView: some View {
        HStack(spacing: 4) {
            Image(systemName: validation.severity.symbolName)
                .font(.system(size: 12))
                .foregroundStyle(validationColor)
            
            if let message = validation.message {
                Text(message)
                    .font(theme.typography.component.helperText.font)
                    .foregroundStyle(validationColor)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(validationAccessibilityLabel)
    }
    
    private var validationColor: Color {
        switch validation.severity {
        case .error:
            return theme.colors.state.danger
        case .warning:
            return theme.colors.state.warning
        case .success:
            return theme.colors.state.success
        case .none:
            return theme.colors.fg.tertiary
        }
    }
    
    private var validationAccessibilityLabel: String {
        let prefix: String
        switch validation.severity {
        case .error: prefix = "Error"
        case .warning: prefix = "Warning"
        case .success: prefix = "Success"
        case .none: prefix = ""
        }
        let message = validation.message ?? ""
        return "\(prefix): \(message)"
    }
    
    // MARK: - Character Count
    
    private func characterCountView(count: Int) -> some View {
        let countText: String
        if let max = maxCharacters {
            countText = "\(count)/\(max)"
        } else {
            countText = "\(count)"
        }
        
        let isOverLimit = maxCharacters.map { count > $0 } ?? false
        let color = isOverLimit ? theme.colors.state.danger : theme.colors.fg.tertiary
        
        return Text(countText)
            .font(theme.typography.component.helperText.font)
            .foregroundStyle(color)
            .monospacedDigit()
    }
}

// MARK: - String Label Convenience

extension DSFieldChrome {
    
    /// Creates a field chrome wrapper with a plain string label.
    ///
    /// - Parameters:
    ///   - label: Optional label string above the field.
    ///   - helperText: Optional helper text string below the field.
    ///   - isRequired: Whether to show a required asterisk. Defaults to `false`.
    ///   - validation: The current validation state. Defaults to `.none`.
    ///   - characterCount: Current character count. Defaults to `nil` (hidden).
    ///   - maxCharacters: Maximum allowed characters. Defaults to `nil`.
    ///   - content: The field content to wrap.
    public init<S: StringProtocol>(
        label: S?,
        helperText: S? = nil,
        isRequired: Bool = false,
        validation: DSValidationState = .none,
        characterCount: Int? = nil,
        maxCharacters: Int? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label.map { LocalizedStringKey(String($0)) }
        self.helperText = helperText.map { LocalizedStringKey(String($0)) }
        self.isRequired = isRequired
        self.validation = validation
        self.characterCount = characterCount
        self.maxCharacters = maxCharacters
        self.content = content()
    }
}

// MARK: - Previews

#Preview("With Label - Light") {
    VStack(spacing: 24) {
        DSFieldChrome(label: "Email", isRequired: true) {
            TextField("user@company.com", text: .constant(""))
                .textFieldStyle(.roundedBorder)
        }
        
        DSFieldChrome(label: "Notes", helperText: "Optional field") {
            TextField("Additional notes...", text: .constant(""))
                .textFieldStyle(.roundedBorder)
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Validation States - Light") {
    VStack(spacing: 24) {
        DSFieldChrome(label: "Email", validation: .error(message: "Invalid email format")) {
            TextField("bad@email", text: .constant("bad@email"))
                .textFieldStyle(.roundedBorder)
        }
        
        DSFieldChrome(label: "Password", validation: .warning(message: "Weak password")) {
            TextField("pass", text: .constant("pass"))
                .textFieldStyle(.roundedBorder)
        }
        
        DSFieldChrome(label: "Username", validation: .success(message: "Username available")) {
            TextField("gooduser", text: .constant("gooduser"))
                .textFieldStyle(.roundedBorder)
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Character Count - Light") {
    DSFieldChrome(
        label: "Bio",
        characterCount: 42,
        maxCharacters: 100
    ) {
        TextField("Tell us about yourself...", text: .constant("A short bio"))
            .textFieldStyle(.roundedBorder)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Validation States - Dark") {
    VStack(spacing: 24) {
        DSFieldChrome(label: "Email", validation: .error(message: "Invalid email format")) {
            TextField("bad@email", text: .constant("bad@email"))
                .textFieldStyle(.roundedBorder)
        }
        
        DSFieldChrome(label: "Password", validation: .warning(message: "Weak password")) {
            TextField("pass", text: .constant("pass"))
                .textFieldStyle(.roundedBorder)
        }
        
        DSFieldChrome(label: "Username", validation: .success(message: "Username available")) {
            TextField("gooduser", text: .constant("gooduser"))
                .textFieldStyle(.roundedBorder)
        }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
