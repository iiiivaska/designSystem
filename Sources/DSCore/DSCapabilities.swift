import Foundation

// MARK: - Form Row Layout

/// Preferred layout mode for form rows.
///
/// `DSFormRowLayout` determines how form rows arrange their label
/// and control content on different platforms.
///
/// ## Platform Defaults
///
/// | Platform | Preferred Layout |
/// |----------|------------------|
/// | iOS | ``inline`` or ``stacked`` |
/// | macOS | ``twoColumn`` |
/// | watchOS | ``stacked`` only |
///
/// ## Usage
///
/// ```swift
/// let layout = capabilities.preferredFormRowLayout
///
/// switch layout {
/// case .stacked:
///     VStack(alignment: .leading) {
///         labelView
///         controlView
///     }
/// case .inline:
///     HStack {
///         labelView
///         Spacer()
///         controlView
///     }
/// case .twoColumn:
///     GridRow {
///         labelView
///         controlView
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Layout Options
///
/// - ``stacked``
/// - ``inline``
/// - ``twoColumn``
public enum DSFormRowLayout: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Label above control (vertical stack).
    ///
    /// Best for narrow screens or when labels are long.
    /// Required on watchOS due to limited horizontal space.
    ///
    /// ```
    /// ┌───────────────────┐
    /// │ Label             │
    /// │ ┌───────────────┐ │
    /// │ │ Control       │ │
    /// │ └───────────────┘ │
    /// └───────────────────┘
    /// ```
    case stacked
    
    /// Label left, control right (horizontal stack).
    ///
    /// Standard layout for iOS forms and settings screens.
    ///
    /// ```
    /// ┌───────────────────┐
    /// │ Label    [Control]│
    /// └───────────────────┘
    /// ```
    case inline
    
    /// Fixed-width label column with controls aligned.
    ///
    /// Preferred on macOS for consistent form alignment.
    ///
    /// ```
    /// ┌────────┬──────────┐
    /// │ Label: │ Control  │
    /// ├────────┼──────────┤
    /// │ Label: │ Control  │
    /// └────────┴──────────┘
    /// ```
    case twoColumn
}

// MARK: - Picker Presentation

/// Preferred presentation style for pickers.
///
/// `DSPickerPresentation` defines how picker selections should be
/// presented to the user on different platforms.
///
/// ## Platform Defaults
///
/// | Platform | Preferred Presentation |
/// |----------|------------------------|
/// | iOS | ``sheet`` |
/// | macOS | ``menu`` or ``popover`` |
/// | watchOS | ``navigation`` |
///
/// ## Usage
///
/// ```swift
/// let presentation = capabilities.preferredPickerPresentation
///
/// switch presentation {
/// case .sheet:
///     Button(selection.title) { showSheet = true }
///         .sheet(isPresented: $showSheet) { PickerList() }
/// case .menu:
///     Menu(selection.title) { ForEach(options) { ... } }
/// case .popover:
///     Button(selection.title) { showPopover = true }
///         .popover(isPresented: $showPopover) { PickerList() }
/// case .navigation:
///     NavigationLink(selection.title) { PickerList() }
/// }
/// ```
///
/// ## Topics
///
/// ### Presentation Options
///
/// - ``sheet``
/// - ``popover``
/// - ``menu``
/// - ``navigation``
public enum DSPickerPresentation: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Present picker as a modal sheet.
    ///
    /// Standard presentation for iOS pickers. Slides up from bottom
    /// and provides a clear selection interface.
    case sheet
    
    /// Present picker in a popover.
    ///
    /// Used on macOS and iPadOS for contextual selection near
    /// the triggering element.
    case popover
    
    /// Present picker as a drop-down menu.
    ///
    /// Compact presentation for macOS, ideal for small option sets.
    case menu
    
    /// Present picker via navigation push.
    ///
    /// Required on watchOS where modal presentations are limited.
    /// Also useful on iOS for complex selections with many options.
    case navigation
}

// MARK: - Text Field Mode

