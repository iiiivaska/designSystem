// DSControlsTests.swift
// DesignSystem

import Testing
@testable import DSControls

@Suite("DSControls Tests")
struct DSControlsTests {
    
    @Test("Module version is defined")
    func testVersion() {
        #expect(DSControls.version == "0.1.0")
    }
}
