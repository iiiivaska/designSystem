//
//  DSStepperShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSControls

// MARK: - DSStepper Showcase watchOS

/// Showcase view demonstrating DSStepper and DSIntStepper controls on watchOS
struct DSStepperShowcasewatchOSView: View {
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Basic Stepper
            sectionView(title: "Basic") {
                VStack(spacing: 12) {
                    DSIntStepper("Quantity", value: $quantity, range: 0...10)
                    
                    Text("Value: \(quantity)")
                        .font(.caption2)
                        .foregroundStyle(theme.colors.fg.secondary)
                }
            }
            
            // Sizes
            sectionView(title: "Sizes") {
                VStack(spacing: 10) {
                    DSIntStepper("Small", value: $smallValue, range: 0...10, size: .small)
                    DSIntStepper("Medium", value: $mediumValue, range: 0...10, size: .medium)
                    DSIntStepper("Large", value: $largeValue, range: 0...10, size: .large)
                }
            }
            
            // Bounds
            sectionView(title: "Bounds") {
                VStack(spacing: 10) {
                    DSIntStepper("At Min", value: $atMinValue, range: 0...10)
                    DSIntStepper("At Max", value: $atMaxValue, range: 0...10)
                }
            }
            
            // Custom Step
            sectionView(title: "Step by 5") {
                VStack(spacing: 8) {
                    DSIntStepper("Amount", value: $stepByFive, range: 0...100, step: 5)
                    
                    Text("Value: \(stepByFive)")
                        .font(.caption2)
                        .foregroundStyle(theme.colors.fg.secondary)
                }
            }
            
            // Disabled
            sectionView(title: "Disabled") {
                DSIntStepper("Disabled", value: $disabledValue, range: 0...10, isDisabled: true)
            }
            
            // Floating Point
            sectionView(title: "Decimal") {
                VStack(spacing: 8) {
                    DSStepper("Temp", value: $temperature, range: 0.0...5.0, step: 0.5)
                    
                    Text("Value: \(String(format: "%.1f", temperature))")
                        .font(.caption2)
                        .foregroundStyle(theme.colors.fg.secondary)
                }
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

#Preview("DSStepper watchOS") {
    NavigationStack {
        ScrollView {
            DSStepperShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("DSStepper")
    }
    .dsTheme(.dark)
}
