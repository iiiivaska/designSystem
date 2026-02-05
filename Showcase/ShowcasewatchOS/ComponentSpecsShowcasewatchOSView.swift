//
//  ComponentSpecsShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme

// MARK: - Component Specs Showcase (watchOS)

/// Compact showcase view for component specs on watchOS
struct ComponentSpecsShowcasewatchOSView: View {
    let theme = DSTheme.light
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Button specs
            Text("Button Specs")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                let spec = DSButtonSpec.resolve(
                    theme: theme,
                    variant: variant,
                    size: .medium,
                    state: .normal
                )
                
                Text(variant.rawValue)
                    .font(.system(size: spec.typography.size, weight: spec.typography.weight))
                    .foregroundStyle(spec.foregroundColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: spec.height)
                    .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: spec.cornerRadius)
                            .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                    )
            }
            
            Divider()
            
            // Form Row layout
            Text("Form Row Layout")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            let rowSpec = DSFormRowSpec.resolve(
                theme: theme,
                layoutMode: .auto,
                capabilities: .watchOS()
            )
            
            HStack {
                Text("Layout")
                    .font(.caption)
                Spacer()
                Text(rowSpec.resolvedLayout.rawValue)
                    .font(.system(.caption, design: .monospaced))
            }
            
            HStack {
                Text("Min Height")
                    .font(.caption)
                Spacer()
                Text("\(Int(rowSpec.minHeight))pt")
                    .font(.system(.caption, design: .monospaced))
            }
            
            Divider()
            
            // Card elevations
            Text("Card Elevations")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 6) {
                ForEach(DSCardElevation.allCases, id: \.rawValue) { elevation in
                    let spec = DSCardSpec.resolve(theme: theme, elevation: elevation)
                    
                    VStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: spec.cornerRadius * 0.6)
                            .fill(spec.backgroundColor)
                            .frame(height: 30)
                            .overlay(
                                RoundedRectangle(cornerRadius: spec.cornerRadius * 0.6)
                                    .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                            )
                        
                        Text(elevation.rawValue)
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Divider()
            
            // List row styles
            Text("Row Styles")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            ForEach(DSListRowStyle.allCases, id: \.rawValue) { style in
                let spec = DSListRowSpec.resolve(
                    theme: theme,
                    style: style,
                    state: .normal,
                    capabilities: .watchOS()
                )
                
                HStack {
                    Text(style.rawValue)
                        .font(.caption)
                        .foregroundStyle(spec.titleColor)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: spec.accessorySize, weight: .semibold))
                        .foregroundStyle(spec.accessoryColor)
                }
            }
        }
    }
}

#Preview("Component Specs watchOS") {
    NavigationStack {
        ScrollView {
            ComponentSpecsShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("Specs")
    }
}
