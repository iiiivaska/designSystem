// DSButton.swift
// DesignSystem
//
// Primary interactive button control with all variants and states.
// Uses DSButtonSpec from theme for resolve-then-render architecture.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSButton

/// A themed button control with variant, size, and state support.
///
/// `DSButton` is the primary interactive button in the design system.
/// It resolves its styling from ``DSButtonSpec`` through the theme,
/// ensuring consistent appearance across the application.
///
/// ## Overview
///
/// ```swift
/// // Primary action
/// DSButton("Save") { /* action */ }
///
/// // Secondary with icon
/// DSButton("Edit", icon: "pencil", variant: .secondary) { /* action */ }
///
/// // Destructive with confirmation
/// DSButton("Delete", icon: "trash", variant: .destructive) { /* action */ }
///
/// // Loading state
/// DSButton("Saving...", variant: .primary, isLoading: true) { }
/// ```
///
/// ## Variants
///
/// | Variant | Usage |
/// |---------|-------|
/// | ``DSButtonVariant/primary`` | Main CTA, submit actions |
/// | ``DSButtonVariant/secondary`` | Secondary actions |
/// | ``DSButtonVariant/tertiary`` | Inline actions, less prominent |
/// | ``DSButtonVariant/destructive`` | Delete, remove, sign out |
///
/// ## Sizes
///
/// | Size | Height |
/// |------|--------|
/// | ``DSButtonSize/small`` | 32pt |
/// | ``DSButtonSize/medium`` | 40pt |
/// | ``DSButtonSize/large`` | 48pt |
///
/// ## States
///
/// - Normal: Default interactive state
/// - Pressed: Visual feedback on tap/click
/// - Disabled: Non-interactive, reduced opacity
/// - Loading: Shows spinner, non-interactive
///
/// ## Accessibility
///
/// - Button label is automatically used for VoiceOver
/// - Disabled state announces "dimmed"
/// - Loading state announces "Loading" via the spinner
///
/// ## Topics
///
/// ### Creating Buttons
///
/// - ``init(_:icon:variant:size:isLoading:isDisabled:fullWidth:action:)``
///
/// ### Configuration
///
/// - ``DSButtonVariant``
/// - ``DSButtonSize``
///
/// ### Styling
///
/// - ``DSButtonSpec``
/// - ``DSButtonStyleModifier``
public struct DSButton: View {
    
    // MARK: - Properties
    
    /// The button label text.
    private let label: LocalizedStringKey
    
    /// Optional leading SF Symbol icon name.
    private let icon: String?
    
    /// The button variant.
    private let variant: DSButtonVariant
    
    /// The button size.
    private let size: DSButtonSize
    
    /// Whether the button is in a loading state.
    private let isLoading: Bool
    
    /// Whether the button is disabled.
    private let isDisabled: Bool
    
    /// Whether the button stretches to full width.
    private let fullWidth: Bool
    
    /// The action to perform when tapped.
    private let action: () -> Void
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    
    // MARK: - Initializer
    
    /// Creates a design system button.
    ///
    /// - Parameters:
    ///   - label: The button label text.
    ///   - icon: Optional SF Symbol name for a leading icon.
    ///   - variant: The button variant. Defaults to ``DSButtonVariant/primary``.
    ///   - size: The button size. Defaults to ``DSButtonSize/medium``.
    ///   - isLoading: Whether to show a loading spinner. Defaults to `false`.
    ///   - isDisabled: Whether the button is disabled. Defaults to `false`.
    ///   - fullWidth: Whether the button expands to fill available width. Defaults to `false`.
    ///   - action: The closure to execute when the button is tapped.
    public init(
        _ label: LocalizedStringKey,
        icon: String? = nil,
        variant: DSButtonVariant = .primary,
        size: DSButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        fullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.fullWidth = fullWidth
        self.action = action
    }
    
    // MARK: - Computed State
    
    /// The resolved control state for spec resolution.
    private var controlState: DSControlState {
        var state: DSControlState = .normal
        if isDisabled { state.insert(.disabled) }
        if isLoading { state.insert(.loading) }
        return state
    }
    
    /// Whether the button allows interaction.
    private var isInteractive: Bool {
        !isDisabled && !isLoading
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: action) {
            buttonContent
        }
        .buttonStyle(
            DSButtonStyleModifier(
                theme: theme,
                variant: variant,
                size: size,
                controlState: controlState,
                fullWidth: fullWidth
            )
        )
        .disabled(!isInteractive)
        .accessibilityAddTraits(.isButton)
        .accessibilityRemoveTraits(isInteractive ? [] : .isButton)
    }
    
    // MARK: - Button Content
    
    /// The button's internal content (icon + label or loader + label).
    @ViewBuilder
    private var buttonContent: some View {
        if isLoading {
            loadingContent
        } else {
            labelContent
        }
    }
    
    /// The standard label content with optional icon.
    @ViewBuilder
    private var labelContent: some View {
        HStack(spacing: iconSpacing) {
            if let icon {
                Image(systemName: icon)
                    .font(iconFont)
            }
            Text(label)
        }
    }
    
    /// The loading content with spinner and label.
    private var loadingContent: some View {
        HStack(spacing: iconSpacing) {
            DSLoader(size: loaderSize, color: loaderColor)
            Text(label)
        }
    }
    
    // MARK: - Size-dependent Values
    
    /// Spacing between icon and label text.
    private var iconSpacing: CGFloat {
        switch size {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        }
    }
    
    /// Font for the leading icon.
    private var iconFont: Font {
        switch size {
        case .small: return .system(size: 12, weight: .semibold)
        case .medium: return .system(size: 14, weight: .semibold)
        case .large: return .system(size: 16, weight: .semibold)
        }
    }
    
    /// Loader size matching the button size.
    private var loaderSize: DSLoaderSize {
        switch size {
        case .small: return .small
        case .medium: return .small
        case .large: return .medium
        }
    }
    
    /// Loader color based on the variant.
    private var loaderColor: DSLoaderColor {
        switch variant {
        case .primary, .destructive:
            return .custom(.white)
        case .secondary, .tertiary:
            return .accent
        }
    }
}

