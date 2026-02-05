//
//  ComponentSpecsShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme
import DSCore

// MARK: - Component Specs Showcase

/// Showcase view demonstrating the resolve-then-render spec system
struct ComponentSpecsShowcaseView: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    
    @State private var selectedVariant: DSThemeVariant = .light
    
    private var previewTheme: DSTheme {
        selectedVariant == .light ? .light : .dark
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Theme variant toggle
            Picker("Theme", selection: $selectedVariant) {
                Text("Light").tag(DSThemeVariant.light)
                Text("Dark").tag(DSThemeVariant.dark)
            }
            .pickerStyle(.segmented)
            
            // Button Specs
            buttonSpecSection
            
            // Field Specs
            fieldSpecSection
            
            // Toggle Specs
            toggleSpecSection
            
            // Form Row Specs
            formRowSpecSection
            
            // Card Specs
            cardSpecSection
            
            // List Row Specs
            listRowSpecSection
        }
    }
    
    // MARK: - Button Spec
    
    private var buttonSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSButtonSpec")
                .font(.headline)
            
            Text("Variants \u{00d7} Sizes \u{00d7} States")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                VStack(alignment: .leading, spacing: 4) {
                    Text(variant.rawValue.capitalized)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 8) {
                        ForEach(DSButtonSize.allCases, id: \.rawValue) { size in
                            let spec = DSButtonSpec.resolve(
                                theme: previewTheme,
                                variant: variant,
                                size: size,
                                state: .normal
                            )
                            
                            Text(size.rawValue)
                                .font(spec.typography.font)
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
            
            // States showcase
            VStack(alignment: .leading, spacing: 4) {
                Text("States (primary, medium)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 8) {
                    ForEach(
                        [("Normal", DSControlState.normal), ("Pressed", DSControlState.pressed),
                         ("Disabled", DSControlState.disabled), ("Loading", DSControlState.loading)],
                        id: \.0
                    ) { label, state in
                        let spec = DSButtonSpec.resolve(
                            theme: previewTheme,
                            variant: .primary,
                            size: .medium,
                            state: state
                        )
                        
                        Text(label)
                            .font(.caption2)
                            .foregroundStyle(spec.foregroundColor)
                            .padding(.horizontal, 12)
                            .frame(height: spec.height)
                            .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
                            .opacity(spec.opacity)
                            .scaleEffect(spec.scaleEffect)
                    }
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Field Spec
    
    private var fieldSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSFieldSpec")
                .font(.headline)
            
            ForEach(
                [("Normal", DSControlState.normal, DSValidationState.none),
                 ("Focused", DSControlState.focused, DSValidationState.none),
                 ("Error", DSControlState.normal, DSValidationState.error(message: "Required")),
                 ("Warning", DSControlState.normal, DSValidationState.warning(message: "Weak")),
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
                        .frame(width: 60, alignment: .leading)
                    
                    Text("Sample text")
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
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Toggle Spec
    
    private var toggleSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSToggleSpec")
                .font(.headline)
            
            HStack(spacing: 24) {
                ForEach(
                    [(true, DSControlState.normal, "On"),
                     (false, DSControlState.normal, "Off"),
                     (true, DSControlState.disabled, "Disabled On"),
                     (false, DSControlState.disabled, "Disabled Off")],
                    id: \.2
                ) { isOn, state, label in
                    let spec = DSToggleSpec.resolve(
                        theme: previewTheme,
                        isOn: isOn,
                        state: state
                    )
                    
                    VStack(spacing: 4) {
                        Capsule()
                            .fill(spec.trackColor)
                            .frame(width: spec.trackWidth, height: spec.trackHeight)
                            .overlay(
                                Capsule()
                                    .stroke(spec.trackBorderColor, lineWidth: spec.trackBorderWidth)
                            )
                            .opacity(spec.opacity)
                        
                        Text(label)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Form Row Spec
    
    private var formRowSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSFormRowSpec")
                .font(.headline)
            
            Text("Auto-degradation by platform")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            ForEach(
                [("iOS", DSCapabilities.iOS()),
                 ("macOS", DSCapabilities.macOS()),
                 ("watchOS", DSCapabilities.watchOS())],
                id: \.0
            ) { platform, caps in
                let spec = DSFormRowSpec.resolve(
                    theme: previewTheme,
                    layoutMode: .auto,
                    capabilities: caps
                )
                
                HStack {
                    Text(platform)
                        .font(.caption)
                        .frame(width: 60, alignment: .leading)
                    
                    Text(spec.resolvedLayout.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 4))
                    
                    if let labelWidth = spec.labelWidth {
                        Text("label: \(Int(labelWidth))pt")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("h:\(Int(spec.minHeight))pt")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Card Spec
    
    private var cardSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSCardSpec")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(DSCardElevation.allCases, id: \.rawValue) { elevation in
                    let spec = DSCardSpec.resolve(
                        theme: previewTheme,
                        elevation: elevation
                    )
                    
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: spec.cornerRadius)
                            .fill(spec.backgroundColor)
                            .frame(width: 60, height: 60)
                            .shadow(
                                color: spec.shadow.color,
                                radius: spec.shadow.radius,
                                x: spec.shadow.x,
                                y: spec.shadow.y
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: spec.cornerRadius)
                                    .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                            )
                        
                        Text(elevation.rawValue)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        
                        if spec.usesGlassEffect {
                            Image(systemName: "sparkles")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - List Row Spec
    
    private var listRowSpecSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DSListRowSpec")
                .font(.headline)
            
            ForEach(DSListRowStyle.allCases, id: \.rawValue) { style in
                let spec = DSListRowSpec.resolve(
                    theme: previewTheme,
                    style: style,
                    state: .normal,
                    capabilities: capabilities
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
                .padding(.horizontal, spec.horizontalPadding)
                .frame(minHeight: spec.minHeight)
                .opacity(spec.opacity)
                
                if style != DSListRowStyle.allCases.last {
                    Divider()
                        .padding(.leading, spec.separatorInsets.leading)
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Component Specs - Light") {
    NavigationStack {
        ScrollView {
            ComponentSpecsShowcaseView()
                .padding()
        }
        .navigationTitle("Component Specs")
    }
}

#Preview("Component Specs - Dark") {
    NavigationStack {
        ScrollView {
            ComponentSpecsShowcaseView()
                .padding()
        }
        .navigationTitle("Component Specs")
    }
    .preferredColorScheme(.dark)
}
