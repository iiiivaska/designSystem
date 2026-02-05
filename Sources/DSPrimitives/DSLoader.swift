// DSLoader.swift
// DesignSystem
//
// Indeterminate loading spinner with theme integration.
// Respects reduce motion and uses accent color from the theme.

import SwiftUI
import DSCore
import DSTheme

// MARK: - DSLoaderSize

/// Size variants for ``DSLoader``.
///
/// Each size matches the corresponding ``DSIconSize`` dimensions
/// for visual consistency when used alongside icons.
///
/// ## Overview
///
/// | Size | Points | Usage |
/// |------|--------|-------|
/// | ``small`` | 16pt | Inline indicators, badges |
/// | ``medium`` | 20pt | Standard loader, buttons |
/// | ``large`` | 24pt | Prominent loading states |
/// | ``xl`` | 32pt | Full-screen or section loading |
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
/// - ``lineWidth``
public enum DSLoaderSize: String, Sendable, Equatable, CaseIterable, Identifiable {
    
    /// Small loader size (16pt).
    ///
    /// Used for inline loading indicators next to text or in badges.
    case small
    
    /// Medium loader size (20pt).
    ///
    /// The default loader size. Used in buttons and standard controls.
    case medium
    
    /// Large loader size (24pt).
    ///
    /// Used for prominent loading states in cards and sections.
    case large
    
    /// Extra-large loader size (32pt).
    ///
    /// Used for full-screen or section-level loading indicators.
    case xl
    
    // MARK: - Identifiable
    
    /// The unique identifier for this size.
    public var id: String { rawValue }
    
    // MARK: - Dimensions
    
    /// The loader dimension in points.
    public var points: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 20
        case .large: return 24
        case .xl: return 32
        }
    }
    
    /// The stroke line width for this size.
    public var lineWidth: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 2.5
        case .large: return 3
        case .xl: return 3.5
        }
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

// MARK: - DSLoaderColor

/// Color mode for ``DSLoader``.
///
/// Determines how the loader color is resolved from the theme.
public enum DSLoaderColor: Sendable, Equatable {
    
    /// Primary accent color from theme.
    case accent
    
    /// Primary foreground color from theme.
    case primary
    
    /// Secondary foreground color from theme.
    case secondary
    
    /// A custom color override.
    case custom(Color)
    
    /// Resolves this color mode to a concrete `Color` using the theme.
    ///
    /// - Parameter theme: The current theme.
    /// - Returns: The resolved color.
    public func resolve(from theme: DSTheme) -> Color {
        switch self {
        case .accent: return theme.colors.accent.primary
        case .primary: return theme.colors.fg.primary
        case .secondary: return theme.colors.fg.secondary
        case .custom(let color): return color
        }
    }
}

// MARK: - DSLoader

/// An indeterminate loading spinner with theme integration.
///
/// `DSLoader` provides a spinning indicator that communicates
/// ongoing activity. It uses the theme's accent color by default
/// and respects the reduce motion accessibility preference.
///
/// ## Overview
///
/// ```swift
/// // Default spinner
/// DSLoader()
///
/// // With specific size
/// DSLoader(size: .large)
///
/// // With custom color
/// DSLoader(size: .medium, color: .secondary)
///
/// // Custom color override
/// DSLoader(color: .custom(.purple))
/// ```
///
/// ## Sizes
///
/// Sizes match ``DSIconSize`` for consistency:
///
/// | Size | Points | Line Width |
/// |------|--------|------------|
/// | ``DSLoaderSize/small`` | 16pt | 2pt |
/// | ``DSLoaderSize/medium`` | 20pt | 2.5pt |
/// | ``DSLoaderSize/large`` | 24pt | 3pt |
/// | ``DSLoaderSize/xl`` | 32pt | 3.5pt |
///
/// ## Accessibility
///
/// - Announces as "Loading" to VoiceOver
/// - When reduce motion is enabled, the spinner uses a pulsing
///   opacity animation instead of rotation
///
/// ## Topics
///
/// ### Creating Loaders
///
/// - ``init(size:color:)``
///
/// ### Sizing
///
/// - ``DSLoaderSize``
///
/// ### Coloring
///
/// - ``DSLoaderColor``
public struct DSLoader: View {
    
