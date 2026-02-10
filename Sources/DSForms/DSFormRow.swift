// DSFormRow.swift
// DesignSystem
//
// Flexible form row layout component with inline/stacked/twoColumn modes.
// Uses slot-based architecture: label, control, accessory, footer.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

#if os(watchOS)
import WatchKit
#endif

// MARK: - DSFormRow

/// A flexible form row that arranges label and control content according
/// to the current layout mode.
///
/// `DSFormRow` is the building block for form-based UIs. It provides
/// a slot-based architecture with four configurable areas: **label**,
/// **control**, **accessory**, and **footer**.
///
/// ## Overview
///
/// The row adapts its layout based on the resolved form configuration:
///
/// | Layout | Description |
/// |--------|-------------|
/// | ``DSFormRowLayout/inline`` | Label left, control right (iOS default) |
/// | ``DSFormRowLayout/stacked`` | Label above control (watchOS default) |
/// | ``DSFormRowLayout/twoColumn`` | Fixed-width label column (macOS default) |
///
/// ## Usage
///
/// ```swift
/// DSFormRow {
///     DSText("Username", role: .rowTitle)
/// } control: {
///     DSTextField("Enter username", text: $username)
/// }
///
/// DSFormRow {
///     DSText("Theme", role: .rowTitle)
/// } control: {
///     DSPicker("Theme", selection: $theme, options: themes)
/// } accessory: {
///     DSIcon(DSIconToken.Navigation.chevronRight, size: .small, color: .secondary)
/// } footer: {
///     DSText("Choose your preferred appearance", role: .helperText)
/// }
/// ```
///
/// ## Platform Behavior
///
/// When used inside a ``DSForm``, the row reads the resolved layout
/// from the environment. You can also override the layout per-row:
///
/// ```swift
/// DSFormRow(layout: .stacked) {
///     DSText("Description", role: .rowTitle)
/// } control: {
///     DSMultilineField("Description", text: $description)
/// }
/// ```
///
/// ## Accessibility
///
/// - Row is grouped as an accessible element
/// - Label provides the accessibility label for the group
/// - Footer hint is announced as accessibility hint
/// - Minimum tap target of 44pt enforced on touch platforms
///
/// ## Topics
///
/// ### Creating Rows
///
/// - ``init(layout:showSeparator:label:control:accessory:footer:)``
///
/// ### Convenience Initializers
///
/// - ``init(_:layout:showSeparator:control:)``
/// - ``init(_:layout:showSeparator:control:footer:)``
///
/// ### Layout
///
/// - ``DSFormRowLayout``
public struct DSFormRow<Label: View, Control: View, Accessory: View, Footer: View>: View {
    
    // MARK: - Properties
    
    /// Optional layout override. When nil, uses the environment's resolved layout.
    private let layoutOverride: DSFormRowLayout?
    
    /// Whether to show a separator below this row.
    private let showSeparator: Bool?
    
    /// The label slot content.
    private let label: Label
    
    /// The control slot content.
    private let control: Control
    
    /// The accessory slot content.
    private let accessory: Accessory
    
    /// The footer slot content.
    private let footer: Footer
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    @Environment(\.dsCapabilities) private var capabilities: DSCapabilities
    @Environment(\.dsFormResolvedLayout) private var resolvedLayout: DSFormRowLayout
    @Environment(\.dsFormConfiguration) private var formConfig: DSFormConfiguration
    
    // MARK: - Initialization
    
    /// Creates a form row with all four slots.
    ///
    /// - Parameters:
    ///   - layout: Optional layout override. When `nil`, uses the environment layout.
    ///   - showSeparator: Whether to show a separator. When `nil`, uses form configuration.
    ///   - label: The label content (left/top position).
    ///   - control: The control content (right/bottom position).
    ///   - accessory: Trailing accessory content (e.g., chevron, badge).
    ///   - footer: Footer content below the main row (e.g., hint, validation).
    public init(
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder label: () -> Label,
        @ViewBuilder control: () -> Control,
        @ViewBuilder accessory: () -> Accessory,
        @ViewBuilder footer: () -> Footer
    ) {
        self.layoutOverride = layout
        self.showSeparator = showSeparator
        self.label = label()
        self.control = control()
        self.accessory = accessory()
        self.footer = footer()
    }
    
    // MARK: - Computed Properties
    
    /// The effective layout for this row.
    private var effectiveLayout: DSFormRowLayout {
        layoutOverride ?? resolvedLayout
    }
    
