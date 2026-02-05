// DSForm.swift
// DesignSystem
//
// Form container with grouped sections, keyboard avoidance, and platform adaptation.
// Passes configuration to child rows via environment.

import SwiftUI
import DSCore
import DSTheme

// MARK: - DSForm

/// A themed form container with platform-adaptive layout and keyboard avoidance.
///
/// `DSForm` is the primary container for form content in the design system.
/// It manages layout configuration, keyboard avoidance on iOS, and passes
/// form settings to child rows via environment.
///
/// ## Overview
///
/// ```swift
/// DSForm {
///     DSFormSection("Account") {
///         DSTextField("Name", text: $name)
///         DSTextField("Email", text: $email)
///     }
///
///     DSFormSection("Preferences") {
///         DSToggle("Notifications", isOn: $notifications)
///         DSPicker("Theme", selection: $theme)
///     }
/// }
/// ```
///
/// ## Platform Behavior
///
/// | Platform | Default Layout | Keyboard Handling |
/// |----------|---------------|-------------------|
/// | iOS | inline | Keyboard avoidance |
/// | macOS | twoColumn | Tab navigation |
/// | watchOS | stacked | Crown navigation |
///
/// ## Configuration
///
/// Customize form behavior through ``DSFormConfiguration``:
///
/// ```swift
/// DSForm(configuration: .compact) {
///     // Compact-density form content
/// }
///
/// DSForm(configuration: DSFormConfiguration(
///     layoutMode: .fixed(.twoColumn),
///     validationDisplay: .inline
/// )) {
///     // Custom configuration
/// }
/// ```
///
/// ## Accessibility
///
/// - Form groups are announced as regions
/// - Validation errors are announced when they appear
/// - Keyboard navigation respects accessibility settings
/// - Dynamic Type supported throughout
///
/// ## Topics
///
/// ### Creating Forms
///
/// - ``init(configuration:content:)``
///
/// ### Configuration
///
/// - ``DSFormConfiguration``
/// - ``DSFormLayoutMode``
/// - ``DSFormValidationDisplayMode``
public struct DSForm<Content: View>: View {
    
    // MARK: - Properties
    
    /// The form configuration.
    private let configuration: DSFormConfiguration
    
    /// The form content.
    private let content: Content
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    @Environment(\.dsCapabilities) private var capabilities: DSCapabilities
    @Environment(\.dsDensity) private var environmentDensity: DSDensity
    
    // MARK: - Initialization
    
    /// Creates a form container with configuration.
    ///
    /// - Parameters:
    ///   - configuration: Form configuration. Defaults to ``DSFormConfiguration/default``.
    ///   - content: A view builder that creates the form content.
    public init(
        configuration: DSFormConfiguration = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.configuration = configuration
        self.content = content()
    }
    
    // MARK: - Computed Properties
    
    /// The effective density (configuration override or environment).
    private var effectiveDensity: DSDensity {
        configuration.density ?? environmentDensity
    }
    
    /// The resolved layout for form rows.
    private var resolvedLayout: DSFormRowLayout {
        switch configuration.layoutMode {
        case .auto:
            return capabilities.preferredFormRowLayout
        case .fixed(let layout):
            return layout
        }
    }
    
    // MARK: - Body
    
    public var body: some View {
        formContainer
            .environment(\.dsFormConfiguration, configuration)
            .environment(\.dsDensity, effectiveDensity)
            .environment(\.dsFormResolvedLayout, resolvedLayout)
    }
    
    // MARK: - Form Container
    
    @ViewBuilder
    private var formContainer: some View {
        if configuration.keyboardAvoidanceEnabled {
            keyboardAwareContainer
        } else {
            standardContainer
        }
    }
    
    /// Standard scrollable container without keyboard avoidance.
    @ViewBuilder
    private var standardContainer: some View {
        ScrollView {
            formContent
        }
        .scrollDismissesKeyboard(.interactively)
    }
    
