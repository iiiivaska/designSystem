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
