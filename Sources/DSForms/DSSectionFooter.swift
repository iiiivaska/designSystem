// DSSectionFooter.swift
// DesignSystem
//
// Styled section footer with description text for DSFormSection.
// Provides help text or additional context below a section.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSSectionFooter

/// A styled section footer with optional title and description text.
///
/// `DSSectionFooter` displays help text or additional context below
/// a ``DSFormSection``. It uses the theme's helper text typography
/// for consistent styling.
///
/// ## Overview
///
/// ```swift
/// // Simple description footer
/// DSSectionFooter("Your data is encrypted end-to-end.")
///
/// // Footer with title and description
/// DSSectionFooter(
///     "Data Policy",
///     description: "We collect minimal data necessary to provide our services."
/// )
/// ```
///
/// ## Appearance
///
/// The footer uses:
/// - Description: ``DSTextRole/helperText`` from theme (small, tertiary color)
/// - Title (optional): ``DSTextRole/footnote`` with semibold weight
/// - Color: Theme's tertiary foreground for subtle appearance
///
/// ## Accessibility
///
/// - Footer text serves as a hint for the parent section
/// - Uses standard text accessibility
///
/// ## Topics
///
/// ### Creating Footers
///
/// - ``init(_:)``
/// - ``init(_:description:)``
public struct DSSectionFooter: View {
    
    // MARK: - Properties
    
    /// Optional title text.
    let title: String?
    
    /// Description text.
    let description: String
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    
    // MARK: - Initializers
    
    /// Creates a section footer with a description.
    ///
    /// - Parameter description: The footer description text.
    public init(_ description: LocalizedStringKey) {
        self.title = nil
        // Store as String for measurement; localization handled in body
        self.description = "\(description)"
    }
    
    /// Creates a section footer with a string description.
    ///
    /// - Parameter description: The footer description text.
    public init<S: StringProtocol>(_ description: S) {
        self.title = nil
        self.description = String(description)
    }
    
    /// Creates a section footer with title and description.
    ///
    /// - Parameters:
    ///   - title: An optional title displayed above the description.
    ///   - description: The footer description text.
    public init(
        _ title: LocalizedStringKey,
        description: LocalizedStringKey
    ) {
        self.title = "\(title)"
        self.description = "\(description)"
    }
    
    /// Creates a section footer with string title and description.
    ///
    /// - Parameters:
    ///   - title: An optional title displayed above the description. Can be `nil`.
    ///   - description: The footer description text.
    public init(
        title: String?,
        description: String
    ) {
        self.title = title
        self.description = description
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.padding.xxs) {
            if let title {
                DSText(title, role: .footnote)
                    .dsTextWeight(.semibold)
                    .dsTextColor(theme.colors.fg.tertiary)
            }
            
            DSText(description, role: .helperText)
                .dsTextColor(theme.colors.fg.tertiary)
        }
    }
}

// MARK: - Previews

#Preview("Simple Footer - Light") {
    VStack(alignment: .leading, spacing: 24) {
        DSSectionFooter("Your data is encrypted end-to-end.")
        
        DSSectionFooter("Changes may take up to 24 hours to take effect.")
        
        DSSectionFooter("This setting affects all devices linked to your account.")
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Simple Footer - Dark") {
    VStack(alignment: .leading, spacing: 24) {
        DSSectionFooter("Your data is encrypted end-to-end.")
        
        DSSectionFooter("Changes may take up to 24 hours to take effect.")
        
        DSSectionFooter("This setting affects all devices linked to your account.")
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Footer with Title - Light") {
    VStack(alignment: .leading, spacing: 24) {
        DSSectionFooter(
            "Data Policy",
            description: "We collect minimal data necessary to provide our services."
        )
        
        DSSectionFooter(
            "Privacy Note",
            description: "Location data is only used while the app is active and never stored on our servers."
        )
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Footer with Title - Dark") {
    VStack(alignment: .leading, spacing: 24) {
        DSSectionFooter(
            "Data Policy",
            description: "We collect minimal data necessary to provide our services."
        )
        
        DSSectionFooter(
            "Privacy Note",
            description: "Location data is only used while the app is active and never stored on our servers."
        )
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
