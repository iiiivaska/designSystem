// DSComponentStyles.swift
// DesignSystem
//
// Registry of component style resolvers.
// Each resolver can be customized to override default spec resolution.

import SwiftUI
import DSCore

// MARK: - DSComponentStyles

/// Registry of component style resolvers in the theme.
///
/// `DSComponentStyles` provides a centralized place where components look up
/// their spec resolvers. By default every resolver delegates to the matching
/// `DSSpec.resolve(…)` static method, but consumers can replace individual
/// resolvers to customize styling without touching the component code.
///
/// ## Overview
///
/// The component styles registry follows the resolve-then-render architecture:
///
/// 1. A component asks the theme for its style resolver
/// 2. The resolver produces a concrete spec from theme + parameters
/// 3. The component renders using the spec's values
///
/// ## Usage
///
/// ```swift
/// // Use through DSTheme convenience methods:
/// let spec = theme.resolveButton(variant: .primary, size: .medium, state: .normal)
///
/// // Or access resolvers directly:
/// let spec = theme.componentStyles.button.resolve(
///     theme: theme, variant: .primary, size: .medium, state: .normal
/// )
/// ```
///
/// ## Customization
///
/// Override a resolver to customize component styling:
///
/// ```swift
/// var styles = DSComponentStyles.default
/// styles.button = DSButtonStyleResolver(id: "rounded") { theme, variant, size, state in
///     var spec = DSButtonSpec.resolve(theme: theme, variant: variant, size: size, state: state)
///     // Apply custom corner radius
///     return DSButtonSpec(
///         backgroundColor: spec.backgroundColor,
///         foregroundColor: spec.foregroundColor,
///         borderColor: spec.borderColor,
///         borderWidth: spec.borderWidth,
///         height: spec.height,
///         horizontalPadding: spec.horizontalPadding,
///         verticalPadding: spec.verticalPadding,
///         cornerRadius: 999, // pill shape
///         typography: spec.typography,
///         shadow: spec.shadow,
///         opacity: spec.opacity,
///         scaleEffect: spec.scaleEffect,
///         animation: spec.animation
///     )
/// }
///
/// let theme = DSTheme(variant: .light, componentStyles: styles)
/// ```
///
/// ## Topics
///
/// ### Resolvers
///
/// - ``button``
/// - ``field``
/// - ``toggle``
/// - ``slider``
/// - ``formRow``
/// - ``card``
/// - ``listRow``
///
/// ### Presets
///
/// - ``default``
public struct DSComponentStyles: Sendable, Equatable {
    
    // MARK: - Resolvers
    
    /// Button spec resolver.
    ///
    /// Produces ``DSButtonSpec`` for a given variant, size, and state.
    public var button: DSButtonStyleResolver
    
    /// Field spec resolver.
    ///
    /// Produces ``DSFieldSpec`` for a given variant, state, and validation.
    public var field: DSFieldStyleResolver
    
    /// Toggle spec resolver.
    ///
    /// Produces ``DSToggleSpec`` for a given on/off state and interaction state.
    public var toggle: DSToggleStyleResolver
    
    /// Slider spec resolver.
    ///
    /// Produces ``DSSliderSpec`` for a given interaction state.
    public var slider: DSSliderStyleResolver
    
    /// Form row spec resolver.
    ///
    /// Produces ``DSFormRowSpec`` for a given layout mode and capabilities.
    public var formRow: DSFormRowStyleResolver
    
    /// Card spec resolver.
    ///
    /// Produces ``DSCardSpec`` for a given elevation level.
    public var card: DSCardStyleResolver
    
    /// List row spec resolver.
    ///
    /// Produces ``DSListRowSpec`` for a given style, state, and capabilities.
    public var listRow: DSListRowStyleResolver
    
    // MARK: - Initialization
    
