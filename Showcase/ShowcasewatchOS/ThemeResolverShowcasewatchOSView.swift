//
//  ThemeResolverShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives
import DSTheme
import DSCore

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
