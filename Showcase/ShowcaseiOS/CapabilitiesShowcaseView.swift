//
//  CapabilitiesShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSPrimitives
import DSCore

// MARK: - Capabilities Showcase

/// Showcase view demonstrating DSCapabilities system
struct CapabilitiesShowcaseView: View {
    @Environment(\.dsCapabilities) private var capabilities
    @State private var selectedPlatform: DSPlatform = .current
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Platform selector
            platformSelector
            
            // Current capabilities display
            capabilitiesDisplay
            
            // Capability matrix
            capabilityMatrix
        }
    }
    
    private var platformSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Simulate Platform")
                .font(.headline)
            
            Picker("Platform", selection: $selectedPlatform) {
                Text("iOS").tag(DSPlatform.iOS)
                Text("macOS").tag(DSPlatform.macOS)
                Text("watchOS").tag(DSPlatform.watchOS)
            }
            .pickerStyle(.segmented)
            
            Text("Current runtime: \(DSPlatform.current.rawValue)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var simulatedCapabilities: DSCapabilities {
        DSCapabilities.for(platform: selectedPlatform)
    }
    
    private var capabilitiesDisplay: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Capabilities for \(selectedPlatform.rawValue)")
                .font(.headline)
            
            GroupBox {
                VStack(spacing: 0) {
                    capabilityRow("Supports Hover", value: simulatedCapabilities.supportsHover)
                    Divider()
                    capabilityRow("Supports Focus Ring", value: simulatedCapabilities.supportsFocusRing)
                    Divider()
                    capabilityRow("Inline Text Editing", value: simulatedCapabilities.supportsInlineTextEditing)
                    Divider()
                    capabilityRow("Inline Pickers", value: simulatedCapabilities.supportsInlinePickers)
                    Divider()
                    capabilityRow("Supports Toasts", value: simulatedCapabilities.supportsToasts)
                    Divider()
                    capabilityRow("Large Tap Targets", value: simulatedCapabilities.prefersLargeTapTargets)
                }
            }
            
            GroupBox {
                VStack(spacing: 0) {
                    preferenceRow("Form Row Layout", value: simulatedCapabilities.preferredFormRowLayout.rawValue)
                    Divider()
                    preferenceRow("Picker Presentation", value: simulatedCapabilities.preferredPickerPresentation.rawValue)
                    Divider()
                    preferenceRow("Text Field Mode", value: simulatedCapabilities.preferredTextFieldMode.rawValue)
                    Divider()
                    preferenceRow("Min Tap Target", value: "\(Int(simulatedCapabilities.minimumTapTargetSize))pt")
                }
            }
        }
    }
    
    private func capabilityRow(_ label: String, value: Bool) -> some View {
        HStack {
            Text(label)
            Spacer()
            Image(systemName: value ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(value ? .green : .secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
    
    private func preferenceRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
    
    private var capabilityMatrix: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Capability Matrix")
                .font(.headline)
            
            GroupBox {
                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                    GridRow {
                        Text("Capability")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text("iOS")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text("macOS")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text("watch")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                    
                    matrixRow("Hover", ios: false, macos: true, watch: false)
                    matrixRow("Focus Ring", ios: false, macos: true, watch: false)
                    matrixRow("Inline Text", ios: true, macos: true, watch: false)
                    matrixRow("Inline Pickers", ios: true, macos: true, watch: false)
                    matrixRow("Toasts", ios: true, macos: true, watch: false)
                    matrixRow("Large Targets", ios: true, macos: false, watch: true)
                }
                .font(.caption)
            }
        }
    }
    
    private func matrixRow(_ label: String, ios: Bool, macos: Bool, watch: Bool) -> some View {
        GridRow {
            Text(label)
            matrixIcon(ios)
            matrixIcon(macos)
            matrixIcon(watch)
        }
    }
    
    private func matrixIcon(_ value: Bool) -> some View {
        Image(systemName: value ? "checkmark" : "minus")
            .foregroundStyle(value ? .green : .secondary)
    }
}

#Preview("Capabilities Showcase") {
    NavigationStack {
        ScrollView {
            CapabilitiesShowcaseView()
                .padding()
        }
        .navigationTitle("Capabilities")
    }
}

#Preview("Capabilities - Dark") {
    NavigationStack {
        ScrollView {
            CapabilitiesShowcaseView()
                .padding()
        }
        .navigationTitle("Capabilities")
    }
    .preferredColorScheme(.dark)
}
