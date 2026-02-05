// ShowcaseNavigation.swift
// Showcase
//
// Shared navigation components for all platform Showcase apps.

import SwiftUI

/// Category list row
public struct ShowcaseCategoryRow: View {
    let category: ShowcaseCategory
    
    public init(category: ShowcaseCategory) {
        self.category = category
    }
    
    public var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(category.rawValue)
                    .font(.headline)
                Text(category.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: category.icon)
                .foregroundStyle(.tint)
        }
    }
}

/// Item list row
public struct ShowcaseItemRow: View {
    let item: ShowcaseItem
    
    public init(item: ShowcaseItem) {
        self.item = item
    }
    
    public var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.headline)
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        } icon: {
            Image(systemName: item.icon)
                .foregroundStyle(.tint)
        }
    }
}

/// Placeholder view for components not yet implemented
public struct ShowcasePlaceholder: View {
    let title: String
    let message: String
    
    public init(title: String, message: String = "Coming soon") {
        self.title = title
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "hammer")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
