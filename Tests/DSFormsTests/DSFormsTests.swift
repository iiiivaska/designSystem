// DSFormsTests.swift
// DesignSystem

import Testing
@testable import DSForms
@testable import DSCore

@Suite("DSForms Tests")
struct DSFormsTests {
    
    @Test("Module version is defined")
    func testVersion() {
        #expect(DSForms.version == "0.1.0")
    }
}

// MARK: - DSFormConfiguration Tests

@Suite("DSFormConfiguration Tests")
struct DSFormConfigurationTests {
    
    @Test("Default configuration has expected values")
    func testDefaultConfiguration() {
        let config = DSFormConfiguration.default
        
        #expect(config.layoutMode == .auto)
        #expect(config.validationDisplay == .below)
        #expect(config.density == nil)
        #expect(config.keyboardAvoidanceEnabled == true)
        #expect(config.showRowSeparators == true)
    }
    
    @Test("Compact configuration has compact density")
    func testCompactConfiguration() {
        let config = DSFormConfiguration.compact
        
        #expect(config.density == .compact)
        #expect(config.validationDisplay == .inline)
    }
    
    @Test("Settings configuration is auto layout")
    func testSettingsConfiguration() {
        let config = DSFormConfiguration.settings
        
        #expect(config.layoutMode == .auto)
        #expect(config.showRowSeparators == true)
    }
    
    @Test("Two-column configuration forces twoColumn layout")
    func testTwoColumnConfiguration() {
        let config = DSFormConfiguration.twoColumn
        
        #expect(config.layoutMode == .fixed(.twoColumn))
        #expect(config.showRowSeparators == false)
    }
    
    @Test("Stacked configuration forces stacked layout")
    func testStackedConfiguration() {
        let config = DSFormConfiguration.stacked
        
        #expect(config.layoutMode == .fixed(.stacked))
        #expect(config.showRowSeparators == true)
    }
    
    @Test("Custom configuration preserves all values")
    func testCustomConfiguration() {
        let config = DSFormConfiguration(
            layoutMode: .fixed(.inline),
            validationDisplay: .summary,
            density: .spacious,
            keyboardAvoidanceEnabled: false,
            showRowSeparators: false
        )
        
        #expect(config.layoutMode == .fixed(.inline))
        #expect(config.validationDisplay == .summary)
        #expect(config.density == .spacious)
        #expect(config.keyboardAvoidanceEnabled == false)
        #expect(config.showRowSeparators == false)
    }
}

// MARK: - DSFormLayoutMode Tests

@Suite("DSFormLayoutMode Tests")
struct DSFormLayoutModeTests {
    
    @Test("Auto mode equals auto")
    func testAutoEquality() {
        let mode1 = DSFormLayoutMode.auto
        let mode2 = DSFormLayoutMode.auto
        
        #expect(mode1 == mode2)
    }
    
    @Test("Fixed modes are equal when layout matches")
    func testFixedEquality() {
        let mode1 = DSFormLayoutMode.fixed(.inline)
        let mode2 = DSFormLayoutMode.fixed(.inline)
        let mode3 = DSFormLayoutMode.fixed(.stacked)
        
        #expect(mode1 == mode2)
        #expect(mode1 != mode3)
    }
    
    @Test("Auto and fixed modes are not equal")
    func testAutoVsFixedInequality() {
        let auto = DSFormLayoutMode.auto
        let fixed = DSFormLayoutMode.fixed(.inline)
        
        #expect(auto != fixed)
    }
}

// MARK: - DSFormValidationDisplayMode Tests

@Suite("DSFormValidationDisplayMode Tests")
struct DSFormValidationDisplayModeTests {
    
    @Test("All cases have unique raw values")
    func testUniqueRawValues() {
        let modes = DSFormValidationDisplayMode.allCases
        let rawValues = Set(modes.map(\.rawValue))
        
        #expect(rawValues.count == modes.count)
    }
    
    @Test("Expected cases exist")
    func testExpectedCases() {
        let cases = DSFormValidationDisplayMode.allCases
        
        #expect(cases.contains(.inline))
        #expect(cases.contains(.below))
        #expect(cases.contains(.summary))
        #expect(cases.contains(.hidden))
    }
}

// MARK: - DSFormSectionStyle Tests

@Suite("DSFormSectionStyle Tests")
struct DSFormSectionStyleTests {
    
    @Test("All cases exist")
    func testAllCases() {
        let cases = DSFormSectionStyle.allCases
        
        #expect(cases.count == 3)
        #expect(cases.contains(.plain))
        #expect(cases.contains(.grouped))
        #expect(cases.contains(.insetGrouped))
    }
    
    @Test("Raw values are unique")
    func testUniqueRawValues() {
        let cases = DSFormSectionStyle.allCases
        let rawValues = Set(cases.map(\.rawValue))
        
        #expect(rawValues.count == cases.count)
    }
    
    @Test("Display names are meaningful")
    func testDisplayNames() {
        #expect(DSFormSectionStyle.plain.displayName == "Plain")
        #expect(DSFormSectionStyle.grouped.displayName == "Grouped")
        #expect(DSFormSectionStyle.insetGrouped.displayName == "Inset Grouped")
    }
    
