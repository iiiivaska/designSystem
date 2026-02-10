// DSFormSectionShowcasemacOSView.swift
// ShowcasemacOS
//
// Showcase for DSFormSection demonstrating section styles, headers, footers, and collapsibility on macOS.

import SwiftUI
import DSCore
import DSTheme
import DSForms
import DSPrimitives

struct DSFormSectionShowcasemacOSView: View {
    @State private var selectedStyle: DSFormSectionStyle = .insetGrouped
    @State private var toggleA = true
    @State private var toggleB = false
    @State private var toggleC = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // MARK: - Configuration
            
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Section Style")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Picker("Style", selection: $selectedStyle) {
                        ForEach(DSFormSectionStyle.allCases) { style in
                            Text(style.displayName).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 320)
                }
                
                Spacer()
            }
            
            Divider()
            
            // MARK: - Side-by-Side: Styles vs Custom
            
            HStack(alignment: .top, spacing: 24) {
                
                // Left: Interactive Demo
                GroupBox("Interactive Demo (\(selectedStyle.displayName))") {
                    VStack(alignment: .leading, spacing: 0) {
                        DSFormSection("Account", style: selectedStyle) {
                            VStack(alignment: .leading, spacing: 0) {
                                settingsRow(label: "Name", value: "John Doe")
                                DSDivider(insets: 16)
                                settingsRow(label: "Email", value: "john@example.com")
                                DSDivider(insets: 16)
                                settingsRow(label: "Department", value: "Engineering")
                            }
                        }
                        
                        DSFormSection(
                            "Privacy",
                            footer: "Your data is encrypted end-to-end.",
                            style: selectedStyle
                        ) {
                            VStack(alignment: .leading, spacing: 0) {
                                toggleRow(label: "Analytics", isOn: $toggleA)
                                DSDivider(insets: 16)
                                toggleRow(label: "Location", isOn: $toggleB)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Right: Custom Header/Footer + Collapsible
                VStack(alignment: .leading, spacing: 16) {
                    GroupBox("Custom Header & Footer") {
                        DSFormSection(
                            style: .insetGrouped,
                            header: {
                                DSSectionHeader("Notifications", icon: "bell.fill", iconColor: .accent)
                            },
                            footer: {
                                DSSectionFooter(
                                    "Push Notifications",
                                    description: "Control how and when you receive notifications."
                                )
                            },
                            content: {
                                VStack(alignment: .leading, spacing: 0) {
                                    toggleRow(label: "Push", isOn: $toggleA)
                                    DSDivider(insets: 16)
                                    toggleRow(label: "Email", isOn: $toggleB)
                                    DSDivider(insets: 16)
                                    toggleRow(label: "SMS", isOn: $toggleC)
                                }
                            }
                        )
                    }
                    
                    GroupBox("Collapsible Section (macOS)") {
                        VStack(alignment: .leading, spacing: 0) {
                            DSFormSection("Advanced Options", isCollapsible: true, style: .grouped) {
                                VStack(alignment: .leading, spacing: 0) {
                                    settingsRow(label: "Debug Mode", value: "Off")
                                    DSDivider(insets: 16)
                                    settingsRow(label: "Log Level", value: "Warning")
                                    DSDivider(insets: 16)
                                    settingsRow(label: "Cache Size", value: "256 MB")
                                }
                            }
                            
                            DSFormSection("Developer Tools", isCollapsible: true, style: .grouped) {
                                VStack(alignment: .leading, spacing: 0) {
                                    settingsRow(label: "Inspector", value: "Enabled")
                                    DSDivider(insets: 16)
                                    settingsRow(label: "Profiler", value: "Disabled")
                                }
                            }
                        }
                        .dsCapabilities(.macOS())
                    }
                }
                .frame(maxWidth: .infinity)
            }
            
            Divider()
            
            // MARK: - Style Comparison
            
            GroupBox("Style Comparison") {
                HStack(alignment: .top, spacing: 32) {
                    ForEach(DSFormSectionStyle.allCases) { style in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(style.displayName)
                                .font(.headline)
                            
                            DSFormSection("Section", style: style) {
                                VStack(alignment: .leading, spacing: 0) {
                                    settingsRow(label: "Item 1", value: "Value")
                                    DSDivider(insets: 16)
                                    settingsRow(label: "Item 2", value: "Value")
                                    DSDivider(insets: 16)
                                    settingsRow(label: "Item 3", value: "Value")
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            
            Divider()
            
            // MARK: - Headers & Footers
            
            HStack(alignment: .top, spacing: 24) {
                GroupBox("Section Headers") {
                    VStack(alignment: .leading, spacing: 12) {
                        DSSectionHeader("Simple")
                        Divider()
                        DSSectionHeader("With Icon", icon: "person.fill")
                        Divider()
                        DSSectionHeader("Accent", icon: "star.fill", iconColor: .accent)
                        Divider()
                        DSSectionHeader("Warning", icon: "exclamationmark.triangle.fill", iconColor: .warning)
                        Divider()
                        DSSectionHeader("Success", icon: "checkmark.circle.fill", iconColor: .success)
                    }
                    .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity)
                
                GroupBox("Section Footers") {
                    VStack(alignment: .leading, spacing: 16) {
                        DSSectionFooter("Simple description text.")
                        
                        Divider()
                        
                        DSSectionFooter(
                            "Privacy Note",
                            description: "Your data is encrypted end-to-end and never shared."
                        )
                        
                        Divider()
                        
                        DSSectionFooter(
                            title: "Storage",
                            description: "4.2 GB of 15 GB used."
                        )
                    }
                    .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Helper Views
    
    private func settingsRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
    
    private func toggleRow(label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .toggleStyle(.checkbox)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 4)
    }
}

#Preview("DSFormSection Showcase macOS - Light") {
    ScrollView {
        DSFormSectionShowcasemacOSView()
            .padding()
    }
    .frame(minWidth: 800, minHeight: 600)
    .dsTheme(.light)
}

#Preview("DSFormSection Showcase macOS - Dark") {
    ScrollView {
        DSFormSectionShowcasemacOSView()
            .padding()
    }
    .frame(minWidth: 800, minHeight: 600)
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
