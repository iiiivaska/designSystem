// DSIcon.swift
// DesignSystem
//
// SF Symbols wrapper with theme integration.
// Uses only system SF Symbols — no custom icon assets.

import SwiftUI
import DSCore
import DSTheme

// MARK: - DSIconColor

/// Color mode for ``DSIcon``.
///
/// Determines how the icon color is resolved from the theme.
///
/// ## Usage
///
/// ```swift
/// // Use theme semantic role
/// DSIcon("star.fill", color: .accent)
///
/// // Use custom color
/// DSIcon("star.fill", color: .custom(.red))
/// ```
///
/// ## Topics
///
/// ### Semantic Colors
///
/// - ``primary``
/// - ``secondary``
/// - ``tertiary``
/// - ``disabled``
/// - ``accent``
/// - ``success``
/// - ``warning``
/// - ``danger``
/// - ``info``
///
/// ### Custom
///
/// - ``custom(_:)``
public enum DSIconColor: Sendable, Equatable {
    
    /// Primary foreground color from theme.
    case primary
    
    /// Secondary foreground color from theme.
    case secondary
    
    /// Tertiary foreground color from theme.
    case tertiary
    
    /// Disabled foreground color from theme.
    case disabled
    
    /// Primary accent color from theme.
    case accent
    
    /// Success state color from theme.
    case success
    
    /// Warning state color from theme.
    case warning
    
    /// Danger state color from theme.
    case danger
    
    /// Info state color from theme.
    case info
    
    /// A custom color override.
    ///
    /// - Parameter color: The specific color to use.
    case custom(Color)
    
    /// Resolves this color mode to a concrete `Color` using the theme.
    ///
    /// - Parameter theme: The current theme.
    /// - Returns: The resolved color.
    public func resolve(from theme: DSTheme) -> Color {
        switch self {
        case .primary: return theme.colors.fg.primary
        case .secondary: return theme.colors.fg.secondary
        case .tertiary: return theme.colors.fg.tertiary
        case .disabled: return theme.colors.fg.disabled
        case .accent: return theme.colors.accent.primary
        case .success: return theme.colors.state.success
        case .warning: return theme.colors.state.warning
        case .danger: return theme.colors.state.danger
        case .info: return theme.colors.state.info
        case .custom(let color): return color
        }
    }
}

// MARK: - DSIcon

/// An SF Symbols icon wrapper with theme integration.
///
/// `DSIcon` renders SF Symbols with consistent sizing and coloring
/// from the design system theme. It is the only icon component in the
/// design system — no custom icon assets are used in v0.
///
/// ## Overview
///
/// ```swift
/// // Basic usage with default size and color
/// DSIcon("star.fill")
///
/// // With size
/// DSIcon("chevron.right", size: .small)
///
/// // With semantic color
/// DSIcon("checkmark.circle.fill", size: .large, color: .success)
///
/// // Using icon tokens
/// DSIcon(DSIconToken.Navigation.chevronRight, size: .small, color: .secondary)
/// ```
///
/// ## Sizes
///
/// | Size | Points |
/// |------|--------|
/// | ``DSIconSize/small`` | 16pt |
/// | ``DSIconSize/medium`` | 20pt |
/// | ``DSIconSize/large`` | 24pt |
/// | ``DSIconSize/xl`` | 32pt |
///
/// ## Colors
///
/// Colors resolve from the theme's semantic roles:
///
/// ```swift
/// DSIcon("star", color: .primary)    // Theme fg.primary
/// DSIcon("star", color: .accent)     // Theme accent.primary
/// DSIcon("star", color: .danger)     // Theme state.danger
/// DSIcon("star", color: .custom(.purple)) // Custom color
/// ```
///
/// ## Accessibility
///
/// - Accessibility labels are automatically derived from the SF Symbol name
/// - Use ``dsIconAccessibilityLabel(_:)`` to provide a custom label
/// - Decorative icons can be hidden with ``dsIconAccessibilityHidden()``
///
/// ## Topics
///
/// ### Creating Icons
///
/// - ``init(_:size:color:)``
///
/// ### Sizing
///
/// - ``DSIconSize``
///
/// ### Coloring
///
/// - ``DSIconColor``
///
/// ### Icon Tokens
///
/// - ``DSIconToken``
///
/// ### Modifiers
///
/// - ``dsIconAccessibilityLabel(_:)``
/// - ``dsIconAccessibilityHidden()``
public struct DSIcon: View {
    
    // MARK: - Properties
    
    /// The SF Symbol name.
    private let symbolName: String
    
    /// The icon size.
    private let size: DSIconSize
    
    /// The icon color mode.
    private let color: DSIconColor
    
    /// Optional custom accessibility label override.
    private var accessibilityLabelOverride: String?
    
    /// Whether the icon is purely decorative (hidden from accessibility).
    private var isAccessibilityHidden: Bool = false
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    
    // MARK: - Initializer
    
    /// Creates a design system icon from an SF Symbol name.
    ///
    /// - Parameters:
    ///   - symbolName: The SF Symbol name (e.g., `"star.fill"`, `"chevron.right"`).
    ///   - size: The icon size. Defaults to ``DSIconSize/medium``.
    ///   - color: The icon color mode. Defaults to ``DSIconColor/primary``.
    public init(
        _ symbolName: String,
        size: DSIconSize = .medium,
        color: DSIconColor = .primary
    ) {
        self.symbolName = symbolName
        self.size = size
        self.color = color
    }
    
    // MARK: - Private Init for Modifiers
    
