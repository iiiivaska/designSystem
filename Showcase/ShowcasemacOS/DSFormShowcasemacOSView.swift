// DSFormShowcasemacOSView.swift
// ShowcasemacOS
//
// Showcase for DSForm container demonstrating form layouts and configurations on macOS.

import SwiftUI
import DSCore
import DSTheme
import DSForms
import DSControls

struct DSFormShowcasemacOSView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var selectedLayout: DSFormRowLayout = .twoColumn
    @State private var selectedDensity: DSDensity = .regular
    @State private var showSeparators = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // MARK: - Configuration Controls
            
            configurationSection
            
            Divider()
            
            // MARK: - Layout Comparison
            
            HStack(alignment: .top, spacing: 24) {
                // Auto Layout (Platform Default)
                GroupBox("Auto Layout (macOS Default)") {
                    DSForm {
                        VStack(spacing: 16) {
                            twoColumnRow(label: "Name:", value: "John Doe")
                            twoColumnRow(label: "Email:", value: "john@example.com")
                            twoColumnRow(label: "Department:", value: "Engineering")
                        }
                    }
                    .frame(minHeight: 120)
                }
                .frame(maxWidth: .infinity)
                
                // Fixed Layout Demo
                GroupBox("Fixed Layout (\(selectedLayout.rawValue.capitalized))") {
                    DSForm(configuration: DSFormConfiguration(
                        layoutMode: .fixed(selectedLayout),
                        validationDisplay: .below,
                        density: selectedDensity,
                        keyboardAvoidanceEnabled: true,
                        showRowSeparators: showSeparators
                    )) {
                        layoutContent
                    }
                    .frame(minHeight: 120)
                }
                .frame(maxWidth: .infinity)
            }
            
            Divider()
            
            // MARK: - Density Comparison
            
            GroupBox("Density Comparison") {
                HStack(alignment: .top, spacing: 32) {
                    densityDemo(density: .compact, name: "Compact")
                    densityDemo(density: .regular, name: "Regular")
                    densityDemo(density: .spacious, name: "Spacious")
                }
            }
            
            // MARK: - Configuration Presets
            
            GroupBox("Configuration Presets") {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    presetCard(name: "Default", config: .default)
                    presetCard(name: "Compact", config: .compact)
                    presetCard(name: "Settings", config: .settings)
                    presetCard(name: "Two-Column", config: .twoColumn)
                    presetCard(name: "Stacked", config: .stacked)
                }
            }
            
            // MARK: - Focus Ring Demo
            
            GroupBox("Focus Ring Support") {
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("macOS forms support focus rings for keyboard navigation.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Tab navigation between fields")
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Visual focus indicators")
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Two-column layout by default")
                        }
                    }
                    .font(.callout)
                    
                    Spacer()
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Configuration Section
    
    private var configurationSection: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Layout Mode")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Picker("Layout", selection: $selectedLayout) {
                    Text("Inline").tag(DSFormRowLayout.inline)
                    Text("Stacked").tag(DSFormRowLayout.stacked)
                    Text("Two-Column").tag(DSFormRowLayout.twoColumn)
                }
                .pickerStyle(.segmented)
                .frame(width: 240)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Density")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Picker("Density", selection: $selectedDensity) {
                    Text("Compact").tag(DSDensity.compact)
                    Text("Regular").tag(DSDensity.regular)
                    Text("Spacious").tag(DSDensity.spacious)
                }
                .pickerStyle(.segmented)
                .frame(width: 240)
            }
            
            Toggle("Row Separators", isOn: $showSeparators)
                .toggleStyle(.checkbox)
            
            Spacer()
        }
    }
    
    // MARK: - Layout Content
    
    @ViewBuilder
    private var layoutContent: some View {
        switch selectedLayout {
        case .inline:
            VStack(alignment: .leading, spacing: 12) {
                inlineRow(label: "Name", value: "John Doe")
                if showSeparators { Divider() }
                inlineRow(label: "Email", value: "john@example.com")
                if showSeparators { Divider() }
                inlineRow(label: "Department", value: "Engineering")
            }
            
        case .stacked:
            VStack(alignment: .leading, spacing: 12) {
                stackedRow(label: "Name", value: "John Doe")
                if showSeparators { Divider() }
                stackedRow(label: "Email", value: "john@example.com")
                if showSeparators { Divider() }
                stackedRow(label: "Department", value: "Engineering")
            }
            
        case .twoColumn:
            VStack(spacing: 12) {
                twoColumnRow(label: "Name:", value: "John Doe")
                if showSeparators { Divider() }
                twoColumnRow(label: "Email:", value: "john@example.com")
                if showSeparators { Divider() }
                twoColumnRow(label: "Department:", value: "Engineering")
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func inlineRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
    
    private func stackedRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
        }
    }
    
    private func twoColumnRow(label: String, value: String) -> some View {
        HStack(spacing: 16) {
            Text(label)
                .frame(width: 120, alignment: .trailing)
                .foregroundStyle(.secondary)
            Text(value)
            Spacer()
        }
    }
    
    private func densityDemo(density: DSDensity, name: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.headline)
            
            DSForm(configuration: DSFormConfiguration(density: density)) {
                VStack(spacing: 8) {
                    inlineRow(label: "Field 1", value: "Value")
                    Divider()
                    inlineRow(label: "Field 2", value: "Value")
                    Divider()
                    inlineRow(label: "Field 3", value: "Value")
                }
            }
            .frame(minWidth: 180)
        }
    }
    
    private func presetCard(name: String, config: DSFormConfiguration) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 4) {
                configRow("Layout", value: layoutName(config.layoutMode))
                configRow("Validation", value: config.validationDisplay.rawValue)
                configRow("Density", value: config.density?.rawValue ?? "inherit")
                configRow("Separators", value: config.showRowSeparators ? "yes" : "no")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func configRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label + ":")
            Spacer()
            Text(value)
        }
    }
    
    private func layoutName(_ mode: DSFormLayoutMode) -> String {
        switch mode {
        case .auto:
            return "auto"
        case .fixed(let layout):
            return layout.rawValue
        }
    }
}

#Preview("DSForm Showcase macOS - Light") {
    ScrollView {
        DSFormShowcasemacOSView()
            .padding()
    }
    .frame(minWidth: 800, minHeight: 600)
    .dsTheme(.light)
}

#Preview("DSForm Showcase macOS - Dark") {
    ScrollView {
        DSFormShowcasemacOSView()
            .padding()
    }
    .frame(minWidth: 800, minHeight: 600)
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
