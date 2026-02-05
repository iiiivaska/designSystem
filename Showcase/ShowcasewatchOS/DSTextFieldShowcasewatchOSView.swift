//
//  DSTextFieldShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSTextField Showcase (watchOS)

/// Compact showcase view demonstrating DSTextField on watchOS
struct DSTextFieldShowcasewatchOSView: View {
    @Environment(\.dsTheme) private var theme
    
    @State private var basicText = ""
    @State private var filledText = "John"
    @State private var searchText = ""
    @State private var password = ""
    @State private var notes = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Basic Fields
            Text("Text Field")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSTextField("Name", text: $basicText, placeholder: "Enter name")
            DSTextField("Filled", text: $filledText, placeholder: "Name")
            DSTextField("Disabled", text: .constant("Locked"), isDisabled: true)
            
            Divider()
                .padding(.vertical, 4)
            
            // Search
            Text("Search")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSTextField(text: $searchText, placeholder: "Search...", variant: .search)
            
            Divider()
                .padding(.vertical, 4)
            
            // Validation
            Text("Validation")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSTextField(
                "Error",
                text: .constant("bad"),
                placeholder: "Email",
                validation: .error(message: "Invalid")
            )
            
            DSTextField(
                "Warning",
                text: .constant("weak"),
                placeholder: "Pass",
                validation: .warning(message: "Weak")
            )
            
            DSTextField(
                "Success",
                text: .constant("ok"),
                placeholder: "User",
                validation: .success(message: "Available")
            )
            
            Divider()
                .padding(.vertical, 4)
            
            // Secure Field
            Text("Secure")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSSecureField("Password", text: $password, placeholder: "Enter password")
            
            Divider()
                .padding(.vertical, 4)
            
            // Multiline
            Text("Multiline")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            DSMultilineField(
                "Notes",
                text: $notes,
                placeholder: "Enter notes...",
                minHeight: 60
            )
            
            Divider()
                .padding(.vertical, 4)
            
            // Spec Info
            Text("Spec Info")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            let spec = theme.resolveField(variant: .default, state: .normal)
            VStack(alignment: .leading, spacing: 4) {
                specItem("Height", "\(Int(spec.height)) pt")
                specItem("Radius", "\(Int(spec.cornerRadius)) pt")
                specItem("Font", "\(Int(spec.textTypography.size)) pt")
            }
        }
    }
    
    private func specItem(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption2)
                .foregroundStyle(theme.colors.fg.secondary)
            Spacer()
            Text(value)
                .font(.caption2.monospaced())
                .foregroundStyle(theme.colors.fg.primary)
        }
    }
}
