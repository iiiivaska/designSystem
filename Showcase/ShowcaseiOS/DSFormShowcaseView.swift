// DSFormShowcaseView.swift
// ShowcaseiOS
//
// Showcase for DSForm container demonstrating form layouts and configurations.

import SwiftUI
import DSCore
import DSTheme
import DSForms
import DSControls

struct DSFormShowcaseView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var selectedLayout: DSFormRowLayout = .inline
    @State private var selectedDensity: DSDensity = .regular
    @State private var showSeparators = true
    @State private var keyboardAvoidance = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // MARK: - Configuration Controls
            
            configurationSection
            
            Divider()
            
            // MARK: - Auto Layout Demo
            
            GroupBox("Auto Layout (Platform Default)") {
                DSForm {
                    VStack(alignment: .leading, spacing: 16) {
                        demoRow(label: "Name", value: "John Doe")
                        Divider()
                        demoRow(label: "Email", value: "john@example.com")
                        Divider()
                        demoRow(label: "Phone", value: "+1 555-1234")
                    }
                }
                .frame(minHeight: 150)
            }
            
            // MARK: - Fixed Layout Demo
            
            GroupBox("Fixed Layout (\(selectedLayout.rawValue.capitalized))") {
                DSForm(configuration: DSFormConfiguration(
                    layoutMode: .fixed(selectedLayout),
                    validationDisplay: .below,
                    density: selectedDensity,
                    keyboardAvoidanceEnabled: keyboardAvoidance,
                    showRowSeparators: showSeparators
                )) {
                    layoutContent
                }
                .frame(minHeight: 150)
            }
            
            // MARK: - Density Comparison
            
            GroupBox("Density Comparison") {
                HStack(spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("Compact")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        DSForm(configuration: .compact) {
                            VStack(spacing: 8) {
                                demoRow(label: "Field 1", value: "Value")
                                Divider()
                                demoRow(label: "Field 2", value: "Value")
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Regular")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        DSForm {
                            VStack(spacing: 8) {
                                demoRow(label: "Field 1", value: "Value")
                                Divider()
                                demoRow(label: "Field 2", value: "Value")
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Spacious")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        DSForm(configuration: DSFormConfiguration(density: .spacious)) {
                            VStack(spacing: 8) {
                                demoRow(label: "Field 1", value: "Value")
                                Divider()
                                demoRow(label: "Field 2", value: "Value")
                            }
                        }
                    }
                }
            }
            
            // MARK: - Configuration Presets
            
            GroupBox("Configuration Presets") {
                VStack(alignment: .leading, spacing: 16) {
                    presetRow(name: "Default", config: .default)
                    presetRow(name: "Compact", config: .compact)
                    presetRow(name: "Settings", config: .settings)
                    presetRow(name: "Two-Column", config: .twoColumn)
                    presetRow(name: "Stacked", config: .stacked)
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Configuration Section
    
    private var configurationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Configuration")
                .font(.headline)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Layout")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Picker("Layout", selection: $selectedLayout) {
                        Text("Inline").tag(DSFormRowLayout.inline)
                        Text("Stacked").tag(DSFormRowLayout.stacked)
                        Text("Two-Column").tag(DSFormRowLayout.twoColumn)
                    }
                    .pickerStyle(.segmented)
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
                }
            }
            
            HStack(spacing: 24) {
                Toggle("Row Separators", isOn: $showSeparators)
                Toggle("Keyboard Avoidance", isOn: $keyboardAvoidance)
            }
            .font(.subheadline)
        }
    }
    
    // MARK: - Layout Content
    
    @ViewBuilder
    private var layoutContent: some View {
        switch selectedLayout {
        case .inline:
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("John Doe")
                        .foregroundStyle(.secondary)
                }
                if showSeparators { Divider() }
                HStack {
                    Text("Email")
                    Spacer()
                    Text("john@example.com")
                        .foregroundStyle(.secondary)
                }
            }
            
        case .stacked:
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Name")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("John Doe")
                }
                if showSeparators { Divider() }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("john@example.com")
                }
            }
            
        case .twoColumn:
            VStack(spacing: 16) {
                HStack(spacing: 24) {
                    Text("Name:")
                        .frame(width: 100, alignment: .trailing)
                    Text("John Doe")
                    Spacer()
                }
                if showSeparators { Divider() }
                HStack(spacing: 24) {
                    Text("Email:")
                        .frame(width: 100, alignment: .trailing)
                    Text("john@example.com")
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func demoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
    
    private func presetRow(name: String, config: DSFormConfiguration) -> some View {
        HStack {
            Text(name)
                .font(.subheadline)
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("Layout: \(layoutName(config.layoutMode))")
                Text("Density: \(config.density?.rawValue ?? "inherited")")
                Text("Separators: \(config.showRowSeparators ? "Yes" : "No")")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
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

#Preview("DSForm Showcase - Light") {
    ScrollView {
        DSFormShowcaseView()
            .padding()
    }
    .dsTheme(.light)
}

#Preview("DSForm Showcase - Dark") {
    ScrollView {
        DSFormShowcaseView()
            .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
