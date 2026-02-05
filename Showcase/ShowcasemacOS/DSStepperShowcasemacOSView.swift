//
//  DSStepperShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSStepper Showcase macOS

/// Showcase view demonstrating DSStepper and DSIntStepper controls on macOS
struct DSStepperShowcasemacOSView: View {
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
        ScrollView {
            HStack(alignment: .top, spacing: 24) {
                // Left column: Sizes & Basic
                VStack(alignment: .leading, spacing: 24) {
                    GroupBox("Basic Integer Stepper") {
                        VStack(alignment: .leading, spacing: 12) {
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    
                    GroupBox("Sizes") {
                        VStack(alignment: .leading, spacing: 12) {
                            DSIntStepper("Small", value: $smallValue, range: 0...10, size: .small)
                            DSIntStepper("Medium", value: $mediumValue, range: 0...10, size: .medium)
                            DSIntStepper("Large", value: $largeValue, range: 0...10, size: .large)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    
                    GroupBox("Floating Point") {
                        VStack(alignment: .leading, spacing: 12) {
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Right column: Bounds & States
                VStack(alignment: .leading, spacing: 24) {
                    GroupBox("Bounds Behavior") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Buttons disable at bounds")
                                .font(.caption)
                                .foregroundStyle(theme.colors.fg.secondary)
                            
                            DSIntStepper("At Minimum (0)", value: $atMinValue, range: 0...10)
                            DSIntStepper("At Maximum (10)", value: $atMaxValue, range: 0...10)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    
                    GroupBox("Custom Step") {
                        VStack(alignment: .leading, spacing: 12) {
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    
                    GroupBox("Disabled State") {
                        VStack(alignment: .leading, spacing: 12) {
                            DSIntStepper("Disabled", value: $disabledValue, range: 0...10, isDisabled: true)
                            DSIntStepper("Enabled", value: $disabledValue, range: 0...10)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    }
                    
                    GroupBox("Custom Layout") {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
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
                        .padding(8)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
}

#Preview("DSStepper Showcase macOS - Light") {
    DSStepperShowcasemacOSView()
        .frame(width: 700, height: 600)
        .dsTheme(.light)
}

#Preview("DSStepper Showcase macOS - Dark") {
    DSStepperShowcasemacOSView()
        .frame(width: 700, height: 600)
        .dsTheme(.dark)
        .preferredColorScheme(.dark)
}
