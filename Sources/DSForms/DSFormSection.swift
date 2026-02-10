// DSFormSection.swift
// DesignSystem
//
// Grouped section within a form with optional header and footer.
// Provides visual separation and semantic grouping for form rows.

import SwiftUI
import DSCore
import DSTheme
import DSPrimitives

// MARK: - DSFormSection

/// A grouped section within a ``DSForm`` with optional header and footer.
///
/// `DSFormSection` visually separates and semantically groups related
/// form rows. It supports a header for section titles and a footer
/// for help text or descriptions.
///
/// ## Overview
///
/// ```swift
/// DSForm {
///     DSFormSection("Account") {
///         DSTextField("Name", text: $name)
///         DSTextField("Email", text: $email)
///     }
///
///     DSFormSection {
///         header: {
///             DSSectionHeader("Privacy", icon: "lock.fill")
///         }
///         footer: {
///             DSSectionFooter("Your data is encrypted end-to-end.")
///         }
///         content: {
///             DSToggle("Analytics", isOn: $analytics)
///         }
///     }
/// }
/// ```
///
/// ## Section Styles
///
/// | Style | Background | Border | Usage |
/// |-------|-----------|--------|-------|
/// | ``DSFormSectionStyle/plain`` | None | None | Simple grouping |
/// | ``DSFormSectionStyle/grouped`` | Surface | Subtle border | Card-like grouping |
/// | ``DSFormSectionStyle/insetGrouped`` | Surface elevated | Rounded corners | iOS Settings style |
///
/// ## Collapsibility (macOS)
///
/// Sections can be made collapsible on macOS through the
/// ``isCollapsible`` parameter. When collapsed, only the header
/// is visible.
///
/// ```swift
/// DSFormSection("Advanced", isCollapsible: true) {
///     // Content hidden when collapsed
/// }
/// ```
///
/// ## Accessibility
///
/// - Section is announced as a group with the header as label
/// - Collapsible state is announced
/// - Footer text is used as accessibility hint
///
/// ## Topics
///
/// ### Creating Sections
///
/// - ``init(_:isCollapsible:style:content:)``
/// - ``init(isCollapsible:style:header:footer:content:)``
///
/// ### Section Styles
///
/// - ``DSFormSectionStyle``
///
/// ### Related
///
/// - ``DSSectionHeader``
/// - ``DSSectionFooter``
public struct DSFormSection<Header: View, Footer: View, Content: View>: View {
    
    // MARK: - Properties
    
    /// The section header view.
    private let header: Header
    
    /// The section footer view.
    private let footer: Footer
    
    /// The section content (rows).
    private let content: Content
    
    /// The visual style of the section.
    private let style: DSFormSectionStyle
    
    /// Whether the section can be collapsed (macOS).
    private let isCollapsible: Bool
    
    // MARK: - State
    
    /// Whether the section is currently collapsed.
    @State private var isCollapsed: Bool = false
    
    // MARK: - Environment
    
    @Environment(\.dsTheme) private var theme: DSTheme
    @Environment(\.dsCapabilities) private var capabilities: DSCapabilities
    @Environment(\.dsFormConfiguration) private var formConfig: DSFormConfiguration
    
    // MARK: - Initialization
    
