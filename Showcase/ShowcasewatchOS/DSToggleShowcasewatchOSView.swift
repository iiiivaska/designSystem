//
//  DSToggleShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSToggle Showcase (watchOS)

/// Compact showcase view for DSToggle and DSCheckbox on watchOS
struct DSToggleShowcasewatchOSView: View {
    @Environment(\.dsTheme) private var theme
    
    // Toggle states
    @State private var toggleOn = true
    @State private var toggleOff = false
    @State private var disabledOn = true
    @State private var disabledOff = false
    
    // Checkbox states
    @State private var cbChecked: DSCheckboxState = .checked
    @State private var cbUnchecked: DSCheckboxState = .unchecked
    @State private var cbIntermediate: DSCheckboxState = .intermediate
    
    // Settings
    @State private var wifiOn = true
    @State private var doNotDisturb = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: Toggle Switch
            Text("Toggle Switch")
                .font(.caption2.bold())
                .foregroundStyle(theme.colors.fg.secondary)
            
            VStack(spacing: 8) {
                DSToggle("On", isOn: $toggleOn)
                DSToggle("Off", isOn: $toggleOff)
            }
            
            // MARK: Disabled
            Text("Disabled")
                .font(.caption2.bold())
                .foregroundStyle(theme.colors.fg.secondary)
            
            VStack(spacing: 8) {
                DSToggle("Disabled On", isOn: $disabledOn, isDisabled: true)
                DSToggle("Disabled Off", isOn: $disabledOff, isDisabled: true)
            }
            
            // MARK: Settings Pattern
            Text("Settings")
                .font(.caption2.bold())
                .foregroundStyle(theme.colors.fg.secondary)
            
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "wifi")
                        .foregroundStyle(theme.colors.accent.primary)
                        .font(.caption2)
                    Text("Wi-Fi")
                        .font(.caption)
                    Spacer()
                    DSToggle(isOn: $wifiOn)
                }
                .padding(.vertical, 4)
                
                Divider()
                
                HStack {
                    Image(systemName: "moon.fill")
                        .foregroundStyle(theme.colors.accent.secondary)
                        .font(.caption2)
                    Text("Do Not Disturb")
                        .font(.caption)
                    Spacer()
                    DSToggle(isOn: $doNotDisturb)
                }
                .padding(.vertical, 4)
            }
            
            // MARK: Checkbox
            Text("Checkbox")
                .font(.caption2.bold())
                .foregroundStyle(theme.colors.fg.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                DSCheckbox("Checked", state: $cbChecked)
                DSCheckbox("Unchecked", state: $cbUnchecked)
                DSCheckbox("Mixed", state: $cbIntermediate)
            }
            
            // MARK: Spec Info
            Text("Spec")
                .font(.caption2.bold())
                .foregroundStyle(theme.colors.fg.secondary)
            
            let spec = theme.resolveToggle(isOn: true, state: .normal)
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Track").font(.caption2).foregroundStyle(theme.colors.fg.tertiary)
                    Spacer()
                    Text("\(Int(spec.trackWidth))×\(Int(spec.trackHeight))")
                        .font(.caption2.monospaced())
                }
                HStack {
                    Text("Thumb").font(.caption2).foregroundStyle(theme.colors.fg.tertiary)
                    Spacer()
                    Text("\(Int(spec.thumbSize)) pt")
                        .font(.caption2.monospaced())
                }
                HStack {
                    Text("Opacity").font(.caption2).foregroundStyle(theme.colors.fg.tertiary)
                    Spacer()
                    Text("\(spec.opacity, specifier: "%.1f")")
                        .font(.caption2.monospaced())
                }
            }
        }
    }
}

#Preview("DSToggle watchOS") {
    NavigationStack {
        ScrollView {
            DSToggleShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSToggle")
    }
    .dsTheme(.dark)
}
