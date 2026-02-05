import Foundation

// MARK: - Platform Factory Methods

extension DSCapabilities {
    
    /// Capabilities for the current runtime platform.
    ///
    /// This property returns the appropriate default capabilities
    /// based on compile-time platform detection.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let caps = DSCapabilities.platformDefault
    ///
    /// if caps.supportsHover {
    ///     // Enable hover states
    /// }
    /// ```
    ///
    /// ## Platform Mapping
    ///
    /// | Compiled Platform | Returned Capabilities |
    /// |-------------------|----------------------|
    /// | iOS | ``iOS()`` |
    /// | macOS | ``macOS()`` |
    /// | watchOS | ``watchOS()`` |
    /// | Other | ``iOS()`` (fallback) |
    ///
    /// - Important: This uses `#if os()` for compile-time platform detection.
    ///   The result is determined at build time, not runtime.
    public static var platformDefault: DSCapabilities {
        #if os(iOS)
        return .iOS()
        #elseif os(macOS)
        return .macOS()
        #elseif os(watchOS)
        return .watchOS()
        #elseif os(tvOS)
        return .tvOS()
        #elseif os(visionOS)
        return .visionOS()
        #else
        return .iOS() // Fallback to iOS defaults
        #endif
    }
    
    /// Returns capabilities for a specific platform.
    ///
    /// Use this method when you need capabilities for a platform
    /// other than the current one, such as in testing or previews.
    ///
    /// - Parameter platform: The platform to get capabilities for.
    /// - Returns: Default capabilities for the specified platform.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // In a test or preview
    /// let watchCaps = DSCapabilities.for(platform: .watchOS)
    /// ```
    public static func `for`(platform: DSPlatform) -> DSCapabilities {
        switch platform {
        case .iOS:
            return .iOS()
        case .macOS:
            return .macOS()
        case .watchOS:
            return .watchOS()
        case .tvOS:
            return .tvOS()
        case .visionOS:
            return .visionOS()
        case .unknown:
            return .iOS() // Fallback
        }
    }
}

// MARK: - iOS Capabilities

extension DSCapabilities {
    
    /// Default capabilities for iOS (iPhone/iPad).
    ///
    /// ## Capability Summary
    ///
    /// | Capability | Value | Notes |
    /// |------------|-------|-------|
    /// | Hover | `false` | Only with pointer; default is touch |
    /// | Focus Ring | `false` | iOS uses different focus indicators |
    /// | Inline Text | `true` | On-screen keyboard coexists with forms |
    /// | Inline Pickers | `true` | Sheets present well on iOS |
    /// | Toasts | `true` | Supported via overlays |
    /// | Large Tap Targets | `true` | Touch input needs larger targets |
    /// | Form Layout | ``DSFormRowLayout/inline`` | Standard iOS form style |
    /// | Picker Style | ``DSPickerPresentation/sheet`` | Slides from bottom |
    /// | Text Field Mode | ``DSTextFieldMode/inline`` | Keyboard overlay |
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // For testing iOS behavior on other platforms
    /// let iosCaps = DSCapabilities.iOS()
    ///
    /// // Use in preview
    /// MyView()
    ///     .environment(\.dsCapabilities, DSCapabilities.iOS())
    /// ```
    ///
    /// - Returns: Capabilities configured for iOS defaults.
    public static func iOS() -> DSCapabilities {
        DSCapabilities(
            supportsHover: false,
            supportsFocusRing: false,
            supportsInlineTextEditing: true,
            supportsInlinePickers: true,
            supportsToasts: true,
            prefersLargeTapTargets: true,
            preferredFormRowLayout: .inline,
            preferredPickerPresentation: .sheet,
            preferredTextFieldMode: .inline
        )
    }
    
