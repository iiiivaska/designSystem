//
//  DSIconShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme
import DSPrimitives

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