    /// Creates a component styles registry with explicit resolvers.
    ///
    /// - Parameters:
    ///   - button: Button spec resolver.
    ///   - field: Field spec resolver.
    ///   - toggle: Toggle spec resolver.
    ///   - slider: Slider spec resolver.
    ///   - formRow: Form row spec resolver.
    ///   - card: Card spec resolver.
    ///   - listRow: List row spec resolver.
    public init(
        button: DSButtonStyleResolver = .default,
        field: DSFieldStyleResolver = .default,
        toggle: DSToggleStyleResolver = .default,
        slider: DSSliderStyleResolver = .default,
        formRow: DSFormRowStyleResolver = .default,
        card: DSCardStyleResolver = .default,
        listRow: DSListRowStyleResolver = .default
    ) {
        self.button = button
        self.field = field
        self.toggle = toggle
        self.slider = slider
        self.formRow = formRow
        self.card = card
        self.listRow = listRow
    }
    
    // MARK: - Presets
    
    /// Default component styles using built-in spec resolvers.
    ///
    /// Each resolver delegates to its matching `DSSpec.resolve(…)` static method.
    public static let `default` = DSComponentStyles()
}

// MARK: - DSButtonStyleResolver

/// Resolver that produces ``DSButtonSpec`` values from theme and parameters.
///
/// The resolver wraps a function that maps (theme, variant, size, state)
/// to a concrete ``DSButtonSpec``. Replace the default resolver to customize
/// button styling across your app.
///
/// ## Default Behavior
///
/// The ``default`` resolver delegates to ``DSButtonSpec/resolve(theme:variant:size:state:)``.
///
/// ## Custom Example
///
/// ```swift
/// let pillButtons = DSButtonStyleResolver(id: "pill") { theme, variant, size, state in
///     var spec = DSButtonSpec.resolve(theme: theme, variant: variant, size: size, state: state)
///     // Return a modified spec with pill-shaped corners
///     return DSButtonSpec(
///         backgroundColor: spec.backgroundColor,
///         foregroundColor: spec.foregroundColor,
///         borderColor: spec.borderColor,
///         borderWidth: spec.borderWidth,
///         height: spec.height,
///         horizontalPadding: spec.horizontalPadding,
///         verticalPadding: spec.verticalPadding,
///         cornerRadius: spec.height / 2,
///         typography: spec.typography,
///         shadow: spec.shadow,
///         opacity: spec.opacity,
///         scaleEffect: spec.scaleEffect,
///         animation: spec.animation
///     )
/// }
/// ```
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:variant:size:state:)``
///
/// ### Presets
///
/// - ``default``
public struct DSButtonStyleResolver: @unchecked Sendable, Equatable {
    
    /// Resolver identifier for equality comparison.
    public let id: String
    
    /// The resolve function.
    private let _resolve: @Sendable (DSTheme, DSButtonVariant, DSButtonSize, DSControlState) -> DSButtonSpec
    
    /// Creates a button style resolver.
    ///
    /// - Parameters:
    ///   - id: Identifier for this resolver (default: `"default"`).
    ///   - resolve: The function that resolves a ``DSButtonSpec``.
    public init(
        id: String = "default",
        resolve: @escaping @Sendable (DSTheme, DSButtonVariant, DSButtonSize, DSControlState) -> DSButtonSpec
    ) {
        self.id = id
        self._resolve = resolve
    }
    
    /// Resolves a button spec.
    ///
    /// - Parameters:
    ///   - theme: The current theme.
    ///   - variant: Button variant.
    ///   - size: Button size.
    ///   - state: Current interaction state.
    /// - Returns: A fully resolved ``DSButtonSpec``.
    public func resolve(
        theme: DSTheme,
        variant: DSButtonVariant,
        size: DSButtonSize,
        state: DSControlState
    ) -> DSButtonSpec {
        _resolve(theme, variant, size, state)
    }
    
    /// Equality based on resolver identifier.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Default resolver using ``DSButtonSpec/resolve(theme:variant:size:state:)``.
    public static let `default` = DSButtonStyleResolver { theme, variant, size, state in
        DSButtonSpec.resolve(theme: theme, variant: variant, size: size, state: state)
    }
}

// MARK: - DSFieldStyleResolver

