// DSText.swift
// DesignSystem
//
// Role-based text component using theme typography.
// Components use DSText instead of raw SwiftUI Text for consistent styling.

import SwiftUI
import DSCore
import DSTheme

// MARK: - DSText

/// A role-based text component that automatically applies theme typography.
///
/// `DSText` is the primary text primitive in the design system. It resolves
/// its styling from the current theme's typography roles, ensuring consistent
/// text appearance across the application.
///
/// ## Overview
///
/// Instead of manually configuring `Text` views with fonts and colors,
/// use `DSText` with a semantic role:
///
/// ```swift
/// // Instead of:
/// Text("Title")
///     .font(.system(size: 28, weight: .bold))
///     .foregroundStyle(Color.primary)
///
/// // Use:
/// DSText("Title", role: .title1)
/// ```
///
/// ## Roles
///
/// Each role maps to a ``DSTextStyle`` in the current theme's typography:
///
/// | Category | Roles |
/// |----------|-------|
/// | System | ``DSTextRole/largeTitle``, ``DSTextRole/title1``, ``DSTextRole/body``, etc. |
/// | Component | ``DSTextRole/buttonLabel``, ``DSTextRole/rowTitle``, ``DSTextRole/monoText``, etc. |
///
/// ## Customization
///
/// Override specific style properties while keeping the role's base styling:
///
/// ```swift
/// // Custom color with role font
/// DSText("Accent text", role: .headline)
///     .dsTextColor(.blue)
///
/// // Custom weight
/// DSText("Bold body", role: .body)
///     .dsTextWeight(.bold)
/// ```
///
/// ## Accessibility
///
/// - Supports Dynamic Type automatically through theme typography
/// - Uses semantic font sizes that scale with system preferences
/// - Letter spacing from theme is applied for readability
///
/// ## Topics
///
/// ### Creating Text
///
/// - ``init(_:role:)``
/// - ``init(verbatim:role:)``
///
/// ### Roles
///
/// - ``DSTextRole``
///
/// ### Modifiers
///
/// - ``dsTextColor(_:)``
/// - ``dsTextWeight(_:)``
public struct DSText: View {
    
    // MARK: - Properties
    
    /// The text content to display.
    private let content: Text
    
    /// The typography role for styling.
    private let role: DSTextRole
    
    /// Optional color override.
    private var colorOverride: Color?
    
    /// Optional weight override.
    private var weightOverride: Font.Weight?
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    
    // MARK: - Initializers
    
    /// Creates a design system text view with a localized string and role.
    ///
    /// The text is styled according to the specified role using
    /// the current theme's typography.
    ///
    /// - Parameters:
    ///   - content: A localized string key.
    ///   - role: The typography role to apply. Defaults to ``DSTextRole/body``.
    public init(_ content: LocalizedStringKey, role: DSTextRole = .body) {
        self.content = Text(content)
        self.role = role
    }
    
    /// Creates a design system text view with a verbatim string and role.
    ///
    /// The text is styled according to the specified role using
    /// the current theme's typography. The string is used verbatim
    /// without localization.
    ///
    /// - Parameters:
    ///   - verbatim: A string to display without localization.
    ///   - role: The typography role to apply. Defaults to ``DSTextRole/body``.
    public init(verbatim: String, role: DSTextRole = .body) {
        self.content = Text(verbatim: verbatim)
        self.role = role
    }
    
    /// Creates a design system text view from a generic StringProtocol.
    ///
    /// - Parameters:
    ///   - content: The string content to display.
    ///   - role: The typography role to apply. Defaults to ``DSTextRole/body``.
    public init<S: StringProtocol>(_ content: S, role: DSTextRole = .body) {
        self.content = Text(content)
        self.role = role
    }
    
    // MARK: - Private Init for Modifiers
    
    private init(
        content: Text,
        role: DSTextRole,
        colorOverride: Color?,
        weightOverride: Font.Weight?
    ) {
        self.content = content
        self.role = role
        self.colorOverride = colorOverride
        self.weightOverride = weightOverride
    }
    
    // MARK: - Body
    
    public var body: some View {
        let style = role.resolve(from: theme)
        
        styledText(style: style)
    }
    
    /// Applies the resolved text style to the content.
    @ViewBuilder
    private func styledText(style: DSTextStyle) -> some View {
        let weight = weightOverride ?? style.weight
        let color = colorOverride ?? style.color
        
        content
            .font(style.font.weight(weight))
            .foregroundStyle(color)
            .ifLet(style.letterSpacing) { view, spacing in
                view.tracking(spacing)
            }
            .accessibilityAddTraits(accessibilityTraits)
    }
    
    /// Determines appropriate accessibility traits based on the role.
    private var accessibilityTraits: AccessibilityTraits {
        switch role {
        case .largeTitle, .title1, .title2, .title3:
            return .isHeader
        default:
            return []
        }
    }
    
    // MARK: - Modifiers
    
    /// Overrides the text color from the role's default.
    ///
    /// Use this to change just the color while keeping the role's
    /// font size, weight, and other properties.
    ///
    /// ```swift
    /// DSText("Custom color", role: .body)
    ///     .dsTextColor(theme.colors.accent.primary)
    /// ```
    ///
    /// - Parameter color: The color to use instead of the role's default.
    /// - Returns: A new DSText with the color override applied.
    public func dsTextColor(_ color: Color) -> DSText {
        DSText(
            content: content,
            role: role,
            colorOverride: color,
            weightOverride: weightOverride
        )
    }
    
    /// Overrides the font weight from the role's default.
    ///
    /// Use this to change just the weight while keeping the role's
    /// font size, color, and other properties.
    ///
    /// ```swift
    /// DSText("Bold body text", role: .body)
    ///     .dsTextWeight(.bold)
    /// ```
    ///
    /// - Parameter weight: The weight to use instead of the role's default.
    /// - Returns: A new DSText with the weight override applied.
    public func dsTextWeight(_ weight: Font.Weight) -> DSText {
        DSText(
            content: content,
            role: role,
            colorOverride: colorOverride,
            weightOverride: weight
        )
    }
}

// MARK: - View Helper

private extension View {
    /// Conditionally applies a transform if a value is non-nil.
    @ViewBuilder
    func ifLet<T, Content: View>(_ value: T?, transform: (Self, T) -> Content) -> some View {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }
}

// MARK: - Previews

#Preview("System Roles - Light") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(DSTextRole.systemRoles) { role in
                DSText(role.displayName, role: role)
            }
        }
        .padding()
    }
    .dsTheme(.light)
}

#Preview("System Roles - Dark") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(DSTextRole.systemRoles) { role in
                DSText(role.displayName, role: role)
            }
        }
        .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Component Roles - Light") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(DSTextRole.componentRoles) { role in
                DSText(role.displayName, role: role)
            }
        }
        .padding()
    }
    .dsTheme(.light)
}

#Preview("Component Roles - Dark") {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(DSTextRole.componentRoles) { role in
                DSText(role.displayName, role: role)
            }
        }
        .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Overrides") {
    VStack(alignment: .leading, spacing: 16) {
        DSText("Default body text", role: .body)
        DSText("Custom color", role: .body)
            .dsTextColor(.blue)
        DSText("Bold headline", role: .headline)
            .dsTextWeight(.bold)
        DSText("Light title", role: .title2)
            .dsTextWeight(.light)
    }
    .padding()
    .dsTheme(.light)
}
