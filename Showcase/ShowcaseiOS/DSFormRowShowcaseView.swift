// DSFormRowShowcaseView.swift
// ShowcaseiOS
//
// Showcase for DSFormRow demonstrating inline, stacked, and twoColumn layouts.

import SwiftUI
import DSCore
import DSTheme
import DSForms
import DSPrimitives
import DSControls

struct DSFormRowShowcaseView: View {
    @State private var selectedLayout: DSFormRowLayout = .inline
    @State private var showSeparators = true
    @State private var toggleValue = true
    @State private var textValue = ""
    @State private var sliderValue: Double = 50
    
    @Environment(\.dsTheme) private var theme: DSTheme
    @Environment(\.dsCapabilities) private var capabilities: DSCapabilities
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // MARK: - Layout Picker
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Row Layout")
                    .font(.headline)
                
                Picker("Layout", selection: $selectedLayout) {
                    ForEach(DSFormRowLayout.allCases, id: \.self) { layout in
                        Text(layout.rawValue.capitalized).tag(layout)
                    }
                }
                .pickerStyle(.segmented)
                
                Toggle("Show Separators", isOn: $showSeparators)
                    .font(.subheadline)
            }
            
            Divider()
            
            // MARK: - Interactive Demo
            
            GroupBox("Interactive Demo (\(selectedLayout.rawValue.capitalized))") {
                VStack(spacing: 0) {
                    DSFormRow("Name", layout: selectedLayout, showSeparator: showSeparators) {
                        Text("John Doe")
                            .foregroundStyle(.secondary)
                    }
                    
                    DSFormRow("Email", layout: selectedLayout, showSeparator: showSeparators) {
                        Text("john@example.com")
                            .foregroundStyle(.secondary)
                    }
                    
                    DSFormRow(layout: selectedLayout, showSeparator: showSeparators) {
                        HStack(spacing: 6) {
                            Image(systemName: "bell.fill")
                                .foregroundStyle(.blue)
                            DSText("Notifications", role: .rowTitle)
                        }
                    } control: {
                        Toggle("", isOn: $toggleValue)
                            .labelsHidden()
                    }
                    
                    DSFormRow("Theme", layout: selectedLayout, showSeparator: showSeparators) {
                        Text("Dark")
                            .foregroundStyle(.secondary)
                    } accessory: {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    
                    DSFormRow("Volume", layout: selectedLayout, showSeparator: false) {
                        Slider(value: $sliderValue, in: 0...100)
                    } footer: {
                        Text("Adjust the system volume level")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            
            Divider()
            
            // MARK: - Layout Comparison
            
            GroupBox("Layout Comparison") {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(DSFormRowLayout.allCases, id: \.self) { layout in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(layout.rawValue.capitalized)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            VStack(spacing: 0) {
                                DSFormRow("Name", layout: layout) {
                                    Text("John Doe")
                                        .foregroundStyle(.secondary)
                                }
                                
                                DSFormRow("Email", layout: layout, showSeparator: false) {
                                    Text("john@example.com")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .background(.background.secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            
            Divider()
            
            // MARK: - Slot Architecture
            
            GroupBox("Slot Architecture") {
                VStack(alignment: .leading, spacing: 16) {
                    Text("DSFormRow provides 4 slots: label, control, accessory, footer")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 0) {
                        // Label + Control only
                        DSFormRow("Label + Control") {
                            Text("Value")
                                .foregroundStyle(.secondary)
                        }
                        
                        // Label + Control + Accessory
                        DSFormRow("With Accessory") {
                            Text("Value")
                                .foregroundStyle(.secondary)
                        } accessory: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        
                        // Label + Control + Footer
                        DSFormRow("With Footer") {
                            Toggle("", isOn: $toggleValue)
                                .labelsHidden()
                        } footer: {
                            Text("Helper text appears below the row")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        
                        // All 4 slots
                        DSFormRow("All Slots", showSeparator: false) {
                            Text("Value")
                                .foregroundStyle(.secondary)
                        } accessory: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        } footer: {
                            Text("Footer hint text for additional context")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
            
            Divider()
            
            // MARK: - Spec Details
            
            GroupBox("Resolved Spec (\(selectedLayout.rawValue))") {
                let spec = DSFormRowSpec.resolve(
                    theme: theme,
                    layoutMode: .fixed(selectedLayout),
                    capabilities: capabilities
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    specRow("Layout", value: "\(spec.resolvedLayout)")
                    specRow("Label Width", value: spec.labelWidth.map { "\(Int($0))pt" } ?? "nil")
                    specRow("H Spacing", value: "\(Int(spec.horizontalSpacing))pt")
                    specRow("V Spacing", value: "\(Int(spec.verticalSpacing))pt")
                    specRow("Min Height", value: "\(Int(spec.minHeight))pt")
                    specRow("Separator", value: "\(spec.separatorVisible)")
                    specRow("Padding", value: "T:\(Int(spec.contentPadding.top)) L:\(Int(spec.contentPadding.leading)) B:\(Int(spec.contentPadding.bottom)) R:\(Int(spec.contentPadding.trailing))")
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Helpers
    
    private func specRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption.monospaced())
        }
    }
}

#Preview("DSFormRow - Light") {
    ScrollView {
        DSFormRowShowcaseView()
            .padding()
    }
    .dsTheme(.light)
}

#Preview("DSFormRow - Dark") {
    ScrollView {
        DSFormRowShowcaseView()
            .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