    /// The resolved form row spec.
    private var spec: DSFormRowSpec {
        let layoutMode: DSFormRowLayoutMode = layoutOverride.map { .fixed($0) } ?? .auto
        return DSFormRowSpec.resolve(
            theme: theme,
            layoutMode: layoutMode,
            capabilities: capabilities
        )
    }
    
    /// Whether to actually show a separator.
    private var effectiveSeparator: Bool {
        showSeparator ?? formConfig.showRowSeparators
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main row content
            mainContent
                .frame(minHeight: spec.minHeight)
                .padding(spec.contentPadding)
            
            // Footer slot
            footerContent
            
            // Separator
            if effectiveSeparator {
                separatorView
            }
        }
        .accessibilityElement(children: .contain)
        .animation(spec.animation, value: effectiveLayout)
    }
    
    // MARK: - Main Content
    
    @ViewBuilder
    private var mainContent: some View {
        switch effectiveLayout {
        case .inline:
            inlineLayout
        case .stacked:
            stackedLayout
        case .twoColumn:
            twoColumnLayout
        }
    }
    
    // MARK: - Inline Layout
    
    /// Label left, control right (iOS default).
    ///
    /// ```
    /// ┌──────────────────────────────┐
    /// │ Label    [Control] [Accesry] │
    /// └──────────────────────────────┘
    /// ```
    @ViewBuilder
    private var inlineLayout: some View {
        HStack(spacing: spec.horizontalSpacing) {
            label
                .layoutPriority(1)
            
            Spacer(minLength: spec.horizontalSpacing)
            
            control
                .multilineTextAlignment(.trailing)
            
            accessorySlot
        }
    }
    
    // MARK: - Stacked Layout
    
    /// Label above control (watchOS default).
    ///
    /// ```
    /// ┌──────────────────┐
    /// │ Label             │
    /// │ ┌──────────────┐  │
    /// │ │ Control      │  │
    /// │ └──────────────┘  │
    /// │            [Acry] │
    /// └──────────────────┘
    /// ```
    @ViewBuilder
    private var stackedLayout: some View {
        VStack(alignment: .leading, spacing: spec.verticalSpacing) {
            label
            
            HStack(spacing: spec.horizontalSpacing) {
                control
                
                accessorySlot
            }
        }
    }
    
    // MARK: - Two-Column Layout
    
    /// Fixed-width label column with aligned controls (macOS default).
    ///
    /// ```
    /// ┌────────┬───────────────────┐
    /// │ Label: │ [Control] [Accry] │
    /// └────────┴───────────────────┘
    /// ```
    @ViewBuilder
    private var twoColumnLayout: some View {
        HStack(alignment: .firstTextBaseline, spacing: spec.horizontalSpacing) {
            label
                .frame(
                    width: spec.labelWidth,
                    alignment: spec.labelAlignment == .trailing ? .trailing : .leading
                )
            
            HStack(spacing: spec.horizontalSpacing) {
                control
                
                Spacer(minLength: 0)
                
                accessorySlot
            }
        }
    }
    
    // MARK: - Accessory Slot
    
    @ViewBuilder
    private var accessorySlot: some View {
        accessory
    }
    
    // MARK: - Footer Content
    
    @ViewBuilder
    private var footerContent: some View {
        let hasFooter = !(Footer.self == EmptyView.self)
        
        if hasFooter {
            footer
                .padding(.horizontal, spec.contentPadding.leading)
                .padding(.bottom, spec.contentPadding.bottom / 2)
        }
    }
    
    // MARK: - Separator
    
    @ViewBuilder
    private var separatorView: some View {
        spec.separatorColor
            .frame(height: 1 / UIScale.factor)
            .padding(.leading, spec.separatorInsets.leading)
            .padding(.trailing, spec.separatorInsets.trailing)
    }
}

// MARK: - UIScale Helper

/// Cross-platform display scale factor.
private enum UIScale {
    static var factor: CGFloat {
        #if os(iOS)
        return UIScreen.main.scale
        #elseif os(macOS)
        return NSScreen.main?.backingScaleFactor ?? 2.0
        #elseif os(watchOS)
        return WKInterfaceDevice.current().screenScale
        #else
        return 2.0
        #endif
    }
}

// MARK: - Convenience: No Accessory, No Footer

extension DSFormRow where Accessory == EmptyView, Footer == EmptyView {
    
