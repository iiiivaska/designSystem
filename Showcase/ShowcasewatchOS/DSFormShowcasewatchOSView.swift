// DSFormShowcasewatchOSView.swift
// ShowcasewatchOS
//
// Showcase for DSForm container demonstrating form layouts on watchOS.

import SwiftUI
import DSCore
import DSTheme
import DSForms

struct DSFormShowcasewatchOSView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: - Auto Layout Demo
            
            Text("Auto Layout")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSForm {
                VStack(alignment: .leading, spacing: 8) {
                    stackedRow(label: "Name", value: "John Doe")
                    Divider()
                    stackedRow(label: "Email", value: "john@email.com")
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - Stacked Layout
            
            Text("Stacked (Default)")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSForm.stacked {
                VStack(alignment: .leading, spacing: 8) {
                    stackedRow(label: "Field 1", value: "Value 1")
                    Divider()
                    stackedRow(label: "Field 2", value: "Value 2")
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - Density Comparison
            
            Text("Density")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Compact")
                        .font(.caption2)
                    DSForm(configuration: .compact) {
                        stackedRow(label: "Label", value: "Val")
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Regular")
                        .font(.caption2)
                    DSForm {
                        stackedRow(label: "Label", value: "Val")
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // MARK: - Platform Info
            
            VStack(alignment: .leading, spacing: 4) {
                Label("Stacked layout", systemImage: "checkmark.circle.fill")
                Label("Large tap targets", systemImage: "checkmark.circle.fill")
                Label("Crown navigation", systemImage: "checkmark.circle.fill")
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
    }
}

#Preview("DSForm watchOS - Light") {
    ScrollView {
        DSFormShowcasewatchOSView()
            .padding()
    }
    .dsTheme(.light)
}

#Preview("DSForm watchOS - Dark") {
    ScrollView {
        DSFormShowcasewatchOSView()
            .padding()
    }
    .dsTheme(.dark)
}