/// Resolver that produces ``DSFieldSpec`` values from theme and parameters.
///
/// The resolver wraps a function that maps (theme, variant, state, validation)
/// to a concrete ``DSFieldSpec``. Replace the default resolver to customize
/// text field styling across your app.
///
/// ## Default Behavior
///
/// The ``default`` resolver delegates to ``DSFieldSpec/resolve(theme:variant:state:validation:)``.
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:variant:state:validation:)``
///
/// ### Presets
///
/// - ``default``
public struct DSFieldStyleResolver: @unchecked Sendable, Equatable {
    
    /// Resolver identifier for equality comparison.
    public let id: String
    
    /// The resolve function.
    private let _resolve: @Sendable (DSTheme, DSFieldVariant, DSControlState, DSValidationState) -> DSFieldSpec
    
    /// Creates a field style resolver.
    ///
    /// - Parameters:
    ///   - id: Identifier for this resolver (default: `"default"`).
    ///   - resolve: The function that resolves a ``DSFieldSpec``.
    public init(
        id: String = "default",
        resolve: @escaping @Sendable (DSTheme, DSFieldVariant, DSControlState, DSValidationState) -> DSFieldSpec
    ) {
        self.id = id
        self._resolve = resolve
    }
    
    /// Resolves a field spec.
    ///
    /// - Parameters:
    ///   - theme: The current theme.
    ///   - variant: Field variant.
    ///   - state: Current interaction state.
    ///   - validation: Current validation state.
    /// - Returns: A fully resolved ``DSFieldSpec``.
    public func resolve(
        theme: DSTheme,
        variant: DSFieldVariant,
        state: DSControlState,
        validation: DSValidationState = .none
    ) -> DSFieldSpec {
        _resolve(theme, variant, state, validation)
    }
    
    /// Equality based on resolver identifier.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Default resolver using ``DSFieldSpec/resolve(theme:variant:state:validation:)``.
    public static let `default` = DSFieldStyleResolver { theme, variant, state, validation in
        DSFieldSpec.resolve(theme: theme, variant: variant, state: state, validation: validation)
    }
}

// MARK: - DSToggleStyleResolver

/// Resolver that produces ``DSToggleSpec`` values from theme and parameters.
///
/// The resolver wraps a function that maps (theme, isOn, state)
/// to a concrete ``DSToggleSpec``. Replace the default resolver to customize
/// toggle styling across your app.
///
/// ## Default Behavior
///
/// The ``default`` resolver delegates to ``DSToggleSpec/resolve(theme:isOn:state:)``.
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:isOn:state:)``
///
/// ### Presets
///
/// - ``default``
public struct DSToggleStyleResolver: @unchecked Sendable, Equatable {
    
    /// Resolver identifier for equality comparison.
    public let id: String
    
    /// The resolve function.
    private let _resolve: @Sendable (DSTheme, Bool, DSControlState) -> DSToggleSpec
    
    /// Creates a toggle style resolver.
    ///
    /// - Parameters:
    ///   - id: Identifier for this resolver (default: `"default"`).
    ///   - resolve: The function that resolves a ``DSToggleSpec``.
    public init(
        id: String = "default",
        resolve: @escaping @Sendable (DSTheme, Bool, DSControlState) -> DSToggleSpec
    ) {
        self.id = id
        self._resolve = resolve
    }
    
    /// Resolves a toggle spec.
    ///
    /// - Parameters:
    ///   - theme: The current theme.
    ///   - isOn: Whether the toggle is on.
    ///   - state: Current interaction state.
    /// - Returns: A fully resolved ``DSToggleSpec``.
    public func resolve(
        theme: DSTheme,
        isOn: Bool,
        state: DSControlState
    ) -> DSToggleSpec {
        _resolve(theme, isOn, state)
    }
    
    /// Equality based on resolver identifier.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Default resolver using ``DSToggleSpec/resolve(theme:isOn:state:)``.
    public static let `default` = DSToggleStyleResolver { theme, isOn, state in
        DSToggleSpec.resolve(theme: theme, isOn: isOn, state: state)
    }
}

