// ShowcasewatchOSRootView.swift
// ShowcasewatchOS
//
// Main navigation structure for watchOS Showcase

import SwiftUI
import ShowcaseCore
import DSCore
import DSTheme

struct ShowcasewatchOSRootView: View {
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
        }
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
        case "themeresolver":
            ThemeResolverShowcasewatchOSView()
        case "capabilities":
            CapabilitiesShowcasewatchOSView()
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
            dynamicTypeSize: .large,
            isBoldTextEnabled: false,
            differentiateWithoutColor: false
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
            .pickerStyle(.segmented)
            
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
