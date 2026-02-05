//
//  DSButtonShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives
import DSTheme
import DSControls

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