// MARK: - DSSliderStyleResolver

/// Resolver that produces ``DSSliderSpec`` values from theme and parameters.
///
/// The resolver wraps a function that maps (theme, state)
/// to a concrete ``DSSliderSpec``. Replace the default resolver to customize
/// slider styling across your app.
///
/// ## Default Behavior
///
/// The ``default`` resolver delegates to ``DSSliderSpec/resolve(theme:state:)``.
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:state:)``
///
/// ### Presets
///
/// - ``default``
public struct DSSliderStyleResolver: @unchecked Sendable, Equatable {
    
    /// Resolver identifier for equality comparison.
    public let id: String
    
    /// The resolve function.
    private let _resolve: @Sendable (DSTheme, DSControlState) -> DSSliderSpec
    
    /// Creates a slider style resolver.
    ///
    /// - Parameters:
    ///   - id: Identifier for this resolver (default: `"default"`).
    ///   - resolve: The function that resolves a ``DSSliderSpec``.
    public init(
        id: String = "default",
        resolve: @escaping @Sendable (DSTheme, DSControlState) -> DSSliderSpec
    ) {
        self.id = id
        self._resolve = resolve
    }
    
    /// Resolves a slider spec.
    ///
    /// - Parameters:
    ///   - theme: The current theme.
    ///   - state: Current interaction state.
    /// - Returns: A fully resolved ``DSSliderSpec``.
    public func resolve(
        theme: DSTheme,
        state: DSControlState
    ) -> DSSliderSpec {
        _resolve(theme, state)
    }
    
    /// Equality based on resolver identifier.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Default resolver using ``DSSliderSpec/resolve(theme:state:)``.
    public static let `default` = DSSliderStyleResolver { theme, state in
        DSSliderSpec.resolve(theme: theme, state: state)
    }
}

// MARK: - DSFormRowStyleResolver

/// Resolver that produces ``DSFormRowSpec`` values from theme and parameters.
///
/// The resolver wraps a function that maps (theme, layoutMode, capabilities)
/// to a concrete ``DSFormRowSpec``. Replace the default resolver to customize
/// form row layout across your app.
///
/// ## Default Behavior
///
/// The ``default`` resolver delegates to ``DSFormRowSpec/resolve(theme:layoutMode:capabilities:)``.
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:layoutMode:capabilities:)``
///
/// ### Presets
///
/// - ``default``
public struct DSFormRowStyleResolver: @unchecked Sendable, Equatable {
    
    /// Resolver identifier for equality comparison.
    public let id: String
    
    /// The resolve function.
    private let _resolve: @Sendable (DSTheme, DSFormRowLayoutMode, DSCapabilities) -> DSFormRowSpec
    
    /// Creates a form row style resolver.
    ///
    /// - Parameters:
    ///   - id: Identifier for this resolver (default: `"default"`).
    ///   - resolve: The function that resolves a ``DSFormRowSpec``.
    public init(
        id: String = "default",
        resolve: @escaping @Sendable (DSTheme, DSFormRowLayoutMode, DSCapabilities) -> DSFormRowSpec
    ) {
        self.id = id
        self._resolve = resolve
    }
    
    /// Resolves a form row spec.
    ///
    /// - Parameters:
    ///   - theme: The current theme.
    ///   - layoutMode: Layout mode (auto or fixed).
    ///   - capabilities: Platform capabilities.
    /// - Returns: A fully resolved ``DSFormRowSpec``.
    public func resolve(
        theme: DSTheme,
        layoutMode: DSFormRowLayoutMode = .auto,
        capabilities: DSCapabilities
    ) -> DSFormRowSpec {
        _resolve(theme, layoutMode, capabilities)
    }
    
    /// Equality based on resolver identifier.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Default resolver using ``DSFormRowSpec/resolve(theme:layoutMode:capabilities:)``.
    public static let `default` = DSFormRowStyleResolver { theme, layoutMode, capabilities in
        DSFormRowSpec.resolve(theme: theme, layoutMode: layoutMode, capabilities: capabilities)
    }
}

