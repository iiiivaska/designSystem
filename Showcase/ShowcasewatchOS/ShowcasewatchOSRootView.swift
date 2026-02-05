// ShowcasewatchOSRootView.swift
// ShowcasewatchOS
//
// Main navigation structure for watchOS Showcase

import SwiftUI
import ShowcaseCore
import DSCore
import DSTheme
import DSPrimitives
import DSControls

struct ShowcasewatchOSRootView: View {
    @State private var isDarkMode = true
    
    private var theme: DSTheme { isDarkMode ? .dark : .light }
    
    var body: some View {
        NavigationStack {
            List(ShowcaseCategory.allCases) { category in
                NavigationLink(value: category) {
                    ShowcaseCategoryRow(category: category)
                }
            }
            .navigationTitle("Components")
            .navigationDestination(for: ShowcaseCategory.self) { category in
                ShowcasewatchOSCategoryView(category: category)
            }
            .navigationDestination(for: ShowcaseItem.self) { item in
                ShowcasewatchOSDetailView(item: item)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isDarkMode.toggle()
                    } label: {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                    .accessibilityLabel(isDarkMode ? "Switch to light mode" : "Switch to dark mode")
                }
            }
        }
        .dsTheme(theme)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct ShowcasewatchOSCategoryView: View {
    let category: ShowcaseCategory
    
    var body: some View {
        List(ShowcaseData.items(for: category)) { item in
            NavigationLink(value: item) {
                ShowcaseItemRow(item: item)
            }
        }
        .navigationTitle(category.rawValue)
    }
}

struct ShowcasewatchOSDetailView: View {
    let item: ShowcaseItem
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Image(systemName: item.icon)
                    .font(.title)
                    .foregroundStyle(.tint)
                
                Text(item.title)
                    .font(.headline)
                
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                // Route to appropriate demo view
                showcaseContent
            }
            .padding()
        }
        .navigationTitle(item.title)
    }
    
    @ViewBuilder
    private var showcaseContent: some View {
        switch item.id {
        case "dstext":
            DSTextShowcasewatchOSView()
        case "dsicon":
            DSIconShowcasewatchOSView()
        case "themeresolver":
            ThemeResolverShowcasewatchOSView()
        case "capabilities":
            CapabilitiesShowcasewatchOSView()
        case "componentspecs":
            ComponentSpecsShowcasewatchOSView()
        case "componentstyles":
            ComponentStylesShowcasewatchOSView()
        case "dssurface":
            DSSurfaceShowcasewatchOSView()
        case "dscard":
            DSCardShowcasewatchOSView()
        case "dsloader":
            DSLoaderShowcasewatchOSView()
        case "dsbutton":
            DSButtonShowcasewatchOSView()
        case "dstoggle":
            DSToggleShowcasewatchOSView()
        case "dstextfield":
            DSTextFieldShowcasewatchOSView()
        default:
            // Placeholder for component demos
            Text("Demo coming soon")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding()
        }
    }
}

// MARK: - Capabilities Showcase (watchOS)

/// Compact showcase view demonstrating DSCapabilities system for watchOS
struct CapabilitiesShowcasewatchOSView: View {
    @Environment(\.dsCapabilities) private var capabilities
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("watchOS Capabilities")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            capabilityItem("Hover", value: capabilities.supportsHover)
            capabilityItem("Focus Ring", value: capabilities.supportsFocusRing)
            capabilityItem("Inline Text", value: capabilities.supportsInlineTextEditing)
            capabilityItem("Inline Pickers", value: capabilities.supportsInlinePickers)
            capabilityItem("Toasts", value: capabilities.supportsToasts)
            capabilityItem("Large Targets", value: capabilities.prefersLargeTapTargets)
            
            Divider()
                .padding(.vertical, 4)
            
