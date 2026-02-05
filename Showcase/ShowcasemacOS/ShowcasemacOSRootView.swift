// ShowcasemacOSRootView.swift
// ShowcasemacOS
//
// Main navigation structure for macOS Showcase with sidebar

import SwiftUI
import ShowcaseCore
import DSCore
import DSTheme
import DSPrimitives
import DSControls

struct ShowcasemacOSRootView: View {
    @State private var selectedCategory: ShowcaseCategory? = .primitives
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
            .navigationSplitViewColumnWidth(min: 200, ideal: 220)
            .navigationTitle("Design System")
        } content: {
            if let category = selectedCategory {
                List(ShowcaseData.items(for: category), selection: $selectedItem) { item in
                    NavigationLink(value: item) {
                        ShowcaseItemRow(item: item)
                    }
                }
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
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
                ShowcasemacOSDetailView(item: item)
            } else {
                ContentUnavailableView(
                    "Select a Component",
                    systemImage: "cube",
                    description: Text("Choose a component to view its showcase")
                )
            }
        }
        .navigationSplitViewStyle(.balanced)
        .toolbar {
            ToolbarItem {
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

struct ShowcasemacOSDetailView: View {
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
    }
    
    @ViewBuilder
    private var showcaseContent: some View {
        switch item.id {
        case "dstext":
            DSTextShowcasemacOSView()
        case "dsicon":
            DSIconShowcasemacOSView()
        case "themeresolver":
            ThemeResolverShowcasemacOSView()
        case "capabilities":
            CapabilitiesShowcasemacOSView()
        case "componentspecs":
            ComponentSpecsShowcasemacOSView()
        case "componentstyles":
            ComponentStylesShowcasemacOSView()
        case "dssurface":
            DSSurfaceShowcasemacOSView()
        case "dscard":
            DSCardShowcasemacOSView()
        case "dsloader":
            DSLoaderShowcasemacOSView()
        case "dsbutton":
            DSButtonShowcasemacOSView()
        case "dstoggle":
            DSToggleShowcasemacOSView()
        case "dstextfield":
            DSTextFieldShowcasemacOSView()
        default:
            // Demo sections
            GroupBox("Light Theme") {
                ShowcasePlaceholder(
                    title: item.title,
                    message: "Light theme demo"
                )
                .frame(minHeight: 200)
            }
            
            GroupBox("Dark Theme") {
                ShowcasePlaceholder(
                    title: item.title,
                    message: "Dark theme demo"
                )
                .frame(minHeight: 200)
            }
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Capabilities Showcase (macOS)

/// Showcase view demonstrating DSCapabilities system for macOS
struct CapabilitiesShowcasemacOSView: View {
    @Environment(\.dsCapabilities) private var capabilities
    @State private var selectedPlatform: DSPlatform = .current
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Left column: Current platform info
            VStack(alignment: .leading, spacing: 16) {
                platformSelector
                capabilitiesDisplay
            }
            .frame(maxWidth: 400)
            
            // Right column: Matrix comparison
            VStack(alignment: .leading, spacing: 16) {
                capabilityMatrix
                computedCapabilities
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var platformSelector: some View {
        GroupBox("Platform Simulation") {
            VStack(alignment: .leading, spacing: 12) {
                Picker("Simulate Platform", selection: $selectedPlatform) {
                    Text("iOS").tag(DSPlatform.iOS)
                    Text("macOS").tag(DSPlatform.macOS)
                    Text("watchOS").tag(DSPlatform.watchOS)
                }
                .pickerStyle(.segmented)
                
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.secondary)
                    Text("Current runtime: \(DSPlatform.current.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var simulatedCapabilities: DSCapabilities {
        DSCapabilities.for(platform: selectedPlatform)
    }
    
    private var capabilitiesDisplay: some View {
        GroupBox("Capabilities for \(selectedPlatform.rawValue)") {
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
                Divider().padding(.vertical, 4)
                preferenceRow("Form Row Layout", value: simulatedCapabilities.preferredFormRowLayout.rawValue)
                Divider()
                preferenceRow("Picker Presentation", value: simulatedCapabilities.preferredPickerPresentation.rawValue)
                Divider()
                preferenceRow("Text Field Mode", value: simulatedCapabilities.preferredTextFieldMode.rawValue)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func capabilityRow(_ label: String, value: Bool) -> some View {
        HStack {
            Text(label)
            Spacer()
            Image(systemName: value ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(value ? .green : .secondary)
        }
        .padding(.vertical, 6)
    }
    
    private func preferenceRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .font(.system(.body, design: .monospaced))
        }
        .padding(.vertical, 6)
    }
    
    private var capabilityMatrix: some View {
        GroupBox("Platform Capability Matrix") {
            Grid(alignment: .leading, horizontalSpacing: 24, verticalSpacing: 8) {
                GridRow {
                    Text("Capability")
                        .fontWeight(.semibold)
                    Text("iOS")
                        .fontWeight(.semibold)
                    Text("macOS")
                        .fontWeight(.semibold)
                    Text("watchOS")
                        .fontWeight(.semibold)
                }
                
                Divider()
                    .gridCellUnsizedAxes(.horizontal)
                
                matrixRow("Hover", ios: false, macos: true, watch: false)
                matrixRow("Focus Ring", ios: false, macos: true, watch: false)
                matrixRow("Inline Text", ios: true, macos: true, watch: false)
                matrixRow("Inline Pickers", ios: true, macos: true, watch: false)
                matrixRow("Toasts", ios: true, macos: true, watch: false)
                matrixRow("Large Tap Targets", ios: true, macos: false, watch: true)
                
                Divider()
                    .gridCellUnsizedAxes(.horizontal)
                
                GridRow {
                    Text("Form Layout")
                    Text("inline")
                        .foregroundStyle(.secondary)
                    Text("twoColumn")
                        .foregroundStyle(.secondary)
                    Text("stacked")
                        .foregroundStyle(.secondary)
                }
                
                GridRow {
                    Text("Picker Style")
                    Text("sheet")
                        .foregroundStyle(.secondary)
                    Text("menu")
                        .foregroundStyle(.secondary)
                    Text("navigation")
                        .foregroundStyle(.secondary)
                }
                
                GridRow {
                    Text("TextField Mode")
                    Text("inline")
                        .foregroundStyle(.secondary)
                    Text("inline")
                        .foregroundStyle(.secondary)
                    Text("separateScreen")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
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
        Image(systemName: value ? "checkmark.circle.fill" : "xmark.circle")
            .foregroundStyle(value ? .green : .secondary)
    }
    
    private var computedCapabilities: some View {
        GroupBox("Computed Queries") {
            VStack(spacing: 0) {
                computedRow("Supports Pointer", value: simulatedCapabilities.supportsPointerInteraction)
                Divider()
                computedRow("Requires Navigation", value: simulatedCapabilities.requiresNavigationPatterns)
                Divider()
                computedRow("Compact Screen", value: simulatedCapabilities.isCompactScreen)
                Divider()
                HStack {
                    Text("Min Tap Target Size")
                    Spacer()
                    Text("\(Int(simulatedCapabilities.minimumTapTargetSize))pt")
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func computedRow(_ label: String, value: Bool) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value ? "true" : "false")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(value ? .primary : .secondary)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Theme Resolver Showcase (macOS)

/// Showcase view demonstrating DSThemeResolver accessibility integration for macOS
struct ThemeResolverShowcasemacOSView: View {
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
            differentiateWithoutColor: false, dynamicTypeSize: dynamicTypeSize,
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
        HStack(alignment: .top, spacing: 24) {
            // Left column: Configuration
            VStack(alignment: .leading, spacing: 16) {
                configurationSection
            }
            .frame(maxWidth: 350)
            
            // Right column: Preview
            VStack(alignment: .leading, spacing: 16) {
                themePreview
            }
            .frame(maxWidth: .infinity)
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
                .padding(.vertical, 4)
            }
            
            // Density picker
            GroupBox("Density") {
                Picker("Density", selection: $selectedDensity) {
                    Text("Compact").tag(DSDensity.compact)
                    Text("Regular").tag(DSDensity.regular)
                    Text("Spacious").tag(DSDensity.spacious)
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 4)
            }
            
            // Dynamic Type Size
            GroupBox("Dynamic Type") {
                VStack(alignment: .leading, spacing: 8) {
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
                    
                    Text("Current: \(dynamicTypeSize.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            
            // Accessibility toggles
            GroupBox("Accessibility Settings") {
                VStack(spacing: 0) {
                    Toggle("Reduce Motion", isOn: $reduceMotion)
                        .padding(.vertical, 6)
                    Divider()
                    Toggle("Increased Contrast", isOn: $increasedContrast)
                        .padding(.vertical, 6)
                    Divider()
                    Toggle("Bold Text", isOn: $boldText)
                        .padding(.vertical, 6)
                    Divider()
                    Toggle("Reduce Transparency", isOn: $reduceTransparency)
                        .padding(.vertical, 6)
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    private var themePreview: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Resolved Theme Preview")
                .font(.headline)
            
            HStack(alignment: .top, spacing: 16) {
                // Colors preview
                GroupBox("Colors") {
                    VStack(spacing: 8) {
                        colorRow("Canvas", color: resolvedTheme.colors.bg.canvas)
                        colorRow("Surface", color: resolvedTheme.colors.bg.surface)
                        colorRow("Elevated", color: resolvedTheme.colors.bg.surfaceElevated)
                        Divider()
                        colorRow("Primary", color: resolvedTheme.colors.fg.primary)
                        colorRow("Secondary", color: resolvedTheme.colors.fg.secondary)
                        colorRow("Tertiary", color: resolvedTheme.colors.fg.tertiary)
                        Divider()
                        colorRow("Accent", color: resolvedTheme.colors.accent.primary)
                        colorRow("Accent Secondary", color: resolvedTheme.colors.accent.secondary)
                        colorRow("Border", color: resolvedTheme.colors.border.subtle)
                    }
                    .padding(.vertical, 4)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Typography preview
                    GroupBox("Typography") {
                        VStack(alignment: .leading, spacing: 8) {
                            typographyRow("Large Title", font: resolvedTheme.typography.system.largeTitle.font)
                            typographyRow("Title", font: resolvedTheme.typography.system.title1.font)
                            typographyRow("Headline", font: resolvedTheme.typography.system.headline.font)
                            typographyRow("Body", font: resolvedTheme.typography.system.body.font)
                            typographyRow("Callout", font: resolvedTheme.typography.system.callout.font)
                            typographyRow("Subheadline", font: resolvedTheme.typography.system.subheadline.font)
                            typographyRow("Footnote", font: resolvedTheme.typography.system.footnote.font)
                            typographyRow("Caption", font: resolvedTheme.typography.system.caption1.font)
                        }
                        .padding(.vertical, 4)
                    }
                    
                    // Spacing preview
                    GroupBox("Spacing Scale") {
                        HStack(spacing: 12) {
                            spacingBox("XS", value: resolvedTheme.spacing.padding.xs)
                            spacingBox("S", value: resolvedTheme.spacing.padding.s)
                            spacingBox("M", value: resolvedTheme.spacing.padding.m)
                            spacingBox("L", value: resolvedTheme.spacing.padding.l)
                            spacingBox("XL", value: resolvedTheme.spacing.padding.xl)
                            spacingBox("2XL", value: resolvedTheme.spacing.padding.xxl)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            
            HStack(alignment: .top, spacing: 16) {
                // Radii preview
                GroupBox("Corner Radii") {
                    HStack(spacing: 16) {
                        radiusBox("XS", value: resolvedTheme.radii.scale.xs)
                        radiusBox("S", value: resolvedTheme.radii.scale.s)
                        radiusBox("M", value: resolvedTheme.radii.scale.m)
                        radiusBox("L", value: resolvedTheme.radii.scale.l)
                        radiusBox("XL", value: resolvedTheme.radii.scale.xl)
                    }
                    .padding(.vertical, 4)
                }
                
                // Motion preview
                GroupBox("Motion Settings") {
                    VStack(alignment: .leading, spacing: 8) {
                        motionRow("Reduce Motion", value: resolvedTheme.motion.reduceMotionEnabled ? "Enabled" : "Disabled")
                        Divider()
                        motionRow("Fast", value: "\(Int(resolvedTheme.motion.duration.fast * 1000))ms")
                        motionRow("Normal", value: "\(Int(resolvedTheme.motion.duration.normal * 1000))ms")
                        motionRow("Slow", value: "\(Int(resolvedTheme.motion.duration.slow * 1000))ms")
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
    
    private func colorRow(_ label: String, color: Color) -> some View {
        HStack {
            Text(label)
                .font(.caption)
            Spacer()
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 80, height: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                )
        }
    }
    
    private func typographyRow(_ label: String, font: Font) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)
            Text("Sample")
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
    
    private func radiusBox(_ label: String, value: CGFloat) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: value)
                .fill(Color.accentColor.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: value)
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
                .font(.caption)
            Spacer()
            Text(value)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Theme Resolver macOS") {
    ScrollView {
        ThemeResolverShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}

#Preview("macOS Root View") {
    ShowcasemacOSRootView()
}

#Preview("Capabilities Showcase") {
    ScrollView {
        CapabilitiesShowcasemacOSView()
            .padding()
    }
    .frame(width: 800, height: 600)
}

// MARK: - Component Specs Showcase (macOS)

/// macOS Showcase view for component specs with two-column layout
struct ComponentSpecsShowcasemacOSView: View {
    @State private var selectedVariant: DSThemeVariant = .light
    
    private var previewTheme: DSTheme {
        selectedVariant == .light ? .light : .dark
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Theme toggle
            HStack {
                Text("Theme Variant")
                    .font(.headline)
                Picker("", selection: $selectedVariant) {
                    Text("Light").tag(DSThemeVariant.light)
                    Text("Dark").tag(DSThemeVariant.dark)
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }
            
            HStack(alignment: .top, spacing: 24) {
                // Left column: Buttons and Fields
                VStack(alignment: .leading, spacing: 20) {
                    macOSButtonSpecSection
                    macOSFieldSpecSection
                    macOSToggleSpecSection
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Right column: Cards, Rows, Form Layout
                VStack(alignment: .leading, spacing: 20) {
                    macOSCardSpecSection
                    macOSFormRowSpecSection
                    macOSListRowSpecSection
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    // MARK: - Buttons
    
    private var macOSButtonSpecSection: some View {
        GroupBox("DSButtonSpec") {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                    HStack(spacing: 6) {
                        Text(variant.rawValue)
                            .font(.caption)
                            .frame(width: 80, alignment: .trailing)
                        
                        ForEach(DSButtonSize.allCases, id: \.rawValue) { size in
                            let spec = DSButtonSpec.resolve(
                                theme: previewTheme,
                                variant: variant,
                                size: size,
                                state: .normal
                            )
                            
                            Text(size.rawValue)
                                .font(.system(size: spec.typography.size, weight: spec.typography.weight))
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
            .padding(4)
        }
    }
    
    // MARK: - Fields
    
    private var macOSFieldSpecSection: some View {
        GroupBox("DSFieldSpec") {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(
                    [("Normal", DSControlState.normal, DSValidationState.none),
                     ("Focused", DSControlState.focused, DSValidationState.none),
                     ("Error", DSControlState.normal, DSValidationState.error(message: "Required")),
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
                            .frame(width: 60, alignment: .trailing)
                        
                        Text("Input text")
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
            .padding(4)
        }
    }
    
    // MARK: - Toggles
    
    private var macOSToggleSpecSection: some View {
        GroupBox("DSToggleSpec") {
            HStack(spacing: 16) {
                ForEach(
                    [(true, DSControlState.normal, "On"),
                     (false, DSControlState.normal, "Off"),
                     (true, DSControlState.disabled, "Disabled")],
                    id: \.2
                ) { isOn, state, label in
                    let spec = DSToggleSpec.resolve(theme: previewTheme, isOn: isOn, state: state)
                    
                    VStack(spacing: 4) {
                        Capsule()
                            .fill(spec.trackColor)
                            .frame(width: spec.trackWidth, height: spec.trackHeight)
                            .overlay(Capsule().stroke(spec.trackBorderColor, lineWidth: spec.trackBorderWidth))
                            .opacity(spec.opacity)
                        
                        Text(label)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(4)
        }
    }
    
    // MARK: - Cards
    
    private var macOSCardSpecSection: some View {
        GroupBox("DSCardSpec") {
            HStack(spacing: 12) {
                ForEach(DSCardElevation.allCases, id: \.rawValue) { elevation in
                    let spec = DSCardSpec.resolve(theme: previewTheme, elevation: elevation)
                    
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: spec.cornerRadius)
                            .fill(spec.backgroundColor)
                            .frame(width: 70, height: 50)
                            .shadow(color: spec.shadow.color, radius: spec.shadow.radius, x: spec.shadow.x, y: spec.shadow.y)
                            .overlay(
                                RoundedRectangle(cornerRadius: spec.cornerRadius)
                                    .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                            )
                        
                        Text(elevation.rawValue)
                            .font(.caption2)
                        
                        if spec.usesGlassEffect {
                            Text("glass")
                                .font(.system(size: 9))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(4)
        }
    }
    
    // MARK: - Form Row
    
    private var macOSFormRowSpecSection: some View {
        GroupBox("DSFormRowSpec") {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(
                    [("iOS", DSCapabilities.iOS()),
                     ("macOS", DSCapabilities.macOS()),
                     ("watchOS", DSCapabilities.watchOS())],
                    id: \.0
                ) { platform, caps in
                    let spec = DSFormRowSpec.resolve(theme: previewTheme, capabilities: caps)
                    
                    HStack(spacing: 8) {
                        Text(platform)
                            .font(.caption)
                            .frame(width: 60, alignment: .trailing)
                        
                        Text(spec.resolvedLayout.rawValue)
                            .font(.system(.caption, design: .monospaced))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 4))
                        
                        Text("h:\(Int(spec.minHeight))pt")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        
                        if let lw = spec.labelWidth {
                            Text("label:\(Int(lw))pt")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(4)
        }
    }
    
    // MARK: - List Row
    
    private var macOSListRowSpecSection: some View {
        GroupBox("DSListRowSpec") {
            VStack(spacing: 0) {
                ForEach(DSListRowStyle.allCases, id: \.rawValue) { style in
                    let spec = DSListRowSpec.resolve(
                        theme: previewTheme,
                        style: style,
                        state: .normal,
                        capabilities: .macOS()
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
                    .padding(.horizontal, 8)
                    .frame(minHeight: spec.minHeight)
                    
                    if style != DSListRowStyle.allCases.last {
                        Divider()
                    }
                }
            }
            .padding(4)
        }
    }
}

#Preview("Component Specs macOS") {
    ScrollView {
        ComponentSpecsShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}

// MARK: - Component Styles Showcase (macOS)

/// Showcase view demonstrating DSComponentStyles registry for macOS.
struct ComponentStylesShowcasemacOSView: View {
    @Environment(\.dsTheme) private var theme
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
            styles.card = DSCardStyleResolver(id: "accent-border") { theme, elevation in
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
        HStack(alignment: .top, spacing: 24) {
            // Left: Configuration
            GroupBox("Configuration") {
                VStack(alignment: .leading, spacing: 12) {
                    Toggle("Dark Theme", isOn: $useDarkTheme)
                    Toggle("Custom Button (Pill)", isOn: $useCustomButton)
                    Toggle("Custom Card (Accent Border)", isOn: $useCustomCard)
                    
                    Divider()
                    
                    Text("Active Resolvers")
                        .font(.headline)
                    
                    resolverIdGrid
                }
                .padding(4)
            }
            .frame(minWidth: 260, maxWidth: 300)
            
            // Right: Live Preview
            GroupBox("Live Preview") {
                VStack(alignment: .leading, spacing: 16) {
                    // Buttons
                    buttonPreview
                    
                    Divider()
                    
                    // Cards
                    cardPreview
                    
                    Divider()
                    
                    // Convenience methods
                    convenienceMethodsSection
                }
                .padding(4)
            }
        }
    }
    
    private var resolverIdGrid: some View {
        let styles = previewTheme.componentStyles
        return VStack(alignment: .leading, spacing: 4) {
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
                .padding(.horizontal, 6)
                .padding(.vertical, 1)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(id == "default" ? Color.secondary.opacity(0.1) : Color.orange.opacity(0.1))
                )
        }
    }
    
    private var buttonPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Buttons")
                .font(.headline)
            
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
    }
    
    private var cardPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cards")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(DSCardElevation.allCases, id: \.rawValue) { elevation in
                    let spec = previewTheme.resolveCard(elevation: elevation)
                    
                    VStack {
                        Text(elevation.rawValue)
                            .font(.caption)
                    }
                    .frame(width: 80, height: 60)
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
    }
    
    private var convenienceMethodsSection: some View {
        let capabilities = DSCapabilities.macOS()
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Convenience Methods")
                .font(.headline)
            
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
    }
    
    private func convenienceRow(_ method: String, detail: String) -> some View {
        HStack {
            Text(method)
                .font(.caption.monospaced())
            Spacer()
            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Component Styles macOS") {
    ScrollView {
        ComponentStylesShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}

// MARK: - DSText Showcase (macOS)

/// Showcase view demonstrating DSText primitive on macOS
struct DSTextShowcasemacOSView: View {
    @State private var isDark = false
    
    private var theme: DSTheme {
        isDark ? .dark : .light
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Left column: Configuration + System roles
            VStack(alignment: .leading, spacing: 16) {
                Toggle("Dark Theme", isOn: $isDark)
                
                GroupBox("System Roles") {
                    VStack(alignment: .leading, spacing: 8) {
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
            }
            .frame(minWidth: 350)
            
            // Right column: Component roles + Overrides
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Component Roles") {
                    VStack(alignment: .leading, spacing: 8) {
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
                
                GroupBox("Color & Weight Overrides") {
                    VStack(alignment: .leading, spacing: 8) {
                        DSText("Default body text", role: .body)
                        DSText("Accent color override", role: .body)
                            .dsTextColor(theme.colors.accent.primary)
                        DSText("Bold headline", role: .headline)
                            .dsTextWeight(.bold)
                        DSText("Light title", role: .title2)
                            .dsTextWeight(.light)
                        DSText("Danger color", role: .body)
                            .dsTextColor(theme.colors.state.danger)
                        DSText("Success + bold", role: .footnote)
                            .dsTextColor(theme.colors.state.success)
                            .dsTextWeight(.bold)
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
            }
            .frame(minWidth: 350)
        }
    }
}

#Preview("DSText macOS") {
    ScrollView {
        DSTextShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}

// MARK: - DSIcon Showcase (macOS)

/// Showcase view demonstrating DSIcon primitive on macOS
struct DSIconShowcasemacOSView: View {
    @State private var isDark = false
    @State private var selectedSize: DSIconSize = .medium
    
    private var theme: DSTheme {
        isDark ? .dark : .light
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Left column: Config + sizes + colors
            VStack(alignment: .leading, spacing: 16) {
                Toggle("Dark Theme", isOn: $isDark)
                
                Picker("Icon Size", selection: $selectedSize) {
                    ForEach(DSIconSize.allCases) { size in
                        Text(size.displayName).tag(size)
                    }
                }
                .pickerStyle(.segmented)
                
                GroupBox("Size Comparison") {
                    HStack(spacing: 32) {
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
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                GroupBox("Semantic Colors") {
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
                    
                    VStack(spacing: 6) {
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
            }
            .frame(minWidth: 350)
            
            // Right column: Icon tokens
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Navigation Icons") {
                    HStack(spacing: 20) {
                        DSIcon(DSIconToken.Navigation.chevronRight, size: selectedSize)
                        DSIcon(DSIconToken.Navigation.chevronLeft, size: selectedSize)
                        DSIcon(DSIconToken.Navigation.chevronDown, size: selectedSize)
                        DSIcon(DSIconToken.Navigation.arrowRight, size: selectedSize)
                        DSIcon(DSIconToken.Navigation.externalLink, size: selectedSize)
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                GroupBox("Action Icons") {
                    HStack(spacing: 20) {
                        DSIcon(DSIconToken.Action.plus, size: selectedSize, color: .accent)
                        DSIcon(DSIconToken.Action.edit, size: selectedSize, color: .accent)
                        DSIcon(DSIconToken.Action.delete, size: selectedSize, color: .danger)
                        DSIcon(DSIconToken.Action.share, size: selectedSize, color: .accent)
                        DSIcon(DSIconToken.Action.search, size: selectedSize)
                        DSIcon(DSIconToken.Action.settings, size: selectedSize)
                        DSIcon(DSIconToken.Action.refresh, size: selectedSize)
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                GroupBox("State Icons") {
                    HStack(spacing: 20) {
                        DSIcon(DSIconToken.State.checkmarkCircle, size: selectedSize, color: .success)
                        DSIcon(DSIconToken.State.warning, size: selectedSize, color: .warning)
                        DSIcon(DSIconToken.State.error, size: selectedSize, color: .danger)
                        DSIcon(DSIconToken.State.info, size: selectedSize, color: .info)
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                GroupBox("Form Icons") {
                    HStack(spacing: 20) {
                        DSIcon(DSIconToken.Form.clear, size: selectedSize, color: .tertiary)
                        DSIcon(DSIconToken.Form.eyeOpen, size: selectedSize)
                        DSIcon(DSIconToken.Form.eyeClosed, size: selectedSize)
                        DSIcon(DSIconToken.Form.dropdown, size: selectedSize, color: .secondary)
                        DSIcon(DSIconToken.Form.calendar, size: selectedSize)
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                GroupBox("Inline with Text") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            DSIcon(DSIconToken.State.checkmarkCircle, size: .small, color: .success)
                            DSText("Verified account", role: .body)
                        }
                        HStack(spacing: 8) {
                            DSIcon(DSIconToken.State.warning, size: .small, color: .warning)
                            DSText("Action required", role: .body)
                        }
                        HStack(spacing: 8) {
                            DSIcon(DSIconToken.State.error, size: .small, color: .danger)
                            DSText("Connection failed", role: .body)
                                .dsTextColor(theme.colors.state.danger)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
            }
            .frame(minWidth: 350)
        }
    }
}

#Preview("DSIcon macOS") {
    ScrollView {
        DSIconShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}

// MARK: - DSSurface Showcase (macOS)

/// macOS showcase for DSSurface primitive
struct DSSurfaceShowcasemacOSView: View {
    @Environment(\.dsTheme) private var theme
    @State private var showStroke = false

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Configuration
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Configuration") {
                    Toggle("Show Stroke", isOn: $showStroke)
                        .padding(.vertical, 4)
                }

                GroupBox("Surface Roles") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(DSSurfaceRole.allCases) { role in
                            HStack {
                                Circle()
                                    .fill(role.resolveColor(from: theme))
                                    .frame(width: 16, height: 16)
                                    .overlay(
                                        Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 0.5)
                                    )
                                Text(role.displayName)
                                    .font(.callout)
                                Spacer()
                                Text(".\(role.rawValue)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(width: 250)

            // Preview
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Surface Layering") {
                    DSSurface(.canvas) {
                        VStack(spacing: 0) {
                            ForEach(DSSurfaceRole.allCases) { role in
                                DSSurface(role, stroke: showStroke) {
                                    HStack {
                                        DSText(role.displayName, role: .rowTitle)
                                        Spacer()
                                        DSText(verbatim: ".\(role.rawValue)", role: .helperText)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                GroupBox("Nested Surfaces") {
                    DSSurface(.canvas) {
                        HStack(spacing: 16) {
                            DSSurface(.surface, stroke: showStroke, cornerRadius: 10) {
                                VStack(spacing: 8) {
                                    DSSurface(.card, stroke: true, cornerRadius: 8) {
                                        DSText("Card", role: .rowTitle)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                    }
                                    DSSurface(.surfaceElevated, stroke: true, cornerRadius: 8) {
                                        DSText("Elevated", role: .rowTitle)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding()
                            }
                            DSSurface(.surfaceElevated, cornerRadius: 10) {
                                VStack(spacing: 8) {
                                    DSSurface(.card, stroke: true, cornerRadius: 8) {
                                        DSText("Card", role: .rowTitle)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding()
                            }
                        }
                        .padding()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
    }
}

// MARK: - DSCard Showcase (macOS)

/// macOS showcase for DSCard primitive
struct DSCardShowcasemacOSView: View {
    @Environment(\.dsTheme) private var theme

    private var isDark: Bool { theme.isDark }

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Spec sidebar
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Spec Details") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(DSCardElevation.allCases, id: \.self) { elevation in
                            let spec = theme.resolveCard(elevation: elevation)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(elevation.rawValue.capitalized)
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                HStack(spacing: 12) {
                                    specBadge(label: "radius", value: "\(Int(spec.cornerRadius))")
                                    specBadge(label: "shadow", value: String(format: "%.1f", spec.shadow.radius))
                                    specBadge(label: "glass", value: spec.usesGlassEffect ? "yes" : "no")
                                    specBadge(label: "border", value: String(format: "%.1f", spec.borderWidth))
                                }
                            }
                            if elevation != .overlay { Divider() }
                        }
                    }
                    .padding(.vertical, 4)
                }

                GroupBox("DSDivider") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Themed separator using theme colors.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        VStack(spacing: 8) {
                            Text("Above")
                            DSDivider()
                            Text("Below")
                        }
                        .padding(.vertical, 4)
                        HStack(spacing: 8) {
                            Text("L")
                            DSDivider(.vertical)
                            Text("M")
                            DSDivider(.vertical)
                            Text("R")
                        }
                        .frame(height: 24)
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(width: 280)

            // Elevation preview
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Elevation Levels") {
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
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }

                GroupBox("Light vs Dark") {
                    HStack(spacing: 16) {
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
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

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
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                }

                GroupBox("Card with Content") {
                    ZStack {
                        (isDark ? Color(hex: "#0B0E14") : Color(hex: "#F7F8FA"))

                        DSCard(.raised) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.yellow)
                                    DSText("Featured", role: .headline)
                                    Spacer()
                                }
                                DSText("Sample card with rich content demonstrating DSCard + DSDivider.", role: .body)
                                DSDivider()
                                HStack {
                                    DSText("Action", role: .callout)
                                        .dsTextColor(theme.colors.accent.primary)
                                    Spacer()
                                    DSIcon(DSIconToken.Navigation.chevronRight, size: .small, color: .secondary)
                                }
                            }
                        }
                        .padding()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
    }

    @ViewBuilder
    private func specBadge(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.caption2).fontWeight(.semibold)
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
    }
}

#Preview("DSSurface macOS") {
    ScrollView {
        DSSurfaceShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 600)
}

#Preview("DSCard macOS") {
    ScrollView {
        DSCardShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}

// MARK: - DSLoader Showcase (macOS)

/// macOS Showcase view demonstrating DSLoader and DSProgress primitives
struct DSLoaderShowcasemacOSView: View {
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
        HStack(alignment: .top, spacing: 24) {
            // Left column: DSLoader + Controls
            VStack(alignment: .leading, spacing: 16) {
                // Configuration
                GroupBox("Configuration") {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Dark Theme", isOn: $isDark)
                        Toggle("Reduce Motion", isOn: $reduceMotion)
                    }
                    .padding(.vertical, 4)
                }
                
                // DSLoader Sizes
                GroupBox("DSLoader — Sizes") {
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
                .dsTheme(theme)
                
                // DSLoader Colors
                GroupBox("DSLoader — Colors") {
                    HStack(spacing: 32) {
                        VStack(spacing: 8) {
                            DSLoader(size: .large, color: .accent)
                            Text("Accent").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 8) {
                            DSLoader(size: .large, color: .primary)
                            Text("Primary").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 8) {
                            DSLoader(size: .large, color: .secondary)
                            Text("Secondary").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack(spacing: 8) {
                            DSLoader(size: .large, color: .custom(.purple))
                            Text("Custom").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .dsTheme(theme)
                
                // Interactive Progress
                GroupBox("Interactive Progress") {
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            DSProgress(value: progressValue, style: .circular, size: .large)
                            VStack(alignment: .leading, spacing: 4) {
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
                .dsTheme(theme)
            }
            .frame(maxWidth: .infinity)
            
            // Right column: DSProgress
            VStack(alignment: .leading, spacing: 16) {
                // Linear sizes
                GroupBox("DSProgress — Linear") {
                    VStack(spacing: 12) {
                        ForEach(DSProgressSize.allCases) { size in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(size.displayName)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                DSProgress(value: 0.6, style: .linear, size: size)
                            }
                        }
                        
                        Divider()
                        
                        // Values
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
                .dsTheme(theme)
                
                // Circular sizes
                GroupBox("DSProgress — Circular") {
                    HStack(spacing: 24) {
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
                .dsTheme(theme)
                
                // Colors
                GroupBox("DSProgress — Colors") {
                    VStack(spacing: 8) {
                        DSProgress(value: 0.6, style: .linear, color: .accent)
                        DSProgress(value: 0.6, style: .linear, color: .primary)
                        DSProgress(value: 0.6, style: .linear, color: .secondary)
                        DSProgress(value: 0.6, style: .linear, color: .custom(.green))
                        
                        Divider()
                        
                        HStack(spacing: 16) {
                            DSProgress(value: 0.7, style: .circular, size: .small, color: .accent)
                            DSProgress(value: 0.7, style: .circular, size: .small, color: .primary)
                            DSProgress(value: 0.7, style: .circular, size: .small, color: .custom(.green))
                            DSProgress(value: 0.7, style: .circular, size: .small, color: .custom(.orange))
                        }
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                // In Context
                GroupBox("In Context") {
                    VStack(alignment: .leading, spacing: 12) {
                        // Loading button
                        HStack(spacing: 8) {
                            DSLoader(size: .small, color: .custom(.white))
                            Text("Loading...")
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(theme.colors.accent.primary, in: RoundedRectangle(cornerRadius: 8))
                        
                        Divider()
                        
                        // Download row
                        HStack(spacing: 12) {
                            DSProgress(value: 0.65, style: .circular, size: .small, color: .accent)
                            VStack(alignment: .leading, spacing: 2) {
                                DSText("Downloading update...", role: .rowTitle)
                                DSText("65% — 12 MB / 18 MB", role: .helperText)
                            }
                            Spacer()
                        }
                        
                        // Upload row
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                DSText("Uploading photo.jpg", role: .rowTitle)
                                Spacer()
                                DSText("80%", role: .helperText)
                            }
                            DSProgress(value: 0.8, style: .linear, size: .small, color: .accent)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview("DSLoader macOS") {
    ScrollView {
        DSLoaderShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}

// MARK: - DSButton Showcase (macOS)

/// macOS showcase view demonstrating DSButton control
struct DSButtonShowcasemacOSView: View {
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
        HStack(alignment: .top, spacing: 24) {
            // Left column: Configuration + Interactive
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Configuration") {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Dark Theme", isOn: $isDark)
                        
                        Divider()
                        
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
                    .padding(.vertical, 4)
                }
                
                GroupBox("Interactive Preview") {
                    VStack(spacing: 12) {
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
                        
                        Text("Tapped \(tapCount) time(s)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                .dsTheme(theme)
            }
            .frame(maxWidth: 350)
            
            // Right column: Variants, Sizes, States
            VStack(alignment: .leading, spacing: 16) {
                // All Variants
                GroupBox("All Variants") {
                    HStack(spacing: 12) {
                        ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                            DSButton(
                                LocalizedStringKey(variant.rawValue.capitalized),
                                variant: variant
                            ) { }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                // All Sizes
                GroupBox("All Sizes") {
                    VStack(alignment: .leading, spacing: 8) {
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
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                // States matrix
                GroupBox("States (Variant x State)") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                            HStack(spacing: 8) {
                                Text(variant.rawValue)
                                    .font(.caption)
                                    .frame(width: 80, alignment: .trailing)
                                
                                DSButton("Normal", variant: variant, size: .small) { }
                                DSButton("Disabled", variant: variant, size: .small, isDisabled: true) { }
                                DSButton("Loading", variant: variant, size: .small, isLoading: true) { }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                // With Icons
                GroupBox("With Icons") {
                    HStack(spacing: 12) {
                        DSButton("Save", icon: "checkmark", variant: .primary) { }
                        DSButton("Edit", icon: "pencil", variant: .secondary) { }
                        DSButton("Share", icon: "square.and.arrow.up", variant: .tertiary) { }
                        DSButton("Delete", icon: "trash", variant: .destructive) { }
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                // Full Width
                GroupBox("Full Width") {
                    VStack(spacing: 8) {
                        DSButton("Sign In", icon: "arrow.right", variant: .primary, size: .large, fullWidth: true) { }
                        DSButton("Create Account", variant: .secondary, size: .large, fullWidth: true) { }
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
            }
        }
    }
}

#Preview("DSButton macOS") {
    ScrollView {
        DSButtonShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}

// MARK: - DSToggle Showcase (macOS)

/// Showcase view demonstrating DSToggle and DSCheckbox on macOS
struct DSToggleShowcasemacOSView: View {
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
    
    // Settings toggles
    @State private var wifiEnabled = true
    @State private var bluetoothEnabled = false
    @State private var notifications = true
    
    // Bool binding checkboxes
    @State private var acceptTerms = false
    @State private var subscribeNewsletter = true
    
    // Multi-select
    @State private var selectAll: DSCheckboxState = .intermediate
    @State private var doc: DSCheckboxState = .checked
    @State private var photo: DSCheckboxState = .unchecked
    @State private var video: DSCheckboxState = .checked
    @State private var music: DSCheckboxState = .unchecked
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Left column: Toggle Switch
            VStack(alignment: .leading, spacing: 24) {
                // MARK: Toggle States
                GroupBox("Toggle Switch") {
                    VStack(alignment: .leading, spacing: 16) {
                        DSToggle("Enabled (On)", isOn: $toggleOn)
                        DSToggle("Enabled (Off)", isOn: $toggleOff)
                        
                        Divider()
                        
                        DSToggle("Disabled (On)", isOn: $disabledOn, isDisabled: true)
                        DSToggle("Disabled (Off)", isOn: $disabledOff, isDisabled: true)
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: Label-less Toggle
                GroupBox("Label-less Toggle") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Custom label layout")
                                .foregroundStyle(theme.colors.fg.secondary)
                            Spacer()
                            DSToggle(isOn: $toggleOn)
                        }
                        
                        HStack {
                            Image(systemName: "wifi")
                                .foregroundStyle(theme.colors.accent.primary)
                            Text("Wi-Fi")
                            Spacer()
                            DSToggle(isOn: $wifiEnabled)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: Settings Example
                GroupBox("Settings Pattern") {
                    VStack(spacing: 0) {
                        settingsRow(icon: "wifi", title: "Wi-Fi", isOn: $wifiEnabled)
                        Divider().padding(.leading, 36)
                        settingsRow(icon: "wave.3.right", title: "Bluetooth", isOn: $bluetoothEnabled)
                        Divider().padding(.leading, 36)
                        settingsRow(icon: "bell.fill", title: "Notifications", isOn: $notifications)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: Spec Details
                GroupBox("Toggle Spec") {
                    let specOn = theme.resolveToggle(isOn: true, state: .normal)
                    let specOff = theme.resolveToggle(isOn: false, state: .normal)
                    let specDisabled = theme.resolveToggle(isOn: true, state: .disabled)
                    
                    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 6) {
                        GridRow {
                            Text("Property").font(.caption.bold())
                            Text("Value").font(.caption.bold())
                        }
                        .foregroundStyle(theme.colors.fg.secondary)
                        
                        Divider()
                        
                        specGridRow("Track Size", "\(Int(specOn.trackWidth))×\(Int(specOn.trackHeight))")
                        specGridRow("Thumb Size", "\(Int(specOn.thumbSize))")
                        specGridRow("Corner Radius", "\(Int(specOn.trackCornerRadius))")
                        specGridRow("Border (Off)", "\(specOff.trackBorderWidth)")
                        specGridRow("Opacity (Normal)", "\(specOn.opacity)")
                        specGridRow("Opacity (Disabled)", "\(specDisabled.opacity)")
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(minWidth: 300)
            
            // Right column: Checkbox
            VStack(alignment: .leading, spacing: 24) {
                // MARK: Checkbox States
                GroupBox("Checkbox") {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Hover supported: \(capabilities.supportsHover ? "Yes" : "No")")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.tertiary)
                        
                        DSCheckbox("Unchecked", state: $cbUnchecked)
                        DSCheckbox("Checked", state: $cbChecked)
                        DSCheckbox("Intermediate", state: $cbIntermediate)
                        
                        Divider()
                        
                        Text("Disabled").font(.caption).foregroundStyle(theme.colors.fg.tertiary)
                        DSCheckbox("Disabled Checked", state: $cbDisabledChecked, isDisabled: true)
                        DSCheckbox("Disabled Unchecked", state: $cbDisabledUnchecked, isDisabled: true)
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: Multi-Select
                GroupBox("Multi-Select Pattern") {
                    VStack(alignment: .leading, spacing: 4) {
                        DSCheckbox("Select All", state: $selectAll)
                            .fontWeight(.semibold)
                        
                        Divider().padding(.vertical, 4)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            DSCheckbox("Documents", state: $doc)
                            DSCheckbox("Photos", state: $photo)
                            DSCheckbox("Videos", state: $video)
                            DSCheckbox("Music", state: $music)
                        }
                        .padding(.leading, 28)
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: Bool Binding
                GroupBox("Bool Binding Checkbox") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Convenience Bool binding maps to checked/unchecked:")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.tertiary)
                        
                        DSCheckbox("Accept Terms", isOn: $acceptTerms)
                        DSCheckbox("Subscribe to Newsletter", isOn: $subscribeNewsletter)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: Checkbox in Table
                GroupBox("Checkbox in List Context") {
                    VStack(spacing: 0) {
                        checkboxListRow(title: "Documents", subtitle: "12 files", state: $doc)
                        Divider().padding(.leading, 36)
                        checkboxListRow(title: "Photos", subtitle: "48 files", state: $photo)
                        Divider().padding(.leading, 36)
                        checkboxListRow(title: "Videos", subtitle: "5 files", state: $video)
                        Divider().padding(.leading, 36)
                        checkboxListRow(title: "Music", subtitle: "156 files", state: $music)
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(minWidth: 300)
        }
    }
    
    private func settingsRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(theme.colors.accent.primary)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(theme.typography.component.rowTitle.font)
                .foregroundStyle(theme.colors.fg.primary)
            
            Spacer()
            
            DSToggle(isOn: isOn)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
    
    private func checkboxListRow(title: String, subtitle: String, state: Binding<DSCheckboxState>) -> some View {
        HStack(spacing: 10) {
            DSCheckbox(state: state)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(theme.typography.component.rowTitle.font)
                    .foregroundStyle(theme.colors.fg.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(theme.colors.fg.tertiary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
    
    private func specGridRow(_ label: String, _ value: String) -> some View {
        GridRow {
            Text(label)
                .font(.caption)
                .foregroundStyle(theme.colors.fg.secondary)
            Text(value)
                .font(.caption.monospaced())
                .foregroundStyle(theme.colors.fg.primary)
        }
    }
}

#Preview("DSToggle macOS") {
    ScrollView {
        DSToggleShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 800)
    .dsTheme(.light)
}

// MARK: - DSTextField Showcase (macOS)

/// Two-column showcase view demonstrating DSTextField controls on macOS
struct DSTextFieldShowcasemacOSView: View {
    @Environment(\.dsTheme) private var theme
    
    // Text field states
    @State private var basicText = ""
    @State private var requiredText = ""
    @State private var filledText = "John Doe"
    @State private var searchText = ""
    
    // Validation
    @State private var emailText = ""
    @State private var emailValidation: DSValidationState = .none
    @State private var warningText = "pass"
    @State private var successText = "gooduser"
    
    // Secure field
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    // Multiline
    @State private var notes = ""
    @State private var bio = "I'm a Swift developer passionate about SwiftUI and design systems."
    
    // Character limit
    @State private var limitedText = ""
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Left Column: Text Fields & Secure
            VStack(alignment: .leading, spacing: 24) {
                GroupBox("Text Field") {
                    VStack(spacing: 16) {
                        DSTextField("Name", text: $basicText, placeholder: "Enter your name")
                        DSTextField("Filled", text: $filledText, placeholder: "Full name")
                        DSTextField("Disabled", text: .constant("Cannot edit"), isDisabled: true)
                        DSTextField(
                            "Required",
                            text: $requiredText,
                            placeholder: "This field is required",
                            isRequired: true,
                            helperText: "Please fill in this field"
                        )
                    }
                    .padding(8)
                }
                
                GroupBox("Search Variant") {
                    VStack(spacing: 16) {
                        DSTextField(text: $searchText, placeholder: "Search components...", variant: .search)
                    }
                    .padding(8)
                }
                
                GroupBox("Secure Field") {
                    VStack(spacing: 16) {
                        DSSecureField(
                            "Password",
                            text: $password,
                            placeholder: "Enter password",
                            isRequired: true,
                            helperText: "At least 8 characters"
                        )
                        DSSecureField(
                            "Confirm",
                            text: $passwordConfirm,
                            placeholder: "Re-enter password",
                            validation: passwordConfirmValidation
                        )
                        DSSecureField(
                            "Disabled",
                            text: .constant("hidden"),
                            placeholder: "Locked",
                            isDisabled: true
                        )
                    }
                    .padding(8)
                }
                
                GroupBox("Character Limit") {
                    DSTextField(
                        "Tweet",
                        text: $limitedText,
                        placeholder: "What's happening?",
                        characterLimit: 280
                    )
                    .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Right Column: Validation & Multiline
            VStack(alignment: .leading, spacing: 24) {
                GroupBox("Validation States") {
                    VStack(spacing: 16) {
                        DSTextField(
                            "Email (interactive)",
                            text: $emailText,
                            placeholder: "user@company.com",
                            validation: emailValidation,
                            isRequired: true
                        )
                        .onChange(of: emailText) { _, newValue in
                            if newValue.isEmpty {
                                emailValidation = .none
                            } else if newValue.contains("@") && newValue.contains(".") {
                                emailValidation = .success(message: "Valid email")
                            } else {
                                emailValidation = .error(message: "Invalid email format")
                            }
                        }
                        
                        DSTextField(
                            "Warning",
                            text: $warningText,
                            placeholder: "Password",
                            validation: .warning(message: "Weak password — consider adding numbers")
                        )
                        
                        DSTextField(
                            "Success",
                            text: $successText,
                            placeholder: "Username",
                            validation: .success(message: "Username is available")
                        )
                    }
                    .padding(8)
                }
                
                GroupBox("Multiline Field") {
                    VStack(spacing: 16) {
                        DSMultilineField(
                            "Notes",
                            text: $notes,
                            placeholder: "Enter your notes here..."
                        )
                        
                        DSMultilineField(
                            "Bio",
                            text: $bio,
                            placeholder: "Tell us about yourself",
                            isRequired: true,
                            helperText: "Write a brief bio",
                            characterLimit: 200
                        )
                    }
                    .padding(8)
                }
                
                GroupBox("Field Spec (Resolved)") {
                    let specNormal = theme.resolveField(variant: .default, state: .normal)
                    let specFocused = theme.resolveField(variant: .default, state: .focused)
                    let specSearch = theme.resolveField(variant: .search, state: .normal)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        specRow("Height", "\(Int(specNormal.height)) pt")
                        specRow("Radius (Default)", "\(Int(specNormal.cornerRadius)) pt")
                        specRow("Radius (Search)", "\(Int(specSearch.cornerRadius)) pt")
                        specRow("Padding (H)", "\(Int(specNormal.horizontalPadding)) pt")
                        specRow("Border (Normal)", "\(specNormal.borderWidth) pt")
                        specRow("Border (Focused)", "\(specFocused.borderWidth) pt")
                        specRow("Focus Ring", "\(specFocused.focusRingWidth) pt")
                        specRow("Font Size", "\(Int(specNormal.textTypography.size)) pt")
                    }
                    .padding(8)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var passwordConfirmValidation: DSValidationState {
        if passwordConfirm.isEmpty { return .none }
        if password == passwordConfirm { return .success(message: "Passwords match") }
        return .error(message: "Passwords do not match")
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