    /// Creates a form row with label and control slots only.
    ///
    /// ```swift
    /// DSFormRow {
    ///     DSText("Name", role: .rowTitle)
    /// } control: {
    ///     DSTextField("Enter name", text: $name)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - layout: Optional layout override.
    ///   - showSeparator: Whether to show a separator.
    ///   - label: The label content.
    ///   - control: The control content.
    public init(
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder label: () -> Label,
        @ViewBuilder control: () -> Control
    ) {
        self.init(
            layout: layout,
            showSeparator: showSeparator,
            label: label,
            control: control,
            accessory: { EmptyView() },
            footer: { EmptyView() }
        )
    }
}

// MARK: - Convenience: With Footer, No Accessory

extension DSFormRow where Accessory == EmptyView {
    
    /// Creates a form row with label, control, and footer slots.
    ///
    /// ```swift
    /// DSFormRow {
    ///     DSText("Email", role: .rowTitle)
    /// } control: {
    ///     DSTextField("Enter email", text: $email)
    /// } footer: {
    ///     DSText("We'll never share your email", role: .helperText)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - layout: Optional layout override.
    ///   - showSeparator: Whether to show a separator.
    ///   - label: The label content.
    ///   - control: The control content.
    ///   - footer: The footer content.
    public init(
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder label: () -> Label,
        @ViewBuilder control: () -> Control,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            layout: layout,
            showSeparator: showSeparator,
            label: label,
            control: control,
            accessory: { EmptyView() },
            footer: footer
        )
    }
}

// MARK: - Convenience: With Accessory, No Footer

extension DSFormRow where Footer == EmptyView {
    
    /// Creates a form row with label, control, and accessory slots.
    ///
    /// ```swift
    /// DSFormRow {
    ///     DSText("Theme", role: .rowTitle)
    /// } control: {
    ///     Text("Dark")
    ///         .foregroundStyle(.secondary)
    /// } accessory: {
    ///     DSIcon(DSIconToken.Navigation.chevronRight, size: .small, color: .secondary)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - layout: Optional layout override.
    ///   - showSeparator: Whether to show a separator.
    ///   - label: The label content.
    ///   - control: The control content.
    ///   - accessory: The accessory content.
    public init(
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder label: () -> Label,
        @ViewBuilder control: () -> Control,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.init(
            layout: layout,
            showSeparator: showSeparator,
            label: label,
            control: control,
            accessory: accessory,
            footer: { EmptyView() }
        )
    }
}

// MARK: - Convenience: String Title Initializers

extension DSFormRow where Label == DSText, Accessory == EmptyView, Footer == EmptyView {
    
    /// Creates a form row with a string title label and control slot.
    ///
    /// ```swift
    /// DSFormRow("Name") {
    ///     DSTextField("Enter name", text: $name)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - title: The row title string.
    ///   - layout: Optional layout override.
    ///   - showSeparator: Whether to show a separator.
    ///   - control: The control content.
    public init(
        _ title: LocalizedStringKey,
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder control: () -> Control
    ) {
        self.init(
            layout: layout,
            showSeparator: showSeparator,
            label: { DSText(title, role: .rowTitle) },
            control: control,
            accessory: { EmptyView() },
            footer: { EmptyView() }
        )
    }
    
    /// Creates a form row with a string title label and control slot.
    ///
    /// - Parameters:
    ///   - title: The row title string.
    ///   - layout: Optional layout override.
    ///   - showSeparator: Whether to show a separator.
    ///   - control: The control content.
    public init<S: StringProtocol>(
        _ title: S,
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder control: () -> Control
    ) {
        self.init(
            layout: layout,
            showSeparator: showSeparator,
            label: { DSText(String(title), role: .rowTitle) },
            control: control,
            accessory: { EmptyView() },
            footer: { EmptyView() }
        )
    }
}

// MARK: - String Title + Footer

extension DSFormRow where Label == DSText, Accessory == EmptyView {
    
    /// Creates a form row with string title, control, and footer.
    ///
    /// ```swift
    /// DSFormRow("Email") {
    ///     DSTextField("Enter email", text: $email)
    /// } footer: {
    ///     DSText("Required field", role: .helperText)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - title: The row title string.
    ///   - layout: Optional layout override.
    ///   - showSeparator: Whether to show a separator.
    ///   - control: The control content.
    ///   - footer: The footer content.
    public init(
        _ title: LocalizedStringKey,
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder control: () -> Control,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            layout: layout,
            showSeparator: showSeparator,
            label: { DSText(title, role: .rowTitle) },
            control: control,
            accessory: { EmptyView() },
            footer: footer
        )
    }
    
    /// Creates a form row with string title, control, and footer.
    ///
    /// - Parameters:
    ///   - title: The row title string.
    ///   - layout: Optional layout override.
    ///   - showSeparator: Whether to show a separator.
    ///   - control: The control content.
    ///   - footer: The footer content.
    public init<S: StringProtocol>(
        _ title: S,
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder control: () -> Control,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            layout: layout,
            showSeparator: showSeparator,
            label: { DSText(String(title), role: .rowTitle) },
            control: control,
            accessory: { EmptyView() },
            footer: footer
        )
    }
}

