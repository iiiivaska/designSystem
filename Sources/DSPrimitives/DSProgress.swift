// DSProgress.swift
// DesignSystem
//
// Progress indicators: linear bar and circular ring.
// Uses theme accent color and respects reduce motion.

import SwiftUI
import DSCore
import DSTheme

// MARK: - DSProgressStyle

/// Visual style for ``DSProgress``.
///
/// Determines whether the progress indicator is displayed
/// as a linear bar or a circular ring.
///
/// ## Topics
///
/// ### Styles
///
/// - ``linear``
/// - ``circular``
public enum DSProgressStyle: String, Sendable, Equatable, CaseIterable, Identifiable {
    
    /// A horizontal linear progress bar.
    case linear
    
    /// A circular progress ring.
    case circular
    
    /// The unique identifier for this style.
    public var id: String { rawValue }
}

// MARK: - DSProgressSize

/// Size variants for ``DSProgress``.
///
/// Controls the dimensions of both linear and circular styles.
///
/// ## Overview
///
/// ### Linear
///
/// | Size | Height |
/// |------|--------|
/// | ``small`` | 4pt |
/// | ``medium`` | 6pt |
/// | ``large`` | 8pt |
///
/// ### Circular
///
/// | Size | Diameter | Line Width |
/// |------|----------|------------|
/// | ``small`` | 20pt | 2.5pt |
/// | ``medium`` | 32pt | 3pt |
/// | ``large`` | 48pt | 4pt |
///
/// ## Topics
///
/// ### Sizes
///
/// - ``small``
/// - ``medium``
/// - ``large``
public enum DSProgressSize: String, Sendable, Equatable, CaseIterable, Identifiable {
    
    /// Small progress indicator.
    case small
    
    /// Medium progress indicator (default).
    case medium
    
    /// Large progress indicator.
    case large
    
    /// The unique identifier for this size.
    public var id: String { rawValue }
    
    // MARK: - Linear Dimensions
    
    /// Height of the linear progress bar.
    public var linearHeight: CGFloat {
        switch self {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        }
    }
    
    /// Corner radius of the linear progress bar.
    public var linearCornerRadius: CGFloat {
        linearHeight / 2
    }
    
    // MARK: - Circular Dimensions
    
    /// Diameter of the circular progress ring.
    public var circularDiameter: CGFloat {
        switch self {
        case .small: return 20
        case .medium: return 32
        case .large: return 48
        }
    }
    
    /// Stroke width of the circular progress ring.
    public var circularLineWidth: CGFloat {
        switch self {
        case .small: return 2.5
        case .medium: return 3
        case .large: return 4
        }
    }
    
    /// Human-readable display name.
    public var displayName: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
}

// MARK: - DSProgress

/// A determinate progress indicator with theme integration.
///
/// `DSProgress` shows a visual representation of progress towards
/// completion. It supports both linear (bar) and circular (ring)
/// styles, uses the theme's accent color, and respects the reduce
/// motion accessibility preference.
///
/// ## Overview
///
/// ```swift
/// // Linear progress bar
/// DSProgress(value: 0.6)
///
/// // Circular progress ring
/// DSProgress(value: downloadProgress, style: .circular)
///
/// // Custom size and color
/// DSProgress(value: 0.75, style: .linear, size: .large, color: .custom(.green))
/// ```
///
/// ## Styles
///
/// - ``DSProgressStyle/linear``: A horizontal bar filling left to right
/// - ``DSProgressStyle/circular``: A ring filling clockwise from top
///
/// ## Accessibility
///
/// - VoiceOver announces the percentage value
/// - Updates are marked with `.updatesFrequently` when animating
/// - Reduce motion uses instant transitions instead of animated fill
///
/// ## Topics
///
/// ### Creating Progress Indicators
///
/// - ``init(value:style:size:color:)``
///
/// ### Styles
///
/// - ``DSProgressStyle``
///
/// ### Sizes
///
/// - ``DSProgressSize``
///
/// ### Colors
///
/// - ``DSLoaderColor``
public struct DSProgress: View {
    
    // MARK: - Properties
    
    /// The progress value (0.0 to 1.0).
    private let value: Double
    
    /// The visual style.
    private let style: DSProgressStyle
    
    /// The indicator size.
    private let size: DSProgressSize
    
    /// The fill color mode.
    private let color: DSLoaderColor
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    
    // MARK: - Initializer
    
    /// Creates a determinate progress indicator.
    ///
    /// - Parameters:
    ///   - value: The progress value from 0.0 (empty) to 1.0 (complete).
    ///     Values are clamped to this range.
    ///   - style: The visual style. Defaults to ``DSProgressStyle/linear``.
    ///   - size: The indicator size. Defaults to ``DSProgressSize/medium``.
    ///   - color: The fill color mode. Defaults to ``DSLoaderColor/accent``.
    public init(
        value: Double,
        style: DSProgressStyle = .linear,
        size: DSProgressSize = .medium,
        color: DSLoaderColor = .accent
    ) {
        self.value = min(max(value, 0), 1)
        self.style = style
        self.size = size
        self.color = color
    }
    