    @Test("IDs match raw values")
    func testIDs() {
        for style in DSFormSectionStyle.allCases {
            #expect(style.id == style.rawValue)
        }
    }
    
    @Test("Equatable conformance")
    func testEquatable() {
        #expect(DSFormSectionStyle.plain == DSFormSectionStyle.plain)
        #expect(DSFormSectionStyle.grouped == DSFormSectionStyle.grouped)
        #expect(DSFormSectionStyle.plain != DSFormSectionStyle.grouped)
        #expect(DSFormSectionStyle.grouped != DSFormSectionStyle.insetGrouped)
    }
    
    @Test("Hashable conformance")
    func testHashable() {
        let set: Set<DSFormSectionStyle> = [.plain, .grouped, .insetGrouped, .plain]
        #expect(set.count == 3)
    }
    
    @Test("Sendable conformance compiles")
    func testSendable() {
        let style: DSFormSectionStyle = .grouped
        let _: any Sendable = style
        #expect(true)
    }
    
    @Test("CaseIterable conformance provides all cases")
    func testCaseIterable() {
        let allCases = DSFormSectionStyle.allCases
        
        #expect(allCases.contains(.plain))
        #expect(allCases.contains(.grouped))
        #expect(allCases.contains(.insetGrouped))
    }
}

// MARK: - DSSectionFooter Tests

@Suite("DSSectionFooter Tests")
struct DSSectionFooterTests {
    
    @Test("Footer with description only has nil title")
    func testDescriptionOnly() {
        let footer = DSSectionFooter(title: nil, description: "Help text")
        
        #expect(footer.title == nil)
        #expect(footer.description == "Help text")
    }
    
    @Test("Footer with title and description")
    func testTitleAndDescription() {
        let footer = DSSectionFooter(title: "Note", description: "Some description")
        
        #expect(footer.title == "Note")
        #expect(footer.description == "Some description")
    }
    
    @Test("String initializer sets description")
    func testStringInit() {
        let footer = DSSectionFooter("Help text here")
        
        #expect(footer.title == nil)
    }
}

// MARK: - DSFormRow Spec Resolution Tests

import DSTheme

@Suite("DSFormRow Spec Resolution Tests")
struct DSFormRowSpecResolutionTests {
    
    // MARK: - Auto-Degradation
    
    @Test("Auto mode resolves to inline for iOS capabilities")
    func testAutoInlineiOS() {
        let theme = DSTheme.light
        let capabilities = DSCapabilities.iOS()
        let spec = DSFormRowSpec.resolve(theme: theme, layoutMode: .auto, capabilities: capabilities)
        
        #expect(spec.resolvedLayout == .inline)
    }
    
    @Test("Auto mode resolves to twoColumn for macOS capabilities")
    func testAutoTwoColumnmacOS() {
        let theme = DSTheme.light
        let capabilities = DSCapabilities.macOS()
        let spec = DSFormRowSpec.resolve(theme: theme, layoutMode: .auto, capabilities: capabilities)
        
        #expect(spec.resolvedLayout == .twoColumn)
    }
    
    @Test("Auto mode resolves to stacked for watchOS capabilities")
    func testAutoStackedwatchOS() {
        let theme = DSTheme.light
        let capabilities = DSCapabilities.watchOS()
        let spec = DSFormRowSpec.resolve(theme: theme, layoutMode: .auto, capabilities: capabilities)
        
        #expect(spec.resolvedLayout == .stacked)
    }
    
    // MARK: - Fixed Layout
    
    @Test("Fixed layout overrides auto")
    func testFixedOverridesAuto() {
        let theme = DSTheme.light
        let capabilities = DSCapabilities.iOS() // Would default to inline
        let spec = DSFormRowSpec.resolve(theme: theme, layoutMode: .fixed(.stacked), capabilities: capabilities)
        
        #expect(spec.resolvedLayout == .stacked)
    }
    
    @Test("Fixed twoColumn layout on iOS capabilities")
    func testFixedTwoColumniOS() {
        let theme = DSTheme.light
        let capabilities = DSCapabilities.iOS()
        let spec = DSFormRowSpec.resolve(theme: theme, layoutMode: .fixed(.twoColumn), capabilities: capabilities)
        
        #expect(spec.resolvedLayout == .twoColumn)
        #expect(spec.labelWidth == 140)
    }
    
    // MARK: - Layout-Specific Properties
    
    @Test("Inline layout has no labelWidth")
    func testInlineLabelWidth() {
        let theme = DSTheme.light
        let capabilities = DSCapabilities.iOS()
        let spec = DSFormRowSpec.resolve(theme: theme, layoutMode: .fixed(.inline), capabilities: capabilities)
        
        #expect(spec.labelWidth == nil)
        #expect(spec.horizontalSpacing > 0)
        #expect(spec.verticalSpacing == 0)
    }
    
