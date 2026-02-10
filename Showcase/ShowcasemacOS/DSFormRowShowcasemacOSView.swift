// DSFormRowShowcasemacOSView.swift
// ShowcasemacOS
//
// Showcase for DSFormRow on macOS, demonstrating two-column layout and all modes.

import SwiftUI
import DSCore
import DSTheme
import DSForms
import DSPrimitives
import DSControls

struct DSFormRowShowcasemacOSView: View {
    @State private var selectedLayout: DSFormRowLayout = .twoColumn
    @State private var showSeparators = true
    @State private var toggleValue = true
    @State private var textValue = "John Doe"
    @State private var emailValue = "john@example.com"
    
    @Environment(\.dsTheme) private var theme: DSTheme
    @Environment(\.dsCapabilities) private var capabilities: DSCapabilities
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Left: Interactive Demo
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Layout Picker
                
                GroupBox("Configuration") {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("Layout", selection: $selectedLayout) {
                            ForEach(DSFormRowLayout.allCases, id: \.self) { layout in
                                Text(layout.rawValue.capitalized).tag(layout)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Toggle("Show Separators", isOn: $showSeparators)
                    }
                }
                
                // MARK: - Interactive Demo
                
                GroupBox("Interactive Demo (\(selectedLayout.rawValue.capitalized))") {
                    VStack(spacing: 0) {
                        DSFormRow("Name:", layout: selectedLayout, showSeparator: showSeparators) {
                            TextField("Enter name", text: $textValue)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        DSFormRow("Email:", layout: selectedLayout, showSeparator: showSeparators) {
                            TextField("Enter email", text: $emailValue)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        DSFormRow("Notifications:", layout: selectedLayout, showSeparator: showSeparators) {
                            Toggle("", isOn: $toggleValue)
                                .labelsHidden()
                        }
                        
                        DSFormRow("Theme:", layout: selectedLayout, showSeparator: showSeparators) {
                            Text("Dark")
                                .foregroundStyle(.secondary)
                        } accessory: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        
                        DSFormRow("Description:", layout: selectedLayout, showSeparator: false) {
                            TextField("Optional description", text: .constant(""))
                                .textFieldStyle(.roundedBorder)
                        } footer: {
                            Text("This field is optional. Leave blank if not needed.")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                
                // MARK: - Slot Architecture
                
                GroupBox("Slot Architecture") {
                    VStack(spacing: 0) {
                        DSFormRow("Label + Control") {
                            Text("Value").foregroundStyle(.secondary)
                        }
                        
                        DSFormRow("With Accessory") {
                            Text("Value").foregroundStyle(.secondary)
                        } accessory: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        
                        DSFormRow("With Footer") {
                            Toggle("", isOn: $toggleValue).labelsHidden()
                        } footer: {
                            Text("Footer hint below the row")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        
                        DSFormRow("All 4 Slots", showSeparator: false) {
                            Text("Value").foregroundStyle(.secondary)
                        } accessory: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.blue)
                        } footer: {
                            Text("Complete row with all slots filled")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
            .frame(minWidth: 400)
            
            // Right: Comparison + Spec
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Layout Comparison
                
                GroupBox("Layout Comparison") {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(DSFormRowLayout.allCases, id: \.self) { layout in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(layout.rawValue.capitalized)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                                
                                VStack(spacing: 0) {
                                    DSFormRow("Name:", layout: layout) {
                                        Text("John Doe").foregroundStyle(.secondary)
                                    }
                                    DSFormRow("Email:", layout: layout, showSeparator: false) {
                                        Text("john@example.com").foregroundStyle(.secondary)
                                    }
                                }
                                .padding(4)
                                .background(.background.secondary)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                        }
                    }
                }
                
                // MARK: - Spec Details
                
                GroupBox("Resolved Spec (\(selectedLayout.rawValue))") {
                    let spec = DSFormRowSpec.resolve(
                        theme: theme,
                        layoutMode: .fixed(selectedLayout),
                        capabilities: capabilities
                    )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        specRow("Layout", value: "\(spec.resolvedLayout)")
                        specRow("Label Width", value: spec.labelWidth.map { "\(Int($0))pt" } ?? "nil")
                        specRow("H Spacing", value: "\(Int(spec.horizontalSpacing))pt")
                        specRow("V Spacing", value: "\(Int(spec.verticalSpacing))pt")
                        specRow("Min Height", value: "\(Int(spec.minHeight))pt")
                        specRow("Separator", value: "\(spec.separatorVisible)")
                        specRow("Padding", value: "T:\(Int(spec.contentPadding.top)) L:\(Int(spec.contentPadding.leading))")
                    }
                }
                
                // MARK: - Platform Info
                
                GroupBox("Platform Info") {
                    VStack(alignment: .leading, spacing: 6) {
                        specRow("Auto Layout", value: "\(capabilities.preferredFormRowLayout)")
                        specRow("Hover", value: "\(capabilities.supportsHover)")
                        specRow("Focus Ring", value: "\(capabilities.supportsFocusRing)")
                        specRow("Large Targets", value: "\(capabilities.prefersLargeTapTargets)")
                    }
                }
            }
            .frame(minWidth: 300)
        }
    }
    
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

#Preview("DSFormRow macOS - Light") {
    ScrollView {
        DSFormRowShowcasemacOSView()
            .padding()
    }
    .dsTheme(.light)
    .frame(minWidth: 800, minHeight: 700)
}

#Preview("DSFormRow macOS - Dark") {
    ScrollView {
        DSFormRowShowcasemacOSView()
            .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
    .frame(minWidth: 800, minHeight: 700)
}
