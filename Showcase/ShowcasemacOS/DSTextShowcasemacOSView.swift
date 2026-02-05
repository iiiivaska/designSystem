//
//  DSTextShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme
import DSPrimitives

// MARK: - DSText Showcase (macOS)

/// Showcase view demonstrating DSText primitive on macOS
struct DSTextShowcasemacOSView: View {
    @State private var isDark = false
    
    private var theme: DSTheme {
        isDark ? .dark : .light
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Left column: Configuration + System roles
            VStack(alignment: .leading, spacing: 16) {
                Toggle("Dark Theme", isOn: $isDark)
                
                GroupBox("System Roles") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(DSTextRole.systemRoles) { role in
                            HStack(alignment: .firstTextBaseline) {
                                DSText(role.displayName, role: role)
                                Spacer()
                                Text(role.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                    .monospaced()
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
            }
            .frame(minWidth: 350)
            
            // Right column: Component roles + Overrides
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Component Roles") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(DSTextRole.componentRoles) { role in
                            HStack(alignment: .firstTextBaseline) {
                                DSText(role.displayName, role: role)
                                Spacer()
                                Text(role.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                    .monospaced()
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
                
                GroupBox("Color & Weight Overrides") {
                    VStack(alignment: .leading, spacing: 8) {
                        DSText("Default body text", role: .body)
                        DSText("Accent color override", role: .body)
                            .dsTextColor(theme.colors.accent.primary)
                        DSText("Bold headline", role: .headline)
                            .dsTextWeight(.bold)
                        DSText("Light title", role: .title2)
                            .dsTextWeight(.light)
                        DSText("Danger color", role: .body)
                            .dsTextColor(theme.colors.state.danger)
                        DSText("Success + bold", role: .footnote)
                            .dsTextColor(theme.colors.state.success)
                            .dsTextWeight(.bold)
                    }
                    .padding(.vertical, 4)
                }
                .dsTheme(theme)
            }
            .frame(minWidth: 350)
        }
    }
}

#Preview("DSText macOS") {
    ScrollView {
        DSTextShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}
