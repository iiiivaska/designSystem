// ShowcaseiOSRootView.swift
// ShowcaseiOS
//
// Main navigation structure for iOS Showcase

import SwiftUI
import ShowcaseCore
import DSCore
import DSTheme
import DSPrimitives
import DSControls

struct ShowcaseiOSRootView: View {
    @State private var selectedCategory: ShowcaseCategory?
    @State private var selectedItem: ShowcaseItem?
    @State private var isDarkMode = false
    
    private var theme: DSTheme { isDarkMode ? .dark : .light }
    
    var body: some View {
        NavigationSplitView {
            List(ShowcaseCategory.allCases, selection: $selectedCategory) { category in
                NavigationLink(value: category) {
                    ShowcaseCategoryRow(category: category)
                }
            }
            .navigationTitle("Design System")
        } content: {
            if let category = selectedCategory {
                List(ShowcaseData.items(for: category), selection: $selectedItem) { item in
                    NavigationLink(value: item) {
                        ShowcaseItemRow(item: item)
                    }
                }
                .navigationTitle(category.rawValue)
            } else {
                ContentUnavailableView(
                    "Select a Category",
                    systemImage: "square.grid.2x2",
                    description: Text("Choose a component category from the sidebar")
                )
            }
        } detail: {
            if let item = selectedItem {
                ShowcaseDetailView(item: item)
            } else {
                ContentUnavailableView(
                    "Select a Component",
                    systemImage: "cube",
                    description: Text("Choose a component to view its showcase")
                )
            }
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
        .dsTheme(theme)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct ShowcaseDetailView: View {
    let item: ShowcaseItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Label(item.title, systemImage: item.icon)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom)
                
                Divider()
                
                // Route to appropriate demo view
                showcaseContent
            }
            .padding()
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var showcaseContent: some View {
        switch item.id {
        case "dstext":
            DSTextShowcaseView()
        case "dsicon":
            DSIconShowcaseView()
        case "themeresolver":
            ThemeResolverShowcaseView()
        case "capabilities":
            CapabilitiesShowcaseView()
        case "componentspecs":
            ComponentSpecsShowcaseView()
        case "componentstyles":
            ComponentStylesShowcaseView()
        case "dssurface":
            DSSurfaceShowcaseView()
        case "dscard":
            DSCardShowcaseView()
        case "dsloader":
            DSLoaderShowcaseView()
        case "dsbutton":
            DSButtonShowcaseView()
        case "dstoggle":
            DSToggleShowcaseView()
        default:
            // Placeholder for components not yet implemented
            ShowcasePlaceholder(
                title: item.title,
                message: "Component implementation coming in future steps"
            )
            .frame(minHeight: 300)
        }
    }
}

// MARK: - DSSurface Showcase

/// Showcase view demonstrating DSSurface primitive
struct DSSurfaceShowcaseView: View {
    @Environment(\.dsTheme) private var theme
    @State private var showStroke = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // Controls
            Toggle("Show Stroke", isOn: $showStroke)

            Divider()

            // Surface Roles
            Text("Surface Roles")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Each role maps to a theme background color. The layering creates visual depth.")
                .font(.callout)
                .foregroundStyle(.secondary)

