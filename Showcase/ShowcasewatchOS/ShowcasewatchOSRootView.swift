// ShowcasewatchOSRootView.swift
// ShowcasewatchOS
//
// Main navigation structure for watchOS Showcase

import SwiftUI
import ShowcaseCore

struct ShowcasewatchOSRootView: View {
    var body: some View {
        NavigationStack {
            List(ShowcaseCategory.allCases) { category in
                NavigationLink(value: category) {
                    ShowcaseCategoryRow(category: category)
                }
            }
            .navigationTitle("Components")
            .navigationDestination(for: ShowcaseCategory.self) { category in
                ShowcasewatchOSCategoryView(category: category)
            }
            .navigationDestination(for: ShowcaseItem.self) { item in
                ShowcasewatchOSDetailView(item: item)
            }
        }
    }
}

struct ShowcasewatchOSCategoryView: View {
    let category: ShowcaseCategory
    
    var body: some View {
        List(ShowcaseData.items(for: category)) { item in
            NavigationLink(value: item) {
                ShowcaseItemRow(item: item)
            }
        }
        .navigationTitle(category.rawValue)
    }
}

struct ShowcasewatchOSDetailView: View {
    let item: ShowcaseItem
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Image(systemName: item.icon)
                    .font(.title)
                    .foregroundStyle(.tint)
                
                Text(item.title)
                    .font(.headline)
                
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                // Placeholder for component demos
                Text("Demo coming soon")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding()
            }
            .padding()
        }
        .navigationTitle(item.title)
    }
}

#Preview {
    ShowcasewatchOSRootView()
}
