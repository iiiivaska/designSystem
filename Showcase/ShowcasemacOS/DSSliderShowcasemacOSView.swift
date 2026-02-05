//
//  DSSliderShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSSlider Showcase macOS

/// Showcase view demonstrating DSSlider control on macOS
struct DSSliderShowcasemacOSView: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    
    // Continuous slider states
    @State private var volume = 0.5
    @State private var brightness = 50.0
    
    // Discrete slider states
    @State private var quality = 3.0
    @State private var rating = 4.0
    
    // Mode comparison states
    @State private var continuousValue = 0.5
    @State private var discreteValue = 3.0
    @State private var stepperValue = 3.0
    
    // Disabled state
    @State private var disabledValue = 0.5
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top, spacing: 24) {
                // Left column
                VStack(alignment: .leading, spacing: 24) {
                    GroupBox("Platform Capabilities") {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("supportsInlinePickers:")
                                    .font(.caption)
                                    .foregroundStyle(theme.colors.fg.secondary)
                                Text(capabilities.supportsInlinePickers ? "true" : "false")
                                    .font(.caption.monospaced())
                                    .foregroundStyle(capabilities.supportsInlinePickers ? theme.colors.state.success : theme.colors.state.danger)
                            }
                            
                            Text("On macOS, sliders render as continuous track with hover states.")
                                .font(.caption)
                                .foregroundStyle(theme.colors.fg.tertiary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    
                    GroupBox("Continuous Slider") {
                        VStack(alignment: .leading, spacing: 12) {
                            DSSlider("Volume", value: $volume)
                            DSSlider("Brightness", value: $brightness, range: 0...100)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    
                    GroupBox("Discrete Slider (Ticks)") {
                        VStack(alignment: .leading, spacing: 12) {
                            DSSlider("Quality", value: $quality, range: 1...5, step: 1, mode: .discrete)
                            
                            Text("Discrete sliders show tick marks for each step.")
                                .font(.caption)
                                .foregroundStyle(theme.colors.fg.tertiary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    
                    GroupBox("Without Value Display") {
                        DSSlider("Hidden Value", value: $volume, showsValue: false)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Right column
                VStack(alignment: .leading, spacing: 24) {
                    GroupBox("Mode Comparison") {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Continuous (.continuous)")
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(theme.colors.fg.secondary)
                                DSSlider("Value", value: $continuousValue, mode: .continuous)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Discrete (.discrete)")
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(theme.colors.fg.secondary)
                                DSSlider("Level", value: $discreteValue, range: 1...5, step: 1, mode: .discrete)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Stepper (.stepper)")
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(theme.colors.fg.secondary)
                                DSSlider("Rating", value: $stepperValue, range: 1...5, step: 1, mode: .stepper)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    
                    GroupBox("Custom Ranges") {
                        VStack(alignment: .leading, spacing: 12) {
                            DSSlider("Percentage", value: $brightness, range: 0...100)
                            DSSlider("Rating", value: $rating, range: 1...5, step: 0.5)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    
                    GroupBox("Disabled State") {
                        VStack(alignment: .leading, spacing: 12) {
                            DSSlider("Disabled", value: $disabledValue, isDisabled: true)
                            DSSlider("Enabled", value: $disabledValue)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    
                    GroupBox("Custom Layout") {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Audio")
                                    .font(theme.typography.component.rowTitle.font)
                                    .foregroundStyle(theme.colors.fg.primary)
                                Text("Adjust volume level")
                                    .font(.caption)
                                    .foregroundStyle(theme.colors.fg.secondary)
                            }
                            Spacer()
                            DSSlider(value: $volume, showsValue: false)
                                .frame(width: 150)
                        }
                        .padding(8)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
}

#Preview("DSSlider Showcase macOS - Light") {
    DSSliderShowcasemacOSView()
        .frame(width: 700, height: 650)
        .dsTheme(.light)
}

#Preview("DSSlider Showcase macOS - Dark") {
    DSSliderShowcasemacOSView()
        .frame(width: 700, height: 650)
        .dsTheme(.dark)
        .preferredColorScheme(.dark)
}
