//
//  ComponentStylesShowcasemacOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme
import DSCore

// MARK: - Component Styles Showcase (macOS)

/// Showcase view demonstrating DSComponentStyles registry for macOS.
struct ComponentStylesShowcasemacOSView: View {
    @Environment(\.dsTheme) private var theme
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
            styles.card = DSCardStyleResolver(id: "accent-border") { theme, elevation in
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
        HStack(alignment: .top, spacing: 24) {
            // Left: Configuration
            GroupBox("Configuration") {
                VStack(alignment: .leading, spacing: 12) {
                    Toggle("Dark Theme", isOn: $useDarkTheme)
                    Toggle("Custom Button (Pill)", isOn: $useCustomButton)
                    Toggle("Custom Card (Accent Border)", isOn: $useCustomCard)
                    
                    Divider()
                    
                    Text("Active Resolvers")
                        .font(.headline)
                    
                    resolverIdGrid
                }
                .padding(4)
            }
            .frame(minWidth: 260, maxWidth: 300)
            
            // Right: Live Preview
            GroupBox("Live Preview") {
                VStack(alignment: .leading, spacing: 16) {
                    // Buttons
                    buttonPreview
                    
                    Divider()
                    
                    // Cards
                    cardPreview
                    
                    Divider()
                    
                    // Convenience methods
                    convenienceMethodsSection
                }
                .padding(4)
            }
        }
    }
    
    private var resolverIdGrid: some View {
        let styles = previewTheme.componentStyles
        return VStack(alignment: .leading, spacing: 4) {
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
                .padding(.horizontal, 6)
                .padding(.vertical, 1)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(id == "default" ? Color.secondary.opacity(0.1) : Color.orange.opacity(0.1))
                )
        }
    }
    
    private var buttonPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Buttons")
                .font(.headline)
            
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
    }
    
    private var cardPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cards")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(DSCardElevation.allCases, id: \.rawValue) { elevation in
                    let spec = previewTheme.resolveCard(elevation: elevation)
                    
                    VStack {
                        Text(elevation.rawValue)
                            .font(.caption)
                    }
                    .frame(width: 80, height: 60)
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
    }
    
    private var convenienceMethodsSection: some View {
        let capabilities = DSCapabilities.macOS()
        
        return VStack(alignment: .leading, spacing: 8) {
            Text("Convenience Methods")
                .font(.headline)
            
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
    }
    
    private func convenienceRow(_ method: String, detail: String) -> some View {
        HStack {
            Text(method)
                .font(.caption.monospaced())
            Spacer()
            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Component Styles macOS") {
    ScrollView {
        ComponentStylesShowcasemacOSView()
            .padding()
    }
    .frame(width: 900, height: 700)
}
