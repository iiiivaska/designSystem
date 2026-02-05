// DSSurface.swift
// DesignSystem
//
// Semantic background container that resolves its color from the theme.
// Use DSSurface to wrap content with proper background layering.

import SwiftUI
import DSCore
import DSTheme

// MARK: - Surface Role

/// Semantic background role for ``DSSurface``.
///
/// Determines which background color from the theme is applied.
///
/// ## Overview
///
/// | Role | Purpose | Light | Dark |
/// |------|---------|-------|------|
/// | ``canvas`` | Root/window background | N1 | D1 |
/// | ``surface`` | Primary content area | N0 | D2 |
/// | ``surfaceElevated`` | Elevated content | N0 | D3 |
/// | ``card`` | Card containers | N0 | D3 |
///
/// ## Usage
///
/// ```swift
/// DSSurface(.canvas) {
///     VStack {
///         DSSurface(.card) {
///             Text("Card content")
///         }
///     }
/// }
/// ```
public enum DSSurfaceRole: String, Sendable, Equatable, CaseIterable, Identifiable {

    /// Root/window background.
    ///
    /// The base layer color for the entire screen or window.
    case canvas

    /// Primary content area background.
    ///
    /// Sits above canvas for primary content surfaces.
    case surface

    /// Elevated surface background.
    ///
    /// Surfaces with visual elevation (panels, popovers).
    case surfaceElevated

    /// Card container background.
    ///
    /// Background for card components and grouped content.
    case card

    public var id: String { rawValue }

    /// A human-readable display name for this role.
    public var displayName: String {
        switch self {
        case .canvas: return "Canvas"
        case .surface: return "Surface"
        case .surfaceElevated: return "Surface Elevated"
        case .card: return "Card"
        }
    }

    /// Resolves the background color from the given theme.
    ///
    /// - Parameter theme: The current design system theme.
    /// - Returns: The resolved `Color` for this surface role.
    public func resolveColor(from theme: DSTheme) -> Color {
        switch self {
        case .canvas:
            return theme.colors.bg.canvas
        case .surface:
            return theme.colors.bg.surface
        case .surfaceElevated:
            return theme.colors.bg.surfaceElevated
        case .card:
            return theme.colors.bg.card
        }
    }
}

// MARK: - DSSurface

/// A semantic background container that uses theme colors.
///
/// `DSSurface` wraps content with a background color resolved from
/// the current theme's background roles. It provides consistent
/// layering across light and dark themes.
///
/// ## Overview
///
/// Use `DSSurface` to create properly themed background regions.
/// The component automatically adapts to light/dark mode and
/// theme changes.
///
/// ```swift
/// DSSurface(.canvas) {
///     VStack(spacing: 16) {
///         DSSurface(.card) {
///             Text("Card content")
///                 .padding()
///         }
///         .clipShape(RoundedRectangle(cornerRadius: 14))
///     }
///     .padding()
/// }
/// ```
///
/// ## Stroke
///
/// Optionally add a border stroke to the surface:
///
/// ```swift
/// DSSurface(.card, stroke: true) {
///     Text("Bordered card")
///         .padding()
/// }
/// ```
///
/// ## Accessibility
///
/// `DSSurface` is semantically transparent to accessibility — it
/// does not add any accessibility traits. The wrapped content
/// retains its own accessibility properties.
///
/// ## Topics
///
/// ### Creating Surfaces
///
/// - ``init(_:stroke:cornerRadius:content:)``
///
/// ### Roles
///
/// - ``DSSurfaceRole``
public struct DSSurface<Content: View>: View {

    // MARK: - Properties

    /// The semantic background role.
    private let role: DSSurfaceRole

    /// Whether to show a subtle border stroke.
    private let stroke: Bool

    /// Optional corner radius override.
    private let cornerRadius: CGFloat?

    /// The content to wrap.
    private let content: Content

    // MARK: - Environment

    @Environment(\.dsTheme) private var theme: DSTheme

    // MARK: - Initializer

    /// Creates a surface container with a semantic background role.
    ///
    /// - Parameters:
    ///   - role: The background role from the theme. Defaults to ``DSSurfaceRole/surface``.
    ///   - stroke: Whether to add a subtle border stroke. Defaults to `false`.
    ///   - cornerRadius: Optional corner radius. When `nil`, no clipping is applied.
    ///   - content: The content to wrap.
    public init(
        _ role: DSSurfaceRole = .surface,
        stroke: Bool = false,
        cornerRadius: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.role = role
        self.stroke = stroke
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        let bgColor = role.resolveColor(from: theme)

        if let radius = cornerRadius {
            let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
            content
                .background(bgColor)
                .clipShape(shape)
                .overlay {
                    if stroke {
                        shape
                            .stroke(
                                theme.shadows.stroke.default.color,
                                lineWidth: theme.shadows.stroke.default.width
                            )
                    }
                }
        } else {
            content
                .background(bgColor)
                .overlay {
                    if stroke {
                        Rectangle()
                            .stroke(
                                theme.shadows.stroke.default.color,
                                lineWidth: theme.shadows.stroke.default.width
                            )
                    }
                }
        }
    }
}

// MARK: - Previews

#Preview("Surface Roles - Light") {
    VStack(spacing: 0) {
        ForEach(DSSurfaceRole.allCases) { role in
            DSSurface(role) {
                HStack {
                    Text(role.displayName)
                        .font(.headline)
                    Spacer()
                    Text(role.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        }
    }
    .dsTheme(.light)
}

#Preview("Surface Roles - Dark") {
    VStack(spacing: 0) {
        ForEach(DSSurfaceRole.allCases) { role in
            DSSurface(role) {
                HStack {
                    Text(role.displayName)
                        .font(.headline)
                    Spacer()
                    Text(role.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        }
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Surface with Stroke - Light") {
    DSSurface(.canvas) {
        VStack(spacing: 16) {
            DSSurface(.card, stroke: true, cornerRadius: 14) {
                Text("Card with stroke")
                    .padding()
            }
            DSSurface(.surfaceElevated, stroke: true, cornerRadius: 10) {
                Text("Elevated with stroke")
                    .padding()
            }
        }
        .padding()
    }
    .dsTheme(.light)
}

#Preview("Surface with Stroke - Dark") {
    DSSurface(.canvas) {
        VStack(spacing: 16) {
            DSSurface(.card, stroke: true, cornerRadius: 14) {
                Text("Card with stroke")
                    .padding()
            }
            DSSurface(.surfaceElevated, stroke: true, cornerRadius: 10) {
                Text("Elevated with stroke")
                    .padding()
            }
        }
        .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Nested Surfaces - Light") {
    DSSurface(.canvas) {
        VStack(spacing: 16) {
            DSSurface(.surface, cornerRadius: 14) {
                VStack(spacing: 12) {
                    DSSurface(.card, stroke: true, cornerRadius: 10) {
                        Text("Inner card")
                            .padding()
                    }
                    DSSurface(.card, stroke: true, cornerRadius: 10) {
                        Text("Another card")
                            .padding()
                    }
                }
                .padding()
            }
        }
        .padding()
    }
    .dsTheme(.light)
}

#Preview("Nested Surfaces - Dark") {
    DSSurface(.canvas) {
        VStack(spacing: 16) {
            DSSurface(.surface, cornerRadius: 14) {
                VStack(spacing: 12) {
                    DSSurface(.card, stroke: true, cornerRadius: 10) {
                        Text("Inner card")
                            .padding()
                    }
                    DSSurface(.card, stroke: true, cornerRadius: 10) {
                        Text("Another card")
                            .padding()
                    }
                }
                .padding()
            }
        }
        .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
