//
//  ThemeResolverShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme
import DSCore

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
