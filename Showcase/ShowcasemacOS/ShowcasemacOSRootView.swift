// ShowcasemacOSRootView.swift
// ShowcasemacOS
//
// Main navigation structure for macOS Showcase with sidebar

import SwiftUI
import ShowcaseCore

struct ShowcasemacOSRootView: View {
    @State private var selectedCategory: ShowcaseCategory? = .primitives
    @State private var selectedItem: ShowcaseItem?
    
    var body: some View {
        NavigationSplitView {
            List(ShowcaseCategory.allCases, selection: $selectedCategory) { category in
                NavigationLink(value: category) {
                    ShowcaseCategoryRow(category: category)
                }
            }
            .navigationSplitViewColumnWidth(min: 200, ideal: 220)
            .navigationTitle("Design System")
        } content: {
            if let category = selectedCategory {
                List(ShowcaseData.items(for: category), selection: $selectedItem) { item in
                    NavigationLink(value: item) {
                        ShowcaseItemRow(item: item)
                    }
                }
                .navigationSplitViewColumnWidth(min: 200, ideal: 250)
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
                ShowcasemacOSDetailView(item: item)
            } else {
                ContentUnavailableView(
                    "Select a Component",
                    systemImage: "cube",
                    description: Text("Choose a component to view its showcase")
                )
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

struct ShowcasemacOSDetailView: View {
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
                
                // Demo sections
                GroupBox("Light Theme") {
                    ShowcasePlaceholder(
                        title: item.title,
                        message: "Light theme demo"
                    )
                    .frame(minHeight: 200)
                }
                
                GroupBox("Dark Theme") {
                    ShowcasePlaceholder(
                        title: item.title,
                        message: "Dark theme demo"
                    )
                    .frame(minHeight: 200)
                }
                .preferredColorScheme(.dark)
            }
            .padding()
        }
        .navigationTitle(item.title)
    }
}

#Preview {
    ShowcasemacOSRootView()
}