    /// iOS capabilities with pointer/trackpad support enabled.
    ///
    /// Use this when an iPad has a trackpad or mouse connected
    /// and hover interactions are available.
    ///
    /// ## Differences from Standard iOS
    ///
    /// | Capability | Standard | With Pointer |
    /// |------------|----------|--------------|
    /// | Hover | `false` | `true` |
    /// | Focus Ring | `false` | `true` |
    ///
    /// - Returns: iOS capabilities with hover and focus ring enabled.
    public static func iOSWithPointer() -> DSCapabilities {
        DSCapabilities(
            supportsHover: true,
            supportsFocusRing: true,
            supportsInlineTextEditing: true,
            supportsInlinePickers: true,
            supportsToasts: true,
            prefersLargeTapTargets: true,
            preferredFormRowLayout: .inline,
            preferredPickerPresentation: .sheet,
            preferredTextFieldMode: .inline
        )
    }
}

// MARK: - macOS Capabilities

extension DSCapabilities {
    
    /// Default capabilities for macOS.
    ///
    /// ## Capability Summary
    ///
    /// | Capability | Value | Notes |
    /// |------------|-------|-------|
    /// | Hover | `true` | Mouse pointer always available |
    /// | Focus Ring | `true` | Standard macOS keyboard navigation |
    /// | Inline Text | `true` | Keyboard always present |
    /// | Inline Pickers | `true` | Menus and popovers work well |
    /// | Toasts | `true` | Notification center integration |
    /// | Large Tap Targets | `false` | Precise pointer input |
    /// | Form Layout | ``DSFormRowLayout/twoColumn`` | Label column alignment |
    /// | Picker Style | ``DSPickerPresentation/menu`` | Compact dropdown |
    /// | Text Field Mode | ``DSTextFieldMode/inline`` | Standard text fields |
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // For testing macOS behavior on other platforms
    /// let macCaps = DSCapabilities.macOS()
    ///
    /// // Use in preview
    /// MyView()
    ///     .environment(\.dsCapabilities, DSCapabilities.macOS())
    /// ```
    ///
    /// - Returns: Capabilities configured for macOS defaults.
    public static func macOS() -> DSCapabilities {
        DSCapabilities(
            supportsHover: true,
            supportsFocusRing: true,
            supportsInlineTextEditing: true,
            supportsInlinePickers: true,
            supportsToasts: true,
            prefersLargeTapTargets: false,
            preferredFormRowLayout: .twoColumn,
            preferredPickerPresentation: .menu,
            preferredTextFieldMode: .inline
        )
    }
}

// MARK: - watchOS Capabilities

extension DSCapabilities {
    
    /// Default capabilities for watchOS.
    ///
    /// ## Capability Summary
    ///
    /// | Capability | Value | Notes |
    /// |------------|-------|-------|
    /// | Hover | `false` | Touch only |
    /// | Focus Ring | `false` | Digital crown navigation |
    /// | Inline Text | `false` | System text input screen |
    /// | Inline Pickers | `false` | Navigation required |
    /// | Toasts | `false` | Limited screen space |
    /// | Large Tap Targets | `true` | Small screen needs large targets |
    /// | Form Layout | ``DSFormRowLayout/stacked`` | Vertical for narrow screen |
    /// | Picker Style | ``DSPickerPresentation/navigation`` | Push to list |
    /// | Text Field Mode | ``DSTextFieldMode/separateScreen`` | System input |
    ///
    /// ## watchOS Specific Behavior
    ///
    /// - Text fields navigate to a system text input screen
    /// - Pickers navigate to a scrollable list view
    /// - All layouts are vertical (stacked)
    /// - Minimum tap target is 44pt for comfort
    /// - No hover or focus ring (crown-based navigation)
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // For testing watchOS behavior on other platforms
    /// let watchCaps = DSCapabilities.watchOS()
    ///
    /// // Use in preview
    /// MyView()
    ///     .environment(\.dsCapabilities, DSCapabilities.watchOS())
    /// ```
    ///
    /// - Returns: Capabilities configured for watchOS defaults.
    public static func watchOS() -> DSCapabilities {
        DSCapabilities(
            supportsHover: false,
            supportsFocusRing: false,
            supportsInlineTextEditing: false,
            supportsInlinePickers: false,
            supportsToasts: false,
            prefersLargeTapTargets: true,
            preferredFormRowLayout: .stacked,
            preferredPickerPresentation: .navigation,
            preferredTextFieldMode: .separateScreen
        )
    }
}

// MARK: - tvOS Capabilities

