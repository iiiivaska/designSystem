// ShowcasemacOSRootView.swift
// ShowcasemacOS
//
// Main navigation structure for macOS Showcase with sidebar

import SwiftUI
import ShowcaseCore
import DSCore
import DSTheme
import DSPrimitives
import DSControls
import DSForms

struct ShowcasemacOSRootView: View {
    @State private var selectedCategory: ShowcaseCategory? = .primitives
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
        .toolbar {
            ToolbarItem {
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
                
                // Route to appropriate demo view
                showcaseContent
            }
            .padding()
        }
        .navigationTitle(item.title)
    }
    
    @ViewBuilder
    private var showcaseContent: some View {
        switch item.id {
        case "dstext":
            DSTextShowcasemacOSView()
        case "dsicon":
            DSIconShowcasemacOSView()
        case "themeresolver":
            ThemeResolverShowcasemacOSView()
        case "capabilities":
            CapabilitiesShowcasemacOSView()
        case "componentspecs":
            ComponentSpecsShowcasemacOSView()
        case "componentstyles":
            ComponentStylesShowcasemacOSView()
        case "dssurface":
            DSSurfaceShowcasemacOSView()
        case "dscard":
            DSCardShowcasemacOSView()
        case "dsloader":
            DSLoaderShowcasemacOSView()
        case "dsbutton":
            DSButtonShowcasemacOSView()
        case "dstoggle":
            DSToggleShowcasemacOSView()
        case "dstextfield":
            DSTextFieldShowcasemacOSView()
        case "dspicker":
            DSPickerShowcasemacOSView()
        case "dsstepper":
            DSStepperShowcasemacOSView()
        case "dsslider":
            DSSliderShowcasemacOSView()
        case "dsform":
            DSFormShowcasemacOSView()
        default:
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
    }
}
