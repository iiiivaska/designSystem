//
//  DSTextShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme
import DSPrimitives

// MARK: - DSText Showcase

/// Showcase view demonstrating DSText primitive
struct DSTextShowcaseView: View {
    @State private var isDark = false
    
    private var theme: DSTheme {
        isDark ? .dark : .light
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Theme toggle
            Toggle("Dark Theme", isOn: $isDark)
                .padding(.bottom, 8)
            
            // System roles
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Text("System Roles")
                        .font(.headline)
                    
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
            
            // Component roles
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Component Roles")
                        .font(.headline)
                    
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
            
            // Overrides demo
            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Color & Weight Overrides")
                        .font(.headline)
                    
                    DSText("Default body text", role: .body)
                    
                    DSText("Custom accent color", role: .body)
                        .dsTextColor(theme.colors.accent.primary)
                    
                    DSText("Bold headline", role: .headline)
                        .dsTextWeight(.bold)
                    
                    DSText("Light title", role: .title2)
                        .dsTextWeight(.light)
                    
                    DSText("Danger color", role: .body)
                        .dsTextColor(theme.colors.state.danger)
                    
                    DSText("Success color + bold", role: .footnote)
                        .dsTextColor(theme.colors.state.success)
                        .dsTextWeight(.bold)
                }
                .padding(.vertical, 4)
            }
            .dsTheme(theme)
        }
    }
}

#Preview("DSText - Light") {
    NavigationStack {
        ScrollView {
            DSTextShowcaseView()
                .padding()
        }
        .navigationTitle("DSText")
    }
}

#Preview("DSText - Dark") {
    NavigationStack {
        ScrollView {
            DSTextShowcaseView()
                .padding()
        }
        .navigationTitle("DSText")
    }
    .preferredColorScheme(.dark)
}