// MARK: - String Title + Accessory + Footer

extension DSFormRow where Label == DSText {
    
    /// Creates a form row with string title, control, accessory, and footer.
    ///
    /// ```swift
    /// DSFormRow("Theme") {
    ///     Text("Dark").foregroundStyle(.secondary)
    /// } accessory: {
    ///     DSIcon(DSIconToken.Navigation.chevronRight, size: .small, color: .secondary)
    /// } footer: {
    ///     DSText("Choose appearance", role: .helperText)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - title: The row title string.
    ///   - layout: Optional layout override.
    ///   - showSeparator: Whether to show a separator.
    ///   - control: The control content.
    ///   - accessory: The accessory content.
    ///   - footer: The footer content.
    public init(
        _ title: LocalizedStringKey,
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder control: () -> Control,
        @ViewBuilder accessory: () -> Accessory,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            layout: layout,
            showSeparator: showSeparator,
            label: { DSText(title, role: .rowTitle) },
            control: control,
            accessory: accessory,
            footer: footer
        )
    }
    
    /// Creates a form row with string title, control, accessory, and footer.
    ///
    /// - Parameters:
    ///   - title: The row title string.
    ///   - layout: Optional layout override.
    ///   - showSeparator: Whether to show a separator.
    ///   - control: The control content.
    ///   - accessory: The accessory content.
    ///   - footer: The footer content.
    public init<S: StringProtocol>(
        _ title: S,
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder control: () -> Control,
        @ViewBuilder accessory: () -> Accessory,
        @ViewBuilder footer: () -> Footer
    ) {
        self.init(
            layout: layout,
            showSeparator: showSeparator,
            label: { DSText(String(title), role: .rowTitle) },
            control: control,
            accessory: accessory,
            footer: footer
        )
    }
}

// MARK: - String Title + Accessory, No Footer

extension DSFormRow where Label == DSText, Footer == EmptyView {
    
    /// Creates a form row with string title, control, and accessory.
    ///
    /// ```swift
    /// DSFormRow("Theme") {
    ///     Text("Dark").foregroundStyle(.secondary)
    /// } accessory: {
    ///     DSIcon(DSIconToken.Navigation.chevronRight, size: .small, color: .secondary)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - title: The row title string.
    ///   - layout: Optional layout override.
    ///   - showSeparator: Whether to show a separator.
    ///   - control: The control content.
    ///   - accessory: The accessory content.
    public init(
        _ title: LocalizedStringKey,
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder control: () -> Control,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.init(
            layout: layout,
            showSeparator: showSeparator,
            label: { DSText(title, role: .rowTitle) },
            control: control,
            accessory: accessory,
            footer: { EmptyView() }
        )
    }
    
    /// Creates a form row with string title, control, and accessory.
    ///
    /// - Parameters:
    ///   - title: The row title string.
    ///   - layout: Optional layout override.
    ///   - showSeparator: Whether to show a separator.
    ///   - control: The control content.
    ///   - accessory: The accessory content.
    public init<S: StringProtocol>(
        _ title: S,
        layout: DSFormRowLayout? = nil,
        showSeparator: Bool? = nil,
        @ViewBuilder control: () -> Control,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.init(
            layout: layout,
            showSeparator: showSeparator,
            label: { DSText(String(title), role: .rowTitle) },
            control: control,
            accessory: accessory,
            footer: { EmptyView() }
        )
    }
}

// MARK: - View Modifier for Row Layout Override

extension View {
    
    /// Overrides the form row layout for this view hierarchy.
    ///
    /// ```swift
    /// DSFormRow("Description") {
    ///     DSMultilineField("Enter description", text: $desc)
    /// }
    /// .dsFormRowLayout(.stacked) // Force stacked regardless of form config
    /// ```
    ///
    /// - Parameter layout: The layout to use.
    /// - Returns: A view with the form row layout overridden.
    public func dsFormRowLayout(_ layout: DSFormRowLayout) -> some View {
        environment(\.dsFormResolvedLayout, layout)
    }
}

// MARK: - Previews