            DSSurface(.canvas) {
                VStack(spacing: 0) {
                    ForEach(DSSurfaceRole.allCases) { role in
                        DSSurface(role, stroke: showStroke) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    DSText(role.displayName, role: .rowTitle)
                                    DSText(verbatim: ".\(role.rawValue)", role: .helperText)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.secondary.opacity(0.2))
            )

            Divider()

            // Nested Surfaces
            Text("Nested Surfaces")
                .font(.title2)
                .fontWeight(.semibold)

            DSSurface(.canvas) {
                VStack(spacing: 12) {
                    DSSurface(.surface, stroke: showStroke, cornerRadius: 14) {
                        VStack(spacing: 8) {
                            DSSurface(.card, stroke: true, cornerRadius: 10) {
                                HStack {
                                    DSText("Card on Surface", role: .rowTitle)
                                    Spacer()
                                }
                                .padding()
                            }
                            DSSurface(.surfaceElevated, stroke: true, cornerRadius: 10) {
                                HStack {
                                    DSText("Elevated on Surface", role: .rowTitle)
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

/// Showcase view demonstrating DSCard primitive
struct DSCardShowcaseView: View {
    @Environment(\.dsTheme) private var theme
    @State private var selectedElevation: DSCardElevation = .raised

    private var isDark: Bool { theme.isDark }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // Controls
            Picker("Elevation", selection: $selectedElevation) {
                ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                    Text(elevation.rawValue.capitalized).tag(elevation)
                }
            }
            .pickerStyle(.segmented)

            Divider()

            // All Elevations
            Text("All Elevation Levels")
                .font(.title2)
                .fontWeight(.semibold)

            ZStack {
                (isDark ? Color(hex: "#0B0E14") : Color(hex: "#F7F8FA"))

                VStack(spacing: 20) {
                    ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                        DSCard(elevation) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    DSText(elevation.rawValue.capitalized, role: .headline)
                                    DSText(verbatim: "DSCard(.\(elevation.rawValue))", role: .helperText)
                                }
                                Spacer()
                                let spec = theme.resolveCard(elevation: elevation)
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("r: \(String(format: "%.1f", spec.shadow.radius))")
                                        .font(.caption2)
                                    Text("glass: \(spec.usesGlassEffect ? "yes" : "no")")
                                        .font(.caption2)
                                }
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Divider()

            // Selected Elevation Detail
            Text("Selected: \(selectedElevation.rawValue.capitalized)")
                .font(.title2)
                .fontWeight(.semibold)

            ZStack {
                (isDark ? Color(hex: "#0B0E14") : Color(hex: "#F7F8FA"))

                DSCard(selectedElevation) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            DSText("Sample Card", role: .headline)
                            Spacer()
                        }
                        DSText("This card uses the .\(selectedElevation.rawValue) elevation level. Use the theme toggle to see glass effects on elevated/overlay cards.", role: .body)
                        DSDivider()
                        HStack {
                            DSText("Learn more", role: .callout)
                                .dsTextColor(theme.colors.accent.primary)
                            Spacer()
                            DSIcon(DSIconToken.Navigation.chevronRight, size: .small, color: .secondary)
                        }
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Divider()

            // Glass Effect Comparison
            Text("Light vs Dark Comparison")
                .font(.title2)
                .fontWeight(.semibold)

            HStack(spacing: 12) {
                ZStack {
                    Color(hex: "#F7F8FA")
                    VStack(spacing: 12) {
                        Text("Light").font(.caption).fontWeight(.semibold)
                        ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                            DSCard(elevation) {
                                Text(elevation.rawValue.capitalized)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(12)
                }
                .dsTheme(.light)
                .environment(\.colorScheme, .light)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                ZStack {
                    Color(hex: "#0B0E14")
                    VStack(spacing: 12) {
                        Text("Dark").font(.caption).fontWeight(.semibold)
                        ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                            DSCard(elevation) {
                                Text(elevation.rawValue.capitalized)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(12)
                }
                .dsTheme(.dark)
                .environment(\.colorScheme, .dark)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }

            Divider()

            // DSDivider in context
            Text("DSDivider")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Themed horizontal and vertical dividers.")
                .font(.callout)
                .foregroundStyle(.secondary)

            ZStack {
                (isDark ? Color(hex: "#0B0E14") : Color(hex: "#F7F8FA"))

                VStack(spacing: 16) {
                    DSCard(.raised) {
                        VStack(spacing: 0) {
                            rowItem(title: "Horizontal divider", icon: "minus")
                            DSDivider()
                            rowItem(title: "Between items", icon: "line.horizontal.3")
                            DSDivider(insets: 16)
                            rowItem(title: "With insets", icon: "arrow.left.and.right")
                        }
                    }

                    DSCard(.raised) {
                        HStack(spacing: 16) {
                            Text("Left")
                            DSDivider(.vertical)
                            Text("Center")
                            DSDivider(.vertical)
                            Text("Right")
                        }
                        .frame(height: 44)
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    @ViewBuilder
    private func rowItem(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 12)
    }
}

// MARK: - Capabilities Showcase

/// Showcase view demonstrating DSCapabilities system
struct CapabilitiesShowcaseView: View {
    @Environment(\.dsCapabilities) private var capabilities
    @State private var selectedPlatform: DSPlatform = .current
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Platform selector
            platformSelector
            
            // Current capabilities display
            capabilitiesDisplay
            
            // Capability matrix
            capabilityMatrix
        }
    }
    
    private var platformSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Simulate Platform")
                .font(.headline)
            
            Picker("Platform", selection: $selectedPlatform) {
                Text("iOS").tag(DSPlatform.iOS)
                Text("macOS").tag(DSPlatform.macOS)
                Text("watchOS").tag(DSPlatform.watchOS)
            }
            .pickerStyle(.segmented)
            
            Text("Current runtime: \(DSPlatform.current.rawValue)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var simulatedCapabilities: DSCapabilities {
        DSCapabilities.for(platform: selectedPlatform)
    }
    
    private var capabilitiesDisplay: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Capabilities for \(selectedPlatform.rawValue)")
                .font(.headline)
            
            GroupBox {
                VStack(spacing: 0) {
                    capabilityRow("Supports Hover", value: simulatedCapabilities.supportsHover)
                    Divider()
                    capabilityRow("Supports Focus Ring", value: simulatedCapabilities.supportsFocusRing)
                    Divider()
                    capabilityRow("Inline Text Editing", value: simulatedCapabilities.supportsInlineTextEditing)
                    Divider()
                    capabilityRow("Inline Pickers", value: simulatedCapabilities.supportsInlinePickers)
                    Divider()
                    capabilityRow("Supports Toasts", value: simulatedCapabilities.supportsToasts)
                    Divider()
                    capabilityRow("Large Tap Targets", value: simulatedCapabilities.prefersLargeTapTargets)
                }
            }
            
            GroupBox {
                VStack(spacing: 0) {
                    preferenceRow("Form Row Layout", value: simulatedCapabilities.preferredFormRowLayout.rawValue)
                    Divider()
                    preferenceRow("Picker Presentation", value: simulatedCapabilities.preferredPickerPresentation.rawValue)
                    Divider()
                    preferenceRow("Text Field Mode", value: simulatedCapabilities.preferredTextFieldMode.rawValue)
                    Divider()
                    preferenceRow("Min Tap Target", value: "\(Int(simulatedCapabilities.minimumTapTargetSize))pt")
                }
            }
        }
    }
    
    private func capabilityRow(_ label: String, value: Bool) -> some View {
        HStack {
            Text(label)
            Spacer()
            Image(systemName: value ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(value ? .green : .secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
    
    private func preferenceRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
    
    private var capabilityMatrix: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Capability Matrix")
                .font(.headline)
            
            GroupBox {
                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                    GridRow {
                        Text("Capability")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text("iOS")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text("macOS")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text("watch")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    
                    matrixRow("Hover", ios: false, macos: true, watch: false)
                    matrixRow("Focus Ring", ios: false, macos: true, watch: false)
                    matrixRow("Inline Text", ios: true, macos: true, watch: false)
                    matrixRow("Inline Pickers", ios: true, macos: true, watch: false)
                    matrixRow("Toasts", ios: true, macos: true, watch: false)
                    matrixRow("Large Targets", ios: true, macos: false, watch: true)
                }
                .font(.caption)
            }
        }
    }
    
    private func matrixRow(_ label: String, ios: Bool, macos: Bool, watch: Bool) -> some View {
        GridRow {
            Text(label)
            matrixIcon(ios)
            matrixIcon(macos)
            matrixIcon(watch)
        }
    }
    
    private func matrixIcon(_ value: Bool) -> some View {
        Image(systemName: value ? "checkmark" : "minus")
            .foregroundStyle(value ? .green : .secondary)
    }
}

// MARK: - Theme Resolver Showcase

/// Showcase view demonstrating DSThemeResolver accessibility integration
struct ThemeResolverShowcaseView: View {
    @State private var selectedVariant: DSThemeVariant = .light
    @State private var selectedDensity: DSDensity = .regular
    @State private var reduceMotion: Bool = false
    @State private var increasedContrast: Bool = false
    @State private var boldText: Bool = false
    @State private var reduceTransparency: Bool = false
    @State private var dynamicTypeSize: DSDynamicTypeSize = .large
    
    private var currentAccessibility: DSAccessibilityPolicy {
        DSAccessibilityPolicy(
            reduceMotion: reduceMotion,
            increasedContrast: increasedContrast,
            reduceTransparency: reduceTransparency,
            differentiateWithoutColor: false,
            dynamicTypeSize: dynamicTypeSize,
            isBoldTextEnabled: boldText
        )
    }
    
    private var resolvedTheme: DSTheme {
        DSTheme(
            variant: selectedVariant,
            accessibility: currentAccessibility,
            density: selectedDensity
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Configuration section
            configurationSection
            
            Divider()
            
            // Theme preview
            themePreview
        }
    }
    
    private var configurationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Configuration")
                .font(.headline)
            
            // Variant picker
            GroupBox("Theme Variant") {
                Picker("Variant", selection: $selectedVariant) {
                    Text("Light").tag(DSThemeVariant.light)
                    Text("Dark").tag(DSThemeVariant.dark)
                }
                .pickerStyle(.segmented)
            }
            
            // Density picker
            GroupBox("Density") {
                Picker("Density", selection: $selectedDensity) {
                    Text("Compact").tag(DSDensity.compact)
                    Text("Regular").tag(DSDensity.regular)
                    Text("Spacious").tag(DSDensity.spacious)
                }
                .pickerStyle(.segmented)
            }
            
            // Dynamic Type Size
            GroupBox("Dynamic Type") {
                Picker("Size", selection: $dynamicTypeSize) {
                    Text("XS").tag(DSDynamicTypeSize.extraSmall)
                    Text("S").tag(DSDynamicTypeSize.small)
                    Text("M").tag(DSDynamicTypeSize.medium)
                    Text("L").tag(DSDynamicTypeSize.large)
                    Text("XL").tag(DSDynamicTypeSize.extraLarge)
                    Text("XXL").tag(DSDynamicTypeSize.extraExtraLarge)
                    Text("XXXL").tag(DSDynamicTypeSize.extraExtraExtraLarge)
                }
                .pickerStyle(.segmented)
            }
            
            // Accessibility toggles
            GroupBox("Accessibility") {
                VStack(spacing: 0) {
                    Toggle("Reduce Motion", isOn: $reduceMotion)
                        .padding(.vertical, 8)
                    Divider()
                    Toggle("Increased Contrast", isOn: $increasedContrast)
                        .padding(.vertical, 8)
                    Divider()
                    Toggle("Bold Text", isOn: $boldText)
                        .padding(.vertical, 8)
                    Divider()
                    Toggle("Reduce Transparency", isOn: $reduceTransparency)
                        .padding(.vertical, 8)
                }
            }
        }
    }
    
    private var themePreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Resolved Theme")
                .font(.headline)
            
            // Colors preview
            GroupBox("Colors") {
                VStack(spacing: 12) {
                    colorRow("Canvas", color: resolvedTheme.colors.bg.canvas)
                    colorRow("Surface", color: resolvedTheme.colors.bg.surface)
                    colorRow("Primary Text", color: resolvedTheme.colors.fg.primary)
                    colorRow("Secondary Text", color: resolvedTheme.colors.fg.secondary)
                    colorRow("Accent", color: resolvedTheme.colors.accent.primary)
                    colorRow("Border", color: resolvedTheme.colors.border.subtle)
                }
            }
            
            // Typography preview
            GroupBox("Typography") {
                VStack(alignment: .leading, spacing: 8) {
                    typographyRow("Title", font: resolvedTheme.typography.system.title1.font)
                    typographyRow("Body", font: resolvedTheme.typography.system.body.font)
                    typographyRow("Caption", font: resolvedTheme.typography.system.caption1.font)
                }
            }
            
            // Spacing preview
            GroupBox("Spacing") {
                HStack(spacing: 16) {
                    spacingBox("XS", value: resolvedTheme.spacing.padding.xs)
                    spacingBox("S", value: resolvedTheme.spacing.padding.s)
                    spacingBox("M", value: resolvedTheme.spacing.padding.m)
                    spacingBox("L", value: resolvedTheme.spacing.padding.l)
                    spacingBox("XL", value: resolvedTheme.spacing.padding.xl)
                }
            }
            
            // Motion preview
            GroupBox("Motion") {
                VStack(alignment: .leading, spacing: 8) {
                    motionRow("Normal Duration", value: "\(Int(resolvedTheme.motion.duration.normal * 1000))ms")
                    motionRow("Slow Duration", value: "\(Int(resolvedTheme.motion.duration.slow * 1000))ms")
                    motionRow("Reduce Motion", value: resolvedTheme.motion.reduceMotionEnabled ? "Yes" : "No")
                }
            }
        }
    }
    
    private func colorRow(_ label: String, color: Color) -> some View {
        HStack {
            Text(label)
            Spacer()
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 60, height: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    private func typographyRow(_ label: String, font: Font) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text("Sample Text")
                .font(font)
        }
    }
    
    private func spacingBox(_ label: String, value: CGFloat) -> some View {
        VStack(spacing: 4) {
            Rectangle()
                .fill(Color.accentColor.opacity(0.3))
                .frame(width: value, height: value)
                .overlay(
                    Rectangle()
                        .stroke(Color.accentColor, lineWidth: 1)
                )
            Text(label)
                .font(.caption2)
            Text("\(Int(value))")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
    
    private func motionRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .font(.system(.body, design: .monospaced))
        }
    }
}

#Preview("Theme Resolver") {
    NavigationStack {
        ScrollView {
            ThemeResolverShowcaseView()
                .padding()
        }
        .navigationTitle("Theme Resolver")
    }
}

#Preview("Theme Resolver - Dark") {
    NavigationStack {
        ScrollView {
            ThemeResolverShowcaseView()
                .padding()
        }
        .navigationTitle("Theme Resolver")
    }
    .preferredColorScheme(.dark)
}

#Preview("iOS Root View") {
    ShowcaseiOSRootView()
}

#Preview("Capabilities Showcase") {
    NavigationStack {
        ScrollView {
            CapabilitiesShowcaseView()
                .padding()
        }
        .navigationTitle("Capabilities")
    }
}

#Preview("Capabilities - Dark") {
    NavigationStack {
        ScrollView {
            CapabilitiesShowcaseView()
                .padding()
        }
        .navigationTitle("Capabilities")
    }
    .preferredColorScheme(.dark)
}

// MARK: - Component Specs Showcase

/// Showcase view demonstrating the resolve-then-render spec system
struct ComponentSpecsShowcaseView: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    
    @State private var selectedVariant: DSThemeVariant = .light
    
    private var previewTheme: DSTheme {
        selectedVariant == .light ? .light : .dark
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Theme variant toggle
            Picker("Theme", selection: $selectedVariant) {
                Text("Light").tag(DSThemeVariant.light)
                Text("Dark").tag(DSThemeVariant.dark)
            }
            .pickerStyle(.segmented)
            
            // Button Specs
            buttonSpecSection
            
            // Field Specs
            fieldSpecSection
            
            // Toggle Specs
            toggleSpecSection
            
            // Form Row Specs
            formRowSpecSection
            
            // Card Specs
            cardSpecSection
            
            // List Row Specs
            listRowSpecSection
        }
    }
    
