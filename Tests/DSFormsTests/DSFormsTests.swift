// DSFormsTests.swift
// DesignSystem

import Testing
@testable import DSForms

@Suite("DSForms Tests")
struct DSFormsTests {
    
    @Test("Module version is defined")
    func testVersion() {
        #expect(DSForms.version == "0.1.0")
    }
}