#Preview("Inline Layout - Light") {
    VStack(spacing: 0) {
        DSFormRow("Name") {
            Text("John Doe")
                .foregroundStyle(.secondary)
        }
        
        DSFormRow("Email") {
            Text("john@example.com")
                .foregroundStyle(.secondary)
        }
        
        DSFormRow {
            HStack(spacing: 6) {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.blue)
                Text("Notifications")
            }
        } control: {
            Toggle("", isOn: .constant(true))
                .labelsHidden()
        }
        
        DSFormRow("Theme") {
            Text("Dark")
                .foregroundStyle(.secondary)
        } accessory: {
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        } footer: {
            Text("Choose your preferred appearance")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
    .dsTheme(.light)
    .environment(\.dsFormResolvedLayout, .inline)
}

#if !os(watchOS)
#Preview("Stacked Layout - Light") {
    VStack(spacing: 0) {
        DSFormRow("Username", layout: .stacked) {
            TextField("Enter username", text: .constant(""))
                .textFieldStyle(.roundedBorder)
        }
        
        DSFormRow("Email", layout: .stacked) {
            TextField("Enter email", text: .constant(""))
                .textFieldStyle(.roundedBorder)
        } footer: {
            Text("We'll never share your email")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
    .dsTheme(.light)
}

#Preview("Two-Column Layout - Light") {
    VStack(spacing: 0) {
        DSFormRow("Name:", layout: .twoColumn) {
            TextField("Enter name", text: .constant("John Doe"))
                .textFieldStyle(.roundedBorder)
        }
        
        DSFormRow("Email:", layout: .twoColumn) {
            TextField("Enter email", text: .constant("john@example.com"))
                .textFieldStyle(.roundedBorder)
        }
        
        DSFormRow("Description:", layout: .twoColumn) {
            TextField("Enter description", text: .constant(""))
                .textFieldStyle(.roundedBorder)
        } footer: {
            Text("Optional field")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
    .dsTheme(.light)
    .frame(maxWidth: 600)
}

#Preview("All Layouts Comparison - Light") {
    ScrollView {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Inline").font(.headline)
                VStack(spacing: 0) {
                    DSFormRow("Name", layout: .inline) {
                        Text("John Doe").foregroundStyle(.secondary)
                    }
                    DSFormRow("Email", layout: .inline) {
                        Text("john@example.com").foregroundStyle(.secondary)
                    }
                }
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Stacked").font(.headline)
                VStack(spacing: 0) {
                    DSFormRow("Name", layout: .stacked) {
                        TextField("Name", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                    }
                    DSFormRow("Email", layout: .stacked) {
                        TextField("Email", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Two-Column").font(.headline)
                VStack(spacing: 0) {
                    DSFormRow("Name:", layout: .twoColumn) {
                        TextField("Name", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                    }
                    DSFormRow("Email:", layout: .twoColumn) {
                        TextField("Email", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
    }
    .dsTheme(.light)
}
#endif

#Preview("Dark Theme") {
    VStack(spacing: 0) {
        DSFormRow("Name") {
            Text("John Doe")
                .foregroundStyle(.secondary)
        }
        
        DSFormRow("Notifications") {
            Toggle("", isOn: .constant(true))
                .labelsHidden()
        }
        
        DSFormRow("Theme") {
            Text("Dark")
                .foregroundStyle(.secondary)
        } accessory: {
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }
    .dsTheme(.dark)
    .environment(\.dsFormResolvedLayout, .inline)
    .preferredColorScheme(.dark)
}

#if os(watchOS)
#Preview("watchOS - Stacked") {
    ScrollView {
        VStack(spacing: 0) {
            DSFormRow("Name") {
                Text("John Doe")
                    .foregroundStyle(.secondary)
            }
            
            DSFormRow("Notifications") {
                Toggle("", isOn: .constant(true))
                    .labelsHidden()
            }
        }
    }
    .dsTheme(.dark)
    .dsCapabilities(.watchOS())
}
#endif

#if os(macOS)
#Preview("macOS - Two-Column") {
    VStack(spacing: 0) {
        DSFormRow("Name:") {
            TextField("Enter name", text: .constant(""))
                .textFieldStyle(.roundedBorder)
        }
        
        DSFormRow("Email:") {
            TextField("Enter email", text: .constant(""))
                .textFieldStyle(.roundedBorder)
        }
        
        DSFormRow("Notifications:") {
            Toggle("", isOn: .constant(true))
                .labelsHidden()
        }
    }
    .dsTheme(.light)
    .dsCapabilities(.macOS())
    .frame(maxWidth: 600)
}
#endif
