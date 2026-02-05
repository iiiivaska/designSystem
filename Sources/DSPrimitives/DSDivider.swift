// DSDivider.swift
// DesignSystem
//
// Themed divider with horizontal and vertical orientation.
// Uses the separator color from the current theme.

import SwiftUI
import DSCore
import DSTheme

// MARK: - Divider Orientation

/// Orientation for ``DSDivider``.
///
/// Determines whether the divider is rendered horizontally
/// or vertically.
public enum DSDividerOrientation: Sendable, Equatable {

    /// Horizontal divider (default).
    ///
    /// Stretches the full available width with a fixed height.
    case horizontal

    /// Vertical divider.
    ///
    /// Stretches the full available height with a fixed width.
    case vertical
}

// MARK: - DSDivider

/// A themed divider line with configurable orientation and thickness.
///
/// `DSDivider` uses the current theme's separator color and stroke
/// width for consistent visual separation across your app.
///
/// ## Overview
///
/// Use `DSDivider` instead of the system `Divider()` to ensure
/// consistent colors and thickness from the design system theme.
///
/// ```swift
/// VStack {
///     Text("Above")
///     DSDivider()
///     Text("Below")
/// }
/// ```
///
/// ## Orientation
///
/// By default, the divider is horizontal. Use ``DSDividerOrientation/vertical``
/// for vertical dividers:
///
/// ```swift
/// HStack {
///     Text("Left")
///     DSDivider(.vertical)
///     Text("Right")
/// }
/// ```
///
/// ## Insets
///
/// Add horizontal insets to align with content padding:
///
/// ```swift
/// DSDivider(insets: 16)
/// ```
///
/// ## Accessibility
///
/// `DSDivider` is hidden from accessibility by default since
/// it is purely decorative.
///
/// ## Topics
///
/// ### Creating Dividers
///
/// - ``init(_:insets:)``
///
/// ### Orientation
///
/// - ``DSDividerOrientation``
public struct DSDivider: View {

    // MARK: - Properties

    /// The divider orientation.
    private let orientation: DSDividerOrientation

    /// Leading/trailing insets for horizontal, top/bottom for vertical.
    private let insets: CGFloat

    // MARK: - Environment

    @Environment(\.dsTheme) private var theme: DSTheme

    // MARK: - Initializer

    /// Creates a themed divider.
    ///
    /// - Parameters:
    ///   - orientation: The divider orientation. Defaults to ``DSDividerOrientation/horizontal``.
    ///   - insets: Inset from the edges. Defaults to `0`.
    public init(
        _ orientation: DSDividerOrientation = .horizontal,
        insets: CGFloat = 0
    ) {
        self.orientation = orientation
        self.insets = insets
    }

    // MARK: - Body

    public var body: some View {
        let strokeStyle = theme.shadows.stroke.separator

        switch orientation {
        case .horizontal:
            Rectangle()
                .fill(strokeStyle.color)
                .frame(height: max(strokeStyle.width, 1.0 / UIScale.main))
                .frame(maxWidth: .infinity)
                .padding(.horizontal, insets)
                .accessibilityHidden(true)

        case .vertical:
            Rectangle()
                .fill(strokeStyle.color)
                .frame(width: max(strokeStyle.width, 1.0 / UIScale.main))
                .frame(maxHeight: .infinity)
                .padding(.vertical, insets)
                .accessibilityHidden(true)
        }
    }
}

// MARK: - UIScale Helper

/// Cross-platform helper to get the display scale factor.
private enum UIScale {
    /// The main display scale (points-to-pixels ratio).
    ///
    /// Returns 2.0 as a sensible default if the actual scale
    /// cannot be determined.
    static var main: CGFloat {
        #if os(watchOS)
        return WKInterfaceDevice.current().screenScale
        #elseif os(macOS)
        return NSScreen.main?.backingScaleFactor ?? 2.0
        #else
        return UIScreen.main.scale
        #endif
    }
}

// MARK: - Previews

#Preview("Horizontal - Light") {
    VStack(spacing: 16) {
        Text("Section A")
            .font(.headline)
        DSDivider()
        Text("Section B")
            .font(.headline)
        DSDivider(insets: 16)
        Text("Section C (inset divider)")
            .font(.headline)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Horizontal - Dark") {
    VStack(spacing: 16) {
        Text("Section A")
            .font(.headline)
        DSDivider()
        Text("Section B")
            .font(.headline)
        DSDivider(insets: 16)
        Text("Section C (inset divider)")
            .font(.headline)
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Vertical - Light") {
    HStack(spacing: 16) {
        Text("Left")
        DSDivider(.vertical)
        Text("Center")
        DSDivider(.vertical, insets: 4)
        Text("Right")
    }
    .frame(height: 60)
    .padding()
    .dsTheme(.light)
}

#Preview("Vertical - Dark") {
    HStack(spacing: 16) {
        Text("Left")
        DSDivider(.vertical)
        Text("Center")
        DSDivider(.vertical, insets: 4)
        Text("Right")
    }
    .frame(height: 60)
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("In Card Context - Light") {
    DSCard(.raised) {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Item 1")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)

            DSDivider()

            HStack {
                Text("Item 2")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)

            DSDivider()

            HStack {
                Text("Item 3")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
        }
    }
    .padding()
    .background(Color(hex: "#F7F8FA"))
    .dsTheme(.light)
}

#Preview("In Card Context - Dark") {
    DSCard(.raised) {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Item 1")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)

            DSDivider()

            HStack {
                Text("Item 2")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)

            DSDivider()

            HStack {
                Text("Item 3")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
        }
    }
    .padding()
    .background(Color(hex: "#0B0E14"))
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
