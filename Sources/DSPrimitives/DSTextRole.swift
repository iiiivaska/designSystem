// DSTextRole.swift
// DesignSystem
//
// All typography roles for DSText component.
// Roles map to semantic text styles in the theme.

import SwiftUI
import DSTheme

// MARK: - DSTextRole

/// Typography role that maps to a semantic text style in the theme.
///
/// `DSTextRole` defines all available text roles for use with ``DSText``.
/// Each role resolves to a specific ``DSTextStyle`` from the current theme,
/// ensuring consistent typography across the design system.
///
/// ## Categories
///
/// ### System Roles
///
/// Standard Apple HIG text styles with Dynamic Type support:
///
/// | Role | Typical Size | Weight | Usage |
/// |------|-------------|--------|-------|
/// | ``largeTitle`` | 34pt | Bold | Large navigation titles |
/// | ``title1`` | 28pt | Bold | Primary titles |
/// | ``title2`` | 22pt | Semibold | Section headers |
/// | ``title3`` | 20pt | Semibold | Subsection headers |
/// | ``headline`` | 17pt | Semibold | Emphasized content |
/// | ``body`` | 17pt | Regular | Main content |
/// | ``callout`` | 16pt | Regular | Supporting text |
/// | ``subheadline`` | 15pt | Regular | Secondary content |
/// | ``footnote`` | 13pt | Regular | Small text, helpers |
/// | ``caption1`` | 12pt | Regular | Captions |
/// | ``caption2`` | 11pt | Regular | Smallest text |
///
/// ### Component Roles
///
/// Specialized roles for specific UI components:
///
/// | Role | Usage |
/// |------|-------|
/// | ``buttonLabel`` | Button text |
/// | ``fieldText`` | Text field input |
/// | ``fieldPlaceholder`` | Placeholder text |
/// | ``helperText`` | Field helper/error messages |
/// | ``rowTitle`` | List row primary text |
/// | ``rowValue`` | List row secondary value |
/// | ``sectionHeader`` | Section header text |
/// | ``badgeText`` | Badge/tag labels |
/// | ``monoText`` | Monospace text for codes |
///
/// ## Usage
///
/// ```swift
/// DSText("Welcome", role: .largeTitle)
/// DSText("Description", role: .body)
/// DSText("v1.2.3", role: .monoText)
/// ```
///
/// ## Topics
///
/// ### System Roles
///
/// - ``largeTitle``
/// - ``title1``
/// - ``title2``
/// - ``title3``
/// - ``headline``
/// - ``body``
/// - ``callout``
/// - ``subheadline``
/// - ``footnote``
/// - ``caption1``
/// - ``caption2``
///
/// ### Component Roles
///
/// - ``buttonLabel``
/// - ``fieldText``
/// - ``fieldPlaceholder``
/// - ``helperText``
/// - ``rowTitle``
/// - ``rowValue``
/// - ``sectionHeader``
/// - ``badgeText``
/// - ``monoText``
public enum DSTextRole: String, Sendable, Equatable, CaseIterable, Identifiable {
    
    // MARK: - System Roles
    
    /// Large title style (34pt bold).
    ///
    /// Used for prominent page titles in iOS navigation.
    case largeTitle
    
    /// Title 1 style (28pt bold).
    ///
    /// Primary titles within content.
    case title1
    
    /// Title 2 style (22pt semibold).
    ///
    /// Section headers and card titles.
    case title2
    
    /// Title 3 style (20pt semibold).
    ///
    /// Subsection headers.
    case title3
    
    /// Headline style (17pt semibold).
    ///
    /// Emphasized content, row titles.
    case headline
    
    /// Body style (17pt regular).
    ///
    /// Main content, paragraphs.
    case body
    
    /// Callout style (16pt regular).
    ///
    /// Supporting text, slightly smaller than body.
    case callout
    
    /// Subheadline style (15pt regular).
    ///
    /// Secondary content, row subtitles.
    case subheadline
    
    /// Footnote style (13pt regular).
    ///
    /// Small text, helper messages, timestamps.
    case footnote
    
    /// Caption 1 style (12pt regular).
    ///
    /// Captions, small labels.
    case caption1
    