            preferenceItem("Layout", value: capabilities.preferredFormRowLayout.rawValue)
            preferenceItem("Picker", value: capabilities.preferredPickerPresentation.rawValue)
            preferenceItem("TextField", value: capabilities.preferredTextFieldMode.rawValue)
            preferenceItem("Tap Size", value: "\(Int(capabilities.minimumTapTargetSize))pt")
        }
    }
    
    private func capabilityItem(_ label: String, value: Bool) -> some View {
        HStack {
            Text(label)
                .font(.caption2)
            Spacer()
            Image(systemName: value ? "checkmark" : "xmark")
                .font(.caption2)
                .foregroundStyle(value ? .green : .secondary)
        }
    }
    
    private func preferenceItem(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption2)
            Spacer()
            Text(value)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Theme Resolver Showcase (watchOS)

/// Compact showcase view demonstrating DSThemeResolver for watchOS
struct ThemeResolverShowcasewatchOSView: View {
    @State private var selectedVariant: DSThemeVariant = .light
    @State private var increasedContrast: Bool = false
    @State private var reduceMotion: Bool = false
    
    private var currentAccessibility: DSAccessibilityPolicy {
        DSAccessibilityPolicy(
            reduceMotion: reduceMotion,
            increasedContrast: increasedContrast,
            reduceTransparency: false,
            differentiateWithoutColor: false, dynamicTypeSize: .large,
            isBoldTextEnabled: false
        )
    }
    
    private var resolvedTheme: DSTheme {
        DSTheme(
            variant: selectedVariant,
            accessibility: currentAccessibility,
            density: .regular
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Variant toggle
            Text("Theme Variant")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Picker("Variant", selection: $selectedVariant) {
                Text("Light").tag(DSThemeVariant.light)
                Text("Dark").tag(DSThemeVariant.dark)
            }
            .pickerStyle(.wheel)
            
            // Accessibility toggles
            Toggle("Contrast", isOn: $increasedContrast)
                .font(.caption2)
            
            Toggle("Reduce Motion", isOn: $reduceMotion)
                .font(.caption2)
            
            Divider()
                .padding(.vertical, 4)
            
            // Colors preview
            Text("Colors")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 4) {
                colorSwatch(resolvedTheme.colors.bg.canvas)
                colorSwatch(resolvedTheme.colors.bg.surface)
                colorSwatch(resolvedTheme.colors.fg.primary)
                colorSwatch(resolvedTheme.colors.accent.primary)
            }
            
            // Spacing preview
            Text("Spacing")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 2) {
                spacingIndicator("XS", value: resolvedTheme.spacing.padding.xs)
                spacingIndicator("S", value: resolvedTheme.spacing.padding.s)
                spacingIndicator("M", value: resolvedTheme.spacing.padding.m)
                spacingIndicator("L", value: resolvedTheme.spacing.padding.l)
            }
            
            // Motion info
            HStack {
                Text("Motion")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(resolvedTheme.motion.reduceMotionEnabled ? "Reduced" : "Normal")
                    .font(.caption2)
            }
        }
    }
    
    private func colorSwatch(_ color: Color) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(color)
            .frame(width: 30, height: 24)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.primary.opacity(0.2), lineWidth: 1)
            )
    }
    
    private func spacingIndicator(_ label: String, value: CGFloat) -> some View {
        VStack(spacing: 2) {
            Rectangle()
                .fill(Color.accentColor.opacity(0.5))
                .frame(width: max(value * 0.8, 8), height: 12)
            Text(label)
                .font(.system(size: 8))
        }
    }
}

#Preview("Theme Resolver") {
    NavigationStack {
        ScrollView {
            ThemeResolverShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("Theme")
    }
}

#Preview("watchOS Root") {
    ShowcasewatchOSRootView()
}

#Preview("Capabilities") {
    NavigationStack {
        ScrollView {
            CapabilitiesShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("Capabilities")
    }
}

// MARK: - Component Specs Showcase (watchOS)

