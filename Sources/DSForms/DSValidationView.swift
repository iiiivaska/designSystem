// DSValidationView.swift
// DesignSystem
//
// Standalone validation message display with icon and text.
// Supports error, warning, success states with themed styling.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSValidationView

/// A themed validation message display with icon and text.
///
/// `DSValidationView` renders a validation state as an icon + message
/// combination, using the design system's state colors and typography.
///
/// ## Overview
///
/// ```swift
/// DSValidationView(state: .error(message: "This field is required"))
///
/// DSValidationView(state: .warning(message: "Weak password"))
///
/// DSValidationView(state: .success(message: "Username available"))
/// ```
///
/// ## Appearance
///
/// Each validation severity maps to a specific icon and color:
///
/// | Severity | Icon | Color |
/// |----------|------|-------|
/// | Error | `xmark.circle.fill` | Danger (red) |
/// | Warning | `exclamationmark.triangle.fill` | Warning (yellow) |
/// | Success | `checkmark.circle.fill` | Success (green) |
///
/// ## Animation
///
/// The view animates its appearance using the theme's validation
/// animation. Set ``animated`` to `false` to disable transitions.
///
/// ## Styles
///
/// The ``DSValidationViewStyle`` enum controls the layout:
///
/// - ``DSValidationViewStyle/compact``: Icon + text inline (default)
/// - ``DSValidationViewStyle/banner``: Full-width block with background
///
/// ## Accessibility
///
/// The validation message is announced to VoiceOver with the severity
/// prefix (e.g., "Error: This field is required").
///
/// ## Topics
///
/// ### Creating a Validation View
///
/// - ``init(state:style:animated:)``
///
/// ### Styles
///
/// - ``DSValidationViewStyle``
public struct DSValidationView: View {
    
    // MARK: - Properties
    
    /// The current validation state to display.
    private let state: DSValidationState
    
    /// The visual style for the validation view.
    private let style: DSValidationViewStyle
    
    /// Whether the view animates its appearance.
    private let animated: Bool
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    
    // MARK: - Initializer
    
    /// Creates a validation view for the given state.
    ///
    /// - Parameters:
    ///   - state: The ``DSValidationState`` to display.
    ///   - style: The visual style. Defaults to ``DSValidationViewStyle/compact``.
    ///   - animated: Whether to animate appearance/disappearance. Defaults to `true`.
    public init(
        state: DSValidationState,
        style: DSValidationViewStyle = .compact,
        animated: Bool = true
    ) {
        self.state = state
        self.style = style
        self.animated = animated
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            if state.hasMessage || state.isValidating {
                content
                    .transition(transition)
            }
        }
        .animation(animated ? theme.motion.component.validationAppear : nil, value: state)
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var content: some View {
        switch style {
        case .compact:
            compactContent
        case .banner:
            bannerContent
        }
    }
    
    // MARK: - Compact Style
    