    // MARK: - Button Spec
    
    private var buttonSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSButtonSpec")
                .font(.headline)
            
            Text("Variants \u{00d7} Sizes \u{00d7} States")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                VStack(alignment: .leading, spacing: 4) {
                    Text(variant.rawValue.capitalized)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 8) {
                        ForEach(DSButtonSize.allCases, id: \.rawValue) { size in
                            let spec = DSButtonSpec.resolve(
                                theme: previewTheme,
                                variant: variant,
                                size: size,
                                state: .normal
                            )
                            
                            Text(size.rawValue)
                                .font(spec.typography.font)
                                .foregroundStyle(spec.foregroundColor)
                                .padding(.horizontal, spec.horizontalPadding)
                                .frame(height: spec.height)
                                .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
                                .overlay(
                                    RoundedRectangle(cornerRadius: spec.cornerRadius)
                                        .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                                )
                        }
                    }
                }
            }
            
            // States showcase
            VStack(alignment: .leading, spacing: 4) {
                Text("States (primary, medium)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 8) {
                    ForEach(
                        [("Normal", DSControlState.normal), ("Pressed", DSControlState.pressed),
                         ("Disabled", DSControlState.disabled), ("Loading", DSControlState.loading)],
                        id: \.0
                    ) { label, state in
                        let spec = DSButtonSpec.resolve(
                            theme: previewTheme,
                            variant: .primary,
                            size: .medium,
                            state: state
                        )
                        
                        Text(label)
                            .font(.caption2)
                            .foregroundStyle(spec.foregroundColor)
                            .padding(.horizontal, 12)
                            .frame(height: spec.height)
                            .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
                            .opacity(spec.opacity)
                            .scaleEffect(spec.scaleEffect)
                    }
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Field Spec
    
    private var fieldSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSFieldSpec")
                .font(.headline)
            
            ForEach(
                [("Normal", DSControlState.normal, DSValidationState.none),
                 ("Focused", DSControlState.focused, DSValidationState.none),
                 ("Error", DSControlState.normal, DSValidationState.error(message: "Required")),
                 ("Warning", DSControlState.normal, DSValidationState.warning(message: "Weak")),
                 ("Disabled", DSControlState.disabled, DSValidationState.none)],
                id: \.0
            ) { label, state, validation in
                let spec = DSFieldSpec.resolve(
                    theme: previewTheme,
                    variant: .default,
                    state: state,
                    validation: validation
                )
                
                HStack {
                    Text(label)
                        .font(.caption)
                        .frame(width: 60, alignment: .leading)
                    
                    Text("Sample text")
                        .font(spec.textTypography.font)
                        .foregroundStyle(spec.foregroundColor)
                        .padding(.horizontal, spec.horizontalPadding)
                        .frame(height: spec.height)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
                        .overlay(
                            RoundedRectangle(cornerRadius: spec.cornerRadius)
                                .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                        )
                        .opacity(spec.opacity)
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Toggle Spec
    
    private var toggleSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSToggleSpec")
                .font(.headline)
            
            HStack(spacing: 24) {
                ForEach(
                    [(true, DSControlState.normal, "On"),
                     (false, DSControlState.normal, "Off"),
                     (true, DSControlState.disabled, "Disabled On"),
                     (false, DSControlState.disabled, "Disabled Off")],
                    id: \.2
                ) { isOn, state, label in
                    let spec = DSToggleSpec.resolve(
                        theme: previewTheme,
                        isOn: isOn,
                        state: state
                    )
                    
                    VStack(spacing: 4) {
                        Capsule()
                            .fill(spec.trackColor)
                            .frame(width: spec.trackWidth, height: spec.trackHeight)
                            .overlay(
                                Capsule()
                                    .stroke(spec.trackBorderColor, lineWidth: spec.trackBorderWidth)
                            )
                            .opacity(spec.opacity)
                        
                        Text(label)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Form Row Spec
    
    private var formRowSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSFormRowSpec")
                .font(.headline)
            
            Text("Auto-degradation by platform")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            ForEach(
                [("iOS", DSCapabilities.iOS()),
                 ("macOS", DSCapabilities.macOS()),
                 ("watchOS", DSCapabilities.watchOS())],
                id: \.0
            ) { platform, caps in
                let spec = DSFormRowSpec.resolve(
                    theme: previewTheme,
                    layoutMode: .auto,
                    capabilities: caps
                )
                
                HStack {
                    Text(platform)
                        .font(.caption)
                        .frame(width: 60, alignment: .leading)
                    
                    Text(spec.resolvedLayout.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 4))
                    
                    if let labelWidth = spec.labelWidth {
                        Text("label: \(Int(labelWidth))pt")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("h:\(Int(spec.minHeight))pt")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Card Spec
    
    private var cardSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSCardSpec")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(DSCardElevation.allCases, id: \.rawValue) { elevation in
                    let spec = DSCardSpec.resolve(
                        theme: previewTheme,
                        elevation: elevation
                    )
                    
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: spec.cornerRadius)
                            .fill(spec.backgroundColor)
                            .frame(width: 60, height: 60)
                            .shadow(
                                color: spec.shadow.color,
                                radius: spec.shadow.radius,
                                x: spec.shadow.x,
                                y: spec.shadow.y
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: spec.cornerRadius)
                                    .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                            )
                        
                        Text(elevation.rawValue)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        
                        if spec.usesGlassEffect {
                            Image(systemName: "sparkles")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - List Row Spec
    
    private var listRowSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSListRowSpec")
                .font(.headline)
            
            ForEach(DSListRowStyle.allCases, id: \.rawValue) { style in
                let spec = DSListRowSpec.resolve(
                    theme: previewTheme,
                    style: style,
                    state: .normal,
                    capabilities: capabilities
                )
                
                HStack {
                    Text(style.rawValue.capitalized)
                        .font(spec.titleTypography.font)
                        .foregroundStyle(spec.titleColor)
                    
                    Spacer()
                    
                    Text("Value")
                        .font(spec.valueTypography.font)
                        .foregroundStyle(spec.valueColor)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: spec.accessorySize, weight: .semibold))
                        .foregroundStyle(spec.accessoryColor)
                }
                .padding(.horizontal, spec.horizontalPadding)
                .frame(minHeight: spec.minHeight)
                .opacity(spec.opacity)
                
                if style != DSListRowStyle.allCases.last {
                    Divider()
                        .padding(.leading, spec.separatorInsets.leading)
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Component Specs - Light") {
    NavigationStack {
        ScrollView {
            ComponentSpecsShowcaseView()
                .padding()
        }
        .navigationTitle("Component Specs")
    }
}

#Preview("Component Specs - Dark") {
    NavigationStack {
        ScrollView {
            ComponentSpecsShowcaseView()
                .padding()
        }
        .navigationTitle("Component Specs")
    }
    .preferredColorScheme(.dark)
}

// MARK: - Component Styles Showcase

/// Showcase view demonstrating DSComponentStyles registry and custom resolvers.
struct ComponentStylesShowcaseView: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    @State private var useDarkTheme = false
    @State private var useCustomButton = false
    @State private var useCustomCard = false
    
    private var previewTheme: DSTheme {
        var styles = DSComponentStyles.default
        
        if useCustomButton {
            styles.button = DSButtonStyleResolver(id: "pill") { theme, variant, size, state in
                let base = DSButtonSpec.resolve(theme: theme, variant: variant, size: size, state: state)
                return DSButtonSpec(
                    backgroundColor: base.backgroundColor,
                    foregroundColor: base.foregroundColor,
                    borderColor: base.borderColor,
                    borderWidth: base.borderWidth,
                    height: base.height,
                    horizontalPadding: base.horizontalPadding * 1.5,
                    verticalPadding: base.verticalPadding,
                    cornerRadius: base.height / 2,
                    typography: base.typography,
                    shadow: base.shadow,
                    opacity: base.opacity,
                    scaleEffect: base.scaleEffect,
                    animation: base.animation
                )
            }
        }
        
        if useCustomCard {
            styles.card = DSCardStyleResolver(id: "no-shadow") { theme, elevation in
                let base = DSCardSpec.resolve(theme: theme, elevation: elevation)
                return DSCardSpec(
                    backgroundColor: base.backgroundColor,
                    borderColor: theme.colors.accent.primary.opacity(0.2),
                    borderWidth: 2,
                    cornerRadius: 20,
                    shadow: .none,
                    padding: base.padding,
                    usesGlassEffect: false,
                    glassBorderColor: .clear
                )
            }
        }
        
        return DSTheme(
            variant: useDarkTheme ? .dark : .light,
            componentStyles: styles
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Description
            Text("DSComponentStyles is a registry of spec resolvers. Override individual resolvers to customize component styling without modifying component code.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Controls
            stylesControls
            
            Divider()
            
            // Resolver IDs
            resolverIdsSection
            
            Divider()
            
            // Live preview
            livePreviewSection
        }
    }
    
    // MARK: - Controls
    
    private var stylesControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Configuration")
                .font(.headline)
            
            Toggle("Dark Theme", isOn: $useDarkTheme)
            Toggle("Custom Button (Pill Shape)", isOn: $useCustomButton)
            Toggle("Custom Card (Accent Border)", isOn: $useCustomCard)
        }
    }
    
    // MARK: - Resolver IDs
    
    private var resolverIdsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Resolvers")
                .font(.headline)
            
            let styles = previewTheme.componentStyles
            
            resolverIdRow("Button", id: styles.button.id)
            resolverIdRow("Field", id: styles.field.id)
            resolverIdRow("Toggle", id: styles.toggle.id)
            resolverIdRow("Form Row", id: styles.formRow.id)
            resolverIdRow("Card", id: styles.card.id)
            resolverIdRow("List Row", id: styles.listRow.id)
        }
    }
    
    private func resolverIdRow(_ name: String, id: String) -> some View {
        HStack {
            Text(name)
                .font(.subheadline)
            Spacer()
            Text(id)
                .font(.subheadline.monospaced())
                .foregroundStyle(id == "default" ? Color.secondary : Color.orange)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(id == "default" ? Color.secondary.opacity(0.1) : Color.orange.opacity(0.1))
                )
        }
    }
    
    // MARK: - Live Preview
    
    private var livePreviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Live Preview")
                .font(.headline)
            
            // Button preview
            buttonPreview
            
            // Card preview
            cardPreview
            
            // Convenience methods demo
            convenienceMethodsDemo
        }
    }
    
    private var buttonPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Buttons (via theme.resolveButton)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                    let spec = previewTheme.resolveButton(variant: variant, size: .medium, state: .normal)
                    
                    Text(variant.rawValue.capitalized)
                        .font(spec.typography.font)
                        .foregroundStyle(spec.foregroundColor)
                        .padding(.horizontal, spec.horizontalPadding)
                        .frame(height: spec.height)
                        .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
                        .overlay(
                            RoundedRectangle(cornerRadius: spec.cornerRadius)
                                .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                        )
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    private var cardPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cards (via theme.resolveCard)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(DSCardElevation.allCases, id: \.rawValue) { elevation in
                    let spec = previewTheme.resolveCard(elevation: elevation)
                    
                    VStack {
                        Text(elevation.rawValue)
                            .font(.caption)
                    }
                    .frame(width: 70, height: 60)
                    .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: spec.cornerRadius)
                            .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                    )
                    .shadow(
                        color: spec.shadow.color,
                        radius: spec.shadow.radius,
                        x: spec.shadow.x,
                        y: spec.shadow.y
                    )
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    private var convenienceMethodsDemo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("All Convenience Methods")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            let buttonSpec = previewTheme.resolveButton(variant: .primary, size: .medium, state: .normal)
            let fieldSpec = previewTheme.resolveField(variant: .default, state: .normal)
            let toggleSpec = previewTheme.resolveToggle(isOn: true, state: .normal)
            let formRowSpec = previewTheme.resolveFormRow(capabilities: capabilities)
            let cardSpec = previewTheme.resolveCard(elevation: .raised)
            let listRowSpec = previewTheme.resolveListRow(style: .plain, state: .normal, capabilities: capabilities)
            
            VStack(alignment: .leading, spacing: 4) {
                convenienceRow("resolveButton", detail: "h=\(Int(buttonSpec.height))pt, r=\(Int(buttonSpec.cornerRadius))pt")
                convenienceRow("resolveField", detail: "h=\(Int(fieldSpec.height))pt, r=\(Int(fieldSpec.cornerRadius))pt")
                convenienceRow("resolveToggle", detail: "w=\(Int(toggleSpec.trackWidth))×\(Int(toggleSpec.trackHeight))pt")
                convenienceRow("resolveFormRow", detail: "layout=\(formRowSpec.resolvedLayout)")
                convenienceRow("resolveCard", detail: "r=\(Int(cardSpec.cornerRadius))pt, glass=\(cardSpec.usesGlassEffect)")
                convenienceRow("resolveListRow", detail: "minH=\(Int(listRowSpec.minHeight))pt")
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func convenienceRow(_ method: String, detail: String) -> some View {
        HStack {
            Text(method)
                .font(.caption.monospaced())
                .foregroundStyle(.primary)
            Spacer()
            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Component Styles - Light") {
    NavigationStack {
        ScrollView {
            ComponentStylesShowcaseView()
                .padding()
        }
        .navigationTitle("Component Styles")
    }
}

#Preview("Component Styles - Dark") {
    NavigationStack {
        ScrollView {
            ComponentStylesShowcaseView()
                .padding()
        }
        .navigationTitle("Component Styles")
    }
    .preferredColorScheme(.dark)
}

// MARK: - DSText Showcase

/// Showcase view demonstrating DSText primitive
struct DSTextShowcaseView: View {
    @State private var isDark = false
    
    private var theme: DSTheme {
        isDark ? .dark : .light
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Theme toggle
            Toggle("Dark Theme", isOn: $isDark)
                .padding(.bottom, 8)
            
            // System roles
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Text("System Roles")
                        .font(.headline)
                    
                    ForEach(DSTextRole.systemRoles) { role in
                        HStack(alignment: .firstTextBaseline) {
                            DSText(role.displayName, role: role)
                            Spacer()
                            Text(role.rawValue)
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                                .monospaced()
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .dsTheme(theme)
            
            // Component roles
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Component Roles")
                        .font(.headline)
                    
                    ForEach(DSTextRole.componentRoles) { role in
                        HStack(alignment: .firstTextBaseline) {
                            DSText(role.displayName, role: role)
                            Spacer()
                            Text(role.rawValue)
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                                .monospaced()
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .dsTheme(theme)
            
            // Overrides demo
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Color & Weight Overrides")
                        .font(.headline)
                    
                    DSText("Default body text", role: .body)
                    
                    DSText("Custom accent color", role: .body)
                        .dsTextColor(theme.colors.accent.primary)
                    
                    DSText("Bold headline", role: .headline)
                        .dsTextWeight(.bold)
                    
                    DSText("Light title", role: .title2)
                        .dsTextWeight(.light)
                    
                    DSText("Danger color", role: .body)
                        .dsTextColor(theme.colors.state.danger)
                    
                    DSText("Success color + bold", role: .footnote)
                        .dsTextColor(theme.colors.state.success)
                        .dsTextWeight(.bold)
                }
                .padding(.vertical, 4)
            }
            .dsTheme(theme)
        }
    }
}

#Preview("DSText - Light") {
    NavigationStack {
        ScrollView {
            DSTextShowcaseView()
                .padding()
        }
        .navigationTitle("DSText")
    }
}

#Preview("DSText - Dark") {
    NavigationStack {
        ScrollView {
            DSTextShowcaseView()
                .padding()
        }
        .navigationTitle("DSText")
    }
    .preferredColorScheme(.dark)
}

