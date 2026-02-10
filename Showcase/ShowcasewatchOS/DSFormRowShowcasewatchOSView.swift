// DSFormRowShowcasewatchOSView.swift
// ShowcasewatchOS
//
// Compact showcase for DSFormRow on watchOS (stacked layout by default).

import SwiftUI
import DSCore
import DSTheme
import DSForms
import DSPrimitives

struct DSFormRowShowcasewatchOSView: View {
    @State private var toggleValue = true
    
    @Environment(\.dsTheme) private var theme: DSTheme
    @Environment(\.dsCapabilities) private var capabilities: DSCapabilities
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // MARK: - Auto Layout (Stacked on watchOS)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Auto Layout")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                VStack(spacing: 0) {
                    DSFormRow("Name") {
                        Text("John Doe")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                    }
                    
                    DSFormRow("Notifications") {
                        Toggle("", isOn: $toggleValue)
                            .labelsHidden()
                    }
                    
                    DSFormRow("Theme", showSeparator: false) {
                        Text("Dark")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                    } accessory: {
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            
            Divider()
            
            // MARK: - With Footer
            
            VStack(alignment: .leading, spacing: 4) {
                Text("With Footer")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                DSFormRow("Volume", showSeparator: false) {
                    Text("75%")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                } footer: {
                    Text("Adjust with Digital Crown")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            
            Divider()
            
            // MARK: - Platform Info
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Platform")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                let spec = DSFormRowSpec.resolve(theme: theme, capabilities: capabilities)
                
                VStack(alignment: .leading, spacing: 2) {
                    infoRow("Layout", value: "\(spec.resolvedLayout)")
                    infoRow("Min Height", value: "\(Int(spec.minHeight))pt")
                    infoRow("V Spacing", value: "\(Int(spec.verticalSpacing))pt")
                }
            }
        }
    }
    
    private func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption2.monospaced())
        }
    }
}

#Preview("DSFormRow watchOS - Dark") {
    ScrollView {
        DSFormRowShowcasewatchOSView()
            .padding(.horizontal, 4)
    }
    .dsTheme(.dark)
    .dsCapabilities(.watchOS())
}

#Preview("DSFormRow watchOS - Light") {
    ScrollView {
        DSFormRowShowcasewatchOSView()
            .padding(.horizontal, 4)
    }
    .dsTheme(.light)
    .dsCapabilities(.watchOS())
}