    /// Creates a form section with custom header, footer, and content.
    ///
    /// - Parameters:
    ///   - isCollapsible: Whether the section can be collapsed. Defaults to `false`.
    ///   - style: The visual style of the section. Defaults to `.plain`.
    ///   - header: A view builder for the section header.
    ///   - footer: A view builder for the section footer.
    ///   - content: A view builder for the section content (rows).
    public init(
        isCollapsible: Bool = false,
        style: DSFormSectionStyle = .plain,
        @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer,
        @ViewBuilder content: () -> Content
    ) {
        self.isCollapsible = isCollapsible
        self.style = style
        self.header = header()
        self.footer = footer()
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            headerView
            
            // Content (collapsible)
            if !isCollapsed {
                contentView
            }
            
            // Footer
            if !isCollapsed {
                footerView
            }
        }
        .padding(.vertical, theme.spacing.gap.section / 2)
        .accessibilityElement(children: .contain)
    }
    
    // MARK: - Header View
    
    @ViewBuilder
    private var headerView: some View {
        if Header.self != EmptyView.self {
            if isCollapsible && capabilities.supportsHover {
                Button {
                    withAnimation(theme.motion.spring.smooth) {
                        isCollapsed.toggle()
                    }
                } label: {
                    HStack(spacing: theme.spacing.padding.xs) {
                        header
                        
                        Spacer()
                        
                        Image(systemName: isCollapsed ? "chevron.right" : "chevron.down")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.tertiary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(.isButton)
                .accessibilityHint(isCollapsed ? "Double tap to expand" : "Double tap to collapse")
                .padding(.bottom, theme.spacing.padding.s)
            } else {
                header
                    .padding(.bottom, theme.spacing.padding.s)
            }
        }
    }
    
    // MARK: - Content View
    
    @ViewBuilder
    private var contentView: some View {
        switch style {
        case .plain:
            plainContent
            
        case .grouped:
            groupedContent
            
        case .insetGrouped:
            insetGroupedContent
        }
    }
    
    /// Plain style: content with optional separators.
    @ViewBuilder
    private var plainContent: some View {
        content
    }
    
    /// Internal padding for grouped/insetGrouped styles.
    private var sectionContentPadding: EdgeInsets {
        EdgeInsets(
            top: theme.spacing.padding.m,
            leading: theme.spacing.padding.l,
            bottom: theme.spacing.padding.m,
            trailing: theme.spacing.padding.l
        )
    }
    
    /// Grouped style: surface background with subtle border.
    @ViewBuilder
    private var groupedContent: some View {
        let radius = theme.radii.component.card
        
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(sectionContentPadding)
        .background(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(theme.colors.bg.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(theme.colors.border.subtle, lineWidth: theme.shadows.stroke.default.width)
        )
        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
    
    /// Inset grouped style: elevated surface with rounded corners.
    @ViewBuilder
    private var insetGroupedContent: some View {
        let radius = theme.radii.component.card
        
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(sectionContentPadding)
        .background(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(theme.colors.bg.surfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(theme.colors.border.subtle, lineWidth: theme.shadows.stroke.default.width)
        )
        .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        .shadow(
            color: theme.shadows.elevation.subtle.color,
            radius: theme.shadows.elevation.subtle.radius,
            x: theme.shadows.elevation.subtle.x,
            y: theme.shadows.elevation.subtle.y
        )
    }
    
    // MARK: - Footer View
    
    @ViewBuilder
    private var footerView: some View {
        if Footer.self != EmptyView.self {
            footer
                .padding(.top, theme.spacing.padding.s)
        }
    }
}

// MARK: - Convenience Initializers

extension DSFormSection where Header == DSSectionHeader, Footer == EmptyView {
    
    /// Creates a form section with a simple text header.
    ///
    /// ```swift
    /// DSFormSection("Account") {
    ///     DSTextField("Name", text: $name)
    ///     DSTextField("Email", text: $email)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - title: The section header title.
    ///   - isCollapsible: Whether the section can be collapsed. Defaults to `false`.
    ///   - style: The visual style. Defaults to `.plain`.
    ///   - content: A view builder for the section content.
    public init(
        _ title: LocalizedStringKey,
        isCollapsible: Bool = false,
        style: DSFormSectionStyle = .plain,
        @ViewBuilder content: () -> Content
    ) {
        self.isCollapsible = isCollapsible
        self.style = style
        self.header = DSSectionHeader(title)
        self.footer = EmptyView()
        self.content = content()
    }
    
    /// Creates a form section with a simple text header from a String.
    ///
    /// - Parameters:
    ///   - title: The section header title.
    ///   - isCollapsible: Whether the section can be collapsed. Defaults to `false`.
    ///   - style: The visual style. Defaults to `.plain`.
    ///   - content: A view builder for the section content.
    public init<S: StringProtocol>(
        _ title: S,
        isCollapsible: Bool = false,
        style: DSFormSectionStyle = .plain,
        @ViewBuilder content: () -> Content
    ) {
        self.isCollapsible = isCollapsible
        self.style = style
        self.header = DSSectionHeader(title)
        self.footer = EmptyView()
        self.content = content()
    }
}

extension DSFormSection where Header == DSSectionHeader, Footer == DSSectionFooter {
    
    /// Creates a form section with text header and footer.
    ///
    /// ```swift
    /// DSFormSection(
    ///     "Privacy",
    ///     footer: "Your data is encrypted end-to-end."
    /// ) {
    ///     DSToggle("Analytics", isOn: $analytics)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - title: The section header title.
    ///   - footer: The section footer text.
    ///   - isCollapsible: Whether the section can be collapsed. Defaults to `false`.
    ///   - style: The visual style. Defaults to `.plain`.
    ///   - content: A view builder for the section content.
    public init(
        _ title: LocalizedStringKey,
        footer: LocalizedStringKey,
        isCollapsible: Bool = false,
        style: DSFormSectionStyle = .plain,
        @ViewBuilder content: () -> Content
    ) {
        self.isCollapsible = isCollapsible
        self.style = style
        self.header = DSSectionHeader(title)
        self.footer = DSSectionFooter(footer)
        self.content = content()
    }
    
    /// Creates a form section with String header and footer.
    ///
    /// - Parameters:
    ///   - title: The section header title.
    ///   - footer: The section footer text.
    ///   - isCollapsible: Whether the section can be collapsed. Defaults to `false`.
    ///   - style: The visual style. Defaults to `.plain`.
    ///   - content: A view builder for the section content.
    public init<S: StringProtocol>(
        _ title: S,
        footer: S,
        isCollapsible: Bool = false,
        style: DSFormSectionStyle = .plain,
        @ViewBuilder content: () -> Content
    ) {
        self.isCollapsible = isCollapsible
        self.style = style
        self.header = DSSectionHeader(title)
        self.footer = DSSectionFooter(title: nil, description: String(footer))
        self.content = content()
    }
}

extension DSFormSection where Header == EmptyView, Footer == EmptyView {
    
    /// Creates a form section without header or footer.
    ///
    /// Use this when you only need visual grouping without labels.
    ///
    /// ```swift
    /// DSFormSection(style: .grouped) {
    ///     DSToggle("Option A", isOn: $optionA)
    ///     DSToggle("Option B", isOn: $optionB)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - style: The visual style. Defaults to `.plain`.
    ///   - content: A view builder for the section content.
    public init(
        style: DSFormSectionStyle = .plain,
        @ViewBuilder content: () -> Content
    ) {
        self.isCollapsible = false
        self.style = style
        self.header = EmptyView()
        self.footer = EmptyView()
        self.content = content()
    }
}

// MARK: - DSFormSectionStyle

/// Visual style for ``DSFormSection``.
///
/// Controls the background, border, and elevation of section content.
///
/// ## Styles
///
/// | Style | Description |
/// |-------|-------------|
/// | ``plain`` | No background or border. Simple vertical grouping. |
/// | ``grouped`` | Surface background with subtle border. |
/// | ``insetGrouped`` | Elevated surface with rounded corners and shadow. |
///
/// ## Usage
///
/// ```swift
/// DSFormSection("Account", style: .insetGrouped) {
///     // Rows appear inside a card-like container
/// }
/// ```
public enum DSFormSectionStyle: String, Sendable, Equatable, Hashable, CaseIterable, Identifiable {
    
    /// No background or border.
    ///
    /// Content is separated only by spacing. Best for simple forms.
    case plain
    
    /// Surface background with subtle border.
    ///
    /// Content appears inside a bordered container. Good for
    /// visually separating groups of related settings.
    case grouped
    
    /// Elevated surface with rounded corners and shadow.
    ///
    /// Content appears inside a card-like container similar to
    /// iOS Settings app style. Provides the most visual separation.
    case insetGrouped
    
    /// The stable identity for this style.
    public var id: String { rawValue }
    
    /// Human-readable display name.
    public var displayName: String {
        switch self {
        case .plain: return "Plain"
        case .grouped: return "Grouped"
        case .insetGrouped: return "Inset Grouped"
        }
    }
}

// MARK: - Previews

#Preview("Plain Section - Light") {
    ScrollView {
        VStack(spacing: 0) {
            DSFormSection("Account") {
                VStack(alignment: .leading, spacing: 12) {
                    row(label: "Name", value: "John Doe")
                    Divider()
                    row(label: "Email", value: "john@example.com")
                }
            }
            
            DSFormSection("Privacy", footer: "Your data is encrypted end-to-end.") {
                VStack(alignment: .leading, spacing: 12) {
                    row(label: "Analytics", value: "Enabled")
                    Divider()
                    row(label: "Location", value: "Disabled")
                }
            }
        }
        .padding()
    }
    .dsTheme(.light)
}

#Preview("Plain Section - Dark") {
    ScrollView {
        VStack(spacing: 0) {
            DSFormSection("Account") {
                VStack(alignment: .leading, spacing: 12) {
                    row(label: "Name", value: "John Doe")
                    Divider()
                    row(label: "Email", value: "john@example.com")
                }
            }
            
            DSFormSection("Privacy", footer: "Your data is encrypted end-to-end.") {
                VStack(alignment: .leading, spacing: 12) {
                    row(label: "Analytics", value: "Enabled")
                    Divider()
                    row(label: "Location", value: "Disabled")
                }
            }
        }
        .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Grouped Section - Light") {
    ScrollView {
        VStack(spacing: 0) {
            DSFormSection("Account", style: .grouped) {
                VStack(alignment: .leading, spacing: 12) {
                    row(label: "Name", value: "John Doe")
                    Divider()
                    row(label: "Email", value: "john@example.com")
                }
            }
            
            DSFormSection("Privacy", footer: "Encrypted", style: .grouped) {
                VStack(alignment: .leading, spacing: 12) {
                    row(label: "Analytics", value: "Enabled")
                }
            }
        }
        .padding()
    }
    .dsTheme(.light)
}

#Preview("Inset Grouped Section - Light") {
    ScrollView {
        VStack(spacing: 0) {
            DSFormSection("Account", style: .insetGrouped) {
                VStack(alignment: .leading, spacing: 12) {
                    row(label: "Name", value: "John Doe")
                    Divider()
                    row(label: "Email", value: "john@example.com")
                }
            }
            
            DSFormSection("Privacy", style: .insetGrouped) {
                VStack(alignment: .leading, spacing: 12) {
                    row(label: "Analytics", value: "Enabled")
                }
            }
        }
        .padding()
    }
    .dsTheme(.light)
}

#Preview("Inset Grouped Section - Dark") {
    ScrollView {
        VStack(spacing: 0) {
            DSFormSection("Account", style: .insetGrouped) {
                VStack(alignment: .leading, spacing: 12) {
                    row(label: "Name", value: "John Doe")
                    Divider()
                    row(label: "Email", value: "john@example.com")
                }
            }
            
            DSFormSection("Privacy", style: .insetGrouped) {
                VStack(alignment: .leading, spacing: 12) {
                    row(label: "Analytics", value: "Enabled")
                }
            }
        }
        .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}

#Preview("Section with Custom Header & Footer") {
    ScrollView {
        VStack(spacing: 0) {
            DSFormSection(
                style: .insetGrouped,
                header: {
                    DSSectionHeader("Notifications", icon: "bell.fill")
                },
                footer: {
                    DSSectionFooter(
                        "Push Notifications",
                        description: "Control how and when you receive notifications."
                    )
                },
                content: {
                    VStack(alignment: .leading, spacing: 12) {
                        row(label: "Push", value: "Enabled")
                        Divider()
                        row(label: "Email", value: "Weekly")
                        Divider()
                        row(label: "SMS", value: "Disabled")
                    }
                }
            )
        }
        .padding()
    }
    .dsTheme(.light)
}

#Preview("Collapsible Section") {
    ScrollView {
        VStack(spacing: 0) {
            DSFormSection("Advanced Options", isCollapsible: true, style: .grouped) {
                VStack(alignment: .leading, spacing: 12) {
                    row(label: "Debug Mode", value: "Off")
                    Divider()
                    row(label: "Log Level", value: "Warning")
                }
            }
        }
        .padding()
    }
    .dsTheme(.light)
    .dsCapabilities(.macOS())
}

// MARK: - Preview Helpers

private func row(label: String, value: String) -> some View {
    HStack {
        Text(label)
        Spacer()
        Text(value)
            .foregroundStyle(.secondary)
    }
}
