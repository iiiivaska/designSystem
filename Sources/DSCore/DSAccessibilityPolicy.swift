import Foundation

// MARK: - DSAccessibilityPolicy

/// Container for accessibility-related settings that affect UI rendering.
///
/// `DSAccessibilityPolicy` encapsulates all accessibility settings in a single
/// type, making it easy to pass through the view hierarchy and test different
/// configurations.
///
/// ## Overview
///
/// Components use this policy to adapt their appearance and behavior:
///
/// ```swift
/// @Environment(\.dsAccessibilityPolicy) private var accessibility
///
/// var body: some View {
///     if accessibility.reduceMotion {
///         // Use crossfade instead of slide animation
///     }
///
///     if accessibility.increasedContrast {
///         // Increase border width
///     }
/// }
/// ```
///
/// ## Topics
///
/// ### Motion Settings
///
/// - ``reduceMotion``
/// - ``autoplayAnimations``
///
/// ### Visual Settings
///
/// - ``increasedContrast``
/// - ``reduceTransparency``
/// - ``differentiateWithoutColor``
/// - ``invertColors``
///
/// ### Text Settings
///
/// - ``dynamicTypeSize``
/// - ``isBoldTextEnabled``
///
/// ### Assistive Technology
///
/// - ``isVoiceOverRunning``
/// - ``isSwitchControlRunning``
/// - ``isAssistiveTechnologyActive``
///
/// ### Creating Policies
///
/// - ``init(reduceMotion:autoplayAnimations:increasedContrast:reduceTransparency:differentiateWithoutColor:invertColors:dynamicTypeSize:isBoldTextEnabled:isVoiceOverRunning:isSwitchControlRunning:)``
/// - ``default``
public struct DSAccessibilityPolicy: Sendable, Equatable, Hashable {
    
    // MARK: - Motion Settings
    
    /// Whether to reduce motion effects.
    ///
    /// When `true`, components should:
    /// - Disable or simplify animations
    /// - Use crossfade instead of movement
    /// - Avoid auto-playing animated content
    ///
    /// - SeeAlso: ``autoplayAnimations``
    public let reduceMotion: Bool
    
    /// Whether to auto-play animated content.
    ///
    /// When `false`, animations should require user action to start.
    public let autoplayAnimations: Bool
    
    // MARK: - Visual Settings
    
    /// Whether to increase contrast.
    ///
    /// When `true`, components should:
    /// - Increase border visibility
    /// - Enhance text contrast
    /// - Avoid subtle color differences
    ///
    /// - Important: Avoid making accent colors overly saturated ("acidic").
    ///   Instead, increase border weights and text contrast.
    public let increasedContrast: Bool
    
    /// Whether to reduce transparency effects.
    ///
    /// When `true`, components should:
    /// - Disable blur/vibrancy effects
    /// - Use solid backgrounds
    public let reduceTransparency: Bool
    
    /// Whether to differentiate without color.
    ///
    /// When `true`, use shapes, icons, or text in addition to color
    /// for conveying information.
    ///
    /// ```swift
    /// if accessibility.differentiateWithoutColor {
    ///     // Add icon next to colored status indicator
    ///     HStack {
    ///         Circle().fill(.red)
    ///         Image(systemName: "xmark")
    ///     }
    /// }
    /// ```
    public let differentiateWithoutColor: Bool
    
    /// Whether to invert colors.
    ///
    /// `true` when Smart Invert or Classic Invert is enabled.
    public let invertColors: Bool
    
    // MARK: - Text Settings
    
    /// The current Dynamic Type size preference.
    ///
    /// - SeeAlso: ``DSDynamicTypeSize``
    public let dynamicTypeSize: DSDynamicTypeSize
    
    /// Whether Bold Text is enabled.
    public let isBoldTextEnabled: Bool
    
    // MARK: - Focus Settings
    
    /// Whether VoiceOver is running.
    public let isVoiceOverRunning: Bool
    
    /// Whether Switch Control is enabled.
    public let isSwitchControlRunning: Bool
    
    /// Whether any assistive technology is active.
    ///
    /// Returns `true` if either ``isVoiceOverRunning`` or
    /// ``isSwitchControlRunning`` is `true`.
    public var isAssistiveTechnologyActive: Bool {
        isVoiceOverRunning || isSwitchControlRunning
    }
    
    // MARK: - Initialization
    