/// Compact showcase view for component specs on watchOS
struct ComponentSpecsShowcasewatchOSView: View {
    let theme = DSTheme.light
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Button specs
            Text("Button Specs")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                let spec = DSButtonSpec.resolve(
                    theme: theme,
                    variant: variant,
                    size: .medium,
                    state: .normal
                )
                
                Text(variant.rawValue)
                    .font(.system(size: spec.typography.size, weight: spec.typography.weight))
                    .foregroundStyle(spec.foregroundColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: spec.height)
                    .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: spec.cornerRadius)
                            .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                    )
            }
            
            Divider()
            
            // Form Row layout
            Text("Form Row Layout")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            let rowSpec = DSFormRowSpec.resolve(
                theme: theme,
                layoutMode: .auto,
                capabilities: .watchOS()
            )
            
            HStack {
                Text("Layout")
                    .font(.caption)
                Spacer()
                Text(rowSpec.resolvedLayout.rawValue)
                    .font(.system(.caption, design: .monospaced))
            }
            
            HStack {
                Text("Min Height")
                    .font(.caption)
                Spacer()
                Text("\(Int(rowSpec.minHeight))pt")
                    .font(.system(.caption, design: .monospaced))
            }
            
            Divider()
            
            // Card elevations
            Text("Card Elevations")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 6) {
                ForEach(DSCardElevation.allCases, id: \.rawValue) { elevation in
                    let spec = DSCardSpec.resolve(theme: theme, elevation: elevation)
                    
                    VStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: spec.cornerRadius * 0.6)
                            .fill(spec.backgroundColor)
                            .frame(height: 30)
                            .overlay(
                                RoundedRectangle(cornerRadius: spec.cornerRadius * 0.6)
                                    .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                            )
                        
                        Text(elevation.rawValue)
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Divider()
            
            // List row styles
            Text("Row Styles")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            ForEach(DSListRowStyle.allCases, id: \.rawValue) { style in
                let spec = DSListRowSpec.resolve(
                    theme: theme,
                    style: style,
                    state: .normal,
                    capabilities: .watchOS()
                )
                
                HStack {
                    Text(style.rawValue)
                        .font(.caption)
                        .foregroundStyle(spec.titleColor)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: spec.accessorySize, weight: .semibold))
                        .foregroundStyle(spec.accessoryColor)
                }
            }
        }
    }
}

#Preview("Component Specs watchOS") {
    NavigationStack {
        ScrollView {
            ComponentSpecsShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("Specs")
    }
}

// MARK: - Component Styles Showcase (watchOS)

/// Compact showcase view demonstrating DSComponentStyles for watchOS.
struct ComponentStylesShowcasewatchOSView: View {
    @Environment(\.dsCapabilities) private var capabilities
    
    private let theme = DSTheme.light
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Resolver IDs
            Text("Resolvers")
                .font(.headline)
            
            let styles = theme.componentStyles
            resolverIdRow("Button", id: styles.button.id)
            resolverIdRow("Field", id: styles.field.id)
            resolverIdRow("Toggle", id: styles.toggle.id)
            resolverIdRow("FormRow", id: styles.formRow.id)
            resolverIdRow("Card", id: styles.card.id)
            resolverIdRow("ListRow", id: styles.listRow.id)
            
            Divider()
            
            // Convenience methods results
            Text("Resolved Values")
                .font(.headline)
            
            let buttonSpec = theme.resolveButton(variant: .primary, size: .medium, state: .normal)
            let fieldSpec = theme.resolveField(variant: .default, state: .normal)
            let formRowSpec = theme.resolveFormRow(capabilities: capabilities)
            let cardSpec = theme.resolveCard(elevation: .raised)
            
            infoRow("Button height", value: "\(Int(buttonSpec.height))pt")
            infoRow("Button radius", value: "\(Int(buttonSpec.cornerRadius))pt")
            infoRow("Field height", value: "\(Int(fieldSpec.height))pt")
            infoRow("Form layout", value: "\(formRowSpec.resolvedLayout)")
            infoRow("Card radius", value: "\(Int(cardSpec.cornerRadius))pt")
            
