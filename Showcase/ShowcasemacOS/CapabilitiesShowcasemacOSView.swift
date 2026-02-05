//
//  CapabilitiesShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSCore

// MARK: - Capabilities Showcase (macOS)

/// Showcase view demonstrating DSCapabilities system for macOS
struct CapabilitiesShowcasemacOSView: View {
    @Environment(\.dsCapabilities) private var capabilities
    @State private var selectedPlatform: DSPlatform = .current
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Left column: Current platform info
            VStack(alignment: .leading, spacing: 16) {
                platformSelector
                capabilitiesDisplay
            }
            .frame(maxWidth: 400)
            
            // Right column: Matrix comparison
            VStack(alignment: .leading, spacing: 16) {
                capabilityMatrix
                computedCapabilities
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var platformSelector: some View {
        GroupBox("Platform Simulation") {
            VStack(alignment: .leading, spacing: 12) {
                Picker("Simulate Platform", selection: $selectedPlatform) {
                    Text("iOS").tag(DSPlatform.iOS)
                    Text("macOS").tag(DSPlatform.macOS)
                    Text("watchOS").tag(DSPlatform.watchOS)
                }
                .pickerStyle(.segmented)
                
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.secondary)
                    Text("Current runtime: \(DSPlatform.current.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var simulatedCapabilities: DSCapabilities {
        DSCapabilities.for(platform: selectedPlatform)
    }
    
    private var capabilitiesDisplay: some View {
        GroupBox("Capabilities for \(selectedPlatform.rawValue)") {
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
                Divider().padding(.vertical, 4)
                preferenceRow("Form Row Layout", value: simulatedCapabilities.preferredFormRowLayout.rawValue)
                Divider()
                preferenceRow("Picker Presentation", value: simulatedCapabilities.preferredPickerPresentation.rawValue)
                Divider()
                preferenceRow("Text Field Mode", value: simulatedCapabilities.preferredTextFieldMode.rawValue)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func capabilityRow(_ label: String, value: Bool) -> some View {
        HStack {
            Text(label)
            Spacer()
            Image(systemName: value ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(value ? .green : .secondary)
        }
        .padding(.vertical, 6)
    }
    
    private func preferenceRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .font(.system(.body, design: .monospaced))
        }
        .padding(.vertical, 6)
    }
    
    private var capabilityMatrix: some View {
        GroupBox("Platform Capability Matrix") {
            Grid(alignment: .leading, horizontalSpacing: 24, verticalSpacing: 8) {
                GridRow {
                    Text("Capability")
                        .fontWeight(.semibold)
                    Text("iOS")
                        .fontWeight(.semibold)
                    Text("macOS")
                        .fontWeight(.semibold)
                    Text("watchOS")
                        .fontWeight(.semibold)
                }
                
                Divider()
                    .gridCellUnsizedAxes(.horizontal)
                
                matrixRow("Hover", ios: false, macos: true, watch: false)
                matrixRow("Focus Ring", ios: false, macos: true, watch: false)
                matrixRow("Inline Text", ios: true, macos: true, watch: false)
                matrixRow("Inline Pickers", ios: true, macos: true, watch: false)
                matrixRow("Toasts", ios: true, macos: true, watch: false)
                matrixRow("Large Tap Targets", ios: true, macos: false, watch: true)
                
                Divider()
                    .gridCellUnsizedAxes(.horizontal)
                
                GridRow {
                    Text("Form Layout")
                    Text("inline")
                        .foregroundStyle(.secondary)
                    Text("twoColumn")
                        .foregroundStyle(.secondary)
                    Text("stacked")
                        .foregroundStyle(.secondary)
                }
                
                GridRow {
                    Text("Picker Style")
                    Text("sheet")
                        .foregroundStyle(.secondary)
                    Text("menu")
                        .foregroundStyle(.secondary)
                    Text("navigation")
                        .foregroundStyle(.secondary)
                }
                
                GridRow {
                    Text("TextField Mode")
                    Text("inline")
                        .foregroundStyle(.secondary)
                    Text("inline")
                        .foregroundStyle(.secondary)
                    Text("separateScreen")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
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
        Image(systemName: value ? "checkmark.circle.fill" : "xmark.circle")
            .foregroundStyle(value ? .green : .secondary)
    }
    
    private var computedCapabilities: some View {
        GroupBox("Computed Queries") {
            VStack(spacing: 0) {
                computedRow("Supports Pointer", value: simulatedCapabilities.supportsPointerInteraction)
                Divider()
                computedRow("Requires Navigation", value: simulatedCapabilities.requiresNavigationPatterns)
                Divider()
                computedRow("Compact Screen", value: simulatedCapabilities.isCompactScreen)
                Divider()
                HStack {
                    Text("Min Tap Target Size")
                    Spacer()
                    Text("\(Int(simulatedCapabilities.minimumTapTargetSize))pt")
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)
            }
            .padding(.vertical, 4)
        }
    }
    
    private func computedRow(_ label: String, value: Bool) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value ? "true" : "false")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(value ? .primary : .secondary)
        }
        .padding(.vertical, 6)
    }
}
