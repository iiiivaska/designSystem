// DSMultilineField.swift
// DesignSystem
//
// Themed multiline text input (TextEditor wrapper) with validation chrome.
// Uses DSFieldSpec from theme for resolve-then-render architecture.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSMultilineField

/// A themed multiline text input for longer text content.
///
/// `DSMultilineField` wraps SwiftUI's `TextEditor` with theme styling
/// and validation chrome from the design system.
///
/// ## Overview
///
/// ```swift
/// @State private var notes = ""
///
/// DSMultilineField(
///     "Notes",
///     text: $notes,
///     placeholder: "Enter your notes here...",
///     minHeight: 100,
///     characterLimit: 500
/// )
/// ```
///
/// ## Features
///
/// - Adjustable minimum height
/// - Optional character count and limit
/// - Placeholder text support
/// - Validation state display
/// - Focus ring and accent border
///
/// ## Topics
///
/// ### Creating Multiline Fields
///
/// - ``init(_:text:placeholder:minHeight:validation:isRequired:isDisabled:helperText:characterLimit:)``
public struct DSMultilineField: View {
    
    // MARK: - Properties
    
    /// The field label text.
    private let label: LocalizedStringKey?
    
    /// Binding to the text value.
    @Binding private var text: String
    
    /// Placeholder text shown when empty.
    private let placeholder: LocalizedStringKey
    
    /// Minimum height for the editor area.
    private let minHeight: CGFloat
    
    /// Current validation state.
    private let validation: DSValidationState
    
    /// Whether the field is required.
    private let isRequired: Bool
    
    /// Whether the field is disabled.
    private let isDisabled: Bool
    
    /// Optional helper text.
    private let helperText: LocalizedStringKey?
    
    /// Optional character limit.
    private let characterLimit: Int?
    
    // MARK: - State
    
    @FocusState private var isFocused: Bool
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    @Environment(\.dsCapabilities) private var capabilities: DSCapabilities
    
    // MARK: - Initializer
    
    /// Creates a themed multiline text field.
    ///
    /// - Parameters:
    ///   - label: Optional label text above the field.
    ///   - text: A binding to the text value.
    ///   - placeholder: Placeholder text shown when empty.
    ///   - minHeight: Minimum height for the editor. Defaults to `80`.
    ///   - validation: Current validation state. Defaults to `.none`.
    ///   - isRequired: Whether to show a required marker. Defaults to `false`.
    ///   - isDisabled: Whether the field is disabled. Defaults to `false`.
    ///   - helperText: Optional helper text below the field.
    ///   - characterLimit: Optional maximum character count. Defaults to `nil`.
    public init(
        _ label: LocalizedStringKey? = nil,
        text: Binding<String>,
        placeholder: LocalizedStringKey = "",
        minHeight: CGFloat = 80,
        validation: DSValidationState = .none,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        helperText: LocalizedStringKey? = nil,
        characterLimit: Int? = nil
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.minHeight = minHeight
        self.validation = validation
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.helperText = helperText
        self.characterLimit = characterLimit
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
            validation: validation,
            characterCount: characterLimit != nil ? text.count : nil,
            maxCharacters: characterLimit
        ) {
            editorContent(spec: spec)
        }
        .opacity(spec.opacity)
        .animation(spec.animation, value: isFocused)
        .animation(spec.animation, value: validation)
    }
    
    // MARK: - Editor Content
    
    @ViewBuilder
    private func editorContent(spec: DSFieldSpec) -> some View {
        ZStack(alignment: .topLeading) {
            // Placeholder
            if text.isEmpty {
                Text(placeholder)
                    .font(spec.placeholderTypography.font)
                    .foregroundStyle(spec.placeholderColor)
                    .padding(.horizontal, spec.horizontalPadding)
                    .padding(.vertical, spec.verticalPadding + 8) // Account for TextEditor internal padding
                    .allowsHitTesting(false)
            }
            
            TextEditor(text: $text)
                .font(spec.textTypography.font)
                .foregroundStyle(spec.foregroundColor)
                .scrollContentBackground(.hidden)
                .focused($isFocused)
                .disabled(isDisabled)
                .tint(theme.colors.accent.primary)
                .padding(.horizontal, spec.horizontalPadding - 5) // Compensate TextEditor's built-in padding
                .padding(.vertical, spec.verticalPadding)
        }
        .frame(minHeight: minHeight)
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

extension DSMultilineField {
    
    /// Creates a themed multiline text field with plain string values.
    public init<S: StringProtocol>(
        _ label: S?,
        text: Binding<String>,
        placeholder: S = "",
        minHeight: CGFloat = 80,
        validation: DSValidationState = .none,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        helperText: S? = nil,
        characterLimit: Int? = nil
    ) {
        self.label = label.map { LocalizedStringKey(String($0)) }
        self._text = text
        self.placeholder = LocalizedStringKey(String(placeholder))
        self.minHeight = minHeight
        self.validation = validation
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.helperText = helperText.map { LocalizedStringKey(String($0)) }
        self.characterLimit = characterLimit
    }
}

// MARK: - Previews

#Preview("Multiline - Light") {
    VStack(spacing: 24) {
        DSMultilineField(
            "Notes",
            text: .constant(""),
            placeholder: "Enter your notes here..."
        )
        
        DSMultilineField(
            "Bio",
            text: .constant("I'm a software developer passionate about SwiftUI and design systems."),
            placeholder: "Tell us about yourself",
            isRequired: true,
            characterLimit: 200
        )
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Multiline - Dark") {
    VStack(spacing: 24) {
        DSMultilineField(
            "Notes",
            text: .constant(""),
            placeholder: "Enter your notes here..."
        )
        
        DSMultilineField(
            "Bio",
            text: .constant("I'm a software developer passionate about SwiftUI and design systems."),
            placeholder: "Tell us about yourself",
            isRequired: true,
            characterLimit: 200
        )
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Multiline Validation - Light") {
    VStack(spacing: 24) {
        DSMultilineField(
            "Description",
            text: .constant("Too short"),
            placeholder: "Enter description",
            validation: .error(message: "Must be at least 50 characters")
        )
        
        DSMultilineField(
            "Description",
            text: .constant("This is a moderate length description"),
            placeholder: "Enter description",
            validation: .warning(message: "Consider adding more detail")
        )
        
        DSMultilineField(
            "Description",
            text: .constant("Cannot edit this"),
            placeholder: "Enter description",
            isDisabled: true
        )
    }
    .padding()
    .dsTheme(.light)
}