    /// Caption 2 style (11pt regular).
    ///
    /// Smallest readable text, badges.
    case caption2
    
    // MARK: - Component Roles
    
    /// Button label style.
    ///
    /// Text for button controls.
    case buttonLabel
    
    /// Field text style.
    ///
    /// Input text in text fields.
    case fieldText
    
    /// Field placeholder style.
    ///
    /// Placeholder text in empty fields.
    case fieldPlaceholder
    
    /// Helper text style.
    ///
    /// Helper messages, validation errors below fields.
    case helperText
    
    /// Row title style.
    ///
    /// Primary text in list/form rows.
    case rowTitle
    
    /// Row value style.
    ///
    /// Secondary value text in list rows.
    case rowValue
    
    /// Section header style.
    ///
    /// Headers for grouped sections.
    case sectionHeader
    
    /// Badge text style.
    ///
    /// Text inside badges and tags.
    case badgeText
    
    /// Monospace text style.
    ///
    /// Code, identifiers, technical values.
    case monoText
    
    // MARK: - Identifiable
    
    /// The unique identifier for this role.
    public var id: String { rawValue }
    
    // MARK: - Resolution
    
    /// Resolves this role to a concrete ``DSTextStyle`` from the theme.
    ///
    /// - Parameter theme: The current theme.
    /// - Returns: The resolved text style.
    public func resolve(from theme: DSTheme) -> DSTextStyle {
        switch self {
        // System roles
        case .largeTitle: return theme.typography.system.largeTitle
        case .title1: return theme.typography.system.title1
        case .title2: return theme.typography.system.title2
        case .title3: return theme.typography.system.title3
        case .headline: return theme.typography.system.headline
        case .body: return theme.typography.system.body
        case .callout: return theme.typography.system.callout
        case .subheadline: return theme.typography.system.subheadline
        case .footnote: return theme.typography.system.footnote
        case .caption1: return theme.typography.system.caption1
        case .caption2: return theme.typography.system.caption2
            
        // Component roles
        case .buttonLabel: return theme.typography.component.buttonLabel
        case .fieldText: return theme.typography.component.fieldText
        case .fieldPlaceholder: return theme.typography.component.fieldPlaceholder
        case .helperText: return theme.typography.component.helperText
        case .rowTitle: return theme.typography.component.rowTitle
        case .rowValue: return theme.typography.component.rowValue
        case .sectionHeader: return theme.typography.component.sectionHeader
        case .badgeText: return theme.typography.component.badgeText
        case .monoText: return theme.typography.component.monoText
        }
    }
    
    // MARK: - Display Name
    
    /// Human-readable display name for the role.
    ///
    /// Used in Showcase and documentation.
    public var displayName: String {
        switch self {
        case .largeTitle: return "Large Title"
        case .title1: return "Title 1"
        case .title2: return "Title 2"
        case .title3: return "Title 3"
        case .headline: return "Headline"
        case .body: return "Body"
        case .callout: return "Callout"
        case .subheadline: return "Subheadline"
        case .footnote: return "Footnote"
        case .caption1: return "Caption 1"
        case .caption2: return "Caption 2"
        case .buttonLabel: return "Button Label"
        case .fieldText: return "Field Text"
        case .fieldPlaceholder: return "Field Placeholder"
        case .helperText: return "Helper Text"
        case .rowTitle: return "Row Title"
        case .rowValue: return "Row Value"
        case .sectionHeader: return "Section Header"
        case .badgeText: return "Badge Text"
        case .monoText: return "Mono Text"
        }
    }
    
    /// Whether this role belongs to the system typography category.
    public var isSystemRole: Bool {
        switch self {
        case .largeTitle, .title1, .title2, .title3, .headline,
             .body, .callout, .subheadline, .footnote, .caption1, .caption2:
            return true
        default:
            return false
        }
    }
    
    /// Whether this role belongs to the component typography category.
    public var isComponentRole: Bool {
        !isSystemRole
    }
    
    /// All system typography roles.
    public static var systemRoles: [DSTextRole] {
        allCases.filter(\.isSystemRole)
    }
    
    /// All component typography roles.
    public static var componentRoles: [DSTextRole] {
        allCases.filter(\.isComponentRole)
    }
}
