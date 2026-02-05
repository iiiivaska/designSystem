//
//  ComponentStylesShowcaseView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme

// MARK: - Component Styles Showcase

/// Showcase view demonstrating DSComponentStyles registry and custom resolvers.
struct ComponentStylesShowcaseView: View {
    @Environment(\.dsTheme) private var theme
    @Environment(\.dsCapabilities) private var capabilities
    @State private var useDarkTheme = false
    @State private var useCustomButton = false
    @State private var useCustomCard = false
    
    private var previewTheme: DSTheme {
        var styles = DSComponentStyles.default
        
        if useCustomButton {
            styles.button = DSButtonStyleResolver(id: "pill") { theme, variant, size, state in
                let base = DSButtonSpec.resolve(theme: theme, variant: variant, size: size, state: state)
                return DSButtonSpec(
                    backgroundColor: base.backgroundColor,
                    foregroundColor: base.foregroundColor,
                    borderColor: base.borderColor,
                    borderWidth: base.borderWidth,
                    height: base.height,
                    horizontalPadding: base.horizontalPadding * 1.5,
                    verticalPadding: base.verticalPadding,
                    cornerRadius: base.height / 2,
                    typography: base.typography,
                    shadow: base.shadow,
                    opacity: base.opacity,
                    scaleEffect: base.scaleEffect,
                    animation: base.animation
                )
            }
        }
        
        if useCustomCard {
            styles.card = DSCardStyleResolver(id: "no-shadow") { theme, elevation in
                let base = DSCardSpec.resolve(theme: theme, elevation: elevation)
                return DSCardSpec(
                    backgroundColor: base.backgroundColor,
                    borderColor: theme.colors.accent.primary.opacity(0.2),
                    borderWidth: 2,
                    cornerRadius: 20,
                    shadow: .none,
                    padding: base.padding,
                    usesGlassEffect: false,
                    glassBorderColor: .clear
                )
            }
        }
        
        return DSTheme(
            variant: useDarkTheme ? .dark : .light,
            componentStyles: styles
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Description
            Text("DSComponentStyles is a registry of spec resolvers. Override individual resolvers to customize component styling without modifying component code.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Controls
            stylesControls
            
            Divider()
            
            // Resolver IDs
            resolverIdsSection
            
            Divider()
            
            // Live preview
            livePreviewSection
        }
    }
    
    // MARK: - Controls
    
    private var stylesControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Configuration")
                .font(.headline)
            
            Toggle("Dark Theme", isOn: $useDarkTheme)
            Toggle("Custom Button (Pill Shape)", isOn: $useCustomButton)
            Toggle("Custom Card (Accent Border)", isOn: $useCustomCard)
        }
    }
    
    // MARK: - Resolver IDs
    
    private var resolverIdsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Resolvers")
                .font(.headline)
            
            let styles = previewTheme.componentStyles
            
            resolverIdRow("Button", id: styles.button.id)
            resolverIdRow("Field", id: styles.field.id)
            resolverIdRow("Toggle", id: styles.toggle.id)
            resolverIdRow("Form Row", id: styles.formRow.id)
            resolverIdRow("Card", id: styles.card.id)
            resolverIdRow("List Row", id: styles.listRow.id)
        }
    }
    
    private func resolverIdRow(_ name: String, id: String) -> some View {
        HStack {
            Text(name)
                .font(.subheadline)
            Spacer()
            Text(id)
                .font(.subheadline.monospaced())
                .foregroundStyle(id == "default" ? Color.secondary : Color.orange)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(id == "default" ? Color.secondary.opacity(0.1) : Color.orange.opacity(0.1))
                )
        }
    }
    
    // MARK: - Live Preview
    
    private var livePreviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Live Preview")
                .font(.headline)
            
            // Button preview
            buttonPreview
            
            // Card preview
            cardPreview
            
            // Convenience methods demo
            convenienceMethodsDemo
        }
    }
    
    private var buttonPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Buttons (via theme.resolveButton)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                    let spec = previewTheme.resolveButton(variant: variant, size: .medium, state: .normal)
                    
                    Text(variant.rawValue.capitalized)
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
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    private var cardPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cards (via theme.resolveCard)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                ForEach(DSCardElevation.allCases, id: \.rawValue) { elevation in
                    let spec = previewTheme.resolveCard(elevation: elevation)
                    
                    VStack {
                        Text(elevation.rawValue)
                            .font(.caption)
                    }
                    .frame(width: 70, height: 60)
                    .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: spec.cornerRadius)
                            .stroke(spec.borderColor, lineWidth: spec.borderWidth)
                    )
                    .shadow(
                        color: spec.shadow.color,
                        radius: spec.shadow.radius,
                        x: spec.shadow.x,
                        y: spec.shadow.y
                    )
                }
            }
        }
        .padding()
        .background(previewTheme.colors.bg.canvas.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
    
    private var convenienceMethodsDemo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("All Convenience Methods")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            let buttonSpec = previewTheme.resolveButton(variant: .primary, size: .medium, state: .normal)
            let fieldSpec = previewTheme.resolveField(variant: .default, state: .normal)
            let toggleSpec = previewTheme.resolveToggle(isOn: true, state: .normal)
            let formRowSpec = previewTheme.resolveFormRow(capabilities: capabilities)
            let cardSpec = previewTheme.resolveCard(elevation: .raised)
            let listRowSpec = previewTheme.resolveListRow(style: .plain, state: .normal, capabilities: capabilities)
            
            VStack(alignment: .leading, spacing: 4) {
                convenienceRow("resolveButton", detail: "h=\(Int(buttonSpec.height))pt, r=\(Int(buttonSpec.cornerRadius))pt")
                convenienceRow("resolveField", detail: "h=\(Int(fieldSpec.height))pt, r=\(Int(fieldSpec.cornerRadius))pt")
                convenienceRow("resolveToggle", detail: "w=\(Int(toggleSpec.trackWidth))×\(Int(toggleSpec.trackHeight))pt")
                convenienceRow("resolveFormRow", detail: "layout=\(formRowSpec.resolvedLayout)")
                convenienceRow("resolveCard", detail: "r=\(Int(cardSpec.cornerRadius))pt, glass=\(cardSpec.usesGlassEffect)")
                convenienceRow("resolveListRow", detail: "minH=\(Int(listRowSpec.minHeight))pt")
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func convenienceRow(_ method: String, detail: String) -> some View {
        HStack {
            Text(method)
                .font(.caption.monospaced())
                .foregroundStyle(.primary)
            Spacer()
            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Component Styles - Light") {
    NavigationStack {
        ScrollView {
            ComponentStylesShowcaseView()
                .padding()
        }
        .navigationTitle("Component Styles")
    }
}

#Preview("Component Styles - Dark") {
    NavigationStack {
        ScrollView {
            ComponentStylesShowcaseView()
                .padding()
        }
        .navigationTitle("Component Styles")
    }
    .preferredColorScheme(.dark)
}
