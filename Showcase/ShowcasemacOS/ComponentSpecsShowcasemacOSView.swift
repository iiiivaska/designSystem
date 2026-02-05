//
//  ComponentSpecsShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme
import DSCore

// MARK: - Component Specs Showcase (macOS)

/// macOS Showcase view for component specs with two-column layout
struct ComponentSpecsShowcasemacOSView: View {
    @State private var selectedVariant: DSThemeVariant = .light
    
    private var previewTheme: DSTheme {
        selectedVariant == .light ? .light : .dark
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Theme toggle
            HStack {
                Text("Theme Variant")
                    .font(.headline)
                Picker("", selection: $selectedVariant) {
                    Text("Light").tag(DSThemeVariant.light)
                    Text("Dark").tag(DSThemeVariant.dark)
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }
            
            HStack(alignment: .top, spacing: 24) {
                // Left column: Buttons and Fields
                VStack(alignment: .leading, spacing: 20) {
                    macOSButtonSpecSection
                    macOSFieldSpecSection
                    macOSToggleSpecSection
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Right column: Cards, Rows, Form Layout
                VStack(alignment: .leading, spacing: 20) {
                    macOSCardSpecSection
                    macOSFormRowSpecSection
                    macOSListRowSpecSection
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    // MARK: - Buttons
    
    private var macOSButtonSpecSection: some View {
        GroupBox("DSButtonSpec") {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                    HStack(spacing: 6) {
                        Text(variant.rawValue)
                            .font(.caption)
                            .frame(width: 80, alignment: .trailing)
                        
                        ForEach(DSButtonSize.allCases, id: \.rawValue) { size in
                            let spec = DSButtonSpec.resolve(
                                theme: previewTheme,
                                variant: variant,
                                size: size,
                                state: .normal
                            )
                            
                            Text(size.rawValue)
                                .font(.system(size: spec.typography.size, weight: spec.typography.weight))
                                .foregroundStyle(spec.foregroundColor)
                                .padding(.horizontal, spec.horizontalPadding)
                                .frame(height: spec.height)
                                .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
                                .overlay(
                                    RoundedRectangle(cornerRadius: spec.cornerRadius)
                                        .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                                )
                        }
                    }
                }
            }
            .padding(4)
        }
    }
    
    // MARK: - Fields
    
    private var macOSFieldSpecSection: some View {
        GroupBox("DSFieldSpec") {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(
                    [("Normal", DSControlState.normal, DSValidationState.none),
                     ("Focused", DSControlState.focused, DSValidationState.none),
                     ("Error", DSControlState.normal, DSValidationState.error(message: "Required")),
                     ("Disabled", DSControlState.disabled, DSValidationState.none)],
                    id: \.0
                ) { label, state, validation in
                    let spec = DSFieldSpec.resolve(
                        theme: previewTheme,
                        variant: .default,
                        state: state,
                        validation: validation
                    )
                    
                    HStack {
                        Text(label)
                            .font(.caption)
                            .frame(width: 60, alignment: .trailing)
                        
                        Text("Input text")
                            .font(spec.textTypography.font)
                            .foregroundStyle(spec.foregroundColor)
                            .padding(.horizontal, spec.horizontalPadding)
                            .frame(height: spec.height)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
                            .overlay(
                                RoundedRectangle(cornerRadius: spec.cornerRadius)
                                    .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                            )
                            .opacity(spec.opacity)
                    }
                }
            }
            .padding(4)
        }
    }
    
    // MARK: - Toggles
    
    private var macOSToggleSpecSection: some View {
        GroupBox("DSToggleSpec") {
            HStack(spacing: 16) {
                ForEach(
                    [(true, DSControlState.normal, "On"),
                     (false, DSControlState.normal, "Off"),
                     (true, DSControlState.disabled, "Disabled")],
                    id: \.2
                ) { isOn, state, label in
                    let spec = DSToggleSpec.resolve(theme: previewTheme, isOn: isOn, state: state)
                    
                    VStack(spacing: 4) {
                        Capsule()
                            .fill(spec.trackColor)
                            .frame(width: spec.trackWidth, height: spec.trackHeight)
                            .overlay(Capsule().stroke(spec.trackBorderColor, lineWidth: spec.trackBorderWidth))
                            .opacity(spec.opacity)
                        
                        Text(label)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(4)
        }
    }
    
    // MARK: - Cards
    
    private var macOSCardSpecSection: some View {
        GroupBox("DSCardSpec") {
            HStack(spacing: 12) {
                ForEach(DSCardElevation.allCases, id: \.rawValue) { elevation in
                    let spec = DSCardSpec.resolve(theme: previewTheme, elevation: elevation)
                    
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: spec.cornerRadius)
                            .fill(spec.backgroundColor)
                            .frame(width: 70, height: 50)
                            .shadow(color: spec.shadow.color, radius: spec.shadow.radius, x: spec.shadow.x, y: spec.shadow.y)
                            .overlay(
                                RoundedRectangle(cornerRadius: spec.cornerRadius)
                                    .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                            )
                        
                        Text(elevation.rawValue)
                            .font(.caption2)
                        
                        if spec.usesGlassEffect {
                            Text("glass")
                                .font(.system(size: 9))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(4)
        }
    }
    
    // MARK: - Form Row
    
    private var macOSFormRowSpecSection: some View {
        GroupBox("DSFormRowSpec") {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(
                    [("iOS", DSCapabilities.iOS()),
                     ("macOS", DSCapabilities.macOS()),
                     ("watchOS", DSCapabilities.watchOS())],
                    id: \.0
                ) { platform, caps in
                    let spec = DSFormRowSpec.resolve(theme: previewTheme, capabilities: caps)
                    
                    HStack(spacing: 8) {
                        Text(platform)
                            .font(.caption)
                            .frame(width: 60, alignment: .trailing)
                        
                        Text(spec.resolvedLayout.rawValue)
                            .font(.system(.caption, design: .monospaced))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 4))
                        
                        Text("h:\(Int(spec.minHeight))pt")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        
                        if let lw = spec.labelWidth {
                            Text("label:\(Int(lw))pt")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(4)
        }
    }
    
    // MARK: - List Row
    
    private var macOSListRowSpecSection: some View {
        GroupBox("DSListRowSpec") {
            VStack(spacing: 0) {
                ForEach(DSListRowStyle.allCases, id: \.rawValue) { style in
                    let spec = DSListRowSpec.resolve(
                        theme: previewTheme,
                        style: style,
                        state: .normal,
                        capabilities: .macOS()
                    )
                    
                    HStack {
                        Text(style.rawValue.capitalized)
                            .font(spec.titleTypography.font)
                            .foregroundStyle(spec.titleColor)
                        Spacer()
                        Text("Value")
                            .font(spec.valueTypography.font)
                            .foregroundStyle(spec.valueColor)
                        Image(systemName: "chevron.right")
                            .font(.system(size: spec.accessorySize, weight: .semibold))
                            .foregroundStyle(spec.accessoryColor)
                    }
                    .padding(.horizontal, 8)
                    .frame(minHeight: spec.minHeight)
                    
                    if style != DSListRowStyle.allCases.last {
                        Divider()
                    }
                }
            }
            .padding(4)
        }
    }
}

#Preview("Component Specs macOS") {
    ScrollView {
        ComponentSpecsShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}