    // MARK: - Properties
    
    /// The loader size.
    private let size: DSLoaderSize
    
    /// The loader color mode.
    private let color: DSLoaderColor
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    
    // MARK: - State
    
    @State private var isAnimating = false
    
    // MARK: - Initializer
    
    /// Creates a design system loading spinner.
    ///
    /// - Parameters:
    ///   - size: The loader size. Defaults to ``DSLoaderSize/medium``.
    ///   - color: The loader color mode. Defaults to ``DSLoaderColor/accent``.
    public init(
        size: DSLoaderSize = .medium,
        color: DSLoaderColor = .accent
    ) {
        self.size = size
        self.color = color
    }
    
    // MARK: - Body
    
    public var body: some View {
        if theme.motion.reduceMotionEnabled {
            reducedMotionView
        } else {
            spinnerView
        }
    }
    
    // MARK: - Standard Spinner
    
    /// The rotating arc spinner used when motion is not reduced.
    private var spinnerView: some View {
        Circle()
            .trim(from: 0.0, to: 0.7)
            .stroke(
                color.resolve(from: theme),
                style: StrokeStyle(
                    lineWidth: size.lineWidth,
                    lineCap: .round
                )
            )
            .frame(width: size.points, height: size.points)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 0.85)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
            .accessibilityLabel(Text("Loading"))
            .accessibilityAddTraits(.updatesFrequently)
    }
    
    // MARK: - Reduced Motion
    
    /// A pulsing opacity view used when reduce motion is enabled.
    private var reducedMotionView: some View {
        Circle()
            .trim(from: 0.0, to: 0.7)
            .stroke(
                color.resolve(from: theme),
                style: StrokeStyle(
                    lineWidth: size.lineWidth,
                    lineCap: .round
                )
            )
            .frame(width: size.points, height: size.points)
            .opacity(isAnimating ? 0.3 : 1.0)
            .animation(
                .easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
            .accessibilityLabel(Text("Loading"))
    }
}

// MARK: - Previews

#Preview("Sizes - Light") {
    HStack(spacing: 24) {
        ForEach(DSLoaderSize.allCases) { size in
            VStack(spacing: 8) {
                DSLoader(size: size)
                Text(size.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Sizes - Dark") {
    HStack(spacing: 24) {
        ForEach(DSLoaderSize.allCases) { size in
            VStack(spacing: 8) {
                DSLoader(size: size)
                Text(size.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Colors - Light") {
    VStack(spacing: 16) {
        HStack(spacing: 24) {
            VStack(spacing: 8) {
                DSLoader(size: .large, color: .accent)
                Text("Accent")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 8) {
                DSLoader(size: .large, color: .primary)
                Text("Primary")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 8) {
                DSLoader(size: .large, color: .secondary)
                Text("Secondary")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 8) {
                DSLoader(size: .large, color: .custom(.purple))
                Text("Custom")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Colors - Dark") {
    VStack(spacing: 16) {
        HStack(spacing: 24) {
            VStack(spacing: 8) {
                DSLoader(size: .large, color: .accent)
                Text("Accent")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 8) {
                DSLoader(size: .large, color: .primary)
                Text("Primary")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 8) {
                DSLoader(size: .large, color: .secondary)
                Text("Secondary")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Reduce Motion") {
    HStack(spacing: 24) {
        ForEach(DSLoaderSize.allCases) { size in
            DSLoader(size: size)
        }
    }
    .padding()
    .dsTheme(DSTheme(variant: .light, reduceMotion: true))
}

#Preview("In Context - Button Loading") {
    HStack(spacing: 8) {
        DSLoader(size: .small, color: .custom(.white))
        Text("Loading...")
            .font(.body)
            .foregroundStyle(.white)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 10)
    .background(.teal, in: RoundedRectangle(cornerRadius: 10))
    .padding()
    .dsTheme(.light)
}
