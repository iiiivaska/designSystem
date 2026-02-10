// DSFormSectionShowcasewatchOSView.swift
// ShowcasewatchOS
//
// Showcase for DSFormSection demonstrating section styles on watchOS.

import SwiftUI
import DSCore
import DSTheme
import DSForms
import DSPrimitives

struct DSFormSectionShowcasewatchOSView: View {
    @State private var toggleA = true
    @State private var toggleB = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: - Plain Section
            
            Text("Plain Section")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSFormSection("Account") {
                VStack(alignment: .leading, spacing: 0) {
                    stackedRow(label: "Name", value: "John Doe")
                    DSDivider()
                    stackedRow(label: "Email", value: "john@email.com")
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - Grouped Section
            
            Text("Grouped Section")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSFormSection("Privacy", style: .grouped) {
                VStack(alignment: .leading, spacing: 0) {
                    toggleRow(label: "Analytics", isOn: $toggleA)
                    DSDivider(insets: 8)
                    toggleRow(label: "Location", isOn: $toggleB)
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - Inset Grouped
            
            Text("Inset Grouped")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSFormSection("Notifications", style: .insetGrouped) {
                VStack(alignment: .leading, spacing: 0) {
                    stackedRow(label: "Push", value: "On")
                    DSDivider(insets: 8)
                    stackedRow(label: "Sound", value: "Off")
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - With Footer
            
            Text("With Footer")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSFormSection(
                "Data",
                footer: "Changes sync across all devices.",
                style: .grouped
            ) {
                VStack(alignment: .leading, spacing: 0) {
                    stackedRow(label: "Sync", value: "Enabled")
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - Custom Header
            
            Text("Custom Header")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSFormSection(
                style: .insetGrouped,
                header: {
                    DSSectionHeader("Storage", icon: "internaldrive.fill", iconColor: .accent)
                },
                footer: {
                    DSSectionFooter("4.2 GB of 15 GB used.")
                },
                content: {
                    VStack(alignment: .leading, spacing: 0) {
                        stackedRow(label: "Photos", value: "2.1 GB")
                        DSDivider(insets: 8)
                        stackedRow(label: "Apps", value: "1.3 GB")
                    }
                }
            )
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - Platform Info
            
            VStack(alignment: .leading, spacing: 4) {
                Label("Stacked layout", systemImage: "checkmark.circle.fill")
                Label("Large tap targets", systemImage: "checkmark.circle.fill")
                Label("No collapsible", systemImage: "xmark.circle")
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Helper Views
    
    private func stackedRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.footnote)
        }
        .padding(.vertical, 6)
    }
    
    private func toggleRow(label: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(label)
                .font(.footnote)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

#Preview("DSFormSection watchOS - Light") {
    ScrollView {
        DSFormSectionShowcasewatchOSView()
            .padding()
    }
    .dsTheme(.light)
}

#Preview("DSFormSection watchOS - Dark") {
    ScrollView {
        DSFormSectionShowcasewatchOSView()
            .padding()
    }
    .dsTheme(.dark)
}
