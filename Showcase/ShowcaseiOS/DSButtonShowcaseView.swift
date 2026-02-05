//
//  DSButtonShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives
import DSTheme
import DSControls

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