/// Preferred editing mode for text fields.
///
/// `DSTextFieldMode` determines whether text editing happens
/// inline or on a separate screen.
///
/// ## Platform Defaults
///
/// | Platform | Preferred Mode |
/// |----------|----------------|
/// | iOS | ``inline`` |
/// | macOS | ``inline`` |
/// | watchOS | ``separateScreen`` |
///
/// ## Usage
///
/// ```swift
/// let mode = capabilities.preferredTextFieldMode
///
/// switch mode {
/// case .inline:
///     TextField("Enter value", text: $value)
/// case .separateScreen:
///     NavigationLink {
///         TextEditScreen(value: $value)
///     } label: {
///         Text(value.isEmpty ? "Enter value" : value)
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Mode Options
///
/// - ``inline``
/// - ``separateScreen``
public enum DSTextFieldMode: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Edit text directly in the row.
    ///
    /// Standard behavior for iOS and macOS where keyboard/input
    /// can coexist with the form layout.
    case inline
    
    /// Navigate to a separate screen for editing.
    ///
    /// Required on watchOS where keyboard input uses a system
    /// text input controller, and recommended for iOS when
    /// editing long-form content.
    case separateScreen
}

// MARK: - DSCapabilities

/// Platform capabilities for UI component adaptation.
///
/// `DSCapabilities` encapsulates all platform-specific capabilities
/// that components query to adapt their behavior. This enables a
/// single codebase to work across iOS, macOS, and watchOS without
/// scattered `#if os()` conditionals.
///
/// ## Overview
///
/// Instead of checking platform directly:
///
/// ```swift
/// // ❌ Don't do this in components
/// #if os(macOS)
/// // macOS-specific code
/// #endif
/// ```
///
/// Query capabilities:
///
/// ```swift
/// // ✅ Use capabilities instead
/// @Environment(\.dsCapabilities) private var capabilities
///
/// if capabilities.supportsHover {
///     // Enable hover states
/// }
/// ```
///
/// ## Capability Matrix
///
/// | Capability | iOS | macOS | watchOS |
/// |------------|-----|-------|---------|
/// | Hover | Pointer only | Yes | No |
/// | Focus Ring | Keyboard | Yes | No |
/// | Inline Text | Yes | Yes | No |
/// | Inline Pickers | Yes | Yes | No |
/// | Toasts | Yes | Yes | No |
/// | Large Targets | Yes | No | Yes |
///
/// ## Creating Capabilities
///
/// Use the platform-specific factory methods:
///
/// ```swift
/// // Get defaults for current platform
/// let caps = DSCapabilities.platformDefault
///
/// // Or for a specific platform
/// let iosCaps = DSCapabilities.iOS()
/// let macCaps = DSCapabilities.macOS()
/// let watchCaps = DSCapabilities.watchOS()
/// ```
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
///
/// ### Factory Methods
///
/// - ``platformDefault``
/// - ``iOS()``
/// - ``macOS()``
/// - ``watchOS()``
public struct DSCapabilities: DSCapabilitiesProtocol, Sendable, Equatable, Hashable {
    
    // MARK: - Interaction Capabilities
    
    /// Whether the platform supports hover states.
    ///
    /// When `true`, components should provide visual feedback on mouse hover.
    /// When `false`, hover handlers can be omitted for performance.
    ///
    /// | Platform | Value |
    /// |----------|-------|
    /// | iOS | `false` (unless pointer connected) |
    /// | macOS | `true` |
    /// | watchOS | `false` |
    public let supportsHover: Bool
    
    /// Whether the platform supports focus rings.
    ///
    /// When `true`, components should display focus indicators for
    /// keyboard navigation accessibility.
    ///
    /// | Platform | Value |
    /// |----------|-------|
    /// | iOS | `false` (keyboard focus uses different indicator) |
    /// | macOS | `true` |
    /// | watchOS | `false` |
    public let supportsFocusRing: Bool
    
    // MARK: - Input Capabilities
    
    /// Whether the platform supports inline text editing.
    ///
    /// When `false`, text fields should navigate to a separate
    /// edit screen instead of inline keyboard entry.
    ///
    /// | Platform | Value |
    /// |----------|-------|
    /// | iOS | `true` |
    /// | macOS | `true` |
    /// | watchOS | `false` |
    public let supportsInlineTextEditing: Bool
    
    /// Whether the platform supports inline pickers.
    ///
    /// When `false`, pickers should use navigation-based
    /// selection lists instead of sheets or popovers.
    ///
    /// | Platform | Value |
    /// |----------|-------|
    /// | iOS | `true` |
    /// | macOS | `true` |
    /// | watchOS | `false` |
    public let supportsInlinePickers: Bool
    
    /// Whether the platform supports toast notifications.
    ///
    /// When `false`, feedback should use alternative methods
    /// like haptics or inline messages.
    ///
    /// | Platform | Value |
    /// |----------|-------|
    /// | iOS | `true` |
    /// | macOS | `true` |
    /// | watchOS | `false` |
    public let supportsToasts: Bool
    
