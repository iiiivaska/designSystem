//
//  CapabilitiesShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI

// MARK: - Capabilities Showcase (watchOS)

/// Compact showcase view demonstrating DSCapabilities system for watchOS
struct CapabilitiesShowcasewatchOSView: View {
    @Environment(\.dsCapabilities) private var capabilities
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("watchOS Capabilities")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            capabilityItem("Hover", value: capabilities.supportsHover)
            capabilityItem("Focus Ring", value: capabilities.supportsFocusRing)
            capabilityItem("Inline Text", value: capabilities.supportsInlineTextEditing)
            capabilityItem("Inline Pickers", value: capabilities.supportsInlinePickers)
            capabilityItem("Toasts", value: capabilities.supportsToasts)
            capabilityItem("Large Targets", value: capabilities.prefersLargeTapTargets)
            
            Divider()
                .padding(.vertical, 4)
            
            preferenceItem("Layout", value: capabilities.preferredFormRowLayout.rawValue)
            preferenceItem("Picker", value: capabilities.preferredPickerPresentation.rawValue)
            preferenceItem("TextField", value: capabilities.preferredTextFieldMode.rawValue)
            preferenceItem("Tap Size", value: "\(Int(capabilities.minimumTapTargetSize))pt")
        }
    }
    
    private func capabilityItem(_ label: String, value: Bool) -> some View {
        HStack {
            Text(label)
                .font(.caption2)
            Spacer()
            Image(systemName: value ? "checkmark" : "xmark")
                .font(.caption2)
                .foregroundStyle(value ? .green : .secondary)
        }
    }
    
    private func preferenceItem(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption2)
            Spacer()
            Text(value)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Capabilities") {
    NavigationStack {
        ScrollView {
            CapabilitiesShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("Capabilities")
    }
}
