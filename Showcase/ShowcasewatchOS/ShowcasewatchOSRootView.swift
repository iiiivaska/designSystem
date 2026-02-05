// ShowcasewatchOSRootView.swift
// ShowcasewatchOS
//
// Main navigation structure for watchOS Showcase

import SwiftUI
import ShowcaseCore
import DSCore
import DSTheme
import DSPrimitives
import DSControls
import DSForms

struct ShowcasewatchOSRootView: View {
    @State private var isDarkMode = true
    
    private var theme: DSTheme { isDarkMode ? .dark : .light }
    
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
        }
        .dsTheme(theme)
        .preferredColorScheme(isDarkMode ? .dark : .light)
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
            DSTextShowcasewatchOSView()
        case "dsicon":
            DSIconShowcasewatchOSView()
        case "themeresolver":
            ThemeResolverShowcasewatchOSView()
        case "capabilities":
            CapabilitiesShowcasewatchOSView()
        case "componentspecs":
            ComponentSpecsShowcasewatchOSView()
        case "componentstyles":
            ComponentStylesShowcasewatchOSView()
        case "dssurface":
            DSSurfaceShowcasewatchOSView()
        case "dscard":
            DSCardShowcasewatchOSView()
        case "dsloader":
            DSLoaderShowcasewatchOSView()
        case "dsbutton":
            DSButtonShowcasewatchOSView()
        case "dstoggle":
            DSToggleShowcasewatchOSView()
        case "dstextfield":
            DSTextFieldShowcasewatchOSView()
        case "dspicker":
            DSPickerShowcasewatchOSView()
        case "dsstepper":
            DSStepperShowcasewatchOSView()
        case "dsslider":
            DSSliderShowcasewatchOSView()
        case "dsform":
            DSFormShowcasewatchOSView()
        default:
            // Placeholder for component demos
            Text("Demo coming soon")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding()
        }
    }
}

#Preview("watchOS Root") {
    ShowcasewatchOSRootView()
}
