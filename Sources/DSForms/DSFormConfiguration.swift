// DSFormConfiguration.swift
// DesignSystem
//
// Configuration for form layout, validation display, and density.
// Passed through environment to child components.

import SwiftUI
import DSCore

// MARK: - Form Layout Mode

/// Layout mode for form rows within the form.
///
/// Determines how rows arrange label and control content.
/// Use `.auto` to let platform capabilities decide.
///
/// ## Platform Behavior
///
/// | Platform | Auto Layout |
/// |----------|-------------|
/// | iOS | ``DSFormRowLayout/inline`` |
/// | macOS | ``DSFormRowLayout/twoColumn`` |
/// | watchOS | ``DSFormRowLayout/stacked`` |
///
/// ## Usage
///
/// ```swift
/// DSForm {
///     // Form content
/// }
/// .formLayoutMode(.fixed(.twoColumn))
/// ```
///
/// ## Topics
///
/// ### Layout Options
///
/// - ``auto``
/// - ``fixed(_:)``
public enum DSFormLayoutMode: Sendable, Equatable, Hashable {
    
    /// Automatically select layout based on platform capabilities.
    ///
    /// Delegates to ``DSCapabilities/preferredFormRowLayout``.
    case auto
    
    /// Force a specific layout regardless of platform.
    ///
    /// - Parameter layout: The ``DSFormRowLayout`` to use.
    case fixed(DSFormRowLayout)
}

// MARK: - Validation Display Mode

/// How validation messages are displayed in forms.
///
/// Controls the visibility and positioning of validation
/// feedback within form rows.
///
/// ## Usage
///
/// ```swift
/// DSForm {
///     // Form content
/// }
/// .formValidationDisplay(.inline)
/// ```
///
/// ## Topics
///
/// ### Display Options
///
/// - ``inline``
/// - ``below``
/// - ``summary``
/// - ``hidden``
public enum DSFormValidationDisplayMode: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Show validation message inline with the control.
    ///
    /// Messages appear next to or within the control.
    /// Best for compact forms with few fields.
    case inline
    
    /// Show validation message below the row.
    ///
    /// Messages appear underneath the field chrome.
    /// Default mode for most forms.
    case below
    
    /// Collect all validation messages at the top.
    ///
    /// A summary banner shows all errors/warnings.
    /// Good for long forms with multiple issues.
    case summary
    
    /// Hide individual validation messages.
    ///
    /// Only border colors indicate state.
    /// Use with external validation display.
    case hidden
}

// MARK: - DSFormConfiguration

/// Configuration options for ``DSForm`` containers.
///
/// `DSFormConfiguration` encapsulates all form-level settings that
/// affect how child rows and sections behave. It's injected into
/// the environment and accessible by all form components.
///
/// ## Overview
///
/// The configuration controls:
/// - Row layout mode (auto/stacked/inline/twoColumn)
/// - Validation display mode
/// - Density override
/// - Keyboard avoidance behavior
/// - Separator visibility
///
/// ## Default Configuration
///
/// ```swift
/// let config = DSFormConfiguration.default
/// // layoutMode: .auto
/// // validationDisplay: .below
/// // density: nil (inherits from environment)
/// // keyboardAvoidanceEnabled: true
/// // showRowSeparators: true
/// ```
///
/// ## Custom Configuration
///
/// ```swift
/// let config = DSFormConfiguration(
///     layoutMode: .fixed(.twoColumn),
///     validationDisplay: .inline,
///     density: .compact,
///     keyboardAvoidanceEnabled: true,
///     showRowSeparators: false
/// )
///
/// DSForm(configuration: config) {
///     // Form content
/// }
/// ```
///
/// ## Topics
///
/// ### Configuration Properties
///
/// - ``layoutMode``
/// - ``validationDisplay``
/// - ``density``
/// - ``keyboardAvoidanceEnabled``
/// - ``showRowSeparators``
///
/// ### Presets
///
/// - ``default``
/// - ``compact``
/// - ``settings``
public struct DSFormConfiguration: Sendable, Equatable, Hashable {
    
    // MARK: - Properties
    
    /// The layout mode for form rows.
    ///
    /// When set to `.auto`, the form uses platform capabilities
    /// to determine the best layout. Use `.fixed()` to override.
    public let layoutMode: DSFormLayoutMode
    
    /// How validation messages are displayed.
    ///
    /// Controls where and how validation feedback appears.
    public let validationDisplay: DSFormValidationDisplayMode
    
    /// Optional density override for the form.
    ///
    /// When `nil`, inherits density from the environment.
    /// Set to override the form's spacing and sizing.
    public let density: DSDensity?
    