    /// Creates a new accessibility policy.
    ///
    /// - Parameters:
    ///   - reduceMotion: Whether to reduce motion effects. Defaults to `false`.
    ///   - autoplayAnimations: Whether to auto-play animations. Defaults to `true`.
    ///   - increasedContrast: Whether to increase contrast. Defaults to `false`.
    ///   - reduceTransparency: Whether to reduce transparency. Defaults to `false`.
    ///   - differentiateWithoutColor: Whether to differentiate without color. Defaults to `false`.
    ///   - invertColors: Whether colors are inverted. Defaults to `false`.
    ///   - dynamicTypeSize: The Dynamic Type size. Defaults to ``DSDynamicTypeSize/large``.
    ///   - isBoldTextEnabled: Whether bold text is enabled. Defaults to `false`.
    ///   - isVoiceOverRunning: Whether VoiceOver is running. Defaults to `false`.
    ///   - isSwitchControlRunning: Whether Switch Control is running. Defaults to `false`.
    public init(
        reduceMotion: Bool = false,
        autoplayAnimations: Bool = true,
        increasedContrast: Bool = false,
        reduceTransparency: Bool = false,
        differentiateWithoutColor: Bool = false,
        invertColors: Bool = false,
        dynamicTypeSize: DSDynamicTypeSize = .large,
        isBoldTextEnabled: Bool = false,
        isVoiceOverRunning: Bool = false,
        isSwitchControlRunning: Bool = false
    ) {
        self.reduceMotion = reduceMotion
        self.autoplayAnimations = autoplayAnimations
        self.increasedContrast = increasedContrast
        self.reduceTransparency = reduceTransparency
        self.differentiateWithoutColor = differentiateWithoutColor
        self.invertColors = invertColors
        self.dynamicTypeSize = dynamicTypeSize
        self.isBoldTextEnabled = isBoldTextEnabled
        self.isVoiceOverRunning = isVoiceOverRunning
        self.isSwitchControlRunning = isSwitchControlRunning
    }
    
    /// Default accessibility policy with no special settings.
    ///
    /// All motion and visual effects are enabled, and Dynamic Type
    /// is set to the default ``DSDynamicTypeSize/large`` size.
    public static let `default` = DSAccessibilityPolicy()
}

// MARK: - DSDynamicTypeSize

/// Represents the Dynamic Type size preference.
///
/// `DSDynamicTypeSize` mirrors `ContentSizeCategory` but as a pure data type
/// for use in non-SwiftUI contexts.
///
/// ## Overview
///
/// Dynamic Type sizes range from ``extraSmall`` to ``accessibilityExtraExtraExtraLarge``.
/// Sizes from ``accessibilityMedium`` onward are considered accessibility sizes.
///
/// ```swift
/// let size = DSDynamicTypeSize.large
///
/// let scaledFont = baseSize * size.scaleFactor
///
/// if size.isAccessibilitySize {
///     // Adjust layout for very large text
/// }
/// ```
///
/// ## Topics
///
/// ### Standard Sizes
///
/// - ``extraSmall``
/// - ``small``
/// - ``medium``
/// - ``large``
/// - ``extraLarge``
/// - ``extraExtraLarge``
/// - ``extraExtraExtraLarge``
///
/// ### Accessibility Sizes
///
/// - ``accessibilityMedium``
/// - ``accessibilityLarge``
/// - ``accessibilityExtraLarge``
/// - ``accessibilityExtraExtraLarge``
/// - ``accessibilityExtraExtraExtraLarge``
///
/// ### Size Information
///
/// - ``isAccessibilitySize``
/// - ``scaleFactor``
public enum DSDynamicTypeSize: String, Sendable, Equatable, Hashable, CaseIterable, Comparable {
    
    // MARK: Standard Sizes
    
    /// Extra small text size.
    case extraSmall
    
    /// Small text size.
    case small
    
    /// Medium text size.
    case medium
    
    /// Large text size (system default).
    case large
    
    /// Extra large text size.
    case extraLarge
    
    /// Extra extra large text size.
    case extraExtraLarge
    
    /// Extra extra extra large text size.
    case extraExtraExtraLarge
    
    // MARK: Accessibility Sizes
    
    /// Accessibility medium text size.
    case accessibilityMedium
    
    /// Accessibility large text size.
    case accessibilityLarge
    
    /// Accessibility extra large text size.
    case accessibilityExtraLarge
    
    /// Accessibility extra extra large text size.
    case accessibilityExtraExtraLarge
    
    /// Accessibility extra extra extra large text size.
    case accessibilityExtraExtraExtraLarge
    
    /// Whether this is an accessibility size.
    ///
    /// Accessibility sizes are ``accessibilityMedium`` and larger.
    /// These sizes may require layout adjustments such as switching
    /// from horizontal to vertical arrangements.
    public var isAccessibilitySize: Bool {
        switch self {
        case .accessibilityMedium, .accessibilityLarge, .accessibilityExtraLarge,
             .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return true
        default:
            return false
        }
    }
    
