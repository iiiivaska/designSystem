// DSSettingsTests.swift
// DesignSystem

import Testing
@testable import DSSettings

@Suite("DSSettings Tests")
struct DSSettingsTests {
    
    @Test("Module version is defined")
    func testVersion() {
        #expect(DSSettings.version == "0.1.0")
    }
}