            Divider()
            
            // Button preview
            Text("Button Preview")
                .font(.headline)
            
            ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                let spec = theme.resolveButton(variant: variant, size: .small, state: .normal)
                
                Text(variant.rawValue.capitalized)
                    .font(spec.typography.font)
                    .foregroundStyle(spec.foregroundColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: spec.height)
                    .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
            }
        }
    }
    
    private func resolverIdRow(_ name: String, id: String) -> some View {
        HStack {
            Text(name)
                .font(.caption2)
            Spacer()
            Text(id)
                .font(.caption2.monospaced())
                .foregroundStyle(.secondary)
        }
    }
    
    private func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption2)
            Spacer()
            Text(value)
                .font(.caption2.monospaced())
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Component Styles watchOS") {
    NavigationStack {
        ScrollView {
            ComponentStylesShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("Styles")
    }
}

// MARK: - DSText Showcase (watchOS)

/// Compact showcase view for DSText on watchOS
struct DSTextShowcasewatchOSView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Show a subset of system roles (compact)
            Text("System")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSText("Large Title", role: .largeTitle)
            DSText("Title 2", role: .title2)
            DSText("Headline", role: .headline)
            DSText("Body", role: .body)
            DSText("Callout", role: .callout)
            DSText("Footnote", role: .footnote)
            DSText("Caption 1", role: .caption1)
            
            Divider()
                .padding(.vertical, 4)
            
            Text("Component")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSText("Button Label", role: .buttonLabel)
            DSText("Row Title", role: .rowTitle)
            DSText("Row Value", role: .rowValue)
            DSText("Section Header", role: .sectionHeader)
            DSText("v1.2.3", role: .monoText)
            
            Divider()
                .padding(.vertical, 4)
            
            Text("Overrides")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSText("Accent color", role: .body)
                .dsTextColor(.teal)
            DSText("Bold body", role: .body)
                .dsTextWeight(.bold)
        }
        .dsTheme(.dark)
    }
}

#Preview("DSText watchOS") {
    NavigationStack {
        ScrollView {
            DSTextShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSText")
    }
}

// MARK: - DSIcon Showcase (watchOS)

/// Compact showcase view for DSIcon on watchOS
struct DSIconShowcasewatchOSView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sizes")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(DSIconSize.allCases) { size in
                    VStack(spacing: 4) {
                        DSIcon("star.fill", size: size, color: .accent)
                        Text("\(Int(size.points))")
                            .font(.system(size: 9))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            Text("Colors")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                DSIcon("circle.fill", size: .medium, color: .primary)
                DSIcon("circle.fill", size: .medium, color: .secondary)
                DSIcon("circle.fill", size: .medium, color: .accent)
                DSIcon("circle.fill", size: .medium, color: .success)
                DSIcon("circle.fill", size: .medium, color: .danger)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            Text("Tokens")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                DSIcon(DSIconToken.Navigation.chevronRight, size: .small)
                DSIcon(DSIconToken.Action.plus, size: .small, color: .accent)
                DSIcon(DSIconToken.State.checkmarkCircle, size: .small, color: .success)
                DSIcon(DSIconToken.State.warning, size: .small, color: .warning)
                DSIcon(DSIconToken.Action.delete, size: .small, color: .danger)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            Text("Inline")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 6) {
                DSIcon(DSIconToken.State.checkmarkCircle, size: .small, color: .success)
                DSText("Verified", role: .footnote)
            }
            
            HStack(spacing: 6) {
                DSIcon(DSIconToken.State.warning, size: .small, color: .warning)
                DSText("Warning", role: .footnote)
            }
        }
        .dsTheme(.dark)
    }
}

#Preview("DSIcon watchOS") {
    NavigationStack {
        ScrollView {
            DSIconShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSIcon")
    }
}

// MARK: - DSSurface Showcase (watchOS)

