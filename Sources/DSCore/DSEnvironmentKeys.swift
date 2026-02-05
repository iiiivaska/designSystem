import SwiftUI

// MARK: - Theme Environment Key

/// Environment key for the Design System theme.
///
/// Use this key to access the current theme from any view in the hierarchy.
///
/// ## Usage
///
/// ```swift
/// struct MyView: View {
///     @Environment(\.dsTheme) private var theme
///
///     var body: some View {
///         Text("Hello")
///             .foregroundStyle(theme?.isDark == true ? .white : .black)
///     }
/// }
/// ```
///
/// - SeeAlso: ``DSThemeProtocol``
public struct DSThemeEnvironmentKey: EnvironmentKey {
    public static let defaultValue: DSThemeProtocol? = nil
}

extension EnvironmentValues {
    /// The current Design System theme.
    ///
    /// Returns `nil` if no theme has been set in the environment.
    /// Use the `.dsTheme(_:)` modifier in DSTheme module to inject a theme.
    public var dsTheme: DSThemeProtocol? {
        get { self[DSThemeEnvironmentKey.self] }
        set { self[DSThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - DSThemeProtocol

/// Protocol that defines the theme contract.
///
/// `DSThemeProtocol` is defined in DSCore to allow environment key declaration
/// without circular dependencies. The actual implementation lives in the DSTheme module.
///
/// ## Conforming to DSThemeProtocol
///
/// ```swift
/// struct MyTheme: DSThemeProtocol {
///     let id = "my-theme"
///     let displayName = "My Theme"
///     let isDark = false
/// }
/// ```
///
/// ## Topics
///
/// ### Identification
///
/// - ``id``
/// - ``displayName``
///
/// ### Theme Properties
///
/// - ``isDark``
public protocol DSThemeProtocol: Sendable {
    
    /// The theme's unique identifier.
    ///
    /// Use this to persist or compare theme selections.
    var id: String { get }
    
    /// The theme's display name for UI.
    ///
    /// Shown in theme pickers and settings screens.
    var displayName: String { get }
    
    /// Whether this is a dark theme variant.
    ///
    /// Components use this to determine appropriate contrast ratios
    /// and accent color treatment.
    var isDark: Bool { get }
}

// MARK: - Capabilities Environment Key

/// Environment key for platform capabilities.
///
/// Use this key to access platform-specific capabilities and adapt
/// UI behavior accordingly.
///
/// ## Usage
///
/// ```swift
/// struct MyButton: View {
///     @Environment(\.dsCapabilities) private var capabilities
///
///     var body: some View {
///         Button("Tap") { }
///             .onHover { hovering in
///                 guard capabilities.supportsHover else { return }
///                 // Handle hover state
///             }
///     }
/// }
/// ```
///
/// ## Default Behavior
///
/// The default value is automatically determined by the current platform
/// using ``DSCapabilities/platformDefault``. You don't need to explicitly
/// set capabilities in most cases.
///
/// ## Custom Capabilities
///
/// To override capabilities (for testing or previews), use the
/// ``SwiftUICore/View/dsCapabilities(_:)`` modifier:
///
/// ```swift
/// MyView()
///     .dsCapabilities(.watchOS())
/// ```
///
/// - SeeAlso: ``DSCapabilities``
/// - SeeAlso: ``DSCapabilitiesProtocol``
public struct DSCapabilitiesEnvironmentKey: EnvironmentKey {
    public static let defaultValue: DSCapabilities = .platformDefault
}

extension EnvironmentValues {
    /// The current platform capabilities.
    ///
    /// Defaults to ``DSCapabilities/platformDefault`` which provides
    /// appropriate capabilities for the current platform.
    ///
    /// ## Example
    ///
    /// ```swift
    /// struct AdaptiveRow: View {
    ///     @Environment(\.dsCapabilities) private var capabilities
    ///
    ///     var body: some View {
    ///         if capabilities.preferredFormRowLayout == .stacked {
    ///             VStack { rowContent }
    ///         } else {
    ///             HStack { rowContent }
    ///         }
    ///     }
    /// }
    /// ```
    public var dsCapabilities: DSCapabilities {
        get { self[DSCapabilitiesEnvironmentKey.self] }
        set { self[DSCapabilitiesEnvironmentKey.self] = newValue }
    }
}

// MARK: - DSCapabilitiesProtocol

/// Protocol that defines the platform capabilities contract.
///
/// `DSCapabilitiesProtocol` abstracts platform differences, allowing
/// components to query capabilities rather than checking `#if os(...)`.
///
/// ## Overview
///
/// Different platforms have different interaction capabilities:
///
/// | Capability | iOS | macOS | watchOS |
/// |------------|-----|-------|---------|
/// | Hover | No | Yes | No |
/// | Focus Ring | No | Yes | No |
/// | Inline Text | Yes | Yes | No |
/// | Inline Pickers | Yes | Yes | No |
/// | Toasts | Yes | Yes | No |
/// | Large Targets | Yes | No | Yes |
///
/// ## Layout Preferences
///
/// | Preference | iOS | macOS | watchOS |
/// |------------|-----|-------|---------|
/// | Form Row Layout | inline | twoColumn | stacked |
/// | Picker Presentation | sheet | menu | navigation |
/// | Text Field Mode | inline | inline | separateScreen |
///
/// ## Conformance
///
/// The concrete ``DSCapabilities`` struct conforms to this protocol
/// and provides factory methods for platform-specific defaults.
///
/// ## Topics
///
/// ### Interaction Capabilities
///
/// - ``supportsHover``
/// - ``supportsFocusRing``
///
/// ### Input Capabilities
///
/// - ``supportsInlineTextEditing``
/// - ``supportsInlinePickers``
/// - ``supportsToasts``
///
/// ### Layout Preferences
///
/// - ``prefersLargeTapTargets``
/// - ``preferredFormRowLayout``
/// - ``preferredPickerPresentation``
/// - ``preferredTextFieldMode``
public protocol DSCapabilitiesProtocol: Sendable {
    
    // MARK: - Interaction Capabilities
    
    /// Whether the platform supports hover states.
    ///
    /// `true` on macOS and iPadOS with pointer, `false` on iOS/watchOS.
    var supportsHover: Bool { get }
    
    /// Whether the platform supports focus rings.
    ///
    /// `true` on macOS, `false` on iOS/watchOS.
    var supportsFocusRing: Bool { get }
    
    // MARK: - Input Capabilities
    
    /// Whether the platform supports inline text editing.
    ///
    /// `false` on watchOS where text entry opens a separate screen.
    var supportsInlineTextEditing: Bool { get }
    
    /// Whether the platform supports inline pickers.
    ///
    /// `false` on watchOS where pickers use navigation.
    var supportsInlinePickers: Bool { get }
    
    /// Whether the platform supports toast notifications.
    ///
    /// `false` on watchOS where screen space is limited.
    var supportsToasts: Bool { get }
    
    // MARK: - Layout Preferences
    
    /// Whether the platform prefers large tap targets.
    ///
    /// `true` on iOS and watchOS, `false` on macOS.
    var prefersLargeTapTargets: Bool { get }
    
    /// The preferred layout for form rows.
    ///
    /// Returns ``DSFormRowLayout/inline`` on iOS,
    /// ``DSFormRowLayout/twoColumn`` on macOS,
    /// and ``DSFormRowLayout/stacked`` on watchOS.
    var preferredFormRowLayout: DSFormRowLayout { get }
    
    /// The preferred presentation for pickers.
    ///
    /// Returns ``DSPickerPresentation/sheet`` on iOS,
    /// ``DSPickerPresentation/menu`` on macOS,
    /// and ``DSPickerPresentation/navigation`` on watchOS.
    var preferredPickerPresentation: DSPickerPresentation { get }
    
    /// The preferred mode for text field editing.
    ///
    /// Returns ``DSTextFieldMode/inline`` on iOS/macOS,
    /// and ``DSTextFieldMode/separateScreen`` on watchOS.
    var preferredTextFieldMode: DSTextFieldMode { get }
}

// MARK: - Accessibility Policy Environment Key

/// Environment key for accessibility policy.
///
/// Use this key to access accessibility settings that affect UI rendering.
///
/// ## Usage
///
/// ```swift
/// struct AnimatedView: View {
///     @Environment(\.dsAccessibilityPolicy) private var accessibility
///
///     var body: some View {
///         Text("Hello")
///             .animation(
///                 accessibility.reduceMotion ? nil : .default,
///                 value: someValue
///             )
///     }
/// }
/// ```
///
/// - SeeAlso: ``DSAccessibilityPolicy``
public struct DSAccessibilityPolicyEnvironmentKey: EnvironmentKey {
    public static let defaultValue: DSAccessibilityPolicy = .default
}

extension EnvironmentValues {
    /// The current accessibility policy.
    ///
    /// Defaults to ``DSAccessibilityPolicy/default`` if not set.
    public var dsAccessibilityPolicy: DSAccessibilityPolicy {
        get { self[DSAccessibilityPolicyEnvironmentKey.self] }
        set { self[DSAccessibilityPolicyEnvironmentKey.self] = newValue }
    }
}

// MARK: - Input Context Environment Key

/// Environment key for input context.
///
/// Use this key to access the current input mode and adapt
/// control behavior accordingly.
///
/// ## Usage
///
/// ```swift
/// struct MyControl: View {
///     @Environment(\.dsInputContext) private var inputContext
///
///     var body: some View {
///         let minSize = inputContext.primaryMode.minimumTapTargetSize
///         // Use minSize for hit testing area
///     }
/// }
/// ```
///
/// - SeeAlso: ``DSInputContext``
public struct DSInputContextEnvironmentKey: EnvironmentKey {
    public static let defaultValue: DSInputContext = .platformDefault
}

extension EnvironmentValues {
    /// The current input context.
    ///
    /// Defaults to ``DSInputContext/platformDefault`` if not set.
    public var dsInputContext: DSInputContext {
        get { self[DSInputContextEnvironmentKey.self] }
        set { self[DSInputContextEnvironmentKey.self] = newValue }
    }
}

// MARK: - Density Environment Key

/// Environment key for UI density.
///
/// Use this key to access the current density preference and
/// adjust spacing/sizing accordingly.
///
/// ## Usage
///
/// ```swift
/// struct MyRow: View {
///     @Environment(\.dsDensity) private var density
///
///     var body: some View {
///         HStack(spacing: 8 * density.spacingMultiplier) {
///             // Row content
///         }
///     }
/// }
/// ```
///
/// - SeeAlso: ``DSDensity``
public struct DSDensityEnvironmentKey: EnvironmentKey {
    public static let defaultValue: DSDensity = .regular
}

extension EnvironmentValues {
    /// The current UI density.
    ///
    /// Defaults to ``DSDensity/regular`` if not set.
    public var dsDensity: DSDensity {
        get { self[DSDensityEnvironmentKey.self] }
        set { self[DSDensityEnvironmentKey.self] = newValue }
    }
}

// MARK: - DSDensity

/// UI density preference for controls and spacing.
///
/// `DSDensity` allows the design system to adapt layout density based
/// on user preference, screen size, or platform conventions.
///
/// ## Overview
///
/// | Density | Spacing | Control Height |
/// |---------|---------|----------------|
/// | ``compact`` | 0.75x | 0.85x |
/// | ``regular`` | 1.0x | 1.0x |
/// | ``spacious`` | 1.25x | 1.15x |
///
/// ## Usage
///
/// ```swift
/// VStack(spacing: baseSpacing * density.spacingMultiplier) {
///     // Content
/// }
/// .frame(height: baseHeight * density.controlHeightMultiplier)
/// ```
///
/// ## Topics
///
/// ### Density Levels
///
/// - ``compact``
/// - ``regular``
/// - ``spacious``
///
/// ### Multipliers
///
/// - ``spacingMultiplier``
/// - ``controlHeightMultiplier``
public enum DSDensity: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Compact density with reduced spacing.
    ///
    /// Use for information-dense UIs like tables and lists with many items.
    case compact
    
    /// Regular/default density.
    ///
    /// The baseline density appropriate for most interfaces.
    case regular
    
    /// Spacious density with increased spacing.
    ///
    /// Use for touch-friendly interfaces or improved readability.
    case spacious
    
    /// Spacing multiplier relative to regular (1.0).
    ///
    /// | Density | Multiplier |
    /// |---------|------------|
    /// | ``compact`` | 0.75 |
    /// | ``regular`` | 1.0 |
    /// | ``spacious`` | 1.25 |
    public var spacingMultiplier: CGFloat {
        switch self {
        case .compact: return 0.75
        case .regular: return 1.0
        case .spacious: return 1.25
        }
    }
    
    /// Height multiplier for controls relative to regular (1.0).
    ///
    /// | Density | Multiplier |
    /// |---------|------------|
    /// | ``compact`` | 0.85 |
    /// | ``regular`` | 1.0 |
    /// | ``spacious`` | 1.15 |
    public var controlHeightMultiplier: CGFloat {
        switch self {
        case .compact: return 0.85
        case .regular: return 1.0
        case .spacious: return 1.15
        }
    }
}

// MARK: - Animation Context Environment Key

/// Environment key for animation context.
///
/// Use this key to access animation settings that respect accessibility
/// preferences like Reduce Motion.
///
/// ## Usage
///
/// ```swift
/// struct MyAnimatedView: View {
///     @Environment(\.dsAnimationContext) private var animationContext
///
///     var body: some View {
///         content
///             .animation(
///                 animationContext.animationsEnabled
///                     ? .spring(response: animationContext.springResponse)
///                     : nil,
///                 value: state
///             )
///     }
/// }
/// ```
///
/// - SeeAlso: ``DSAnimationContext``
public struct DSAnimationContextEnvironmentKey: EnvironmentKey {
    public static let defaultValue: DSAnimationContext = .standard
}

extension EnvironmentValues {
    /// The current animation context.
    ///
    /// Defaults to ``DSAnimationContext/standard`` if not set.
    public var dsAnimationContext: DSAnimationContext {
        get { self[DSAnimationContextEnvironmentKey.self] }
        set { self[DSAnimationContextEnvironmentKey.self] = newValue }
    }
}

// MARK: - DSAnimationContext

/// Context for animations considering accessibility and preferences.
///
/// `DSAnimationContext` encapsulates animation settings and automatically
/// respects the Reduce Motion accessibility preference.
///
/// ## Usage
///
/// ```swift
/// let context = DSAnimationContext.from(accessibilityPolicy: accessibility)
///
/// if context.animationsEnabled {
///     withAnimation(.spring(response: context.springResponse)) {
///         // Animate
///     }
/// } else {
///     // No animation
/// }
/// ```
///
/// ## Topics
///
/// ### Properties
///
/// - ``animationsEnabled``
/// - ``defaultDuration``
/// - ``springResponse``
///
/// ### Presets
///
/// - ``standard``
/// - ``reducedMotion``
///
/// ### Factory Methods
///
/// - ``from(accessibilityPolicy:)``
public struct DSAnimationContext: Sendable, Equatable {
    
    /// Whether animations should be enabled.
    ///
    /// When `false`, components should skip animations entirely
    /// rather than using instant transitions.
    public let animationsEnabled: Bool
    
    /// The default animation duration in seconds.
    ///
    /// Standard value is 0.25 seconds. Set to 0 for reduced motion.
    public let defaultDuration: TimeInterval
    
    /// The spring response for interactive animations.
    ///
    /// Standard value is 0.35. Set to 0 for reduced motion.
    public let springResponse: Double
    
    /// Creates a new animation context.
    ///
    /// - Parameters:
    ///   - animationsEnabled: Whether animations are enabled. Defaults to `true`.
    ///   - defaultDuration: Default animation duration. Defaults to `0.25`.
    ///   - springResponse: Spring response value. Defaults to `0.35`.
    public init(
        animationsEnabled: Bool = true,
        defaultDuration: TimeInterval = 0.25,
        springResponse: Double = 0.35
    ) {
        self.animationsEnabled = animationsEnabled
        self.defaultDuration = defaultDuration
        self.springResponse = springResponse
    }
    
    /// Standard animation context with default values.
    public static let standard = DSAnimationContext()
    
    /// Reduced motion animation context with animations disabled.
    public static let reducedMotion = DSAnimationContext(
        animationsEnabled: false,
        defaultDuration: 0.0,
        springResponse: 0.0
    )
    
    /// Creates a context from accessibility policy.
    ///
    /// Returns ``reducedMotion`` if ``DSAccessibilityPolicy/reduceMotion``
    /// is `true`, otherwise returns ``standard``.
    ///
    /// - Parameter accessibilityPolicy: The accessibility policy to check.
    /// - Returns: An appropriate ``DSAnimationContext``.
    public static func from(accessibilityPolicy: DSAccessibilityPolicy) -> DSAnimationContext {
        if accessibilityPolicy.reduceMotion {
            return .reducedMotion
        }
        return .standard
    }
}

// MARK: - View Modifiers

extension View {
    
    /// Sets the platform capabilities for this view hierarchy.
    ///
    /// Use this modifier to override the default platform capabilities,
    /// which is useful for testing or creating previews that simulate
    /// different platforms.
    ///
    /// ```swift
    /// // Simulate watchOS behavior on iOS
    /// MyView()
    ///     .dsCapabilities(.watchOS())
    ///
    /// // Enable pointer interaction on iOS
    /// MyView()
    ///     .dsCapabilities(.iOSWithPointer())
    /// ```
    ///
    /// - Parameter capabilities: The ``DSCapabilities`` to apply.
    /// - Returns: A view with the capabilities set in its environment.
    public func dsCapabilities(_ capabilities: DSCapabilities) -> some View {
        environment(\.dsCapabilities, capabilities)
    }
    
    /// Sets the Design System density for this view hierarchy.
    ///
    /// ```swift
    /// Form {
    ///     // Form content
    /// }
    /// .dsDensity(.compact)
    /// ```
    ///
    /// - Parameter density: The ``DSDensity`` to apply.
    /// - Returns: A view with the density set in its environment.
    public func dsDensity(_ density: DSDensity) -> some View {
        environment(\.dsDensity, density)
    }
    
    /// Sets the accessibility policy for this view hierarchy.
    ///
    /// ```swift
    /// ContentView()
    ///     .dsAccessibilityPolicy(DSAccessibilityPolicy(
    ///         reduceMotion: true,
    ///         dynamicTypeSize: .accessibilityLarge
    ///     ))
    /// ```
    ///
    /// - Parameter policy: The ``DSAccessibilityPolicy`` to apply.
    /// - Returns: A view with the accessibility policy set in its environment.
    public func dsAccessibilityPolicy(_ policy: DSAccessibilityPolicy) -> some View {
        environment(\.dsAccessibilityPolicy, policy)
    }
    
    /// Sets the input context for this view hierarchy.
    ///
    /// ```swift
    /// ContentView()
    ///     .dsInputContext(DSInputContext(primaryMode: .keyboard))
    /// ```
    ///
    /// - Parameter context: The ``DSInputContext`` to apply.
    /// - Returns: A view with the input context set in its environment.
    public func dsInputContext(_ context: DSInputContext) -> some View {
        environment(\.dsInputContext, context)
    }
    
    /// Sets the animation context for this view hierarchy.
    ///
    /// ```swift
    /// ContentView()
    ///     .dsAnimationContext(.reducedMotion)
    /// ```
    ///
    /// - Parameter context: The ``DSAnimationContext`` to apply.
    /// - Returns: A view with the animation context set in its environment.
    public func dsAnimationContext(_ context: DSAnimationContext) -> some View {
        environment(\.dsAnimationContext, context)
    }
}
