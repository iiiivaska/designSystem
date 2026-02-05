import Foundation

// MARK: - DSInputMode

/// Represents the current primary input mode.
///
/// Components use `DSInputMode` to adapt their interaction behavior based on
/// how the user is interacting with the device.
///
/// ## Overview
///
/// Different input modes require different UI adaptations:
///
/// | Mode | Hover | Focus Ring | Tap Target |
/// |------|-------|------------|------------|
/// | ``touch`` | No | No | 44pt |
/// | ``pointer`` | Yes | No | 24pt |
/// | ``keyboard`` | No | Yes | 44pt |
/// | ``assistive`` | No | Yes | 48pt |
///
/// ## Usage
///
/// ```swift
/// let mode = DSInputMode.touch
///
/// if mode.supportsHover {
///     // Add hover effect
/// }
///
/// let minSize = mode.minimumTapTargetSize
/// ```
///
/// ## Topics
///
/// ### Input Mode Cases
///
/// - ``touch``
/// - ``pointer``
/// - ``keyboard``
/// - ``voice``
/// - ``assistive``
/// - ``default``
///
/// ### Mode Capabilities
///
/// - ``supportsHover``
/// - ``requiresLargeTapTargets``
/// - ``supportsFocusRing``
/// - ``supportsPreciseSelection``
/// - ``minimumTapTargetSize``
public enum DSInputMode: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Touch input (finger on screen).
    case touch
    
    /// Pointer input (mouse or trackpad).
    case pointer
    
    /// Keyboard/focus navigation (tab, arrow keys).
    case keyboard
    
    /// Voice/dictation input.
    case voice
    
    /// Assistive technology (switch control, etc.).
    case assistive
    
    /// Default/unknown input mode.
    case `default`
}

extension DSInputMode {
    
    /// Whether this input mode supports hover states.
    ///
    /// Only ``pointer`` mode supports hover.
    ///
    /// ```swift
    /// if inputMode.supportsHover {
    ///     Button("...") { }
    ///         .onHover { isHovering in
    ///             // Update hover state
    ///         }
    /// }
    /// ```
    public var supportsHover: Bool {
        switch self {
        case .pointer:
            return true
        case .touch, .keyboard, .voice, .assistive, .default:
            return false
        }
    }
    
    /// Whether this input mode requires larger tap targets.
    ///
    /// Returns `true` for ``touch`` and ``assistive`` modes.
    ///
    /// - Important: Apple Human Interface Guidelines recommend minimum 44pt
    ///   tap targets for touch interfaces.
    public var requiresLargeTapTargets: Bool {
        switch self {
        case .touch, .assistive:
            return true
        case .pointer, .keyboard, .voice, .default:
            return false
        }
    }
    
    /// Whether this input mode supports focus ring display.
    ///
    /// Returns `true` for ``keyboard`` and ``assistive`` modes.
    ///
    /// When `true`, interactive elements should display a visible focus indicator.
    public var supportsFocusRing: Bool {
        switch self {
        case .keyboard, .assistive:
            return true
        case .touch, .pointer, .voice, .default:
            return false
        }
    }
    
    /// Whether this input mode supports precise selection.
    ///
    /// Returns `true` for ``pointer`` and ``keyboard`` modes.
    ///
    /// Precise selection enables features like text selection and
    /// fine-grained cursor positioning.
    public var supportsPreciseSelection: Bool {
        switch self {
        case .pointer, .keyboard:
            return true
        case .touch, .voice, .assistive, .default:
            return false
        }
    }
    
    /// Recommended minimum tap target size in points.
    ///
    /// | Mode | Size |
    /// |------|------|
    /// | ``touch`` | 44pt |
    /// | ``assistive`` | 48pt |
    /// | ``pointer`` | 24pt |
    /// | Others | 44pt |
    ///
    /// - Note: These values follow Apple Human Interface Guidelines.
    public var minimumTapTargetSize: CGFloat {
        switch self {
        case .touch:
            return 44.0
        case .assistive:
            return 48.0
        case .pointer:
            return 24.0
        case .keyboard, .voice, .default:
            return 44.0
        }
    }
}

// MARK: - DSInputSource