/// Compact watchOS showcase for DSSurface
struct DSSurfaceShowcasewatchOSView: View {
    var body: some View {
        VStack(spacing: 12) {
            // Surface Roles
            Text("Surface Roles")
                .font(.caption2)
                .foregroundStyle(.secondary)

            DSSurface(.canvas) {
                VStack(spacing: 0) {
                    ForEach(DSSurfaceRole.allCases) { role in
                        DSSurface(role) {
                            HStack {
                                DSText(role.displayName, role: .footnote)
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            // Stroke demo
            Text("With Stroke")
                .font(.caption2)
                .foregroundStyle(.secondary)

            DSSurface(.card, stroke: true, cornerRadius: 10) {
                DSText("Card with border", role: .footnote)
                    .padding(8)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - DSCard Showcase (watchOS)

/// Compact watchOS showcase for DSCard
struct DSCardShowcasewatchOSView: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        VStack(spacing: 12) {
            // All elevations
            Text("Elevations")
                .font(.caption2)
                .foregroundStyle(.secondary)

            ZStack {
                (theme.isDark ? Color(hex: "#0B0E14") : Color(hex: "#F7F8FA"))
                VStack(spacing: 8) {
                    ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                        DSCard(elevation) {
                            DSText(elevation.rawValue.capitalized, role: .footnote)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            // DSDivider demo
            Text("DSDivider")
                .font(.caption2)
                .foregroundStyle(.secondary)

            DSCard(.raised) {
                VStack(spacing: 0) {
                    DSText("Item 1", role: .footnote)
                        .padding(.vertical, 6)
                    DSDivider()
                    DSText("Item 2", role: .footnote)
                        .padding(.vertical, 6)
                    DSDivider()
                    DSText("Item 3", role: .footnote)
                        .padding(.vertical, 6)
                }
            }
        }
    }
}

#Preview("DSSurface watchOS") {
    NavigationStack {
        ScrollView {
            DSSurfaceShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSSurface")
    }
}

#Preview("DSCard watchOS") {
    NavigationStack {
        ScrollView {
            DSCardShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSCard")
    }
}

// MARK: - DSLoader Showcase (watchOS)

/// Compact watchOS showcase for DSLoader and DSProgress
struct DSLoaderShowcasewatchOSView: View {
    @State private var progressValue: Double = 0.65
    
    var body: some View {
        VStack(spacing: 12) {
            // DSLoader sizes
            Text("DSLoader")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(DSLoaderSize.allCases) { size in
                    VStack(spacing: 4) {
                        DSLoader(size: size)
                        Text("\(Int(size.points))")
                            .font(.system(size: 9))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // DSLoader colors
            Text("Colors")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 16) {
                DSLoader(size: .medium, color: .accent)
                DSLoader(size: .medium, color: .primary)
                DSLoader(size: .medium, color: .secondary)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // Linear progress
            Text("Linear Progress")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            ForEach(DSProgressSize.allCases) { size in
                DSProgress(value: 0.6, style: .linear, size: size)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // Circular progress
            Text("Circular Progress")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(DSProgressSize.allCases) { size in
                    DSProgress(value: 0.7, style: .circular, size: size)
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // In context
            Text("In Context")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 8) {
                DSProgress(value: progressValue, style: .circular, size: .small, color: .accent)
                VStack(alignment: .leading, spacing: 2) {
                    DSText("Downloading...", role: .footnote)
                    DSText("\(Int(progressValue * 100))%", role: .helperText)
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    DSText("Upload", role: .footnote)
                    Spacer()
                    DSText("80%", role: .helperText)
                }
                DSProgress(value: 0.8, style: .linear, size: .small)
            }
        }
    }
}

#Preview("DSLoader watchOS") {
    NavigationStack {
        ScrollView {
            DSLoaderShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSLoader")
    }
}

// MARK: - DSButton Showcase (watchOS)

/// Compact watchOS showcase for DSButton
struct DSButtonShowcasewatchOSView: View {
    @State private var tapCount = 0
    
    var body: some View {
        VStack(spacing: 12) {
            // Variants
            Text("Variants")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                DSButton(
                    LocalizedStringKey(variant.rawValue.capitalized),
                    variant: variant,
                    size: .small,
                    fullWidth: true
                ) { }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // Sizes
            Text("Sizes")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            ForEach(DSButtonSize.allCases, id: \.rawValue) { size in
                DSButton(
                    LocalizedStringKey(size.rawValue.capitalized),
                    variant: .primary,
                    size: size,
                    fullWidth: true
                ) { }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // States
            Text("States")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSButton("Normal", size: .small, fullWidth: true) { }
            DSButton("Disabled", size: .small, isDisabled: true, fullWidth: true) { }
            DSButton("Loading", size: .small, isLoading: true, fullWidth: true) { }
            
            Divider()
                .padding(.vertical, 4)
            
            // Icons
            Text("With Icons")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSButton("Save", icon: "checkmark", variant: .primary, size: .small, fullWidth: true) { }
            DSButton("Delete", icon: "trash", variant: .destructive, size: .small, fullWidth: true) { }
            
            Divider()
                .padding(.vertical, 4)
            
            // Interactive
            Text("Interactive")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSButton("Tap (\(tapCount))", icon: "hand.tap", variant: .primary, size: .medium, fullWidth: true) {
                tapCount += 1
            }
        }
        .dsTheme(.dark)
    }
}

#Preview("DSButton watchOS") {
    NavigationStack {
        ScrollView {
            DSButtonShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSButton")
    }
}

// MARK: - DSToggle Showcase (watchOS)

/// Compact showcase view for DSToggle and DSCheckbox on watchOS
struct DSToggleShowcasewatchOSView: View {
    @Environment(\.dsTheme) private var theme
    
    // Toggle states
    @State private var toggleOn = true
    @State private var toggleOff = false
    @State private var disabledOn = true
    @State private var disabledOff = false
    
    // Checkbox states
    @State private var cbChecked: DSCheckboxState = .checked
    @State private var cbUnchecked: DSCheckboxState = .unchecked
    @State private var cbIntermediate: DSCheckboxState = .intermediate
    
    // Settings
    @State private var wifiOn = true
    @State private var doNotDisturb = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: Toggle Switch
            Text("Toggle Switch")
                .font(.caption2.bold())
                .foregroundStyle(theme.colors.fg.secondary)
            
            VStack(spacing: 8) {
                DSToggle("On", isOn: $toggleOn)
                DSToggle("Off", isOn: $toggleOff)
            }
            
            // MARK: Disabled
            Text("Disabled")
                .font(.caption2.bold())
                .foregroundStyle(theme.colors.fg.secondary)
            
            VStack(spacing: 8) {
                DSToggle("Disabled On", isOn: $disabledOn, isDisabled: true)
                DSToggle("Disabled Off", isOn: $disabledOff, isDisabled: true)
            }
            
            // MARK: Settings Pattern
            Text("Settings")
                .font(.caption2.bold())
                .foregroundStyle(theme.colors.fg.secondary)
            
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "wifi")
                        .foregroundStyle(theme.colors.accent.primary)
                        .font(.caption2)
                    Text("Wi-Fi")
                        .font(.caption)
                    Spacer()
                    DSToggle(isOn: $wifiOn)
                }
                .padding(.vertical, 4)
                
                Divider()
                
                HStack {
                    Image(systemName: "moon.fill")
                        .foregroundStyle(theme.colors.accent.secondary)
                        .font(.caption2)
                    Text("Do Not Disturb")
                        .font(.caption)
                    Spacer()
                    DSToggle(isOn: $doNotDisturb)
                }
                .padding(.vertical, 4)
            }
            
            // MARK: Checkbox
            Text("Checkbox")
                .font(.caption2.bold())
                .foregroundStyle(theme.colors.fg.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                DSCheckbox("Checked", state: $cbChecked)
                DSCheckbox("Unchecked", state: $cbUnchecked)
                DSCheckbox("Mixed", state: $cbIntermediate)
            }
            
            // MARK: Spec Info
            Text("Spec")
                .font(.caption2.bold())
                .foregroundStyle(theme.colors.fg.secondary)
            
            let spec = theme.resolveToggle(isOn: true, state: .normal)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Track").font(.caption2).foregroundStyle(theme.colors.fg.tertiary)
                    Spacer()
                    Text("\(Int(spec.trackWidth))×\(Int(spec.trackHeight))")
                        .font(.caption2.monospaced())
                }
                HStack {
                    Text("Thumb").font(.caption2).foregroundStyle(theme.colors.fg.tertiary)
                    Spacer()
                    Text("\(Int(spec.thumbSize)) pt")
                        .font(.caption2.monospaced())
                }
                HStack {
                    Text("Opacity").font(.caption2).foregroundStyle(theme.colors.fg.tertiary)
                    Spacer()
                    Text("\(spec.opacity, specifier: "%.1f")")
                        .font(.caption2.monospaced())
                }
            }
        }
    }
}

#Preview("DSToggle watchOS") {
    NavigationStack {
        ScrollView {
            DSToggleShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSToggle")
    }
    .dsTheme(.dark)
}

// MARK: - DSTextField Showcase (watchOS)

/// Compact showcase view demonstrating DSTextField on watchOS
struct DSTextFieldShowcasewatchOSView: View {
    @Environment(\.dsTheme) private var theme
    
    @State private var basicText = ""
    @State private var filledText = "John"
    @State private var searchText = ""
    @State private var password = ""
    @State private var notes = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Basic Fields
            Text("Text Field")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSTextField("Name", text: $basicText, placeholder: "Enter name")
            DSTextField("Filled", text: $filledText, placeholder: "Name")
            DSTextField("Disabled", text: .constant("Locked"), isDisabled: true)
            
            Divider()
                .padding(.vertical, 4)
            
            // Search
            Text("Search")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSTextField(text: $searchText, placeholder: "Search...", variant: .search)
            
            Divider()
                .padding(.vertical, 4)
            
            // Validation
            Text("Validation")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSTextField(
                "Error",
                text: .constant("bad"),
                placeholder: "Email",
                validation: .error(message: "Invalid")
            )
            
            DSTextField(
                "Warning",
                text: .constant("weak"),
                placeholder: "Pass",
                validation: .warning(message: "Weak")
            )
            
            DSTextField(
                "Success",
                text: .constant("ok"),
                placeholder: "User",
                validation: .success(message: "Available")
            )
            
            Divider()
                .padding(.vertical, 4)
            
            // Secure Field
            Text("Secure")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSSecureField("Password", text: $password, placeholder: "Enter password")
            
            Divider()
                .padding(.vertical, 4)
            
            // Multiline
            Text("Multiline")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSMultilineField(
                "Notes",
                text: $notes,
                placeholder: "Enter notes...",
                minHeight: 60
            )
            
            Divider()
                .padding(.vertical, 4)
            
            // Spec Info
            Text("Spec Info")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            let spec = theme.resolveField(variant: .default, state: .normal)
            VStack(alignment: .leading, spacing: 4) {
                specItem("Height", "\(Int(spec.height)) pt")
                specItem("Radius", "\(Int(spec.cornerRadius)) pt")
                specItem("Font", "\(Int(spec.textTypography.size)) pt")
            }
        }
    }
    
    private func specItem(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption2)
                .foregroundStyle(theme.colors.fg.secondary)
            Spacer()
            Text(value)
                .font(.caption2.monospaced())
                .foregroundStyle(theme.colors.fg.primary)
        }
    }
}

#Preview("DSTextField watchOS") {
    NavigationStack {
        ScrollView {
            DSTextFieldShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSTextField")
    }
    .dsTheme(.dark)
}
