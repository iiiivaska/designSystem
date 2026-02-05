// DSCard.swift
// DesignSystem
//
// Elevated card container with shadow, border, and glass effect support.
// Uses DSCardSpec from the theme for consistent styling.

import SwiftUI
import DSCore
import DSTheme

// MARK: - DSCard

/// An elevated card container with theme-resolved styling.
///
/// `DSCard` resolves its visual properties from ``DSCardSpec`` in the
/// current theme, producing consistent elevation, shadows, borders,
/// and optional glass effects across light and dark themes.
///
/// ## Overview
///
/// Cards create visually distinct containers with depth. The elevation
/// level determines shadow intensity and background treatment:
///
/// ```swift
/// DSCard {
///     Text("Default raised card")
/// }
///
/// DSCard(.elevated) {
///     Text("Elevated card")
/// }
/// ```
///
/// ## Elevation Levels
///
/// | Level | Shadow | Background | Usage |
/// |-------|--------|------------|-------|
/// | ``DSCardElevation/flat`` | None | Card bg + border | Subtle containers |
/// | ``DSCardElevation/raised`` | Subtle | Card bg | Standard cards |
/// | ``DSCardElevation/elevated`` | Medium | Elevated bg | Prominent panels |
/// | ``DSCardElevation/overlay`` | Strong | Elevated bg | Floating panels |
///
/// ## Glass Effect (Dark Theme)
///
/// In dark mode, elevated and overlay cards use a glass/material
/// background effect with a semi-transparent border:
///
/// ```swift
/// DSCard(.elevated) {
///     Text("Glass card in dark mode")
/// }
/// .dsTheme(.dark)
/// ```
///
/// ## Custom Padding
///
/// Override the default padding from the spec:
///
/// ```swift
/// DSCard(.raised, padding: EdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16)) {
///     Text("Custom padding")
/// }
/// ```
///
/// ## Accessibility
///
/// `DSCard` acts as a visual container only. It does not add
/// accessibility traits. Ensure content inside cards has appropriate
/// labels and traits.
///
/// ## Topics
///
/// ### Creating Cards
///
/// - ``init(_:padding:content:)``
///
/// ### Elevation
///
/// - ``DSCardElevation``
///
/// ### Specification
///
/// - ``DSCardSpec``
public struct DSCard<Content: View>: View {

    // MARK: - Properties

    /// The card elevation level.
    private let elevation: DSCardElevation

    /// Optional padding override.
    private let paddingOverride: EdgeInsets?

    /// The card content.
    private let content: Content

    // MARK: - Environment

    @Environment(\.dsTheme) private var theme: DSTheme

    // MARK: - Initializer

    /// Creates a card with a specified elevation level.
    ///
    /// The card resolves its complete styling (background, border, shadow,
    /// corner radius, glass effect) from the current theme's card spec.
    ///
    /// - Parameters:
    ///   - elevation: The elevation level. Defaults to ``DSCardElevation/raised``.
    ///   - padding: Optional padding override. When `nil`, uses the spec's default padding.
    ///   - content: The content to display inside the card.
    public init(
        _ elevation: DSCardElevation = .raised,
        padding: EdgeInsets? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.paddingOverride = padding
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        let spec = theme.resolveCard(elevation: elevation)
        let insets = paddingOverride ?? spec.padding
        let shape = RoundedRectangle(cornerRadius: spec.cornerRadius, style: .continuous)

        content
            .padding(insets)
            .background {
                if spec.usesGlassEffect {
                    glassBackground(spec: spec, shape: shape)
                } else {
                    shape.fill(spec.backgroundColor)
                }
            }
            .clipShape(shape)
            .overlay {
                borderOverlay(spec: spec, shape: shape)
            }
            .shadow(
                color: spec.shadow.color,
                radius: spec.shadow.radius,
                x: spec.shadow.x,
                y: spec.shadow.y
            )
            .accessibilityElement(children: .contain)
    }

