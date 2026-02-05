//
//  DSSliderShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSSlider Showcase

/// Showcase view demonstrating DSSlider control on iOS
struct DSSliderShowcaseView: View {
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
        VStack(alignment: .leading, spacing: 32) {
            
            // Platform Info
            sliderSection(title: "Platform Capabilities") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("supportsInlinePickers:")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.secondary)
                        Text(capabilities.supportsInlinePickers ? "true" : "false")
                            .font(.caption.monospaced())
                            .foregroundStyle(capabilities.supportsInlinePickers ? theme.colors.state.success : theme.colors.state.danger)
                    }
                    
                    Text("On iOS, sliders render as continuous track. On watchOS, they auto-fallback to stepper.")
                        .font(.caption)
                        .foregroundStyle(theme.colors.fg.tertiary)
                }
            }
            
            // Basic Continuous Slider
            sliderSection(title: "Continuous Slider") {
                VStack(spacing: 16) {
                    DSSlider("Volume", value: $volume)
                    
                    DSSlider("Brightness", value: $brightness, range: 0...100)
                }
            }
            
            // Discrete Slider with Ticks
            sliderSection(title: "Discrete Slider (with Ticks)") {
                VStack(spacing: 16) {
                    DSSlider("Quality", value: $quality, range: 1...5, step: 1, mode: .discrete)
                    
                    Text("Discrete sliders show tick marks for each step value.")
                        .font(.caption)
                        .foregroundStyle(theme.colors.fg.tertiary)
                }
            }
            
            // Mode Comparison
            sliderSection(title: "Mode Comparison") {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Continuous (.continuous)")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(theme.colors.fg.secondary)
                        DSSlider("Value", value: $continuousValue, mode: .continuous)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Discrete (.discrete)")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(theme.colors.fg.secondary)
                        DSSlider("Level", value: $discreteValue, range: 1...5, step: 1, mode: .discrete)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Stepper (.stepper) - Fallback Mode")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(theme.colors.fg.secondary)
                        DSSlider("Rating", value: $stepperValue, range: 1...5, step: 1, mode: .stepper)
                    }
                }
            }
            
            // Range Examples
            sliderSection(title: "Custom Ranges") {
                VStack(spacing: 16) {
                    DSSlider("Percentage", value: $brightness, range: 0...100)
                    
                    DSSlider("Rating (1-5)", value: $rating, range: 1...5, step: 0.5)
                }
            }
            
            // Without Value Display
            sliderSection(title: "Without Value Display") {
                DSSlider("Hidden Value", value: $volume, showsValue: false)
            }
            
            // Without Label
            sliderSection(title: "Without Label") {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Custom Layout")
                            .font(theme.typography.component.rowTitle.font)
                            .foregroundStyle(theme.colors.fg.primary)
                        Text("Slider without built-in label")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.secondary)
                    }
                    Spacer()
                    DSSlider(value: $volume, showsValue: false)
                        .frame(width: 120)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.card)
                )
            }
            
            // Disabled State
            sliderSection(title: "Disabled State") {
                VStack(spacing: 16) {
                    DSSlider("Disabled Slider", value: $disabledValue, isDisabled: true)
                    DSSlider("Enabled Slider", value: $disabledValue)
                }
            }
            
        }
    }
    
    @ViewBuilder
    private func sliderSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(theme.colors.fg.primary)
            
            content()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.surface)
                )
        }
    }
}

#Preview("DSSlider Showcase - Light") {
    ScrollView {
        DSSliderShowcaseView()
            .padding()
    }
    .dsTheme(.light)
}

#Preview("DSSlider Showcase - Dark") {
    ScrollView {
        DSSliderShowcaseView()
            .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
