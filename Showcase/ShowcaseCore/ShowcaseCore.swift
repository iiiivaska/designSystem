// ShowcaseCore.swift
// Showcase
//
// Shared demo data and navigation for all platform Showcase apps.

import SwiftUI

/// Showcase component category
public enum ShowcaseCategory: String, CaseIterable, Identifiable {
    case primitives = "Primitives"
    case controls = "Controls"
    case forms = "Forms"
    case settings = "Settings"
    case theme = "Theme"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .primitives: return "square.on.circle"
        case .controls: return "slider.horizontal.3"
        case .forms: return "rectangle.and.pencil.and.ellipsis"
        case .settings: return "gearshape"
        case .theme: return "paintpalette"
        }
    }
    
    public var description: String {
        switch self {
        case .primitives: return "Text, Icon, Surface, Card, Loader"
        case .controls: return "Button, Toggle, TextField, Picker, Stepper"
        case .forms: return "Form containers, sections, rows"
        case .settings: return "Settings screen patterns"
        case .theme: return "Theme and token exploration"
        }
    }
}

/// Demo item within a category
public struct ShowcaseItem: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let icon: String
    
    public init(id: String, title: String, subtitle: String? = nil, icon: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
}

/// Demo data provider
public enum ShowcaseData {
    public static func items(for category: ShowcaseCategory) -> [ShowcaseItem] {
        switch category {
        case .primitives:
            return [
                ShowcaseItem(id: "dstext", title: "DSText", subtitle: "Role-based text", icon: "textformat"),
                ShowcaseItem(id: "dsicon", title: "DSIcon", subtitle: "SF Symbols wrapper", icon: "star"),
                ShowcaseItem(id: "dssurface", title: "DSSurface", subtitle: "Background containers", icon: "square"),
                ShowcaseItem(id: "dscard", title: "DSCard", subtitle: "Elevated cards", icon: "rectangle.on.rectangle"),
                ShowcaseItem(id: "dsloader", title: "DSLoader", subtitle: "Loading indicators", icon: "arrow.2.circlepath"),
            ]
        case .controls:
            return [
                ShowcaseItem(id: "dsbutton", title: "DSButton", subtitle: "Interactive buttons", icon: "rectangle.fill"),
                ShowcaseItem(id: "dstoggle", title: "DSToggle", subtitle: "Toggle switches", icon: "switch.2"),
                ShowcaseItem(id: "dstextfield", title: "DSTextField", subtitle: "Text input", icon: "character.cursor.ibeam"),
                ShowcaseItem(id: "dspicker", title: "DSPicker", subtitle: "Selection picker", icon: "list.bullet"),
                ShowcaseItem(id: "dsstepper", title: "DSStepper", subtitle: "Numeric stepper", icon: "plus.forwardslash.minus"),
                ShowcaseItem(id: "dsslider", title: "DSSlider", subtitle: "Range slider", icon: "slider.horizontal.below.rectangle"),
            ]
        case .forms:
            return [
                ShowcaseItem(id: "dsform", title: "DSForm", subtitle: "Form container", icon: "doc.plaintext"),
                ShowcaseItem(id: "dsformsection", title: "DSFormSection", subtitle: "Grouped sections", icon: "rectangle.split.3x1"),
                ShowcaseItem(id: "dsformrow", title: "DSFormRow", subtitle: "Row layouts", icon: "rectangle.and.arrow.up.right.and.arrow.down.left"),
                ShowcaseItem(id: "dsvalidation", title: "Validation", subtitle: "Error states", icon: "exclamationmark.triangle"),
                ShowcaseItem(id: "dsfocuschain", title: "Focus Chain", subtitle: "Keyboard navigation", icon: "arrow.right.arrow.left"),
            ]
        case .settings:
            return [
                ShowcaseItem(id: "dsnavigationrow", title: "DSNavigationRow", subtitle: "Navigation links", icon: "chevron.right"),
                ShowcaseItem(id: "dstogglerow", title: "DSToggleRow", subtitle: "Toggle setting", icon: "switch.2"),
                ShowcaseItem(id: "dspickerrow", title: "DSPickerRow", subtitle: "Selection setting", icon: "list.bullet"),
                ShowcaseItem(id: "dstextfieldrow", title: "DSTextFieldRow", subtitle: "Text input setting", icon: "pencil"),
                ShowcaseItem(id: "dsinforow", title: "DSInfoRow", subtitle: "Read-only value", icon: "info.circle"),
                ShowcaseItem(id: "dsactionrow", title: "DSActionRow", subtitle: "Action buttons", icon: "arrow.right.circle"),
                ShowcaseItem(id: "dsdestructiverow", title: "DSDestructiveRow", subtitle: "Destructive actions", icon: "trash"),
                ShowcaseItem(id: "dsnoticeblock", title: "DSNoticeBlock", subtitle: "Inline notices", icon: "exclamationmark.bubble"),
            ]
        case .theme:
            return [
                ShowcaseItem(id: "themeresolver", title: "Theme Resolver", subtitle: "Accessibility integration", icon: "wand.and.stars"),
                ShowcaseItem(id: "capabilities", title: "Capabilities", subtitle: "Platform capabilities", icon: "gearshape.2"),
                ShowcaseItem(id: "colors", title: "Colors", subtitle: "Color palette", icon: "paintpalette"),
                ShowcaseItem(id: "typography", title: "Typography", subtitle: "Text styles", icon: "textformat.size"),
                ShowcaseItem(id: "spacing", title: "Spacing", subtitle: "Spacing scale", icon: "ruler"),
                ShowcaseItem(id: "radius", title: "Radius", subtitle: "Corner radius", icon: "square.on.square"),
                ShowcaseItem(id: "shadows", title: "Shadows", subtitle: "Elevation", icon: "square.stack.3d.up"),
            ]
        }
    }
}