    // MARK: - Glass Effect

    /// Creates a glass/material background for dark theme elevated cards.
    @ViewBuilder
    private func glassBackground(spec: DSCardSpec, shape: RoundedRectangle) -> some View {
        ZStack {
            shape.fill(spec.backgroundColor.opacity(0.7))
            shape.fill(.ultraThinMaterial)
        }
    }

    // MARK: - Border

    /// Creates the border overlay, choosing glass or standard border.
    @ViewBuilder
    private func borderOverlay(spec: DSCardSpec, shape: RoundedRectangle) -> some View {
        if spec.usesGlassEffect {
            shape.stroke(
                spec.glassBorderColor,
                lineWidth: spec.borderWidth
            )
        } else if spec.borderWidth > 0 {
            shape.stroke(
                spec.borderColor,
                lineWidth: spec.borderWidth
            )
        }
    }
}

// MARK: - Previews

#Preview("Elevations - Light") {
    ScrollView {
        VStack(spacing: 24) {
            ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                DSCard(elevation) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(elevation.rawValue.capitalized)
                                .font(.headline)
                            Text("DSCard(.\(elevation.rawValue))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding()
    }
    .background(Color(hex: "#F7F8FA"))
    .dsTheme(.light)
}

#Preview("Elevations - Dark") {
    ScrollView {
        VStack(spacing: 24) {
            ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                DSCard(elevation) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(elevation.rawValue.capitalized)
                                .font(.headline)
                            Text("DSCard(.\(elevation.rawValue))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding()
    }
    .background(Color(hex: "#0B0E14"))
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Glass Effect Comparison") {
    HStack(spacing: 24) {
        VStack(spacing: 16) {
            Text("Light").font(.title3).fontWeight(.semibold)
            ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                DSCard(elevation) {
                    Text(elevation.rawValue.capitalized)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color(hex: "#F7F8FA"))
        .dsTheme(.light)
        .environment(\.colorScheme, .light)

        VStack(spacing: 16) {
            Text("Dark").font(.title3).fontWeight(.semibold)
            ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                DSCard(elevation) {
                    Text(elevation.rawValue.capitalized)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color(hex: "#0B0E14"))
        .dsTheme(.dark)
        .environment(\.colorScheme, .dark)
    }
}

#Preview("Card with Content - Light") {
    DSCard(.raised) {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("Featured")
                    .font(.headline)
                Spacer()
                Text("New")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.1))
                    .clipShape(Capsule())
            }
            Text("This is a sample card with rich content to demonstrate how DSCard handles complex layouts.")
                .font(.body)
                .foregroundStyle(.secondary)
            Divider()
            HStack {
                Text("Learn more")
                    .font(.callout)
                    .foregroundStyle(.blue)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
    .background(Color(hex: "#F7F8FA"))
    .dsTheme(.light)
}

#Preview("Card with Content - Dark") {
    DSCard(.elevated) {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("Featured")
                    .font(.headline)
                Spacer()
                Text("New")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.1))
                    .clipShape(Capsule())
            }
            Text("This is a sample card with rich content to demonstrate how DSCard handles complex layouts.")
                .font(.body)
                .foregroundStyle(.secondary)
            Divider()
            HStack {
                Text("Learn more")
                    .font(.callout)
                    .foregroundStyle(.blue)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
    .background(Color(hex: "#0B0E14"))
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Custom Padding") {
    VStack(spacing: 16) {
        DSCard(.raised, padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)) {
            Text("Compact padding")
                .frame(maxWidth: .infinity)
        }
        DSCard(.raised) {
            Text("Default padding")
                .frame(maxWidth: .infinity)
        }
        DSCard(.raised, padding: EdgeInsets(top: 32, leading: 24, bottom: 32, trailing: 24)) {
            Text("Spacious padding")
                .frame(maxWidth: .infinity)
        }
    }
    .padding()
    .background(Color(hex: "#F7F8FA"))
    .dsTheme(.light)
}
