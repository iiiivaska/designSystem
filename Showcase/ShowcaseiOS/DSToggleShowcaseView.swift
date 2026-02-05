//
//  DSToggleShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSToggle Showcase

/// Showcase view demonstrating DSToggle and DSCheckbox controls
struct DSToggleShowcaseView: View {
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
    
    // Settings-style toggles
    @State private var wifiEnabled = true
    @State private var bluetoothEnabled = false
    @State private var airplaneMode = false
    @State private var notifications = true
    @State private var darkMode = false
    
    // Multi-select checkbox demo
    @State private var selectAll: DSCheckboxState = .intermediate
    @State private var item1: DSCheckboxState = .checked
    @State private var item2: DSCheckboxState = .unchecked
    @State private var item3: DSCheckboxState = .checked
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // MARK: Toggle States
            VStack(alignment: .leading, spacing: 12) {
                Text("Toggle Switch")
                    .font(.headline)
                
                VStack(spacing: 16) {
                    DSToggle("Enabled (On)", isOn: $toggleOn)
                    DSToggle("Enabled (Off)", isOn: $toggleOff)
                    DSToggle("Disabled (On)", isOn: $disabledOn, isDisabled: true)
                    DSToggle("Disabled (Off)", isOn: $disabledOff, isDisabled: true)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
            
            // MARK: Label-less Toggle
            VStack(alignment: .leading, spacing: 12) {
                Text("Label-less Toggle")
                    .font(.headline)
                
                HStack {
                    Text("Custom layout toggle")
                        .foregroundStyle(theme.colors.fg.secondary)
                    Spacer()
                    DSToggle(isOn: $toggleOn)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
            
            // MARK: Settings Style
            VStack(alignment: .leading, spacing: 12) {
                Text("Settings Example")
                    .font(.headline)
                
                VStack(spacing: 0) {
                    settingsRow(icon: "wifi", title: "Wi-Fi", isOn: $wifiEnabled)
                    Divider().padding(.leading, 44)
                    settingsRow(icon: "wave.3.right", title: "Bluetooth", isOn: $bluetoothEnabled)
                    Divider().padding(.leading, 44)
                    settingsRow(icon: "airplane", title: "Airplane Mode", isOn: $airplaneMode)
                    Divider().padding(.leading, 44)
                    settingsRow(icon: "bell.fill", title: "Notifications", isOn: $notifications)
                    Divider().padding(.leading, 44)
                    settingsRow(icon: "moon.fill", title: "Dark Mode", isOn: $darkMode)
                }
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
            
            // MARK: Checkbox States
            VStack(alignment: .leading, spacing: 12) {
                Text("Checkbox")
                    .font(.headline)
                
                Text("Supports hover on macOS (capability: \(capabilities.supportsHover ? "Yes" : "No"))")
                    .font(.caption)
                    .foregroundStyle(theme.colors.fg.tertiary)
                
                VStack(alignment: .leading, spacing: 16) {
                    DSCheckbox("Unchecked", state: $cbUnchecked)
                    DSCheckbox("Checked", state: $cbChecked)
                    DSCheckbox("Intermediate", state: $cbIntermediate)
                    
                    Divider()
                    
                    DSCheckbox("Disabled Checked", state: $cbDisabledChecked, isDisabled: true)
                    DSCheckbox("Disabled Unchecked", state: $cbDisabledUnchecked, isDisabled: true)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
            
            // MARK: Multi-select Checkbox
            VStack(alignment: .leading, spacing: 12) {
                Text("Multi-Select Pattern")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 4) {
                    DSCheckbox("Select All", state: $selectAll)
                    
                    Divider().padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        DSCheckbox("Documents", state: $item1)
                        DSCheckbox("Photos", state: $item2)
                        DSCheckbox("Videos", state: $item3)
                    }
                    .padding(.leading, 28)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
            
            // MARK: Spec Details
            VStack(alignment: .leading, spacing: 12) {
                Text("Toggle Spec (Resolved)")
                    .font(.headline)
                
                let specOn = theme.resolveToggle(isOn: true, state: .normal)
                let specOff = theme.resolveToggle(isOn: false, state: .normal)
                
                VStack(alignment: .leading, spacing: 8) {
                    specRow("Track Size", "\(Int(specOn.trackWidth))×\(Int(specOn.trackHeight)) pt")
                    specRow("Thumb Size", "\(Int(specOn.thumbSize)) pt")
                    specRow("Corner Radius", "\(Int(specOn.trackCornerRadius)) pt")
                    specRow("Border (Off)", "\(specOff.trackBorderWidth) pt")
                    specRow("Opacity (Normal)", "\(specOn.opacity)")
                    specRow("Opacity (Disabled)", "0.5")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
            }
        }
    }
    
    private func settingsRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(theme.colors.accent.primary)
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(theme.colors.accent.primary.opacity(0.12))
                )
            
            Text(title)
                .font(theme.typography.component.rowTitle.font)
                .foregroundStyle(theme.colors.fg.primary)
            
            Spacer()
            
            DSToggle(isOn: isOn)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private func specRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(theme.colors.fg.secondary)
            Spacer()
            Text(value)
                .font(.caption.monospaced())
                .foregroundStyle(theme.colors.fg.primary)
        }
    }
}