// MARK: - DSIcon Showcase

/// Showcase view demonstrating DSIcon primitive
struct DSIconShowcaseView: View {
    @State private var isDark = false
    @State private var selectedSize: DSIconSize = .medium
    
    private var theme: DSTheme {
        isDark ? .dark : .light
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Theme toggle
            Toggle("Dark Theme", isOn: $isDark)
                .padding(.bottom, 8)
            
            // Size selector
            VStack(alignment: .leading, spacing: 8) {
                Text("Icon Size")
                    .font(.headline)
                Picker("Size", selection: $selectedSize) {
                    ForEach(DSIconSize.allCases) { size in
                        Text(size.displayName).tag(size)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            // All sizes comparison
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Size Comparison")
                        .font(.headline)
                    
                    HStack(spacing: 24) {
                        ForEach(DSIconSize.allCases) { size in
                            VStack(spacing: 8) {
                                DSIcon("star.fill", size: size, color: .accent)
                                Text(size.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Text("\(Int(size.points))pt")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                    .monospaced()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 4)
            }
            .dsTheme(theme)
            
            // Color variants
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Semantic Colors")
                        .font(.headline)
                    
                    let colors: [(String, DSIconColor)] = [
                        ("Primary", .primary),
                        ("Secondary", .secondary),
                        ("Tertiary", .tertiary),
                        ("Disabled", .disabled),
                        ("Accent", .accent),
                        ("Success", .success),
                        ("Warning", .warning),
                        ("Danger", .danger),
                        ("Info", .info),
                    ]
                    
                    ForEach(colors, id: \.0) { name, color in
                        HStack(spacing: 12) {
                            DSIcon("star.fill", size: selectedSize, color: color)
                            Text(name)
                                .font(.body)
                            Spacer()
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .dsTheme(theme)
            
            // Icon tokens
            GroupBox {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Icon Tokens")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Navigation")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 16) {
                            DSIcon(DSIconToken.Navigation.chevronRight, size: selectedSize)
                            DSIcon(DSIconToken.Navigation.chevronLeft, size: selectedSize)
                            DSIcon(DSIconToken.Navigation.chevronDown, size: selectedSize)
                            DSIcon(DSIconToken.Navigation.arrowRight, size: selectedSize)
                            DSIcon(DSIconToken.Navigation.externalLink, size: selectedSize)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Actions")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 16) {
                            DSIcon(DSIconToken.Action.plus, size: selectedSize, color: .accent)
                            DSIcon(DSIconToken.Action.edit, size: selectedSize, color: .accent)
                            DSIcon(DSIconToken.Action.delete, size: selectedSize, color: .danger)
                            DSIcon(DSIconToken.Action.share, size: selectedSize, color: .accent)
                            DSIcon(DSIconToken.Action.search, size: selectedSize)
                            DSIcon(DSIconToken.Action.settings, size: selectedSize)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("State")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 16) {
                            DSIcon(DSIconToken.State.checkmarkCircle, size: selectedSize, color: .success)
                            DSIcon(DSIconToken.State.warning, size: selectedSize, color: .warning)
                            DSIcon(DSIconToken.State.error, size: selectedSize, color: .danger)
                            DSIcon(DSIconToken.State.info, size: selectedSize, color: .info)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Form")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 16) {
                            DSIcon(DSIconToken.Form.clear, size: selectedSize, color: .tertiary)
                            DSIcon(DSIconToken.Form.eyeOpen, size: selectedSize)
                            DSIcon(DSIconToken.Form.eyeClosed, size: selectedSize)
                            DSIcon(DSIconToken.Form.dropdown, size: selectedSize, color: .secondary)
                            DSIcon(DSIconToken.Form.calendar, size: selectedSize)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("General")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 16) {
                            DSIcon(DSIconToken.General.starFilled, size: selectedSize, color: .accent)
                            DSIcon(DSIconToken.General.heartFilled, size: selectedSize, color: .danger)
                            DSIcon(DSIconToken.General.person, size: selectedSize)
                            DSIcon(DSIconToken.General.lock, size: selectedSize)
                            DSIcon(DSIconToken.General.bell, size: selectedSize)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .dsTheme(theme)
            
            // Text + Icon inline
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Inline with Text")
                        .font(.headline)
                    
                    HStack(spacing: 8) {
                        DSIcon(DSIconToken.State.checkmarkCircle, size: .small, color: .success)
                        DSText("Verified account", role: .body)
                    }
                    .dsTheme(theme)
                    
                    HStack(spacing: 8) {
                        DSIcon(DSIconToken.State.warning, size: .small, color: .warning)
                        DSText("Action required", role: .body)
                    }
                    .dsTheme(theme)
                    
                    HStack(spacing: 8) {
                        DSIcon(DSIconToken.State.error, size: .small, color: .danger)
                        DSText("Connection failed", role: .body)
                            .dsTextColor(theme.colors.state.danger)
                    }
                    .dsTheme(theme)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview("DSIcon - Light") {
    NavigationStack {
        ScrollView {
            DSIconShowcaseView()
                .padding()
        }
        .navigationTitle("DSIcon")
    }
}

#Preview("DSIcon - Dark") {
    NavigationStack {
        ScrollView {
            DSIconShowcaseView()
                .padding()
        }
        .navigationTitle("DSIcon")
    }
    .preferredColorScheme(.dark)
}

// MARK: - DSLoader Showcase

/// Showcase view demonstrating DSLoader and DSProgress primitives
struct DSLoaderShowcaseView: View {
    @State private var isDark = false
    @State private var reduceMotion = false
    @State private var progressValue: Double = 0.6
    
    private var theme: DSTheme {
        DSTheme(
            variant: isDark ? .dark : .light,
            reduceMotion: reduceMotion
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Controls
            Toggle("Dark Theme", isOn: $isDark)
            Toggle("Reduce Motion", isOn: $reduceMotion)
            
            Divider()
            
            // DSLoader section
            loaderSection
            
            Divider()
            
            // DSProgress linear section
            linearProgressSection
            
            Divider()
            
            // DSProgress circular section
            circularProgressSection
            
            Divider()
            
            // Interactive progress
            interactiveProgressSection
            
            Divider()
            
            // In-context examples
            inContextSection
        }
        .dsTheme(theme)
    }
    
    // MARK: - Loader Section
    
    private var loaderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("DSLoader")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Indeterminate spinner with size and color variants.")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            // Size comparison
            GroupBox("Sizes") {
                HStack(spacing: 32) {
                    ForEach(DSLoaderSize.allCases) { size in
                        VStack(spacing: 8) {
                            DSLoader(size: size)
                            Text(size.rawValue)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Text("\(Int(size.points))pt")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                                .monospaced()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            
            // Color variants
            GroupBox("Colors") {
                HStack(spacing: 32) {
                    VStack(spacing: 8) {
                        DSLoader(size: .large, color: .accent)
                        Text("Accent")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSLoader(size: .large, color: .primary)
                        Text("Primary")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSLoader(size: .large, color: .secondary)
                        Text("Secondary")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSLoader(size: .large, color: .custom(.purple))
                        Text("Custom")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
    }
    
    // MARK: - Linear Progress Section
    
    private var linearProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("DSProgress — Linear")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Horizontal progress bar with size variants.")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            GroupBox("Sizes") {
                VStack(spacing: 12) {
                    ForEach(DSProgressSize.allCases) { size in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(size.displayName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            DSProgress(value: 0.6, style: .linear, size: size)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            
            GroupBox("Values") {
                VStack(spacing: 8) {
                    ForEach([0.0, 0.25, 0.5, 0.75, 1.0], id: \.self) { val in
                        HStack {
                            Text("\(Int(val * 100))%")
                                .font(.caption)
                                .frame(width: 40, alignment: .trailing)
                            DSProgress(value: val, style: .linear, size: .medium)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    // MARK: - Circular Progress Section
    
    private var circularProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("DSProgress — Circular")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Circular progress ring with size variants.")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            GroupBox("Sizes") {
                HStack(spacing: 32) {
                    ForEach(DSProgressSize.allCases) { size in
                        VStack(spacing: 8) {
                            DSProgress(value: 0.7, style: .circular, size: size)
                            Text(size.displayName)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            
            GroupBox("Colors") {
                HStack(spacing: 24) {
                    VStack(spacing: 8) {
                        DSProgress(value: 0.7, style: .circular, size: .medium, color: .accent)
                        Text("Accent")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSProgress(value: 0.7, style: .circular, size: .medium, color: .primary)
                        Text("Primary")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSProgress(value: 0.7, style: .circular, size: .medium, color: .secondary)
                        Text("Secondary")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        DSProgress(value: 0.7, style: .circular, size: .medium, color: .custom(.green))
                        Text("Custom")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
    }
    
    // MARK: - Interactive Progress
    
    private var interactiveProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interactive Progress")
                .font(.title2)
                .fontWeight(.semibold)
            
            GroupBox {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        DSProgress(value: progressValue, style: .circular, size: .large)
                        VStack(alignment: .leading) {
                            Text("\(Int(progressValue * 100))% Complete")
                                .font(.headline)
                            DSProgress(value: progressValue, style: .linear, size: .small)
                        }
                    }
                    
                    Slider(value: $progressValue, in: 0...1, step: 0.05) {
                        Text("Progress")
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    // MARK: - In-Context
    
    private var inContextSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("In Context")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Loading button
            GroupBox("Loading Button") {
                HStack(spacing: 8) {
                    DSLoader(size: .small, color: .custom(.white))
                    Text("Loading...")
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(theme.colors.accent.primary, in: RoundedRectangle(cornerRadius: 10))
                .padding(.vertical, 4)
            }
            
            // Download card
            GroupBox("Download Card") {
                DSCard(.raised) {
                    HStack(spacing: 12) {
                        DSProgress(value: 0.65, style: .circular, size: .small, color: .accent)
                        VStack(alignment: .leading, spacing: 2) {
                            DSText("Downloading update...", role: .rowTitle)
                            DSText("65% complete — 12 MB / 18 MB", role: .helperText)
                        }
                        Spacer()
                    }
                }
                .padding(.vertical, 4)
            }
            
            // Upload progress
            GroupBox("Upload Progress") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        DSText("Uploading photo.jpg", role: .rowTitle)
                        Spacer()
                        DSText("80%", role: .helperText)
                    }
                    DSProgress(value: 0.8, style: .linear, size: .small, color: .accent)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview("DSLoader - Light") {
    NavigationStack {
        ScrollView {
            DSLoaderShowcaseView()
                .padding()
        }
        .navigationTitle("DSLoader")
    }
}

#Preview("DSLoader - Dark") {
    NavigationStack {
        ScrollView {
            DSLoaderShowcaseView()
                .padding()
        }
        .navigationTitle("DSLoader")
    }
    .preferredColorScheme(.dark)
}

// MARK: - DSButton Showcase

/// Showcase view demonstrating DSButton control
struct DSButtonShowcaseView: View {
    @State private var isDark = false
    @State private var selectedVariant: DSButtonVariant = .primary
    @State private var selectedSize: DSButtonSize = .medium
    @State private var isLoading = false
    @State private var isDisabled = false
    @State private var isFullWidth = false
    @State private var showIcon = false
    @State private var tapCount = 0
    
    private var theme: DSTheme {
        isDark ? .dark : .light
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Controls
            Toggle("Dark Theme", isOn: $isDark)
            
            Divider()
            
            // Interactive Configuration
            interactiveSection
            
            Divider()
            
            // All Variants
            allVariantsSection
            
            Divider()
            
            // All Sizes
            allSizesSection
            
            Divider()
            
            // States
            statesSection
            
            Divider()
            
            // With Icons
            iconsSection
            
            Divider()
            
            // Full Width
            fullWidthSection
        }
        .dsTheme(theme)
    }
    
    // MARK: - Interactive Section
    
    private var interactiveSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interactive Demo")
                .font(.title2)
                .fontWeight(.semibold)
            
            GroupBox {
                VStack(spacing: 12) {
                    Picker("Variant", selection: $selectedVariant) {
                        ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                            Text(variant.rawValue.capitalized).tag(variant)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Size", selection: $selectedSize) {
                        ForEach(DSButtonSize.allCases, id: \.rawValue) { size in
                            Text(size.rawValue.capitalized).tag(size)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Toggle("Loading", isOn: $isLoading)
                    Toggle("Disabled", isOn: $isDisabled)
                    Toggle("Full Width", isOn: $isFullWidth)
                    Toggle("Show Icon", isOn: $showIcon)
                }
            }
            
            DSButton(
                "Tap Me (\(tapCount))",
                icon: showIcon ? "hand.tap" : nil,
                variant: selectedVariant,
                size: selectedSize,
                isLoading: isLoading,
                isDisabled: isDisabled,
                fullWidth: isFullWidth
            ) {
                tapCount += 1
            }
        }
    }
    
    // MARK: - All Variants
    
    private var allVariantsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("All Variants")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Each variant provides a different level of visual emphasis.")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 12) {
                ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                    HStack {
                        DSButton(
                            LocalizedStringKey(variant.rawValue.capitalized),
                            variant: variant
                        ) { }
                        
                        Spacer()
                        
                        Text(variant.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .monospaced()
                    }
                }
            }
        }
    }
    
    // MARK: - All Sizes
    
    private var allSizesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("All Sizes")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack(spacing: 12) {
                ForEach(DSButtonSize.allCases, id: \.rawValue) { size in
                    DSButton(
                        LocalizedStringKey(size.rawValue.capitalized),
                        variant: .primary,
                        size: size
                    ) { }
                }
            }
            
            HStack(spacing: 12) {
                ForEach(DSButtonSize.allCases, id: \.rawValue) { size in
                    DSButton(
                        LocalizedStringKey(size.rawValue.capitalized),
                        variant: .secondary,
                        size: size
                    ) { }
                }
            }
        }
    }
    
    // MARK: - States
    
    private var statesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("States")
                .font(.title2)
                .fontWeight(.semibold)
            
            ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                VStack(alignment: .leading, spacing: 8) {
                    Text(variant.rawValue.capitalized)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 8) {
                        DSButton("Normal", variant: variant, size: .small) { }
                        DSButton("Disabled", variant: variant, size: .small, isDisabled: true) { }
                        DSButton("Loading", variant: variant, size: .small, isLoading: true) { }
                    }
                }
            }
        }
    }
    
    // MARK: - Icons
    
    private var iconsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("With Icons")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                DSButton("Save", icon: "checkmark", variant: .primary) { }
                DSButton("Edit", icon: "pencil", variant: .secondary) { }
                DSButton("Share", icon: "square.and.arrow.up", variant: .tertiary) { }
                DSButton("Delete", icon: "trash", variant: .destructive) { }
            }
        }
    }
    
    // MARK: - Full Width
    
    private var fullWidthSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Full Width")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                DSButton("Sign In", icon: "arrow.right", variant: .primary, size: .large, fullWidth: true) { }
                DSButton("Create Account", variant: .secondary, size: .large, fullWidth: true) { }
                DSButton("Continue as Guest", variant: .tertiary, fullWidth: true) { }
            }
        }
    }
}

#Preview("DSButton - Light") {
    NavigationStack {
        ScrollView {
            DSButtonShowcaseView()
                .padding()
        }
        .navigationTitle("DSButton")
    }
}

#Preview("DSButton - Dark") {
    NavigationStack {
        ScrollView {
            DSButtonShowcaseView()
                .padding()
        }
        .navigationTitle("DSButton")
    }
    .preferredColorScheme(.dark)
}

// MARK: - DSToggle Showcase

/// Showcase view demonstrating DSToggle and DSCheckbox controls
struct DSToggleShowcaseView: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    
    // Toggle states
    @State private var toggleOn = true
    @State private var toggleOff = false
    @State private var disabledOn = true
    @State private var disabledOff = false
    
    // Checkbox states
    @State private var cbUnchecked: DSCheckboxState = .unchecked
    @State private var cbChecked: DSCheckboxState = .checked
    @State private var cbIntermediate: DSCheckboxState = .intermediate
    @State private var cbDisabledChecked: DSCheckboxState = .checked
    @State private var cbDisabledUnchecked: DSCheckboxState = .unchecked
    
    // Settings-style toggles
    @State private var wifiEnabled = true
    @State private var bluetoothEnabled = false
    @State private var airplaneMode = false
    @State private var notifications = true
    @State private var darkMode = false
    
    // Multi-select checkbox demo
    @State private var selectAll: DSCheckboxState = .intermediate
    @State private var item1: DSCheckboxState = .checked
    @State private var item2: DSCheckboxState = .unchecked
    @State private var item3: DSCheckboxState = .checked
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // MARK: Toggle States
            VStack(alignment: .leading, spacing: 12) {
                Text("Toggle Switch")
                    .font(.headline)
                
                VStack(spacing: 16) {
                    DSToggle("Enabled (On)", isOn: $toggleOn)
                    DSToggle("Enabled (Off)", isOn: $toggleOff)
                    DSToggle("Disabled (On)", isOn: $disabledOn, isDisabled: true)
                    DSToggle("Disabled (Off)", isOn: $disabledOff, isDisabled: true)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
            
            // MARK: Label-less Toggle
            VStack(alignment: .leading, spacing: 12) {
                Text("Label-less Toggle")
                    .font(.headline)
                
                HStack {
                    Text("Custom layout toggle")
                        .foregroundStyle(theme.colors.fg.secondary)
                    Spacer()
                    DSToggle(isOn: $toggleOn)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
            
            // MARK: Settings Style
            VStack(alignment: .leading, spacing: 12) {
                Text("Settings Example")
                    .font(.headline)
                
                VStack(spacing: 0) {
                    settingsRow(icon: "wifi", title: "Wi-Fi", isOn: $wifiEnabled)
                    Divider().padding(.leading, 44)
                    settingsRow(icon: "wave.3.right", title: "Bluetooth", isOn: $bluetoothEnabled)
                    Divider().padding(.leading, 44)
                    settingsRow(icon: "airplane", title: "Airplane Mode", isOn: $airplaneMode)
                    Divider().padding(.leading, 44)
                    settingsRow(icon: "bell.fill", title: "Notifications", isOn: $notifications)
                    Divider().padding(.leading, 44)
                    settingsRow(icon: "moon.fill", title: "Dark Mode", isOn: $darkMode)
                }
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
            
            // MARK: Checkbox States
            VStack(alignment: .leading, spacing: 12) {
                Text("Checkbox")
                    .font(.headline)
                
                Text("Supports hover on macOS (capability: \(capabilities.supportsHover ? "Yes" : "No"))")
                    .font(.caption)
                    .foregroundStyle(theme.colors.fg.tertiary)
                
                VStack(alignment: .leading, spacing: 16) {
                    DSCheckbox("Unchecked", state: $cbUnchecked)
                    DSCheckbox("Checked", state: $cbChecked)
                    DSCheckbox("Intermediate", state: $cbIntermediate)
                    
                    Divider()
                    
                    DSCheckbox("Disabled Checked", state: $cbDisabledChecked, isDisabled: true)
                    DSCheckbox("Disabled Unchecked", state: $cbDisabledUnchecked, isDisabled: true)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
            
            // MARK: Multi-select Checkbox
            VStack(alignment: .leading, spacing: 12) {
                Text("Multi-Select Pattern")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 4) {
                    DSCheckbox("Select All", state: $selectAll)
                    
                    Divider().padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        DSCheckbox("Documents", state: $item1)
                        DSCheckbox("Photos", state: $item2)
                        DSCheckbox("Videos", state: $item3)
                    }
                    .padding(.leading, 28)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
            
            // MARK: Spec Details
            VStack(alignment: .leading, spacing: 12) {
                Text("Toggle Spec (Resolved)")
                    .font(.headline)
                
                let specOn = theme.resolveToggle(isOn: true, state: .normal)
                let specOff = theme.resolveToggle(isOn: false, state: .normal)
                
                VStack(alignment: .leading, spacing: 8) {
                    specRow("Track Size", "\(Int(specOn.trackWidth))×\(Int(specOn.trackHeight)) pt")
                    specRow("Thumb Size", "\(Int(specOn.thumbSize)) pt")
                    specRow("Corner Radius", "\(Int(specOn.trackCornerRadius)) pt")
                    specRow("Border (Off)", "\(specOff.trackBorderWidth) pt")
                    specRow("Opacity (Normal)", "\(specOn.opacity)")
                    specRow("Opacity (Disabled)", "0.5")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
        }
    }
    
    private func settingsRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(theme.colors.accent.primary)
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(theme.colors.accent.primary.opacity(0.12))
                )
            
            Text(title)
                .font(theme.typography.component.rowTitle.font)
                .foregroundStyle(theme.colors.fg.primary)
            
            Spacer()
            
            DSToggle(isOn: isOn)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private func specRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(theme.colors.fg.secondary)
            Spacer()
            Text(value)
                .font(.caption.monospaced())
                .foregroundStyle(theme.colors.fg.primary)
        }
    }
}