/// Represents a specific input source or device.
///
/// Use `DSInputSource` to track individual input devices when multiple
/// are connected (e.g., keyboard + mouse + touch).
///
/// ## Topics
///
/// ### Properties
///
/// - ``id``
/// - ``mode``
/// - ``isPrimary``
///
/// ### Creating Input Sources
///
/// - ``init(id:mode:isPrimary:)``
public struct DSInputSource: Sendable, Equatable, Hashable {
    
    /// Unique identifier for this input source.
    public let id: String
    
    /// The input mode this source provides.
    public let mode: DSInputMode
    
    /// Whether this is the primary input source.
    public let isPrimary: Bool
    
    /// Creates a new input source.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the input source.
    ///   - mode: The ``DSInputMode`` this source provides.
    ///   - isPrimary: Whether this is the primary input source. Defaults to `false`.
    public init(id: String, mode: DSInputMode, isPrimary: Bool = false) {
        self.id = id
        self.mode = mode
        self.isPrimary = isPrimary
    }
}

// MARK: - DSInputContext

/// Provides context about the current input state.
///
/// `DSInputContext` is typically provided via SwiftUI's environment and updated
/// by the system as input methods change.
///
/// ## Overview
///
/// ```swift
/// @Environment(\.dsInputContext) private var inputContext
///
/// var body: some View {
///     if inputContext.hasHardwareKeyboard {
///         // Show keyboard shortcuts
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Properties
///
/// - ``primaryMode``
/// - ``activeSources``
/// - ``hasHardwareKeyboard``
/// - ``hasPointerDevice``
///
/// ### Creating Contexts
///
/// - ``init(primaryMode:activeSources:hasHardwareKeyboard:hasPointerDevice:)``
/// - ``platformDefault``
public struct DSInputContext: Sendable, Equatable {
    
    /// The current primary input mode.
    public let primaryMode: DSInputMode
    
    /// All currently active input sources.
    public let activeSources: [DSInputSource]
    
    /// Whether a hardware keyboard is connected.
    public let hasHardwareKeyboard: Bool
    
    /// Whether a pointer device (mouse/trackpad) is connected.
    public let hasPointerDevice: Bool
    
    /// Creates a new input context.
    ///
    /// - Parameters:
    ///   - primaryMode: The primary ``DSInputMode``.
    ///   - activeSources: Array of active ``DSInputSource`` instances. Defaults to empty.
    ///   - hasHardwareKeyboard: Whether a hardware keyboard is connected. Defaults to `false`.
    ///   - hasPointerDevice: Whether a pointer device is connected. Defaults to `false`.
    public init(
        primaryMode: DSInputMode,
        activeSources: [DSInputSource] = [],
        hasHardwareKeyboard: Bool = false,
        hasPointerDevice: Bool = false
    ) {
        self.primaryMode = primaryMode
        self.activeSources = activeSources
        self.hasHardwareKeyboard = hasHardwareKeyboard
        self.hasPointerDevice = hasPointerDevice
    }
    
    /// Default input context based on the current platform.
    ///
    /// | Platform | Primary Mode | Keyboard | Pointer |
    /// |----------|--------------|----------|---------|
    /// | iOS | ``DSInputMode/touch`` | No | No |
    /// | macOS | ``DSInputMode/pointer`` | Yes | Yes |
    /// | watchOS | ``DSInputMode/touch`` | No | No |
    /// | tvOS | ``DSInputMode/keyboard`` | No | No |
    /// | visionOS | ``DSInputMode/pointer`` | No | Yes |
    public static var platformDefault: DSInputContext {
        let platform = DSPlatform.current
        
        switch platform {
        case .iOS:
            return DSInputContext(
                primaryMode: .touch,
                hasHardwareKeyboard: false,
                hasPointerDevice: false
            )
        case .macOS:
            return DSInputContext(
                primaryMode: .pointer,
                hasHardwareKeyboard: true,
                hasPointerDevice: true
            )
        case .watchOS:
            return DSInputContext(
                primaryMode: .touch,
                hasHardwareKeyboard: false,
                hasPointerDevice: false
            )
        case .tvOS:
            return DSInputContext(
                primaryMode: .keyboard,
                hasHardwareKeyboard: false,
                hasPointerDevice: false
            )
        case .visionOS:
            return DSInputContext(
                primaryMode: .pointer,
                hasHardwareKeyboard: false,
                hasPointerDevice: true
            )
        case .unknown:
            return DSInputContext(
                primaryMode: .default,
                hasHardwareKeyboard: false,
                hasPointerDevice: false
            )
        }
    }
}