    private var compactContent: some View {
        HStack(spacing: theme.spacing.padding.xs) {
            iconView
            messageText
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }
    
    // MARK: - Banner Style
    
    private var bannerContent: some View {
        HStack(spacing: theme.spacing.padding.s) {
            iconView
            
            VStack(alignment: .leading, spacing: 2) {
                if let title = bannerTitle {
                    Text(title)
                        .font(theme.typography.component.helperText.font)
                        .fontWeight(.semibold)
                        .foregroundStyle(stateColor)
                }
                
                messageText
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, theme.spacing.padding.m)
        .padding(.vertical, theme.spacing.padding.s)
        .background(stateColor.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: theme.radii.scale.s))
        .overlay(
            RoundedRectangle(cornerRadius: theme.radii.scale.s)
                .strokeBorder(stateColor.opacity(0.2), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }
    
    // MARK: - Icon
    
    @ViewBuilder
    private var iconView: some View {
        if state.isValidating {
            ProgressView()
                .controlSize(.small)
        } else {
            let symbolName = state.severity.symbolName
            if !symbolName.isEmpty {
                Image(systemName: symbolName)
                    .font(.system(size: style == .banner ? 16 : 12))
                    .foregroundStyle(stateColor)
            }
        }
    }
    
    // MARK: - Message Text
    
    @ViewBuilder
    private var messageText: some View {
        if state.isValidating {
            Text("Validating…")
                .font(theme.typography.component.helperText.font)
                .foregroundStyle(theme.colors.fg.tertiary)
        } else if let message = state.message {
            Text(message)
                .font(theme.typography.component.helperText.font)
                .foregroundStyle(style == .banner ? stateColor : stateColor)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Helpers
    
    /// Resolves the color for the current validation severity.
    private var stateColor: Color {
        switch state.severity {
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
    
    /// Banner title for the severity.
    private var bannerTitle: String? {
        switch state.severity {
        case .error: return "Error"
        case .warning: return "Warning"
        case .success: return "Success"
        case .none: return nil
        }
    }
    
    /// Transition for appearance/disappearance.
    private var transition: AnyTransition {
        .opacity.combined(with: .move(edge: .top)).combined(with: .scale(scale: 0.95))
    }
    
    /// Accessibility label with severity prefix.
    private var accessibilityLabel: String {
        let prefix: String
        switch state.severity {
        case .error: prefix = "Error"
        case .warning: prefix = "Warning"
        case .success: prefix = "Success"
        case .none: prefix = ""
        }
        
        if state.isValidating {
            return "Validating"
        }
        
        let message = state.message ?? ""
        return prefix.isEmpty ? message : "\(prefix): \(message)"
    }
}

// MARK: - DSValidationViewStyle

/// Visual style for ``DSValidationView``.
///
/// ## Styles
///
/// | Style | Description |
/// |-------|-------------|
/// | ``compact`` | Icon + text inline (default) |
/// | ``banner`` | Full-width block with tinted background |
public enum DSValidationViewStyle: String, Sendable, Equatable, CaseIterable {
    
    /// Compact inline display with icon and message text.
    ///
    /// Best for field-level validation beneath individual inputs.
    case compact
    
    /// Full-width banner with tinted background and border.
    ///
    /// Best for form-level validation summaries or prominent warnings.
    case banner
}

// MARK: - Previews

#Preview("Compact States - Light") {
    VStack(alignment: .leading, spacing: 16) {
        DSValidationView(state: .error(message: "This field is required"))
        DSValidationView(state: .warning(message: "Password is weak"))
        DSValidationView(state: .success(message: "Username available"))
        DSValidationView(state: .validating)
        DSValidationView(state: .none)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Compact States - Dark") {
    VStack(alignment: .leading, spacing: 16) {
        DSValidationView(state: .error(message: "This field is required"))
        DSValidationView(state: .warning(message: "Password is weak"))
        DSValidationView(state: .success(message: "Username available"))
        DSValidationView(state: .validating)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Banner States - Light") {
    VStack(spacing: 12) {
        DSValidationView(
            state: .error(message: "Please fix the errors below before submitting."),
            style: .banner
        )
        DSValidationView(
            state: .warning(message: "Your session will expire in 5 minutes."),
            style: .banner
        )
        DSValidationView(
            state: .success(message: "All fields are valid. Ready to submit."),
            style: .banner
        )
        DSValidationView(
            state: .validating,
            style: .banner
        )
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Banner States - Dark") {
    VStack(spacing: 12) {
        DSValidationView(
            state: .error(message: "Please fix the errors below before submitting."),
            style: .banner
        )
        DSValidationView(
            state: .warning(message: "Your session will expire in 5 minutes."),
            style: .banner
        )
        DSValidationView(
            state: .success(message: "All fields are valid. Ready to submit."),
            style: .banner
        )
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Long Messages") {
    VStack(alignment: .leading, spacing: 16) {
        DSValidationView(
            state: .error(message: "The email address you entered is not valid. Please check the format and try again.")
        )
        DSValidationView(
            state: .error(message: "The email address you entered is not valid. Please check the format and try again."),
            style: .banner
        )
    }
    .padding()
    .frame(maxWidth: 320)
    .dsTheme(.light)
}

#if os(watchOS)
#Preview("watchOS") {
    ScrollView {
        VStack(alignment: .leading, spacing: 8) {
            DSValidationView(state: .error(message: "Required field"))
            DSValidationView(state: .warning(message: "Weak password"))
            DSValidationView(state: .success(message: "Looks good"))
        }
    }
    .dsTheme(.dark)
}
#endif
