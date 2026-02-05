// DSFormRowSpec.swift
// DesignSystem
//
// Form row layout specification.
// Pure data — no SwiftUI views.

import SwiftUI
import DSCore

// MARK: - Form Row Layout Mode

/// Layout mode selection for form rows.
///
/// The `.auto` case delegates layout selection to the
/// platform capabilities, while explicit cases force a
/// specific layout regardless of platform.
///
/// ## Usage
///
/// ```swift
/// // Let the platform decide
/// let spec = DSFormRowSpec.resolve(
///     theme: theme,
///     layoutMode: .auto,
///     capabilities: capabilities
/// )
///
/// // Force stacked layout
/// let stackedSpec = DSFormRowSpec.resolve(
///     theme: theme,
///     layoutMode: .fixed(.stacked),
///     capabilities: capabilities
/// )
/// ```
public enum DSFormRowLayoutMode: Sendable, Equatable, Hashable {
    
    /// Automatically select layout based on platform capabilities.
    ///
    /// Delegates to ``DSCapabilities/preferredFormRowLayout``.
    case auto
    
    /// Force a specific layout regardless of platform.
    ///
    /// - Parameter layout: The layout to use.
    case fixed(DSFormRowLayout)
}

// MARK: - DSFormRowSpec

/// Resolved form row specification with concrete layout values.
///
/// `DSFormRowSpec` contains all layout and styling information needed
/// to render a form row, including resolved layout mode, spacing,
/// and dimensions.
///
/// ## Overview
///
/// Form rows adapt their layout based on platform capabilities:
///
/// | Platform | Default Layout | Label Position |
/// |----------|---------------|----------------|
/// | iOS | inline | Leading, control trailing |
/// | macOS | twoColumn | Fixed-width label column |
/// | watchOS | stacked | Label above, control below |
///
/// ## Properties
///
/// | Category | Properties |
/// |----------|-----------|
/// | Layout | ``resolvedLayout``, ``labelWidth``, ``labelAlignment`` |
/// | Spacing | ``horizontalSpacing``, ``verticalSpacing``, ``contentPadding`` |
/// | Row | ``minHeight``, ``separatorVisible``, ``separatorColor``, ``separatorInsets`` |
/// | Animation | ``animation`` |
///
/// ## Usage
///
/// ```swift
/// let spec = DSFormRowSpec.resolve(
///     theme: theme,
///     layoutMode: .auto,
///     capabilities: capabilities
/// )
///
/// switch spec.resolvedLayout {
/// case .stacked:
///     VStack(alignment: .leading, spacing: spec.verticalSpacing) {
///         labelView
///         controlView
///     }
///     .padding(spec.contentPadding)
/// case .inline:
///     HStack(spacing: spec.horizontalSpacing) {
///         labelView
///         Spacer()
///         controlView
///     }
///     .padding(spec.contentPadding)
/// case .twoColumn:
///     HStack(spacing: spec.horizontalSpacing) {
///         labelView
///             .frame(width: spec.labelWidth, alignment: spec.labelAlignment)
///         controlView
///     }
///     .padding(spec.contentPadding)
/// }
/// ```
///
/// ## Topics
///
/// ### Resolution
///
/// - ``resolve(theme:layoutMode:capabilities:)``
///
/// ### Configuration
///
/// - ``DSFormRowLayoutMode``
public struct DSFormRowSpec: DSSpec {
    
    // MARK: - Layout
    
    /// The resolved layout (after auto-degradation).
    public let resolvedLayout: DSFormRowLayout
    
    /// Fixed label width for two-column layout.
    ///
    /// `nil` for inline and stacked layouts.
    public let labelWidth: CGFloat?
    
    /// Label text alignment.
    public let labelAlignment: HorizontalAlignment
    
    // MARK: - Spacing
    
    /// Horizontal spacing between label and control (inline/twoColumn).
    public let horizontalSpacing: CGFloat
    
    /// Vertical spacing between label and control (stacked).
    public let verticalSpacing: CGFloat
    
    /// Content padding around the entire row.
    public let contentPadding: EdgeInsets
    
