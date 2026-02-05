// ShowcaseiOSRootView.swift
// ShowcaseiOS
//
// Main navigation structure for iOS Showcase

import SwiftUI
import ShowcaseCore
import DSCore
import DSTheme
import DSPrimitives
import DSControls

struct ShowcaseiOSRootView: View {
    @State private var selectedCategory: ShowcaseCategory?
    @State private var selectedItem: ShowcaseItem?
    @State private var isDarkMode = false
    
    private var theme: DSTheme { isDarkMode ? .dark : .light }
    
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isDarkMode.toggle()
                } label: {
                    Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                }
                .accessibilityLabel(isDarkMode ? "Switch to light mode" : "Switch to dark mode")
            }
        }
        .dsTheme(theme)
        .preferredColorScheme(isDarkMode ? .dark : .light)
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
                
                // Route to appropriate demo view
                showcaseContent
            }
            .padding()
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var showcaseContent: some View {
        switch item.id {
        case "dstext":
            DSTextShowcaseView()
        case "dsicon":
            DSIconShowcaseView()
        case "themeresolver":
            ThemeResolverShowcaseView()
        case "capabilities":
            CapabilitiesShowcaseView()
        case "componentspecs":
            ComponentSpecsShowcaseView()
        case "componentstyles":
            ComponentStylesShowcaseView()
        case "dssurface":
            DSSurfaceShowcaseView()
        case "dscard":
            DSCardShowcaseView()
        case "dsloader":
            DSLoaderShowcaseView()
        case "dsbutton":
            DSButtonShowcaseView()
        case "dstoggle":
            DSToggleShowcaseView()
        case "dstextfield":
            DSTextFieldShowcaseView()
        case "dspicker":
            DSPickerShowcaseView()
        case "dsstepper":
            DSStepperShowcaseView()
        case "dsslider":
            DSSliderShowcaseView()
        default:
            // Placeholder for components not yet implemented
            ShowcasePlaceholder(
                title: item.title,
                message: "Component implementation coming in future steps"
            )
            .frame(minHeight: 300)
        }
    }
}
