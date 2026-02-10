// DSRequiredMarker.swift
// DesignSystem
//
// Required field asterisk marker with accessibility support.
// Displays a themed asterisk to indicate required form fields.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSRequiredMarker

/// A styled asterisk indicator for required form fields.
///
/// `DSRequiredMarker` displays a red asterisk (`*`) with proper
/// accessibility labeling. It is the standard way to indicate
/// required fields in the design system.
///
/// ## Overview
///
/// ```swift
/// HStack(spacing: 2) {
///     DSText("Email", role: .rowTitle)
///     DSRequiredMarker()
/// }
/// ```
///
/// ## Customization
///
/// The marker supports different sizes and custom colors:
///
/// ```swift
/// // Larger marker for headers
/// DSRequiredMarker(size: .large)
///
/// // Custom tint color
/// DSRequiredMarker(color: .orange)
/// ```
///
/// ## Accessibility
///
/// The marker is announced as "Required" by VoiceOver. When used
/// alongside a label, combine accessibility elements:
///
/// ```swift
/// HStack(spacing: 2) {
///     Text("Name")
///     DSRequiredMarker()
/// }
/// .accessibilityElement(children: .combine)
/// ```
///
/// ## Topics
///
/// ### Creating a Marker
///
/// - ``init(size:color:)``
///
/// ### Sizes
///
/// - ``DSRequiredMarkerSize``
public struct DSRequiredMarker: View {
    
    // MARK: - Properties
    
    /// The marker size.
    private let size: DSRequiredMarkerSize
    
    /// Optional color override. When nil, uses theme danger color.
    private let colorOverride: Color?
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    
    // MARK: - Initializer
    
    /// Creates a required field marker.
    ///
    /// - Parameters:
    ///   - size: The marker size. Defaults to ``DSRequiredMarkerSize/standard``.
    ///   - color: Optional color override. When `nil`, uses the theme's danger color.
    public init(
        size: DSRequiredMarkerSize = .standard,
        color: Color? = nil
    ) {
        self.size = size
        self.colorOverride = color
    }
    
    // MARK: - Body
    
    public var body: some View {
        Text("*")
            .font(size.font)
            .foregroundStyle(resolvedColor)
            .accessibilityLabel("Required")
            .accessibilityHidden(false)
    }
    
    // MARK: - Private
    
    private var resolvedColor: Color {
        colorOverride ?? theme.colors.state.danger
    }
}

// MARK: - DSRequiredMarkerSize

/// Size options for ``DSRequiredMarker``.
///
/// ## Overview
///
/// | Size | Font |
/// |------|------|
/// | ``small`` | caption1 |
/// | ``standard`` | footnote (semibold) |
/// | ``large`` | body (semibold) |
public enum DSRequiredMarkerSize: String, Sendable, Equatable, CaseIterable {
    
    /// Small marker for compact layouts.
    case small
    
    /// Standard marker size (default).
    case standard
    
    /// Large marker for headers and prominent labels.
    case large
    
    /// The font to use for this size.
    var font: Font {
        switch self {
        case .small:
            return .caption
        case .standard:
            return .footnote.weight(.semibold)
        case .large:
            return .body.weight(.semibold)
        }
    }
}

// MARK: - View Extension

extension View {
    
    /// Appends a required marker to this view if the field is required.
    ///
    /// Wraps the view in an HStack with a ``DSRequiredMarker`` when
    /// `isRequired` is `true`.
    ///
    /// ```swift
    /// DSText("Email", role: .rowTitle)
    ///     .dsRequired(true)
    /// ```
    ///
    /// - Parameter isRequired: Whether to show the required marker.
    /// - Returns: A view with an optional required marker appended.
    public func dsRequired(_ isRequired: Bool) -> some View {
        HStack(spacing: 2) {
            self
            if isRequired {
                DSRequiredMarker()
            }
        }
    }
}

// MARK: - Previews

#Preview("Sizes - Light") {
    VStack(alignment: .leading, spacing: 16) {
        ForEach(DSRequiredMarkerSize.allCases, id: \.rawValue) { size in
            HStack(spacing: 4) {
                Text("Field Label")
                DSRequiredMarker(size: size)
                Spacer()
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
    VStack(alignment: .leading, spacing: 16) {
        ForEach(DSRequiredMarkerSize.allCases, id: \.rawValue) { size in
            HStack(spacing: 4) {
                Text("Field Label")
                DSRequiredMarker(size: size)
                Spacer()
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

#Preview("With dsRequired Modifier") {
    VStack(alignment: .leading, spacing: 12) {
        DSText("Required Field", role: .rowTitle)
            .dsRequired(true)
        
        DSText("Optional Field", role: .rowTitle)
            .dsRequired(false)
    }
    .padding()
    .dsTheme(.light)
}

#Preview("Custom Color") {
    VStack(alignment: .leading, spacing: 12) {
        HStack(spacing: 2) {
            Text("Default (danger)")
            DSRequiredMarker()
        }
        
        HStack(spacing: 2) {
            Text("Custom (orange)")
            DSRequiredMarker(color: .orange)
        }
        
        HStack(spacing: 2) {
            Text("Custom (purple)")
            DSRequiredMarker(color: .purple)
        }
    }
    .padding()
    .dsTheme(.light)
}

#if os(watchOS)
#Preview("watchOS") {
    VStack(alignment: .leading, spacing: 8) {
        HStack(spacing: 2) {
            Text("Name")
            DSRequiredMarker()
        }
        HStack(spacing: 2) {
            Text("Email")
            DSRequiredMarker()
        }
    }
    .dsTheme(.dark)
}
#endif
