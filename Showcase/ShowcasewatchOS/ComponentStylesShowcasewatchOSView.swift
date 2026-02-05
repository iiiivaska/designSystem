//
//  ComponentStylesShowcasewatchOSView.swift
//  Showcase
//
//  Created by Василий on 06.02.2026.
//

import SwiftUI
import DSTheme

// MARK: - Component Styles Showcase (watchOS)

/// Compact showcase view demonstrating DSComponentStyles for watchOS.
struct ComponentStylesShowcasewatchOSView: View {
    @Environment(\.dsCapabilities) private var capabilities
    
    private let theme = DSTheme.light
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Resolver IDs
            Text("Resolvers")
                .font(.headline)
            
            let styles = theme.componentStyles
            resolverIdRow("Button", id: styles.button.id)
            resolverIdRow("Field", id: styles.field.id)
            resolverIdRow("Toggle", id: styles.toggle.id)
            resolverIdRow("FormRow", id: styles.formRow.id)
            resolverIdRow("Card", id: styles.card.id)
            resolverIdRow("ListRow", id: styles.listRow.id)
            
            Divider()
            
            // Convenience methods results
            Text("Resolved Values")
                .font(.headline)
            
            let buttonSpec = theme.resolveButton(variant: .primary, size: .medium, state: .normal)
            let fieldSpec = theme.resolveField(variant: .default, state: .normal)
            let formRowSpec = theme.resolveFormRow(capabilities: capabilities)
            let cardSpec = theme.resolveCard(elevation: .raised)
            
            infoRow("Button height", value: "\(Int(buttonSpec.height))pt")
            infoRow("Button radius", value: "\(Int(buttonSpec.cornerRadius))pt")
            infoRow("Field height", value: "\(Int(fieldSpec.height))pt")
            infoRow("Form layout", value: "\(formRowSpec.resolvedLayout)")
            infoRow("Card radius", value: "\(Int(cardSpec.cornerRadius))pt")
            
            Divider()
            
            // Button preview
            Text("Button Preview")
                .font(.headline)
            
            ForEach(DSButtonVariant.allCases, id: \.rawValue) { variant in
                let spec = theme.resolveButton(variant: variant, size: .small, state: .normal)
                
                Text(variant.rawValue.capitalized)
                    .font(spec.typography.font)
                    .foregroundStyle(spec.foregroundColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: spec.height)
                    .background(spec.backgroundColor, in: RoundedRectangle(cornerRadius: spec.cornerRadius))
            }
        }
    }
    
    private func resolverIdRow(_ name: String, id: String) -> some View {
        HStack {
            Text(name)
                .font(.caption2)
            Spacer()
            Text(id)
                .font(.caption2.monospaced())
                .foregroundStyle(.secondary)
        }
    }
    
    private func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption2)
            Spacer()
            Text(value)
                .font(.caption2.monospaced())
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Component Styles watchOS") {
    NavigationStack {
        ScrollView {
            ComponentStylesShowcasewatchOSView()
                .padding()
        }
        .navigationTitle("Styles")
    }
}