    private init(
        symbolName: String,
        size: DSIconSize,
        color: DSIconColor,
        accessibilityLabelOverride: String?,
        isAccessibilityHidden: Bool
    ) {
        self.symbolName = symbolName
        self.size = size
        self.color = color
        self.accessibilityLabelOverride = accessibilityLabelOverride
        self.isAccessibilityHidden = isAccessibilityHidden
    }
    
    // MARK: - Body
    
    public var body: some View {
        Image(systemName: symbolName)
            .font(size.font)
            .foregroundStyle(color.resolve(from: theme))
            .frame(width: size.points, height: size.points)
            .accessibilityLabel(resolvedAccessibilityLabel)
            .accessibilityHidden(isAccessibilityHidden)
    }
    
    // MARK: - Accessibility
    
    /// Resolves the accessibility label for VoiceOver.
    private var resolvedAccessibilityLabel: Text {
        if let override = accessibilityLabelOverride {
            return Text(override)
        }
        // Derive a readable label from the symbol name
        let label = symbolName
            .replacingOccurrences(of: ".fill", with: "")
            .replacingOccurrences(of: ".circle", with: "")
            .replacingOccurrences(of: ".", with: " ")
        return Text(label)
    }
    
    // MARK: - Modifiers
    
    /// Sets a custom accessibility label for VoiceOver.
    ///
    /// Use this to provide a more descriptive label than the
    /// automatically derived one from the symbol name.
    ///
    /// ```swift
    /// DSIcon("star.fill", color: .accent)
    ///     .dsIconAccessibilityLabel("Favorite")
    /// ```
    ///
    /// - Parameter label: The accessibility label text.
    /// - Returns: A new DSIcon with the label applied.
    public func dsIconAccessibilityLabel(_ label: String) -> DSIcon {
        DSIcon(
            symbolName: symbolName,
            size: size,
            color: color,
            accessibilityLabelOverride: label,
            isAccessibilityHidden: false
        )
    }
    
    /// Hides the icon from accessibility (decorative icon).
    ///
    /// Use this for purely decorative icons that don't convey
    /// information to VoiceOver users.
    ///
    /// ```swift
    /// DSIcon("circle.fill", size: .small, color: .tertiary)
    ///     .dsIconAccessibilityHidden()
    /// ```
    ///
    /// - Returns: A new DSIcon hidden from accessibility.
    public func dsIconAccessibilityHidden() -> DSIcon {
        DSIcon(
            symbolName: symbolName,
            size: size,
            color: color,
            accessibilityLabelOverride: accessibilityLabelOverride,
            isAccessibilityHidden: true
        )
    }
}

// MARK: - Previews

#Preview("Sizes - Light") {
    HStack(spacing: 24) {
        ForEach(DSIconSize.allCases) { size in
            VStack(spacing: 8) {
                DSIcon("star.fill", size: size, color: .accent)
                Text(size.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Sizes - Dark") {
    HStack(spacing: 24) {
        ForEach(DSIconSize.allCases) { size in
            VStack(spacing: 8) {
                DSIcon("star.fill", size: size, color: .accent)
                Text(size.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Colors - Light") {
    let colors: [(String, DSIconColor)] = [
        ("Primary", .primary),
        ("Secondary", .secondary),
        ("Tertiary", .tertiary),
        ("Disabled", .disabled),
        ("Accent", .accent),
        ("Success", .success),
        ("Warning", .warning),
        ("Danger", .danger),
        ("Info", .info),
    ]
    
    VStack(spacing: 12) {
        ForEach(colors, id: \.0) { name, color in
            HStack {
                DSIcon("star.fill", size: .medium, color: color)
                Text(name)
                    .font(.body)
                Spacer()
            }
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Colors - Dark") {
    let colors: [(String, DSIconColor)] = [
        ("Primary", .primary),
        ("Secondary", .secondary),
        ("Tertiary", .tertiary),
        ("Disabled", .disabled),
        ("Accent", .accent),
        ("Success", .success),
        ("Warning", .warning),
        ("Danger", .danger),
        ("Info", .info),
    ]
    
    VStack(spacing: 12) {
        ForEach(colors, id: \.0) { name, color in
            HStack {
                DSIcon("star.fill", size: .medium, color: color)
                Text(name)
                    .font(.body)
                Spacer()
            }
        }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Icon Tokens") {
    VStack(alignment: .leading, spacing: 16) {
        Group {
            Text("Navigation").font(.headline)
            HStack(spacing: 16) {
                DSIcon(DSIconToken.Navigation.chevronRight, size: .small)
                DSIcon(DSIconToken.Navigation.chevronLeft, size: .small)
                DSIcon(DSIconToken.Navigation.chevronDown, size: .small)
                DSIcon(DSIconToken.Navigation.externalLink, size: .small)
            }
        }
        Group {
            Text("Actions").font(.headline)
            HStack(spacing: 16) {
                DSIcon(DSIconToken.Action.plus, size: .medium, color: .accent)
                DSIcon(DSIconToken.Action.edit, size: .medium, color: .accent)
                DSIcon(DSIconToken.Action.delete, size: .medium, color: .danger)
                DSIcon(DSIconToken.Action.share, size: .medium, color: .accent)
            }
        }
        Group {
            Text("State").font(.headline)
            HStack(spacing: 16) {
                DSIcon(DSIconToken.State.checkmarkCircle, size: .large, color: .success)
                DSIcon(DSIconToken.State.warning, size: .large, color: .warning)
                DSIcon(DSIconToken.State.error, size: .large, color: .danger)
                DSIcon(DSIconToken.State.info, size: .large, color: .info)
            }
        }
    }
    .padding()
    .dsTheme(.light)
}