// MARK: - String Initializer

extension DSButton {
    
    /// Creates a design system button with a plain string label.
    ///
    /// - Parameters:
    ///   - label: The button label string.
    ///   - icon: Optional SF Symbol name for a leading icon.
    ///   - variant: The button variant. Defaults to ``DSButtonVariant/primary``.
    ///   - size: The button size. Defaults to ``DSButtonSize/medium``.
    ///   - isLoading: Whether to show a loading spinner. Defaults to `false`.
    ///   - isDisabled: Whether the button is disabled. Defaults to `false`.
    ///   - fullWidth: Whether the button expands to fill available width. Defaults to `false`.
    ///   - action: The closure to execute when the button is tapped.
    public init<S: StringProtocol>(
        _ label: S,
        icon: String? = nil,
        variant: DSButtonVariant = .primary,
        size: DSButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        fullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = LocalizedStringKey(String(label))
        self.icon = icon
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.fullWidth = fullWidth
        self.action = action
    }
}

// MARK: - Previews

#Preview("Variants - Light") {
    VStack(spacing: 16) {
        DSButton("Primary", variant: .primary) { }
        DSButton("Secondary", variant: .secondary) { }
        DSButton("Tertiary", variant: .tertiary) { }
        DSButton("Destructive", variant: .destructive) { }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Variants - Dark") {
    VStack(spacing: 16) {
        DSButton("Primary", variant: .primary) { }
        DSButton("Secondary", variant: .secondary) { }
        DSButton("Tertiary", variant: .tertiary) { }
        DSButton("Destructive", variant: .destructive) { }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Sizes - Light") {
    VStack(spacing: 16) {
        DSButton("Small", variant: .primary, size: .small) { }
        DSButton("Medium", variant: .primary, size: .medium) { }
        DSButton("Large", variant: .primary, size: .large) { }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Sizes - Dark") {
    VStack(spacing: 16) {
        DSButton("Small", variant: .primary, size: .small) { }
        DSButton("Medium", variant: .primary, size: .medium) { }
        DSButton("Large", variant: .primary, size: .large) { }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("States - Light") {
    VStack(spacing: 16) {
        DSButton("Normal") { }
        DSButton("Disabled", isDisabled: true) { }
        DSButton("Loading", isLoading: true) { }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("States - Dark") {
    VStack(spacing: 16) {
        DSButton("Normal") { }
        DSButton("Disabled", isDisabled: true) { }
        DSButton("Loading", isLoading: true) { }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("With Icons - Light") {
    VStack(spacing: 16) {
        DSButton("Save", icon: "checkmark", variant: .primary) { }
        DSButton("Edit", icon: "pencil", variant: .secondary) { }
        DSButton("Share", icon: "square.and.arrow.up", variant: .tertiary) { }
        DSButton("Delete", icon: "trash", variant: .destructive) { }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("With Icons - Dark") {
    VStack(spacing: 16) {
        DSButton("Save", icon: "checkmark", variant: .primary) { }
        DSButton("Edit", icon: "pencil", variant: .secondary) { }
        DSButton("Share", icon: "square.and.arrow.up", variant: .tertiary) { }
        DSButton("Delete", icon: "trash", variant: .destructive) { }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Full Width - Light") {
    VStack(spacing: 16) {
        DSButton("Full Width Primary", variant: .primary, fullWidth: true) { }
        DSButton("Full Width Secondary", variant: .secondary, fullWidth: true) { }
        DSButton("Full Width Loading", variant: .primary, isLoading: true, fullWidth: true) { }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Full Width - Dark") {
    VStack(spacing: 16) {
        DSButton("Full Width Primary", variant: .primary, fullWidth: true) { }
        DSButton("Full Width Secondary", variant: .secondary, fullWidth: true) { }
        DSButton("Full Width Loading", variant: .primary, isLoading: true, fullWidth: true) { }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("All Variants x All States") {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                VStack(alignment: .leading, spacing: 8) {
                    Text(variant.rawValue.capitalized)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        DSButton("Normal", variant: variant, size: .small) { }
                        DSButton("Disabled", variant: variant, size: .small, isDisabled: true) { }
                        DSButton("Loading", variant: variant, size: .small, isLoading: true) { }
                    }
                }
            }
        }
        .padding()
    }
    .dsTheme(.light)
}