    /// Container with keyboard avoidance support.
    @ViewBuilder
    private var keyboardAwareContainer: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    formContent
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
    }
    
    /// The main form content with proper styling.
    @ViewBuilder
    private var formContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(formPadding)
        .frame(maxWidth: formMaxWidth, alignment: .leading)
    }
    
    /// Padding based on density and layout.
    private var formPadding: EdgeInsets {
        let spacing = theme.spacing
        
        switch resolvedLayout {
        case .twoColumn:
            // More horizontal padding for two-column
            return EdgeInsets(
                top: spacing.padding.l,
                leading: spacing.padding.xl,
                bottom: spacing.padding.l,
                trailing: spacing.padding.xl
            )
        case .stacked:
            // Minimal horizontal padding for stacked (watchOS)
            return EdgeInsets(
                top: spacing.padding.m,
                leading: spacing.padding.s,
                bottom: spacing.padding.m,
                trailing: spacing.padding.s
            )
        case .inline:
            return spacing.insets.screen
        }
    }
    
    /// Maximum width for form content (constraints wide forms).
    private var formMaxWidth: CGFloat? {
        switch resolvedLayout {
        case .twoColumn:
            return 800 // Constrain two-column forms
        case .inline, .stacked:
            return nil // Full width
        }
    }
}

// MARK: - Resolved Layout Environment Key

/// Environment key for the resolved form row layout.
///
/// This is set by ``DSForm`` after resolving the layout mode
/// against platform capabilities.
public struct DSFormResolvedLayoutEnvironmentKey: EnvironmentKey {
    public static let defaultValue: DSFormRowLayout = .inline
}

extension EnvironmentValues {
    
    /// The resolved form row layout.
    ///
    /// Set by ``DSForm`` containers. Child rows use this to
    /// determine their layout.
    public var dsFormResolvedLayout: DSFormRowLayout {
        get { self[DSFormResolvedLayoutEnvironmentKey.self] }
        set { self[DSFormResolvedLayoutEnvironmentKey.self] = newValue }
    }
}

// MARK: - Convenience Initializers

extension DSForm {
    
    /// Creates a form with inline layout mode.
    ///
    /// ```swift
    /// DSForm.inline {
    ///     // Form content with inline layout
    /// }
    /// ```
    ///
    /// - Parameter content: The form content.
    /// - Returns: A form configured with inline layout.
    public static func inline(@ViewBuilder content: () -> Content) -> DSForm {
        DSForm(
            configuration: DSFormConfiguration(layoutMode: .fixed(.inline)),
            content: content
        )
    }
    
    /// Creates a form with stacked layout mode.
    ///
    /// ```swift
    /// DSForm.stacked {
    ///     // Form content with stacked layout
    /// }
    /// ```
    ///
    /// - Parameter content: The form content.
    /// - Returns: A form configured with stacked layout.
    public static func stacked(@ViewBuilder content: () -> Content) -> DSForm {
        DSForm(
            configuration: DSFormConfiguration(layoutMode: .fixed(.stacked)),
            content: content
        )
    }
    
    /// Creates a form with two-column layout mode.
    ///
    /// ```swift
    /// DSForm.twoColumn {
    ///     // Form content with two-column layout
    /// }
    /// ```
    ///
    /// - Parameter content: The form content.
    /// - Returns: A form configured with two-column layout.
    public static func twoColumn(@ViewBuilder content: () -> Content) -> DSForm {
        DSForm(
            configuration: .twoColumn,
            content: content
        )
    }
    
    /// Creates a form with settings-style configuration.
    ///
    /// ```swift
    /// DSForm.settings {
    ///     // Settings-style form content
    /// }
    /// ```
    ///
    /// - Parameter content: The form content.
    /// - Returns: A form configured for settings screens.
    public static func settings(@ViewBuilder content: () -> Content) -> DSForm {
        DSForm(
            configuration: .settings,
            content: content
        )
    }
}

// MARK: - Form Modifiers

extension DSForm {
    
    /// Sets the layout mode for this form.
    ///
    /// - Parameter mode: The layout mode to use.
    /// - Returns: A form with the specified layout mode.
    public func layoutMode(_ mode: DSFormLayoutMode) -> DSForm {
        DSForm(
            configuration: DSFormConfiguration(
                layoutMode: mode,
                validationDisplay: configuration.validationDisplay,
                density: configuration.density,
                keyboardAvoidanceEnabled: configuration.keyboardAvoidanceEnabled,
                showRowSeparators: configuration.showRowSeparators,
                animation: configuration.animation
            ),
            content: { content }
        )
    }
    
    /// Sets the validation display mode for this form.
    ///
    /// - Parameter mode: The validation display mode.
    /// - Returns: A form with the specified validation display.
    public func validationDisplay(_ mode: DSFormValidationDisplayMode) -> DSForm {
        DSForm(
            configuration: DSFormConfiguration(
                layoutMode: configuration.layoutMode,
                validationDisplay: mode,
                density: configuration.density,
                keyboardAvoidanceEnabled: configuration.keyboardAvoidanceEnabled,
                showRowSeparators: configuration.showRowSeparators,
                animation: configuration.animation
            ),
            content: { content }
        )
    }
    
