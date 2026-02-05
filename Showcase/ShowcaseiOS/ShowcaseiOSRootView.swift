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
