//
//  DSStepperShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSStepper Showcase

/// Showcase view demonstrating DSStepper and DSIntStepper controls on iOS
struct DSStepperShowcaseView: View {
    @Environment(\.dsTheme) private var theme
    
    // Integer stepper states
    @State private var quantity = 5
    @State private var smallValue = 3
    @State private var mediumValue = 5
    @State private var largeValue = 7
    @State private var atMinValue = 0
    @State private var atMaxValue = 10
    @State private var stepByFive = 50
    @State private var disabledValue = 5
    
    // Floating point stepper states
    @State private var temperature: Double = 2.5
    @State private var rating: Double = 3.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            // Basic Integer Stepper
            stepperSection(title: "Basic Integer Stepper") {
                VStack(spacing: 16) {
                    DSIntStepper("Quantity", value: $quantity, range: 0...10)
                    
                    HStack {
                        Text("Current value:")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.secondary)
                        Text("\(quantity)")
                            .font(.caption.monospaced())
                            .foregroundStyle(theme.colors.fg.primary)
                    }
                }
            }
            
            // Sizes
            stepperSection(title: "Sizes") {
                VStack(spacing: 16) {
                    DSIntStepper("Small", value: $smallValue, range: 0...10, size: .small)
                    DSIntStepper("Medium", value: $mediumValue, range: 0...10, size: .medium)
                    DSIntStepper("Large", value: $largeValue, range: 0...10, size: .large)
                }
            }
            
            // Bounds Behavior
            stepperSection(title: "Bounds Behavior") {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Buttons disable at bounds")
                        .font(.caption)
                        .foregroundStyle(theme.colors.fg.secondary)
                    
                    DSIntStepper("At Minimum (0)", value: $atMinValue, range: 0...10)
                    DSIntStepper("At Maximum (10)", value: $atMaxValue, range: 0...10)
                }
            }
            
            // Custom Step
            stepperSection(title: "Custom Step Amount") {
                VStack(spacing: 16) {
                    DSIntStepper("Step by 5", value: $stepByFive, range: 0...100, step: 5)
                    
                    HStack {
                        Text("Current value:")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.secondary)
                        Text("\(stepByFive)")
                            .font(.caption.monospaced())
                            .foregroundStyle(theme.colors.fg.primary)
                    }
                }
            }
            
            // Disabled State
            stepperSection(title: "Disabled State") {
                VStack(spacing: 16) {
                    DSIntStepper("Disabled Stepper", value: $disabledValue, range: 0...10, isDisabled: true)
                    DSIntStepper("Enabled Stepper", value: $disabledValue, range: 0...10)
                }
            }
            
            // Floating Point Stepper
            stepperSection(title: "Floating Point Stepper") {
                VStack(spacing: 16) {
                    DSStepper("Temperature", value: $temperature, range: 0.0...5.0, step: 0.5)
                    
                    HStack {
                        Text("Value:")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.secondary)
                        Text(String(format: "%.1f", temperature))
                            .font(.caption.monospaced())
                            .foregroundStyle(theme.colors.fg.primary)
                    }
                }
            }
            
            // Without Label
            stepperSection(title: "Without Label (Custom Layout)") {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Rating")
                            .font(theme.typography.component.rowTitle.font)
                            .foregroundStyle(theme.colors.fg.primary)
                        Text("Set your preference")
                            .font(.caption)
                            .foregroundStyle(theme.colors.fg.secondary)
                    }
                    Spacer()
                    DSStepper(value: $rating, range: 1.0...5.0, step: 0.5)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(theme.colors.bg.card)
                )
            }
            
        }
    }
    
    @ViewBuilder
    private func stepperSection(title: String, @ViewBuilder content: () -> some View) -> some View {
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

#Preview("DSStepper Showcase - Light") {
    ScrollView {
        DSStepperShowcaseView()
            .padding()
    }
    .dsTheme(.light)
}

#Preview("DSStepper Showcase - Dark") {
    ScrollView {
        DSStepperShowcaseView()
            .padding()
    }
    .dsTheme(.dark)
    .preferredColorScheme(.dark)
}