// MARK: - DSCardStyleResolver

/// Resolver that produces ``DSCardSpec`` values from theme and parameters.
///
/// The resolver wraps a function that maps (theme, elevation)
/// to a concrete ``DSCardSpec``. Replace the default resolver to customize
/// card styling across your app.
///
/// ## Default Behavior
///
/// The ``default`` resolver delegates to ``DSCardSpec/resolve(theme:elevation:)``.
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:elevation:)``
///
/// ### Presets
///
/// - ``default``
public struct DSCardStyleResolver: @unchecked Sendable, Equatable {
    
    /// Resolver identifier for equality comparison.
    public let id: String
    
    /// The resolve function.
    private let _resolve: @Sendable (DSTheme, DSCardElevation) -> DSCardSpec
    
    /// Creates a card style resolver.
    ///
    /// - Parameters:
    ///   - id: Identifier for this resolver (default: `"default"`).
    ///   - resolve: The function that resolves a ``DSCardSpec``.
    public init(
        id: String = "default",
        resolve: @escaping @Sendable (DSTheme, DSCardElevation) -> DSCardSpec
    ) {
        self.id = id
        self._resolve = resolve
    }
    
    /// Resolves a card spec.
    ///
    /// - Parameters:
    ///   - theme: The current theme.
    ///   - elevation: Card elevation level.
    /// - Returns: A fully resolved ``DSCardSpec``.
    public func resolve(
        theme: DSTheme,
        elevation: DSCardElevation
    ) -> DSCardSpec {
        _resolve(theme, elevation)
    }
    
    /// Equality based on resolver identifier.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Default resolver using ``DSCardSpec/resolve(theme:elevation:)``.
    public static let `default` = DSCardStyleResolver { theme, elevation in
        DSCardSpec.resolve(theme: theme, elevation: elevation)
    }
}

// MARK: - DSListRowStyleResolver

/// Resolver that produces ``DSListRowSpec`` values from theme and parameters.
///
/// The resolver wraps a function that maps (theme, style, state, capabilities)
/// to a concrete ``DSListRowSpec``. Replace the default resolver to customize
/// list row styling across your app.
///
/// ## Default Behavior
///
/// The ``default`` resolver delegates to ``DSListRowSpec/resolve(theme:style:state:capabilities:)``.
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:style:state:capabilities:)``
///
/// ### Presets
///
/// - ``default``
public struct DSListRowStyleResolver: @unchecked Sendable, Equatable {
    
    /// Resolver identifier for equality comparison.
    public let id: String
    
    /// The resolve function.
    private let _resolve: @Sendable (DSTheme, DSListRowStyle, DSControlState, DSCapabilities) -> DSListRowSpec
    
    /// Creates a list row style resolver.
    ///
    /// - Parameters:
    ///   - id: Identifier for this resolver (default: `"default"`).
    ///   - resolve: The function that resolves a ``DSListRowSpec``.
    public init(
        id: String = "default",
        resolve: @escaping @Sendable (DSTheme, DSListRowStyle, DSControlState, DSCapabilities) -> DSListRowSpec
    ) {
        self.id = id
        self._resolve = resolve
    }
    
    /// Resolves a list row spec.
    ///
    /// - Parameters:
    ///   - theme: The current theme.
    ///   - style: Row visual style.
    ///   - state: Current interaction state.
    ///   - capabilities: Platform capabilities.
    /// - Returns: A fully resolved ``DSListRowSpec``.
    public func resolve(
        theme: DSTheme,
        style: DSListRowStyle,
        state: DSControlState,
        capabilities: DSCapabilities
    ) -> DSListRowSpec {
        _resolve(theme, style, state, capabilities)
    }
    
    /// Equality based on resolver identifier.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Default resolver using ``DSListRowSpec/resolve(theme:style:state:capabilities:)``.
    public static let `default` = DSListRowStyleResolver { theme, style, state, capabilities in
        DSListRowSpec.resolve(theme: theme, style: style, state: state, capabilities: capabilities)
    }
}
