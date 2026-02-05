// ShowcaseiOSRootView.swift
// ShowcaseiOS
//
// Main navigation structure for iOS Showcase

import SwiftUI
import ShowcaseCore
import DSCore
import DSTheme

struct ShowcaseiOSRootView: View {
    @State private var selectedCategory: ShowcaseCategory?
    @State private var selectedItem: ShowcaseItem?
    
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
        case "themeresolver":
            ThemeResolverShowcaseView()
        case "capabilities":
            CapabilitiesShowcaseView()
        case "componentspecs":
            ComponentSpecsShowcaseView()
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
