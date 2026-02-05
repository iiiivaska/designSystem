//
//  DSSliderShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSSlider Showcase watchOS

/// Showcase view demonstrating DSSlider control on watchOS
/// Note: On watchOS, sliders auto-fallback to stepper mode due to platform capabilities
struct DSSliderShowcasewatchOSView: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    
    // Slider states (will render as steppers)
    @State private var volume = 0.5
    @State private var quality = 3.0
    @State private var rating = 3.0
    @State private var disabledValue = 0.5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Platform Info
            sectionView(title: "Platform") {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Inline:")
                            .font(.caption2)
                            .foregroundStyle(theme.colors.fg.secondary)
                        Text(capabilities.supportsInlinePickers ? "Yes" : "No")
                            .font(.caption2.monospaced())
                            .foregroundStyle(capabilities.supportsInlinePickers ? theme.colors.state.success : theme.colors.state.warning)
                    }
                    
                    Text("Auto-fallback to stepper")
                        .font(.caption2)
                        .foregroundStyle(theme.colors.fg.tertiary)
                }
            }
            
            // Auto Mode (will fallback to stepper)
            sectionView(title: "Auto Mode") {
                VStack(spacing: 8) {
                    DSSlider("Volume", value: $volume, range: 0...1, step: 0.1)
                    
                    Text("Value: \(String(format: "%.1f", volume))")
                        .font(.caption2)
                        .foregroundStyle(theme.colors.fg.secondary)
                }
            }
            
            // Discrete Values
            sectionView(title: "Discrete") {
                VStack(spacing: 8) {
                    DSSlider("Quality", value: $quality, range: 1...5, step: 1, mode: .discrete)
                    
                    Text("Level: \(Int(quality))")
                        .font(.caption2)
                        .foregroundStyle(theme.colors.fg.secondary)
                }
            }
            
            // Explicit Stepper Mode
            sectionView(title: "Stepper Mode") {
                VStack(spacing: 8) {
                    DSSlider("Rating", value: $rating, range: 1...5, step: 1, mode: .stepper)
                    
                    Text("Rating: \(Int(rating))")
                        .font(.caption2)
                        .foregroundStyle(theme.colors.fg.secondary)
                }
            }
            
            // Disabled
            sectionView(title: "Disabled") {
                DSSlider("Disabled", value: $disabledValue, isDisabled: true)
            }
        }
    }
    
    @ViewBuilder
    private func sectionView(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(theme.colors.fg.secondary)
            
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("DSSlider watchOS") {
    NavigationStack {
        ScrollView {
            DSSliderShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSSlider")
    }
    .dsTheme(.dark)
}
