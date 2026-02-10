// DSFormSectionShowcaseView.swift
// ShowcaseiOS
//
// Showcase for DSFormSection demonstrating section styles, headers, footers, and collapsibility.

import SwiftUI
import DSCore
import DSTheme
import DSForms
import DSPrimitives

struct DSFormSectionShowcaseView: View {
    @State private var selectedStyle: DSFormSectionStyle = .plain
    @State private var toggleA = true
    @State private var toggleB = false
    @State private var toggleC = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // MARK: - Style Picker
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Section Style")
                    .font(.headline)
                
                Picker("Style", selection: $selectedStyle) {
                    ForEach(DSFormSectionStyle.allCases) { style in
                        Text(style.displayName).tag(style)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Divider()
            
            // MARK: - Interactive Demo
            
            GroupBox("Interactive Demo (\(selectedStyle.displayName))") {
                VStack(alignment: .leading, spacing: 0) {
                    DSFormSection("Account Settings", style: selectedStyle) {
                        VStack(alignment: .leading, spacing: 0) {
                            settingsRow(label: "Name", value: "John Doe")
                            DSDivider(insets: 16)
                            settingsRow(label: "Email", value: "john@example.com")
                            DSDivider(insets: 16)
                            settingsRow(label: "Phone", value: "+1 555-1234")
                        }
                    }
                    
                    DSFormSection(
                        "Privacy",
                        footer: "Your data is encrypted end-to-end and never shared.",
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
            
            Divider()
            
            // MARK: - Style Comparison
            
            GroupBox("Style Comparison") {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(DSFormSectionStyle.allCases) { style in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(style.displayName)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            DSFormSection("Section", style: style) {
                                VStack(alignment: .leading, spacing: 0) {
                                    settingsRow(label: "Item 1", value: "Value")
                                    DSDivider(insets: 16)
                                    settingsRow(label: "Item 2", value: "Value")
                                }
                            }
                        }
                    }
                }
            }
            
            Divider()
            
            // MARK: - Custom Header & Footer
            
            GroupBox("Custom Header & Footer") {
                DSFormSection(
                    style: .insetGrouped,
                    header: {
                        DSSectionHeader("Notifications", icon: "bell.fill", iconColor: .accent)
                    },
                    footer: {
                        DSSectionFooter(
                            "Push Notifications",
                            description: "Control how and when you receive notifications from the app."
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
            
            Divider()
            
            // MARK: - Section Header Styles
            
            GroupBox("Section Headers") {
                VStack(alignment: .leading, spacing: 12) {
                    DSSectionHeader("Simple Header")
                    Divider()
                    DSSectionHeader("With Icon", icon: "person.fill")
                    Divider()
                    DSSectionHeader("Accent Icon", icon: "star.fill", iconColor: .accent)
                    Divider()
                    DSSectionHeader("Warning Icon", icon: "exclamationmark.triangle.fill", iconColor: .warning)
                    Divider()
                    DSSectionHeader("Success Icon", icon: "checkmark.circle.fill", iconColor: .success)
                }
            }
            
            Divider()
            
            // MARK: - Section Footers
            
            GroupBox("Section Footers") {
                VStack(alignment: .leading, spacing: 16) {
                    DSSectionFooter("Simple description footer text.")
                    
                    Divider()
                    
                    DSSectionFooter(
                        "Privacy Note",
                        description: "Your data is encrypted and never shared with third parties."
                    )
                    
                    Divider()
                    
                    DSSectionFooter(
                        title: "Storage Info",
                        description: "You have used 4.2 GB of 15 GB available storage."
                    )
                }
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
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
    }
    
    private func toggleRow(label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

#Preview("DSFormSection Showcase - Light") {
    ScrollView {
        DSFormSectionShowcaseView()
            .padding()
    }
    .dsTheme(.light)
}

#Preview("DSFormSection Showcase - Dark") {
    ScrollView {
        DSFormSectionShowcaseView()
            .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
