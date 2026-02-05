// ShowcaseiOSRootView.swift
// ShowcaseiOS
//
// Main navigation structure for iOS Showcase

import SwiftUI
import ShowcaseCore

struct ShowcaseiOSRootView: View {
    @State private var selectedCategory: ShowcaseCategory?
    @State private var selectedItem: ShowcaseItem?
    
    var body: some View {
        NavigationSplitView {
            List(ShowcaseCategory.allCases, selection: $selectedCategory) { category in
                NavigationLink(value: category) {
                    ShowcaseCategoryRow(category: category)
                }
            }
            .navigationTitle("Design System")
        } content: {
            if let category = selectedCategory {
                List(ShowcaseData.items(for: category), selection: $selectedItem) { item in
                    NavigationLink(value: item) {
                        ShowcaseItemRow(item: item)
                    }
                }
                .navigationTitle(category.rawValue)
            } else {
                ContentUnavailableView(
                    "Select a Category",
                    systemImage: "square.grid.2x2",
                    description: Text("Choose a component category from the sidebar")
                )
            }
        } detail: {
            if let item = selectedItem {
                ShowcaseDetailView(item: item)
            } else {
                ContentUnavailableView(
                    "Select a Component",
                    systemImage: "cube",
                    description: Text("Choose a component to view its showcase")
                )
            }
        }
    }
}

struct ShowcaseDetailView: View {
    let item: ShowcaseItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Label(item.title, systemImage: item.icon)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom)
                
                Divider()
                
                // Placeholder for component demos
                ShowcasePlaceholder(
                    title: item.title,
                    message: "Component implementation coming in future steps"
                )
                .frame(minHeight: 300)
            }
            .padding()
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ShowcaseiOSRootView()
}