extension DSCapabilities {
    
    /// Default capabilities for tvOS.
    ///
    /// ## Capability Summary
    ///
    /// | Capability | Value | Notes |
    /// |------------|-------|-------|
    /// | Hover | `true` | Focus-based interaction |
    /// | Focus Ring | `true` | tvOS focus system |
    /// | Inline Text | `false` | Remote-based text entry |
    /// | Inline Pickers | `true` | Focus-based selection |
    /// | Toasts | `true` | Overlay notifications |
    /// | Large Tap Targets | `true` | 10-foot UI |
    /// | Form Layout | ``DSFormRowLayout/inline`` | Horizontal for wide screen |
    /// | Picker Style | ``DSPickerPresentation/navigation`` | Full-screen selection |
    /// | Text Field Mode | ``DSTextFieldMode/separateScreen`` | System keyboard |
    ///
    /// - Note: tvOS is reserved for future compatibility.
    ///
    /// - Returns: Capabilities configured for tvOS defaults.
    public static func tvOS() -> DSCapabilities {
        DSCapabilities(
            supportsHover: true, // Focus-based hover
            supportsFocusRing: true,
            supportsInlineTextEditing: false,
            supportsInlinePickers: true,
            supportsToasts: true,
            prefersLargeTapTargets: true,
            preferredFormRowLayout: .inline,
            preferredPickerPresentation: .navigation,
            preferredTextFieldMode: .separateScreen
        )
    }
}

// MARK: - visionOS Capabilities

extension DSCapabilities {
    
    /// Default capabilities for visionOS.
    ///
    /// ## Capability Summary
    ///
    /// | Capability | Value | Notes |
    /// |------------|-------|-------|
    /// | Hover | `true` | Eye tracking / hand proximity |
    /// | Focus Ring | `true` | Spatial focus indicators |
    /// | Inline Text | `true` | Virtual keyboard |
    /// | Inline Pickers | `true` | Spatial menus |
    /// | Toasts | `true` | Spatial notifications |
    /// | Large Tap Targets | `true` | Comfortable in 3D |
    /// | Form Layout | ``DSFormRowLayout/inline`` | Spatial panels |
    /// | Picker Style | ``DSPickerPresentation/popover`` | Spatial popover |
    /// | Text Field Mode | ``DSTextFieldMode/inline`` | Virtual keyboard |
    ///
    /// - Note: visionOS is reserved for future compatibility.
    ///
    /// - Returns: Capabilities configured for visionOS defaults.
    public static func visionOS() -> DSCapabilities {
        DSCapabilities(
            supportsHover: true,
            supportsFocusRing: true,
            supportsInlineTextEditing: true,
            supportsInlinePickers: true,
            supportsToasts: true,
            prefersLargeTapTargets: true,
            preferredFormRowLayout: .inline,
            preferredPickerPresentation: .popover,
            preferredTextFieldMode: .inline
        )
    }
}

// MARK: - Capability Queries

extension DSCapabilities {
    
    /// Whether this configuration supports pointer-style interaction.
    ///
    /// Returns `true` if either hover or focus ring is supported,
    /// indicating the platform has precise pointer input available.
    public var supportsPointerInteraction: Bool {
        supportsHover || supportsFocusRing
    }
    
    /// Whether this configuration requires navigation-based UI patterns.
    ///
    /// Returns `true` if either inline text or inline pickers are
    /// not supported, indicating the platform needs push navigation
    /// for editing and selection flows.
    public var requiresNavigationPatterns: Bool {
        !supportsInlineTextEditing || !supportsInlinePickers
    }
    
    /// Whether this configuration is optimized for compact screens.
    ///
    /// Returns `true` if the preferred form layout is stacked,
    /// indicating limited horizontal space.
    public var isCompactScreen: Bool {
        preferredFormRowLayout == .stacked
    }
    
    /// The minimum recommended tap target size.
    ///
    /// Returns 44pt when ``prefersLargeTapTargets`` is `true`,
    /// otherwise returns 24pt for pointer-based interfaces.
    public var minimumTapTargetSize: CGFloat {
        prefersLargeTapTargets ? 44 : 24
    }
}
