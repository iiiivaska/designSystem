//
//  ThemeResolverShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives
import DSCore
import DSTheme

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