    // MARK: - Layout Preferences
    
    /// Whether the platform prefers large tap targets.
    ///
    /// When `true`, interactive elements should have minimum
    /// 44pt hit areas per accessibility guidelines.
    ///
    /// | Platform | Value |
    /// |----------|-------|
    /// | iOS | `true` |
    /// | macOS | `false` |
    /// | watchOS | `true` |
    public let prefersLargeTapTargets: Bool
    
    /// The preferred layout mode for form rows.
    ///
    /// Components with `.auto` layout should use this value
    /// to determine their default arrangement.
    ///
    /// | Platform | Value |
    /// |----------|-------|
    /// | iOS | ``DSFormRowLayout/inline`` |
    /// | macOS | ``DSFormRowLayout/twoColumn`` |
    /// | watchOS | ``DSFormRowLayout/stacked`` |
    public let preferredFormRowLayout: DSFormRowLayout
    
    /// The preferred presentation style for pickers.
    ///
    /// Components with `.auto` presentation should use this value
    /// to determine how to present selection interfaces.
    ///
    /// | Platform | Value |
    /// |----------|-------|
    /// | iOS | ``DSPickerPresentation/sheet`` |
    /// | macOS | ``DSPickerPresentation/menu`` |
    /// | watchOS | ``DSPickerPresentation/navigation`` |
    public let preferredPickerPresentation: DSPickerPresentation
    
    /// The preferred text field editing mode.
    ///
    /// Components with `.auto` mode should use this value
    /// to determine inline vs separate screen editing.
    ///
    /// | Platform | Value |
    /// |----------|-------|
    /// | iOS | ``DSTextFieldMode/inline`` |
    /// | macOS | ``DSTextFieldMode/inline`` |
    /// | watchOS | ``DSTextFieldMode/separateScreen`` |
    public let preferredTextFieldMode: DSTextFieldMode
    
    // MARK: - Initialization
    
    /// Creates a capabilities instance with explicit values.
    ///
    /// Use this initializer for testing or custom capability sets.
    /// For production, prefer the factory methods like ``platformDefault``.
    ///
    /// - Parameters:
    ///   - supportsHover: Whether hover states are supported.
    ///   - supportsFocusRing: Whether focus rings are supported.
    ///   - supportsInlineTextEditing: Whether inline text editing is supported.
    ///   - supportsInlinePickers: Whether inline pickers are supported.
    ///   - supportsToasts: Whether toast notifications are supported.
    ///   - prefersLargeTapTargets: Whether large tap targets are preferred.
    ///   - preferredFormRowLayout: The preferred form row layout.
    ///   - preferredPickerPresentation: The preferred picker presentation.
    ///   - preferredTextFieldMode: The preferred text field mode.
    public init(
        supportsHover: Bool,
        supportsFocusRing: Bool,
        supportsInlineTextEditing: Bool,
        supportsInlinePickers: Bool,
        supportsToasts: Bool,
        prefersLargeTapTargets: Bool,
        preferredFormRowLayout: DSFormRowLayout,
        preferredPickerPresentation: DSPickerPresentation,
        preferredTextFieldMode: DSTextFieldMode
    ) {
        self.supportsHover = supportsHover
        self.supportsFocusRing = supportsFocusRing
        self.supportsInlineTextEditing = supportsInlineTextEditing
        self.supportsInlinePickers = supportsInlinePickers
        self.supportsToasts = supportsToasts
        self.prefersLargeTapTargets = prefersLargeTapTargets
        self.preferredFormRowLayout = preferredFormRowLayout
        self.preferredPickerPresentation = preferredPickerPresentation
        self.preferredTextFieldMode = preferredTextFieldMode
    }
}

// MARK: - CustomStringConvertible

extension DSCapabilities: CustomStringConvertible {
    
    /// A textual description of the capabilities.
    public var description: String {
        """
        DSCapabilities(
            supportsHover: \(supportsHover),
            supportsFocusRing: \(supportsFocusRing),
            supportsInlineTextEditing: \(supportsInlineTextEditing),
            supportsInlinePickers: \(supportsInlinePickers),
            supportsToasts: \(supportsToasts),
            prefersLargeTapTargets: \(prefersLargeTapTargets),
            preferredFormRowLayout: \(preferredFormRowLayout),
            preferredPickerPresentation: \(preferredPickerPresentation),
            preferredTextFieldMode: \(preferredTextFieldMode)
        )
        """
    }
}