    /// Numeric scale factor relative to default (1.0).
    ///
    /// | Size | Scale Factor |
    /// |------|-------------|
    /// | ``extraSmall`` | 0.823 |
    /// | ``small`` | 0.882 |
    /// | ``medium`` | 0.941 |
    /// | ``large`` | 1.0 |
    /// | ``extraLarge`` | 1.118 |
    /// | ``extraExtraLarge`` | 1.235 |
    /// | ``extraExtraExtraLarge`` | 1.353 |
    /// | ``accessibilityMedium`` | 1.588 |
    /// | ``accessibilityLarge`` | 1.882 |
    /// | ``accessibilityExtraLarge`` | 2.176 |
    /// | ``accessibilityExtraExtraLarge`` | 2.471 |
    /// | ``accessibilityExtraExtraExtraLarge`` | 2.824 |
    public var scaleFactor: CGFloat {
        switch self {
        case .extraSmall: return 0.823
        case .small: return 0.882
        case .medium: return 0.941
        case .large: return 1.0
        case .extraLarge: return 1.118
        case .extraExtraLarge: return 1.235
        case .extraExtraExtraLarge: return 1.353
        case .accessibilityMedium: return 1.588
        case .accessibilityLarge: return 1.882
        case .accessibilityExtraLarge: return 2.176
        case .accessibilityExtraExtraLarge: return 2.471
        case .accessibilityExtraExtraExtraLarge: return 2.824
        }
    }
    
    /// Ordering index for comparison.
    private var orderIndex: Int {
        switch self {
        case .extraSmall: return 0
        case .small: return 1
        case .medium: return 2
        case .large: return 3
        case .extraLarge: return 4
        case .extraExtraLarge: return 5
        case .extraExtraExtraLarge: return 6
        case .accessibilityMedium: return 7
        case .accessibilityLarge: return 8
        case .accessibilityExtraLarge: return 9
        case .accessibilityExtraExtraLarge: return 10
        case .accessibilityExtraExtraExtraLarge: return 11
        }
    }
    
    public static func < (lhs: DSDynamicTypeSize, rhs: DSDynamicTypeSize) -> Bool {
        lhs.orderIndex < rhs.orderIndex
    }
}

// MARK: - DSAccessibilityAdjustments

/// Helper for computing accessibility-adjusted values.
///
/// `DSAccessibilityAdjustments` provides static methods for scaling
/// values based on Dynamic Type and accessibility settings.
///
/// ## Usage
///
/// ```swift
/// let adjustedSize = DSAccessibilityAdjustments.adjustedFontSize(
///     17,
///     for: .accessibilityLarge,
///     minimum: 12,
///     maximum: 40
/// )
/// ```
///
/// ## Topics
///
/// ### Font Adjustments
///
/// - ``adjustedFontSize(_:for:minimum:maximum:)``
///
/// ### Spacing Adjustments
///
/// - ``adjustedSpacing(_:for:scaleForAccessibility:)``
public enum DSAccessibilityAdjustments {
    
    /// Adjusts a font size based on Dynamic Type.
    ///
    /// - Parameters:
    ///   - baseSize: The base font size at default (Large) size.
    ///   - typeSize: The target ``DSDynamicTypeSize``.
    ///   - minimum: Optional minimum size to clamp to.
    ///   - maximum: Optional maximum size to clamp to.
    ///
    /// - Returns: The adjusted font size, clamped to min/max if provided.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Scale 17pt body text for accessibility sizes
    /// let size = DSAccessibilityAdjustments.adjustedFontSize(
    ///     17,
    ///     for: accessibility.dynamicTypeSize,
    ///     minimum: 14,
    ///     maximum: 48
    /// )
    /// ```
    public static func adjustedFontSize(
        _ baseSize: CGFloat,
        for typeSize: DSDynamicTypeSize,
        minimum: CGFloat? = nil,
        maximum: CGFloat? = nil
    ) -> CGFloat {
        var size = baseSize * typeSize.scaleFactor
        
        if let min = minimum {
            size = max(size, min)
        }
        if let max = maximum {
            size = min(size, max)
        }
        
        return size
    }
    
    /// Adjusts spacing based on Dynamic Type.
    ///
    /// - Parameters:
    ///   - baseSpacing: The base spacing value.
    ///   - typeSize: The target ``DSDynamicTypeSize``.
    ///   - scaleForAccessibility: Whether to scale up for accessibility sizes.
    ///     Defaults to `true`.
    ///
    /// - Returns: The adjusted spacing value.
    ///
    /// - Note: Spacing only scales for accessibility sizes (when ``DSDynamicTypeSize/isAccessibilitySize``
    ///   is `true`), and is capped at 1.5x the base spacing.
    public static func adjustedSpacing(
        _ baseSpacing: CGFloat,
        for typeSize: DSDynamicTypeSize,
        scaleForAccessibility: Bool = true
    ) -> CGFloat {
        guard scaleForAccessibility && typeSize.isAccessibilitySize else {
            return baseSpacing
        }
        
        // Scale spacing up for accessibility sizes, capped at 1.5x
        let factor = min(typeSize.scaleFactor, 1.5)
        return baseSpacing * factor
    }
}
