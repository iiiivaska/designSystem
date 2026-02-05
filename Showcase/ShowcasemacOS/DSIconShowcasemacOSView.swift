//
//  DSIconShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives
import DSTheme

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
