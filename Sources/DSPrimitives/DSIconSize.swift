// DSIconSize.swift
// DesignSystem
//
// Size tokens for DSIcon component.

import SwiftUI

// MARK: - DSIconSize

/// Size variants for ``DSIcon``.
///
/// Each size defines a consistent icon dimension used throughout
/// the design system. Sizes are designed to work harmoniously
/// with text styles and control heights.
///
/// ## Overview
///
/// | Size | Points | Usage |
/// |------|--------|-------|
/// | ``small`` | 16pt | Inline icons, badges |
/// | ``medium`` | 20pt | Standard icons, buttons |
/// | ``large`` | 24pt | Prominent icons, navigation |
/// | ``xl`` | 32pt | Feature icons, empty states |
///
/// ## Usage
///
/// ```swift
/// DSIcon("star.fill", size: .medium)
/// DSIcon("chevron.right", size: .small)
/// ```
///
/// ## Topics
///
/// ### Sizes
///
/// - ``small``
/// - ``medium``
/// - ``large``
/// - ``xl``
///
/// ### Properties
///
/// - ``points``
/// - ``font``
public enum DSIconSize: String, Sendable, Equatable, CaseIterable, Identifiable {
    
    /// Small icon size (16pt).
    ///
    /// Used for inline icons next to text, badges, and compact UI elements.
    case small
    
    /// Medium icon size (20pt).
    ///
    /// The default icon size. Used for standard buttons, controls,
    /// and list accessories.
    case medium
    
    /// Large icon size (24pt).
    ///
    /// Used for prominent icons in navigation, cards, and headers.
    case large
    
    /// Extra-large icon size (32pt).
    ///
    /// Used for feature icons, empty states, and onboarding illustrations.
    case xl
    
    // MARK: - Identifiable
    
    /// The unique identifier for this size.
    public var id: String { rawValue }
    
    // MARK: - Dimensions
    
    /// The icon dimension in points.
    public var points: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 20
        case .large: return 24
        case .xl: return 32
        }
    }
    
    /// A SwiftUI `Font` appropriate for this icon size.
    ///
    /// Uses `.system(size:)` to match the icon dimension.
    public var font: Font {
        .system(size: points)
    }
    
    /// Human-readable display name.
    public var displayName: String {
        switch self {
        case .small: return "Small (16pt)"
        case .medium: return "Medium (20pt)"
        case .large: return "Large (24pt)"
        case .xl: return "XL (32pt)"
        }
    }
}
