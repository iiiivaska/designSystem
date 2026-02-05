//
//  DSToggleShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSToggle Showcase (macOS)

/// Showcase view demonstrating DSToggle and DSCheckbox on macOS
struct DSToggleShowcasemacOSView: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    
    // Toggle states
    @State private var toggleOn = true
    @State private var toggleOff = false
    @State private var disabledOn = true
    @State private var disabledOff = false
    
    // Checkbox states
    @State private var cbUnchecked: DSCheckboxState = .unchecked
    @State private var cbChecked: DSCheckboxState = .checked
    @State private var cbIntermediate: DSCheckboxState = .intermediate
    @State private var cbDisabledChecked: DSCheckboxState = .checked
    @State private var cbDisabledUnchecked: DSCheckboxState = .unchecked
    
    // Settings toggles
    @State private var wifiEnabled = true
    @State private var bluetoothEnabled = false
    @State private var notifications = true
    
    // Bool binding checkboxes
    @State private var acceptTerms = false
    @State private var subscribeNewsletter = true
    
    // Multi-select
    @State private var selectAll: DSCheckboxState = .intermediate
    @State private var doc: DSCheckboxState = .checked
    @State private var photo: DSCheckboxState = .unchecked
    @State private var video: DSCheckboxState = .checked
    @State private var music: DSCheckboxState = .unchecked
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Left column: Toggle Switch
            VStack(alignment: .leading, spacing: 24) {
                // MARK: Toggle States
                GroupBox("Toggle Switch") {
                    VStack(alignment: .leading, spacing: 16) {
                        DSToggle("Enabled (On)", isOn: $toggleOn)
                        DSToggle("Enabled (Off)", isOn: $toggleOff)
                        
                        Divider()
                        
                        DSToggle("Disabled (On)", isOn: $disabledOn, isDisabled: true)
                        DSToggle("Disabled (Off)", isOn: $disabledOff, isDisabled: true)
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: Label-less Toggle
                GroupBox("Label-less Toggle") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Custom label layout")
                                .foregroundStyle(theme.colors.fg.secondary)
                            Spacer()
                            DSToggle(isOn: $toggleOn)
                        }
                        
                        HStack {
                            Image(systemName: "wifi")
                                .foregroundStyle(theme.colors.accent.primary)
                            Text("Wi-Fi")
                            Spacer()
                            DSToggle(isOn: $wifiEnabled)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: Settings Example
                GroupBox("Settings Pattern") {
                    VStack(spacing: 0) {
                        settingsRow(icon: "wifi", title: "Wi-Fi", isOn: $wifiEnabled)
                        Divider().padding(.leading, 36)
                        settingsRow(icon: "wave.3.right", title: "Bluetooth", isOn: $bluetoothEnabled)
                        Divider().padding(.leading, 36)
                        settingsRow(icon: "bell.fill", title: "Notifications", isOn: $notifications)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: Spec Details
                GroupBox("Toggle Spec") {
                    let specOn = theme.resolveToggle(isOn: true, state: .normal)
                    let specOff = theme.resolveToggle(isOn: false, state: .normal)
                    let specDisabled = theme.resolveToggle(isOn: true, state: .disabled)
                    
                    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 6) {
                        GridRow {
                            Text("Property").font(.caption.bold())
                            Text("Value").font(.caption.bold())
                        }
                        .foregroundStyle(theme.colors.fg.secondary)
                        
                        Divider()
                        
                        specGridRow("Track Size", "\(Int(specOn.trackWidth))×\(Int(specOn.trackHeight))")
                        specGridRow("Thumb Size", "\(Int(specOn.thumbSize))")
                        specGridRow("Corner Radius", "\(Int(specOn.trackCornerRadius))")
                        specGridRow("Border (Off)", "\(specOff.trackBorderWidth)")
                        specGridRow("Opacity (Normal)", "\(specOn.opacity)")
                        specGridRow("Opacity (Disabled)", "\(specDisabled.opacity)")
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(minWidth: 300)
            
            // Right column: Checkbox
            VStack(alignment: .leading, spacing: 24) {
                // MARK: Checkbox States
                GroupBox("Checkbox") {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Hover supported: \(capabilities.supportsHover ? "Yes" : "No")")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.tertiary)
                        
                        DSCheckbox("Unchecked", state: $cbUnchecked)
                        DSCheckbox("Checked", state: $cbChecked)
                        DSCheckbox("Intermediate", state: $cbIntermediate)
                        
                        Divider()
                        
                        Text("Disabled").font(.caption).foregroundStyle(theme.colors.fg.tertiary)
                        DSCheckbox("Disabled Checked", state: $cbDisabledChecked, isDisabled: true)
                        DSCheckbox("Disabled Unchecked", state: $cbDisabledUnchecked, isDisabled: true)
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: Multi-Select
                GroupBox("Multi-Select Pattern") {
                    VStack(alignment: .leading, spacing: 4) {
                        DSCheckbox("Select All", state: $selectAll)
                            .fontWeight(.semibold)
                        
                        Divider().padding(.vertical, 4)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            DSCheckbox("Documents", state: $doc)
                            DSCheckbox("Photos", state: $photo)
                            DSCheckbox("Videos", state: $video)
                            DSCheckbox("Music", state: $music)
                        }
                        .padding(.leading, 28)
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: Bool Binding
                GroupBox("Bool Binding Checkbox") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Convenience Bool binding maps to checked/unchecked:")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.tertiary)
                        
                        DSCheckbox("Accept Terms", isOn: $acceptTerms)
                        DSCheckbox("Subscribe to Newsletter", isOn: $subscribeNewsletter)
                    }
                    .padding(.vertical, 4)
                }
                
                // MARK: Checkbox in Table
                GroupBox("Checkbox in List Context") {
                    VStack(spacing: 0) {
                        checkboxListRow(title: "Documents", subtitle: "12 files", state: $doc)
                        Divider().padding(.leading, 36)
                        checkboxListRow(title: "Photos", subtitle: "48 files", state: $photo)
                        Divider().padding(.leading, 36)
                        checkboxListRow(title: "Videos", subtitle: "5 files", state: $video)
                        Divider().padding(.leading, 36)
                        checkboxListRow(title: "Music", subtitle: "156 files", state: $music)
                    }
                    .padding(.vertical, 4)
                }
            }
            .frame(minWidth: 300)
        }
    }
    
    private func settingsRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(theme.colors.accent.primary)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(theme.typography.component.rowTitle.font)
                .foregroundStyle(theme.colors.fg.primary)
            
            Spacer()
            
            DSToggle(isOn: isOn)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
    
    private func checkboxListRow(title: String, subtitle: String, state: Binding<DSCheckboxState>) -> some View {
        HStack(spacing: 10) {
            DSCheckbox(state: state)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(theme.typography.component.rowTitle.font)
                    .foregroundStyle(theme.colors.fg.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(theme.colors.fg.tertiary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }
    
    private func specGridRow(_ label: String, _ value: String) -> some View {
        GridRow {
            Text(label)
                .font(.caption)
                .foregroundStyle(theme.colors.fg.secondary)
            Text(value)
                .font(.caption.monospaced())
                .foregroundStyle(theme.colors.fg.primary)
        }
    }
}

#Preview("DSToggle macOS") {
    ScrollView {
        DSToggleShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 800)
    .dsTheme(.light)
}