    /// Sets the density for this form.
    ///
    /// - Parameter density: The density to use.
    /// - Returns: A form with the specified density.
    public func formDensity(_ density: DSDensity) -> DSForm {
        DSForm(
            configuration: DSFormConfiguration(
                layoutMode: configuration.layoutMode,
                validationDisplay: configuration.validationDisplay,
                density: density,
                keyboardAvoidanceEnabled: configuration.keyboardAvoidanceEnabled,
                showRowSeparators: configuration.showRowSeparators,
                animation: configuration.animation
            ),
            content: { content }
        )
    }
    
    /// Enables or disables keyboard avoidance.
    ///
    /// - Parameter enabled: Whether keyboard avoidance is enabled.
    /// - Returns: A form with the specified keyboard avoidance setting.
    public func keyboardAvoidance(_ enabled: Bool) -> DSForm {
        DSForm(
            configuration: DSFormConfiguration(
                layoutMode: configuration.layoutMode,
                validationDisplay: configuration.validationDisplay,
                density: configuration.density,
                keyboardAvoidanceEnabled: enabled,
                showRowSeparators: configuration.showRowSeparators,
                animation: configuration.animation
            ),
            content: { content }
        )
    }
    
    /// Shows or hides row separators.
    ///
    /// - Parameter show: Whether to show row separators.
    /// - Returns: A form with the specified separator visibility.
    public func showSeparators(_ show: Bool) -> DSForm {
        DSForm(
            configuration: DSFormConfiguration(
                layoutMode: configuration.layoutMode,
                validationDisplay: configuration.validationDisplay,
                density: configuration.density,
                keyboardAvoidanceEnabled: configuration.keyboardAvoidanceEnabled,
                showRowSeparators: show,
                animation: configuration.animation
            ),
            content: { content }
        )
    }
}

// MARK: - Previews

#Preview("Auto Layout - Light") {
    DSForm {
        Text("Form content goes here")
            .padding()
    }
    .dsTheme(.light)
}

#Preview("Auto Layout - Dark") {
    DSForm {
        Text("Form content goes here")
            .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Inline Layout") {
    DSForm.inline {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Label")
                Spacer()
                Text("Value")
                    .foregroundStyle(.secondary)
            }
            Divider()
            HStack {
                Text("Another Label")
                Spacer()
                Text("Another Value")
                    .foregroundStyle(.secondary)
            }
        }
    }
    .dsTheme(.light)
}

#Preview("Stacked Layout") {
    DSForm.stacked {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Label")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Value")
            }
            Divider()
            VStack(alignment: .leading, spacing: 4) {
                Text("Another Label")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Another Value")
            }
        }
    }
    .dsTheme(.light)
}

#Preview("Two-Column Layout") {
    DSForm.twoColumn {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                Text("Name:")
                    .frame(width: 140, alignment: .trailing)
                Text("John Doe")
                Spacer()
            }
            HStack(spacing: 24) {
                Text("Email:")
                    .frame(width: 140, alignment: .trailing)
                Text("john@example.com")
                Spacer()
            }
        }
    }
    .dsTheme(.light)
}

#Preview("Compact Density") {
    DSForm(configuration: .compact) {
        VStack(alignment: .leading, spacing: 8) {
            Text("Compact form with tighter spacing")
            Text("Good for information-dense UIs")
                .foregroundStyle(.secondary)
        }
    }
    .dsTheme(.light)
}

#if os(iOS)
#Preview("iOS Specific") {
    DSForm {
        VStack(alignment: .leading, spacing: 16) {
            Text("iOS Form")
                .font(.headline)
            Text("Inline layout with keyboard avoidance")
                .foregroundStyle(.secondary)
        }
    }
    .dsTheme(.light)
    .dsCapabilities(.iOS())
}
#endif

#if os(macOS)
#Preview("macOS Specific") {
    DSForm {
        VStack(alignment: .leading, spacing: 16) {
            Text("macOS Form")
                .font(.headline)
            Text("Two-column layout with focus ring support")
                .foregroundStyle(.secondary)
        }
    }
    .dsTheme(.light)
    .dsCapabilities(.macOS())
}
#endif

#if os(watchOS)
#Preview("watchOS Specific") {
    DSForm {
        VStack(alignment: .leading, spacing: 12) {
            Text("watchOS Form")
                .font(.headline)
            Text("Stacked layout")
                .foregroundStyle(.secondary)
        }
    }
    .dsTheme(.dark)
    .dsCapabilities(.watchOS())
}
#endif