    @Test("Stacked layout has vertical spacing and no horizontal")
    func testStackedSpacing() {
        let theme = DSTheme.light
        let capabilities = DSCapabilities.watchOS()
        let spec = DSFormRowSpec.resolve(theme: theme, layoutMode: .fixed(.stacked), capabilities: capabilities)
        
        #expect(spec.labelWidth == nil)
        #expect(spec.horizontalSpacing == 0)
        #expect(spec.verticalSpacing > 0)
    }
    
    @Test("TwoColumn layout has label width and trailing alignment")
    func testTwoColumnLabelProperties() {
        let theme = DSTheme.light
        let capabilities = DSCapabilities.macOS()
        let spec = DSFormRowSpec.resolve(theme: theme, layoutMode: .fixed(.twoColumn), capabilities: capabilities)
        
        #expect(spec.labelWidth == 140)
        #expect(spec.labelAlignment == .trailing)
        #expect(spec.horizontalSpacing > 0)
        #expect(spec.verticalSpacing == 0)
    }
    
    // MARK: - Row Properties
    
    @Test("Large tap target platforms have taller rows")
    func testLargeTapTargets() {
        let theme = DSTheme.light
        let watchSpec = DSFormRowSpec.resolve(theme: theme, capabilities: DSCapabilities.watchOS())
        let macSpec = DSFormRowSpec.resolve(theme: theme, capabilities: DSCapabilities.macOS())
        
        #expect(watchSpec.minHeight >= macSpec.minHeight)
    }
    
    @Test("Content padding is positive")
    func testContentPadding() {
        let theme = DSTheme.light
        let spec = DSFormRowSpec.resolve(theme: theme, capabilities: DSCapabilities.iOS())
        
        #expect(spec.contentPadding.top > 0)
        #expect(spec.contentPadding.leading > 0)
        #expect(spec.contentPadding.bottom > 0)
        #expect(spec.contentPadding.trailing > 0)
    }
    
    @Test("Separator visible by default")
    func testSeparatorVisible() {
        let theme = DSTheme.light
        let spec = DSFormRowSpec.resolve(theme: theme, capabilities: DSCapabilities.iOS())
        
        #expect(spec.separatorVisible == true)
    }
    
    @Test("Separator insets have leading padding")
    func testSeparatorInsets() {
        let theme = DSTheme.light
        let spec = DSFormRowSpec.resolve(theme: theme, capabilities: DSCapabilities.iOS())
        
        #expect(spec.separatorInsets.leading > 0)
    }
    
    @Test("Animation is present")
    func testAnimation() {
        let theme = DSTheme.light
        let spec = DSFormRowSpec.resolve(theme: theme, capabilities: DSCapabilities.iOS())
        
        #expect(spec.animation != nil)
    }
    
    // MARK: - All Layout Combinations
    
    @Test("All layout and platform combinations resolve without error")
    func testAllCombinations() {
        let themes = [DSTheme.light, DSTheme.dark]
        let platforms: [DSCapabilities] = [.iOS(), .macOS(), .watchOS()]
        let layouts: [DSFormRowLayoutMode] = [.auto, .fixed(.inline), .fixed(.stacked), .fixed(.twoColumn)]
        
        for theme in themes {
            for capabilities in platforms {
                for layout in layouts {
                    let spec = DSFormRowSpec.resolve(theme: theme, layoutMode: layout, capabilities: capabilities)
                    
                    // Verify all specs have valid values
                    #expect(spec.minHeight > 0)
                    #expect(spec.contentPadding.top >= 0)
                    #expect(spec.contentPadding.leading >= 0)
                }
            }
        }
    }
}

// MARK: - DSFormRowLayout Tests

@Suite("DSFormRowLayout Tests")
struct DSFormRowLayoutTests {
    
    @Test("All cases exist")
    func testAllCases() {
        let cases = DSFormRowLayout.allCases
        
        #expect(cases.count == 3)
        #expect(cases.contains(.inline))
        #expect(cases.contains(.stacked))
        #expect(cases.contains(.twoColumn))
    }
    
    @Test("Raw values are unique")
    func testUniqueRawValues() {
        let cases = DSFormRowLayout.allCases
        let rawValues = Set(cases.map(\.rawValue))
        
        #expect(rawValues.count == cases.count)
    }
    
    @Test("Equatable conformance")
    func testEquatable() {
        #expect(DSFormRowLayout.inline == DSFormRowLayout.inline)
        #expect(DSFormRowLayout.stacked == DSFormRowLayout.stacked)
        #expect(DSFormRowLayout.twoColumn == DSFormRowLayout.twoColumn)
        #expect(DSFormRowLayout.inline != DSFormRowLayout.stacked)
        #expect(DSFormRowLayout.inline != DSFormRowLayout.twoColumn)
        #expect(DSFormRowLayout.stacked != DSFormRowLayout.twoColumn)
    }
    
    @Test("Hashable conformance")
    func testHashable() {
        let set: Set<DSFormRowLayout> = [.inline, .stacked, .twoColumn, .inline]
        #expect(set.count == 3)
    }
}