    /// Whether keyboard avoidance is enabled.
    ///
    /// When `true`, the form scrolls to keep focused fields
    /// visible above the keyboard (iOS only).
    public let keyboardAvoidanceEnabled: Bool
    
    /// Whether to show separators between rows.
    ///
    /// When `true`, thin separator lines appear between rows.
    public let showRowSeparators: Bool
    
    /// Animation to use for form state changes.
    ///
    /// Applied when validation states change or
    /// rows are added/removed.
    public let animation: Animation?
    
    // MARK: - Initialization
    
    /// Creates a form configuration with explicit values.
    ///
    /// - Parameters:
    ///   - layoutMode: Layout mode for rows. Defaults to `.auto`.
    ///   - validationDisplay: Validation display mode. Defaults to `.below`.
    ///   - density: Optional density override. Defaults to `nil`.
    ///   - keyboardAvoidanceEnabled: Enable keyboard avoidance. Defaults to `true`.
    ///   - showRowSeparators: Show row separators. Defaults to `true`.
    ///   - animation: Animation for changes. Defaults to `.default`.
    public init(
        layoutMode: DSFormLayoutMode = .auto,
        validationDisplay: DSFormValidationDisplayMode = .below,
        density: DSDensity? = nil,
        keyboardAvoidanceEnabled: Bool = true,
        showRowSeparators: Bool = true,
        animation: Animation? = .default
    ) {
        self.layoutMode = layoutMode
        self.validationDisplay = validationDisplay
        self.density = density
        self.keyboardAvoidanceEnabled = keyboardAvoidanceEnabled
        self.showRowSeparators = showRowSeparators
        self.animation = animation
    }
    
    // MARK: - Presets
    
    /// Default form configuration.
    ///
    /// Uses automatic layout, below validation display,
    /// inherited density, and keyboard avoidance enabled.
    public static let `default` = DSFormConfiguration()
    
    /// Compact form configuration.
    ///
    /// Uses compact density for information-dense forms.
    public static let compact = DSFormConfiguration(
        layoutMode: .auto,
        validationDisplay: .inline,
        density: .compact,
        keyboardAvoidanceEnabled: true,
        showRowSeparators: true
    )
    
    /// Settings-style form configuration.
    ///
    /// Optimized for settings screens with separators
    /// and inline layout on supporting platforms.
    public static let settings = DSFormConfiguration(
        layoutMode: .auto,
        validationDisplay: .below,
        density: nil,
        keyboardAvoidanceEnabled: true,
        showRowSeparators: true
    )
    
    /// Two-column form configuration.
    ///
    /// Forces two-column layout regardless of platform.
    /// Best for wide desktop forms.
    public static let twoColumn = DSFormConfiguration(
        layoutMode: .fixed(.twoColumn),
        validationDisplay: .below,
        density: nil,
        keyboardAvoidanceEnabled: true,
        showRowSeparators: false
    )
    
    /// Stacked form configuration.
    ///
    /// Forces stacked layout regardless of platform.
    /// Good for narrow screens or mobile forms.
    public static let stacked = DSFormConfiguration(
        layoutMode: .fixed(.stacked),
        validationDisplay: .below,
        density: nil,
        keyboardAvoidanceEnabled: true,
        showRowSeparators: true
    )
}

// MARK: - Environment Key

/// Environment key for form configuration.
///
/// Use this to access the current form configuration from child views.
///
/// ## Usage
///
/// ```swift
/// struct MyFormRow: View {
///     @Environment(\.dsFormConfiguration) private var config
///
///     var body: some View {
///         // Use config.layoutMode, config.validationDisplay, etc.
///     }
/// }
/// ```
public struct DSFormConfigurationEnvironmentKey: EnvironmentKey {
    public static let defaultValue: DSFormConfiguration = .default
}

extension EnvironmentValues {
    
    /// The current form configuration.
    ///
    /// Set by ``DSForm`` containers and accessible by child rows.
    public var dsFormConfiguration: DSFormConfiguration {
        get { self[DSFormConfigurationEnvironmentKey.self] }
        set { self[DSFormConfigurationEnvironmentKey.self] = newValue }
    }
}

// MARK: - View Modifiers

extension View {
    
    /// Sets the form configuration for this view hierarchy.
    ///
    /// ```swift
    /// DSForm {
    ///     // Form content
    /// }
    /// .dsFormConfiguration(.compact)
    /// ```
    ///
    /// - Parameter configuration: The configuration to apply.
    /// - Returns: A view with the form configuration set.
    public func dsFormConfiguration(_ configuration: DSFormConfiguration) -> some View {
        environment(\.dsFormConfiguration, configuration)
    }
}