    // MARK: - Body
    
    public var body: some View {
        switch style {
        case .linear:
            linearProgress
        case .circular:
            circularProgress
        }
    }
    
    // MARK: - Linear Progress
    
    /// A horizontal linear progress bar.
    private var linearProgress: some View {
        let resolvedColor = color.resolve(from: theme)
        let trackColor = theme.colors.border.subtle
        let animation: Animation? = theme.motion.reduceMotionEnabled ? nil : .easeInOut(duration: theme.motion.duration.normal)
        
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: size.linearCornerRadius)
                    .fill(trackColor)
                
                // Fill
                RoundedRectangle(cornerRadius: size.linearCornerRadius)
                    .fill(resolvedColor)
                    .frame(width: geometry.size.width * value)
                    .animation(animation, value: value)
            }
        }
        .frame(height: size.linearHeight)
        .accessibilityValue(Text("\(Int(value * 100)) percent"))
        .accessibilityLabel(Text("Progress"))
        .accessibilityAddTraits(.updatesFrequently)
    }
    
    // MARK: - Circular Progress
    
    /// A circular progress ring.
    private var circularProgress: some View {
        let resolvedColor = color.resolve(from: theme)
        let trackColor = theme.colors.border.subtle
        let animation: Animation? = theme.motion.reduceMotionEnabled ? nil : .easeInOut(duration: theme.motion.duration.normal)
        
        return ZStack {
            // Track ring
            Circle()
                .stroke(
                    trackColor,
                    style: StrokeStyle(
                        lineWidth: size.circularLineWidth,
                        lineCap: .round
                    )
                )
            
            // Fill ring
            Circle()
                .trim(from: 0, to: value)
                .stroke(
                    resolvedColor,
                    style: StrokeStyle(
                        lineWidth: size.circularLineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(animation, value: value)
        }
        .frame(width: size.circularDiameter, height: size.circularDiameter)
        .accessibilityValue(Text("\(Int(value * 100)) percent"))
        .accessibilityLabel(Text("Progress"))
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Previews

#Preview("Linear - Light") {
    VStack(spacing: 16) {
        ForEach(DSProgressSize.allCases) { size in
            VStack(alignment: .leading, spacing: 4) {
                Text(size.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                DSProgress(value: 0.6, style: .linear, size: size)
            }
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Linear - Dark") {
    VStack(spacing: 16) {
        ForEach(DSProgressSize.allCases) { size in
            VStack(alignment: .leading, spacing: 4) {
                Text(size.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                DSProgress(value: 0.6, style: .linear, size: size)
            }
        }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Circular - Light") {
    HStack(spacing: 24) {
        ForEach(DSProgressSize.allCases) { size in
            VStack(spacing: 8) {
                DSProgress(value: 0.7, style: .circular, size: size)
                Text(size.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Circular - Dark") {
    HStack(spacing: 24) {
        ForEach(DSProgressSize.allCases) { size in
            VStack(spacing: 8) {
                DSProgress(value: 0.7, style: .circular, size: size)
                Text(size.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    .padding()
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Progress Values") {
    VStack(spacing: 16) {
        ForEach([0.0, 0.25, 0.5, 0.75, 1.0], id: \.self) { val in
            HStack {
                Text("\(Int(val * 100))%")
                    .font(.caption)
                    .frame(width: 40, alignment: .trailing)
                DSProgress(value: val, style: .linear, size: .medium)
            }
        }
        
        Divider()
        
        HStack(spacing: 16) {
            ForEach([0.0, 0.25, 0.5, 0.75, 1.0], id: \.self) { val in
                VStack(spacing: 4) {
                    DSProgress(value: val, style: .circular, size: .small)
                    Text("\(Int(val * 100))%")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Colors") {
    VStack(spacing: 16) {
        DSProgress(value: 0.6, style: .linear, color: .accent)
        DSProgress(value: 0.6, style: .linear, color: .primary)
        DSProgress(value: 0.6, style: .linear, color: .secondary)
        DSProgress(value: 0.6, style: .linear, color: .custom(.green))
        DSProgress(value: 0.6, style: .linear, color: .custom(.orange))
        
        Divider()
        
        HStack(spacing: 16) {
            DSProgress(value: 0.7, style: .circular, size: .medium, color: .accent)
            DSProgress(value: 0.7, style: .circular, size: .medium, color: .primary)
            DSProgress(value: 0.7, style: .circular, size: .medium, color: .custom(.green))
        }
    }
    .padding()
    .dsTheme(.light)
}

#Preview("In Context - Download") {
    VStack(alignment: .leading, spacing: 12) {
        HStack {
            DSProgress(value: 0.65, style: .circular, size: .small, color: .accent)
            VStack(alignment: .leading, spacing: 2) {
                Text("Downloading update...")
                    .font(.body)
                Text("65% complete")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        
        DSProgress(value: 0.65, style: .linear, size: .small, color: .accent)
    }
    .padding()
    .dsTheme(.light)
}
