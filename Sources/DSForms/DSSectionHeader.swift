// DSSectionHeader.swift
// DesignSystem
//
// Styled section header with optional icon for DSFormSection.
// Uses theme typography for consistent styling.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSSectionHeader

/// A styled section header with optional leading icon.
///
/// `DSSectionHeader` displays a section title using the theme's
/// ``DSTextRole/sectionHeader`` typography role, with an optional
/// leading SF Symbol icon.
///
/// ## Overview
///
/// ```swift
/// // Simple header
/// DSSectionHeader("Account")
///
/// // Header with icon
/// DSSectionHeader("Privacy", icon: "lock.fill")
///
/// // Header with custom icon color
/// DSSectionHeader("Notifications", icon: "bell.fill", iconColor: .accent)
/// ```
///
/// ## Appearance
///
/// The header uses:
/// - Font: ``DSTextRole/sectionHeader`` from theme (typically uppercase, small, semibold)
/// - Color: Theme's secondary foreground
/// - Icon: Sized to match the header text
///
/// ## Accessibility
///
/// - Header text is announced with the `.isHeader` trait
/// - Icon is decorative (hidden from VoiceOver)
///
/// ## Topics
///
/// ### Creating Headers
///
/// - ``init(_:icon:iconColor:)``
public struct DSSectionHeader: View {
    
    // MARK: - Properties
    
    /// The header title text.
    private let title: Text
    
    /// Optional SF Symbol icon name.
    private let icon: String?
    
    /// Icon color mode.
    private let iconColor: DSIconColor
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    
    // MARK: - Initializers
    
    /// Creates a section header with a localized title.
    ///
    /// - Parameters:
    ///   - title: The header title as a localized string key.
    ///   - icon: Optional SF Symbol name for a leading icon. Defaults to `nil`.
    ///   - iconColor: The icon color mode. Defaults to `.secondary`.
    public init(
        _ title: LocalizedStringKey,
        icon: String? = nil,
        iconColor: DSIconColor = .secondary
    ) {
        self.title = Text(title)
        self.icon = icon
        self.iconColor = iconColor
    }
    
    /// Creates a section header with a string title.
    ///
    /// - Parameters:
    ///   - title: The header title as a string.
    ///   - icon: Optional SF Symbol name for a leading icon. Defaults to `nil`.
    ///   - iconColor: The icon color mode. Defaults to `.secondary`.
    public init<S: StringProtocol>(
        _ title: S,
        icon: String? = nil,
        iconColor: DSIconColor = .secondary
    ) {
        self.title = Text(title)
        self.icon = icon
        self.iconColor = iconColor
    }
    
    // MARK: - Body
    
    public var body: some View {
        let style = DSTextRole.sectionHeader.resolve(from: theme)
        
        HStack(spacing: theme.spacing.padding.xs) {
            if let icon {
                DSIcon(icon, size: .small, color: iconColor)
                    .accessibilityHidden(true)
            }
            
            title
                .font(style.font.weight(style.weight))
                .foregroundStyle(style.color)
                .accessibilityAddTraits(.isHeader)
        }
    }
}

// MARK: - Previews

#Preview("Simple Header - Light") {
    VStack(alignment: .leading, spacing: 16) {
        DSSectionHeader("Account")
        DSSectionHeader("Privacy")
        DSSectionHeader("Notifications")
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Simple Header - Dark") {
    VStack(alignment: .leading, spacing: 16) {
        DSSectionHeader("Account")
        DSSectionHeader("Privacy")
        DSSectionHeader("Notifications")
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Header with Icons - Light") {
    VStack(alignment: .leading, spacing: 16) {
        DSSectionHeader("Account", icon: "person.fill")
        DSSectionHeader("Privacy", icon: "lock.fill")
        DSSectionHeader("Notifications", icon: "bell.fill")
        DSSectionHeader("Storage", icon: "internaldrive.fill", iconColor: .accent)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Header with Icons - Dark") {
    VStack(alignment: .leading, spacing: 16) {
        DSSectionHeader("Account", icon: "person.fill")
        DSSectionHeader("Privacy", icon: "lock.fill")
        DSSectionHeader("Notifications", icon: "bell.fill")
        DSSectionHeader("Storage", icon: "internaldrive.fill", iconColor: .accent)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