    // MARK: - Row
    
    /// Minimum row height.
    public let minHeight: CGFloat
    
    /// Whether to show a separator below the row.
    public let separatorVisible: Bool
    
    /// Separator line color.
    public let separatorColor: Color
    
    /// Separator leading/trailing insets.
    public let separatorInsets: EdgeInsets
    
    // MARK: - Animation
    
    /// Animation for layout transitions.
    public let animation: Animation?
    
    // MARK: - Initialization
    
    /// Creates a form row spec with explicit values.
    public init(
        resolvedLayout: DSFormRowLayout,
        labelWidth: CGFloat?,
        labelAlignment: HorizontalAlignment,
        horizontalSpacing: CGFloat,
        verticalSpacing: CGFloat,
        contentPadding: EdgeInsets,
        minHeight: CGFloat,
        separatorVisible: Bool,
        separatorColor: Color,
        separatorInsets: EdgeInsets,
        animation: Animation?
    ) {
        self.resolvedLayout = resolvedLayout
        self.labelWidth = labelWidth
        self.labelAlignment = labelAlignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.contentPadding = contentPadding
        self.minHeight = minHeight
        self.separatorVisible = separatorVisible
        self.separatorColor = separatorColor
        self.separatorInsets = separatorInsets
        self.animation = animation
    }
}

// MARK: - Resolution

extension DSFormRowSpec {
    
    /// Resolves a form row spec from theme, layout mode, and capabilities.
    ///
    /// When `layoutMode` is `.auto`, the resolved layout is determined
    /// by the platform capabilities. Otherwise, the fixed layout is used.
    ///
    /// - Parameters:
    ///   - theme: The current design system theme.
    ///   - layoutMode: Layout mode selection (auto or fixed).
    ///   - capabilities: The current platform capabilities.
    /// - Returns: A fully resolved ``DSFormRowSpec``.
    public static func resolve(
        theme: DSTheme,
        layoutMode: DSFormRowLayoutMode = .auto,
        capabilities: DSCapabilities
    ) -> DSFormRowSpec {
        // Resolve layout
        let layout: DSFormRowLayout
        switch layoutMode {
        case .auto:
            layout = capabilities.preferredFormRowLayout
        case .fixed(let fixedLayout):
            layout = fixedLayout
        }
        
        // Layout-specific values
        let labelWidth: CGFloat?
        let labelAlignment: HorizontalAlignment
        let horizontalSpacing: CGFloat
        let verticalSpacing: CGFloat
        
        switch layout {
        case .stacked:
            labelWidth = nil
            labelAlignment = .leading
            horizontalSpacing = 0
            verticalSpacing = theme.spacing.padding.xs
            
        case .inline:
            labelWidth = nil
            labelAlignment = .leading
            horizontalSpacing = theme.spacing.padding.m
            verticalSpacing = 0
            
        case .twoColumn:
            labelWidth = 140
            labelAlignment = .trailing
            horizontalSpacing = theme.spacing.padding.l
            verticalSpacing = 0
        }
        
        // Content padding
        let contentPadding = EdgeInsets(
            top: theme.spacing.padding.m,
            leading: theme.spacing.padding.l,
            bottom: theme.spacing.padding.m,
            trailing: theme.spacing.padding.l
        )
        
        // Min row height
        let minHeight: CGFloat
        if capabilities.prefersLargeTapTargets {
            minHeight = theme.spacing.rowHeight.default
        } else {
            minHeight = theme.spacing.rowHeight.compact
        }
        
        // Separator
        let separatorColor = theme.colors.border.separator
        let separatorInsets = EdgeInsets(
            top: 0,
            leading: theme.spacing.padding.l,
            bottom: 0,
            trailing: 0
        )
        
        return DSFormRowSpec(
            resolvedLayout: layout,
            labelWidth: labelWidth,
            labelAlignment: labelAlignment,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            contentPadding: contentPadding,
            minHeight: minHeight,
            separatorVisible: true,
            separatorColor: separatorColor,
            separatorInsets: separatorInsets,
            animation: theme.motion.spring.smooth
        )
    }
}
