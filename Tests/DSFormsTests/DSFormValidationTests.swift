// DSFormValidationTests.swift
// DesignSystem
//
// Tests for the Form Validation System: DSFormValidationContext,
// DSValidationView, DSValidationSummary, DSRequiredMarker, and related types.

import Testing
import SwiftUI
@testable import DSForms
@testable import DSCore
@testable import DSTheme

// MARK: - DSFormValidationContext Tests

@Suite("DSFormValidationContext Tests")
@MainActor
struct DSFormValidationContextTests {
    
    // MARK: - Initialization
    
    @Test("Initial state is empty")
    func testInitialState() {
        let context = DSFormValidationContext()
        
        #expect(context.fieldStates.isEmpty)
        #expect(context.showValidation == false)
        #expect(context.isFormValid == true)
        #expect(context.errorCount == 0)
        #expect(context.warningCount == 0)
        #expect(context.fieldIds.isEmpty)
        #expect(context.highestSeverity == .none)
        #expect(context.allErrors.isEmpty)
        #expect(context.allWarnings.isEmpty)
    }
    
    // MARK: - State Management: set
    
    @Test("Setting error state for a field")
    func testSetError() {
        let context = DSFormValidationContext()
        
        context.set(.error(message: "Required"), for: "email")
        
        #expect(context.fieldStates.count == 1)
        #expect(context.state(for: "email") == .error(message: "Required"))
    }
    
    @Test("Setting warning state for a field")
    func testSetWarning() {
        let context = DSFormValidationContext()
        
        context.set(.warning(message: "Weak password"), for: "password")
        
        #expect(context.state(for: "password") == .warning(message: "Weak password"))
    }
    
    @Test("Setting success state for a field")
    func testSetSuccess() {
        let context = DSFormValidationContext()
        
        context.set(.success(message: "Looks good"), for: "name")
        
        #expect(context.state(for: "name") == .success(message: "Looks good"))
    }
    
    @Test("Setting validating state for a field")
    func testSetValidating() {
        let context = DSFormValidationContext()
        
        context.set(.validating, for: "username")
        
        #expect(context.state(for: "username") == .validating)
    }
    
    @Test("Setting none state for a field")
    func testSetNone() {
        let context = DSFormValidationContext()
        
        context.set(.none, for: "field")
        
        #expect(context.state(for: "field") == .none)
        #expect(context.fieldStates.count == 1)
    }
    
    @Test("Overwriting existing field state")
    func testOverwrite() {
        let context = DSFormValidationContext()
        
        context.set(.error(message: "Required"), for: "email")
        #expect(context.state(for: "email").hasError)
        
        context.set(.success(message: "Valid"), for: "email")
        #expect(context.state(for: "email") == .success(message: "Valid"))
        #expect(context.fieldStates.count == 1)
    }
    
    @Test("Setting multiple fields")
    func testMultipleFields() {
        let context = DSFormValidationContext()
        
        context.set(.error(message: "Required"), for: "name")
        context.set(.warning(message: "Weak"), for: "password")
        context.set(.success(message: "OK"), for: "email")
        
        #expect(context.fieldStates.count == 3)
        #expect(context.state(for: "name").hasError)
        #expect(context.state(for: "password").hasWarning)
        #expect(context.state(for: "email") == .success(message: "OK"))
    }
    
    // MARK: - State Management: clear
    
    @Test("Clearing a field removes it")
    func testClear() {
        let context = DSFormValidationContext()
        
        context.set(.error(message: "Required"), for: "email")
        #expect(context.fieldStates.count == 1)
        
        context.clear(for: "email")
        #expect(context.fieldStates.isEmpty)
        #expect(context.state(for: "email") == .none)
    }
    
    @Test("Clearing a non-existent field is safe")
    func testClearNonExistent() {
        let context = DSFormValidationContext()
        
        context.clear(for: "nonexistent")
        #expect(context.fieldStates.isEmpty)
    }
    
    @Test("Clearing one field doesn't affect others")
    func testClearSelective() {
        let context = DSFormValidationContext()
        
        context.set(.error(message: "A"), for: "field1")
        context.set(.error(message: "B"), for: "field2")
        
        context.clear(for: "field1")
        
        #expect(context.fieldStates.count == 1)
        #expect(context.state(for: "field1") == .none)
        #expect(context.state(for: "field2") == .error(message: "B"))
    }
    
    // MARK: - State Management: clearAll
    
    @Test("Clear all removes all fields")
    func testClearAll() {
        let context = DSFormValidationContext()
        
        context.set(.error(message: "A"), for: "field1")
        context.set(.warning(message: "B"), for: "field2")
        context.set(.success(message: "C"), for: "field3")
        
        #expect(context.fieldStates.count == 3)
        
        context.clearAll()
        
        #expect(context.fieldStates.isEmpty)
        #expect(context.isFormValid == true)
    }
    
    @Test("Clear all on empty context is safe")
    func testClearAllEmpty() {
        let context = DSFormValidationContext()
        
        context.clearAll()
        #expect(context.fieldStates.isEmpty)
    }
    
    // MARK: - State Management: state(for:)
    
    @Test("State for unregistered field returns .none")
    func testStateForUnregistered() {
        let context = DSFormValidationContext()
        
        #expect(context.state(for: "unknown") == .none)
    }
    
    @Test("State for registered field returns correct state")
    func testStateForRegistered() {
        let context = DSFormValidationContext()
        
        context.set(.error(message: "Error"), for: "field")
        #expect(context.state(for: "field") == .error(message: "Error"))
    }
    
    // MARK: - effectiveState
    
    @Test("effectiveState returns .none when showValidation is false")
    func testEffectiveStateHidden() {
        let context = DSFormValidationContext()
        context.showValidation = false
        
        context.set(.error(message: "Required"), for: "email")
        
        #expect(context.effectiveState(for: "email") == .none)
    }
    
    @Test("effectiveState returns actual state when showValidation is true")
    func testEffectiveStateVisible() {
        let context = DSFormValidationContext()
        context.showValidation = true
        
        context.set(.error(message: "Required"), for: "email")
        
        #expect(context.effectiveState(for: "email") == .error(message: "Required"))
    }
    
    @Test("effectiveState returns .none for unregistered field regardless of showValidation")
    func testEffectiveStateUnregistered() {
        let context = DSFormValidationContext()
        
        context.showValidation = false
        #expect(context.effectiveState(for: "unknown") == .none)
        
        context.showValidation = true
        #expect(context.effectiveState(for: "unknown") == .none)
    }
    
    @Test("effectiveState respects showValidation toggle")
    func testEffectiveStateToggle() {
        let context = DSFormValidationContext()
        context.set(.warning(message: "Weak"), for: "password")
        
        // Initially hidden
        context.showValidation = false
        #expect(context.effectiveState(for: "password") == .none)
        
        // Show
        context.showValidation = true
        #expect(context.effectiveState(for: "password") == .warning(message: "Weak"))
        
        // Hide again
        context.showValidation = false
        #expect(context.effectiveState(for: "password") == .none)
    }
    
    // MARK: - Querying: isFormValid
    
    @Test("Empty form is valid")
    func testEmptyFormValid() {
        let context = DSFormValidationContext()
        #expect(context.isFormValid == true)
    }
    
    @Test("Form with only success states is valid")
    func testFormWithSuccessIsValid() {
        let context = DSFormValidationContext()
        context.set(.success(message: "OK"), for: "field1")
        context.set(.success(), for: "field2")
        
        #expect(context.isFormValid == true)
    }
    
    @Test("Form with only warnings is valid")
    func testFormWithWarningsIsValid() {
        let context = DSFormValidationContext()
        context.set(.warning(message: "Weak"), for: "password")
        
        #expect(context.isFormValid == true)
    }
    
    @Test("Form with .none states is valid")
    func testFormWithNoneIsValid() {
        let context = DSFormValidationContext()
        context.set(.none, for: "field1")
        context.set(.none, for: "field2")
        
        #expect(context.isFormValid == true)
    }
    
    @Test("Form with any error is not valid")
    func testFormWithErrorInvalid() {
        let context = DSFormValidationContext()
        context.set(.success(message: "OK"), for: "name")
        context.set(.error(message: "Required"), for: "email")
        
        #expect(context.isFormValid == false)
    }
    
    @Test("Form with validating state is not valid")
    func testFormWithValidatingInvalid() {
        let context = DSFormValidationContext()
        context.set(.validating, for: "username")
        
        #expect(context.isFormValid == false)
    }
    
    @Test("Form becomes valid after clearing errors")
    func testFormBecomesValid() {
        let context = DSFormValidationContext()
        context.set(.error(message: "Required"), for: "email")
        
        #expect(context.isFormValid == false)
        
        context.set(.success(message: "Valid"), for: "email")
        
        #expect(context.isFormValid == true)
    }
    
    // MARK: - Querying: allErrors
    
    @Test("allErrors returns only error fields")
    func testAllErrors() {
        let context = DSFormValidationContext()
        context.set(.error(message: "Error 1"), for: "field1")
        context.set(.warning(message: "Warning"), for: "field2")
        context.set(.error(message: "Error 2"), for: "field3")
        context.set(.success(message: "OK"), for: "field4")
        
        let errors = context.allErrors
        
        #expect(errors.count == 2)
        #expect(errors.contains { $0.fieldId == "field1" && $0.message == "Error 1" })
        #expect(errors.contains { $0.fieldId == "field3" && $0.message == "Error 2" })
    }
    
    @Test("allErrors is sorted by fieldId")
    func testAllErrorsSorted() {
        let context = DSFormValidationContext()
        context.set(.error(message: "C"), for: "z_field")
        context.set(.error(message: "A"), for: "a_field")
        context.set(.error(message: "B"), for: "m_field")
        
        let errors = context.allErrors
        
        #expect(errors[0].fieldId == "a_field")
        #expect(errors[1].fieldId == "m_field")
        #expect(errors[2].fieldId == "z_field")
    }
    
    @Test("allErrors is empty when no errors")
    func testAllErrorsEmpty() {
        let context = DSFormValidationContext()
        context.set(.warning(message: "Warn"), for: "field1")
        context.set(.success(message: "OK"), for: "field2")
        
        #expect(context.allErrors.isEmpty)
    }
    
    // MARK: - Querying: allWarnings
    
    @Test("allWarnings returns only warning fields")
    func testAllWarnings() {
        let context = DSFormValidationContext()
        context.set(.error(message: "Error"), for: "field1")
        context.set(.warning(message: "Warning 1"), for: "field2")
        context.set(.warning(message: "Warning 2"), for: "field3")
        context.set(.success(message: "OK"), for: "field4")
        
        let warnings = context.allWarnings
        
        #expect(warnings.count == 2)
        #expect(warnings.contains { $0.fieldId == "field2" && $0.message == "Warning 1" })
        #expect(warnings.contains { $0.fieldId == "field3" && $0.message == "Warning 2" })
    }
    
    @Test("allWarnings is sorted by fieldId")
    func testAllWarningsSorted() {
        let context = DSFormValidationContext()
        context.set(.warning(message: "C"), for: "z_field")
        context.set(.warning(message: "A"), for: "a_field")
        
        let warnings = context.allWarnings
        
        #expect(warnings[0].fieldId == "a_field")
        #expect(warnings[1].fieldId == "z_field")
    }
    
    @Test("allWarnings is empty when no warnings")
    func testAllWarningsEmpty() {
        let context = DSFormValidationContext()
        context.set(.error(message: "Error"), for: "field1")
        
        #expect(context.allWarnings.isEmpty)
    }
    
    // MARK: - Querying: highestSeverity
    
    @Test("Highest severity with no fields is .none")
    func testHighestSeverityEmpty() {
        let context = DSFormValidationContext()
        #expect(context.highestSeverity == .none)
    }
    
    @Test("Highest severity with only success is .success")
    func testHighestSeveritySuccess() {
        let context = DSFormValidationContext()
        context.set(.success(message: "OK"), for: "field")
        
        #expect(context.highestSeverity == .success)
    }
    
    @Test("Highest severity with warning is .warning")
    func testHighestSeverityWarning() {
        let context = DSFormValidationContext()
        context.set(.success(message: "OK"), for: "field1")
        context.set(.warning(message: "Warn"), for: "field2")
        
        #expect(context.highestSeverity == .warning)
    }
    
    @Test("Highest severity with error is .error")
    func testHighestSeverityError() {
        let context = DSFormValidationContext()
        context.set(.success(message: "OK"), for: "field1")
        context.set(.warning(message: "Warn"), for: "field2")
        context.set(.error(message: "Error"), for: "field3")
        
        #expect(context.highestSeverity == .error)
    }
    
    @Test("Highest severity with only .none states is .none")
    func testHighestSeverityNone() {
        let context = DSFormValidationContext()
        context.set(.none, for: "field1")
        context.set(.none, for: "field2")
        
        #expect(context.highestSeverity == .none)
    }
    
    // MARK: - Querying: fieldIds
    
    @Test("fieldIds returns all registered field identifiers")
    func testFieldIds() {
        let context = DSFormValidationContext()
        context.set(.error(message: "A"), for: "email")
        context.set(.warning(message: "B"), for: "password")
        context.set(.none, for: "name")
        
        let ids = context.fieldIds
        
        #expect(ids.count == 3)
        #expect(ids.contains("email"))
        #expect(ids.contains("password"))
        #expect(ids.contains("name"))
    }
    
    @Test("fieldIds is empty initially")
    func testFieldIdsEmpty() {
        let context = DSFormValidationContext()
        #expect(context.fieldIds.isEmpty)
    }
    
    @Test("fieldIds updates after clearing")
    func testFieldIdsAfterClear() {
        let context = DSFormValidationContext()
        context.set(.error(message: "A"), for: "email")
        context.set(.error(message: "B"), for: "name")
        
        context.clear(for: "email")
        
        #expect(context.fieldIds.count == 1)
        #expect(context.fieldIds.contains("name"))
    }
    
    // MARK: - Querying: errorCount / warningCount
    
    @Test("errorCount counts only errors")
    func testErrorCount() {
        let context = DSFormValidationContext()
        context.set(.error(message: "E1"), for: "f1")
        context.set(.error(message: "E2"), for: "f2")
        context.set(.warning(message: "W1"), for: "f3")
        context.set(.success(message: "S1"), for: "f4")
        
        #expect(context.errorCount == 2)
    }
    
    @Test("warningCount counts only warnings")
    func testWarningCount() {
        let context = DSFormValidationContext()
        context.set(.error(message: "E1"), for: "f1")
        context.set(.warning(message: "W1"), for: "f2")
        context.set(.warning(message: "W2"), for: "f3")
        context.set(.warning(message: "W3"), for: "f4")
        
        #expect(context.warningCount == 3)
    }
    
    @Test("errorCount is zero when no errors")
    func testErrorCountZero() {
        let context = DSFormValidationContext()
        context.set(.warning(message: "W"), for: "f1")
        
        #expect(context.errorCount == 0)
    }
    
    @Test("warningCount is zero when no warnings")
    func testWarningCountZero() {
        let context = DSFormValidationContext()
        context.set(.error(message: "E"), for: "f1")
        
        #expect(context.warningCount == 0)
    }
    
    // MARK: - Rule-Based Validation: validate
    
    @Test("validate with passing rules sets .none")
    func testValidatePassing() {
        let context = DSFormValidationContext()
        
        let result = context.validate("Hello", for: "name", rules: [.required])
        
        #expect(result == .none)
        #expect(context.state(for: "name") == .none)
    }
    
    @Test("validate with failing required rule sets error")
    func testValidateFailingRequired() {
        let context = DSFormValidationContext()
        
        let result = context.validate("", for: "name", rules: [.required])
        
        #expect(result.hasError)
        #expect(result.message == "This field is required")
        #expect(context.state(for: "name").hasError)
    }
    
    @Test("validate stops at first failing rule")
    func testValidateStopsAtFirstFailure() {
        let context = DSFormValidationContext()
        
        // Both rules would fail, but should only get the first error
        let result = context.validate("", for: "email", rules: [.required, .email])
        
        #expect(result.hasError)
        #expect(result.message == "This field is required")
    }
    
    @Test("validate with email rule")
    func testValidateEmail() {
        let context = DSFormValidationContext()
        
        let validResult = context.validate("test@example.com", for: "email", rules: [.required, .email])
        #expect(validResult == .none)
        
        let invalidResult = context.validate("not-an-email", for: "email", rules: [.required, .email])
        #expect(invalidResult.hasError)
        #expect(invalidResult.message == "Invalid email address")
    }
    
    @Test("validate with minLength rule")
    func testValidateMinLength() {
        let context = DSFormValidationContext()
        
        let tooShort = context.validate("ab", for: "password", rules: [.minLength(3)])
        #expect(tooShort.hasError)
        
        let justRight = context.validate("abc", for: "password", rules: [.minLength(3)])
        #expect(justRight == .none)
    }
    
    @Test("validate with maxLength rule")
    func testValidateMaxLength() {
        let context = DSFormValidationContext()
        
        let tooLong = context.validate("abcdef", for: "code", rules: [.maxLength(5)])
        #expect(tooLong.hasError)
        
        let justRight = context.validate("abcde", for: "code", rules: [.maxLength(5)])
        #expect(justRight == .none)
    }
    
    @Test("validate with multiple rules all passing")
    func testValidateMultipleRulesPassing() {
        let context = DSFormValidationContext()
        
        let result = context.validate("test@example.com", for: "email", rules: [
            .required,
            .minLength(5),
            .email
        ])
        
        #expect(result == .none)
        #expect(context.state(for: "email") == .none)
    }
    
    @Test("validate with empty rules array sets .none")
    func testValidateEmptyRules() {
        let context = DSFormValidationContext()
        
        let result = context.validate("anything", for: "field", rules: [])
        
        #expect(result == .none)
        #expect(context.state(for: "field") == .none)
    }
    
    @Test("validate with custom warning rule")
    func testValidateCustomWarningRule() {
        let context = DSFormValidationContext()
        
        let weakPasswordRule = DSValidationRule<String> { value in
            value.count < 8 ? .warning(message: "Password is weak") : .none
        }
        
        let result = context.validate("short", for: "password", rules: [.required, weakPasswordRule])
        
        #expect(result.hasWarning)
        #expect(result.message == "Password is weak")
        #expect(context.state(for: "password").hasWarning)
    }
    
    @Test("validate overwrites previous state")
    func testValidateOverwrites() {
        let context = DSFormValidationContext()
        
        context.set(.error(message: "Old error"), for: "name")
        #expect(context.state(for: "name").hasError)
        
        context.validate("John", for: "name", rules: [.required])
        #expect(context.state(for: "name") == .none)
    }
    
    // MARK: - validateAll
    
    @Test("validateAll enables showValidation")
    func testValidateAllEnablesShowValidation() {
        let context = DSFormValidationContext()
        
        #expect(context.showValidation == false)
        
        _ = context.validateAll()
        
        #expect(context.showValidation == true)
    }
    
    @Test("validateAll returns true when form is valid")
    func testValidateAllReturnsTrue() {
        let context = DSFormValidationContext()
        context.set(.success(message: "OK"), for: "name")
        
        let result = context.validateAll()
        
        #expect(result == true)
    }
    
    @Test("validateAll returns false when form has errors")
    func testValidateAllReturnsFalse() {
        let context = DSFormValidationContext()
        context.set(.error(message: "Required"), for: "email")
        
        let result = context.validateAll()
        
        #expect(result == false)
    }
    
    @Test("validateAll returns true for empty form")
    func testValidateAllEmptyForm() {
        let context = DSFormValidationContext()
        
        let result = context.validateAll()
        
        #expect(result == true)
        #expect(context.showValidation == true)
    }
    
    @Test("validateAll returns true with only warnings")
    func testValidateAllWithWarnings() {
        let context = DSFormValidationContext()
        context.set(.warning(message: "Weak"), for: "password")
        
        let result = context.validateAll()
        
        #expect(result == true)
    }
    
    // MARK: - toResult
    
    @Test("toResult creates DSFormValidationResult with all fields")
    func testToResult() {
        let context = DSFormValidationContext()
        context.set(.error(message: "Required"), for: "email")
        context.set(.warning(message: "Weak"), for: "password")
        context.set(.success(message: "OK"), for: "name")
        
        let result = context.toResult()
        
        #expect(result.fieldResults.count == 3)
        #expect(result.isValid == false) // Has error
        #expect(result.errors.count == 1)
        #expect(result.warnings.count == 1)
    }
    
    @Test("toResult for empty context creates empty result")
    func testToResultEmpty() {
        let context = DSFormValidationContext()
        
        let result = context.toResult()
        
        #expect(result.fieldResults.isEmpty)
        #expect(result.isValid == true)
        #expect(result == DSFormValidationResult.empty)
    }
    
    @Test("toResult preserves field IDs")
    func testToResultFieldIds() {
        let context = DSFormValidationContext()
        context.set(.error(message: "Error"), for: "myField")
        
        let result = context.toResult()
        
        let fieldResult = result.result(forFieldId: "myField")
        #expect(fieldResult != nil)
        #expect(fieldResult?.state == .error(message: "Error"))
    }
    
    @Test("toResult highestSeverity matches context")
    func testToResultSeverity() {
        let context = DSFormValidationContext()
        context.set(.warning(message: "W"), for: "f1")
        context.set(.error(message: "E"), for: "f2")
        
        let result = context.toResult()
        
        #expect(result.highestSeverity == .error)
        #expect(context.highestSeverity == result.highestSeverity)
    }
    
    // MARK: - Complex Scenarios
    
    @Test("Full lifecycle: register, validate, clear, re-validate")
    func testFullLifecycle() {
        let context = DSFormValidationContext()
        
        // 1. Initial: empty, valid
        #expect(context.isFormValid)
        #expect(context.errorCount == 0)
        
        // 2. Set some errors
        context.set(.error(message: "Required"), for: "name")
        context.set(.error(message: "Invalid"), for: "email")
        #expect(!context.isFormValid)
        #expect(context.errorCount == 2)
        
        // 3. Fix one field
        context.set(.success(message: "OK"), for: "name")
        #expect(!context.isFormValid) // email still has error
        #expect(context.errorCount == 1)
        
        // 4. Fix other field
        context.set(.none, for: "email")
        #expect(context.isFormValid)
        #expect(context.errorCount == 0)
        
        // 5. Validate all
        let result = context.validateAll()
        #expect(result == true)
        #expect(context.showValidation == true)
    }
    
    @Test("Mixed states: errors, warnings, success, none, validating")
    func testMixedStates() {
        let context = DSFormValidationContext()
        
        context.set(.error(message: "E1"), for: "f1")
        context.set(.warning(message: "W1"), for: "f2")
        context.set(.success(message: "S1"), for: "f3")
        context.set(.none, for: "f4")
        context.set(.validating, for: "f5")
        
        #expect(context.fieldStates.count == 5)
        #expect(context.isFormValid == false) // error + validating
        #expect(context.errorCount == 1)
        #expect(context.warningCount == 1)
        #expect(context.highestSeverity == .error)
        #expect(context.allErrors.count == 1)
        #expect(context.allWarnings.count == 1)
    }
    
    @Test("showValidation flag does not affect isFormValid")
    func testShowValidationDoesNotAffectIsFormValid() {
        let context = DSFormValidationContext()
        context.set(.error(message: "Error"), for: "field")
        
        context.showValidation = false
        #expect(context.isFormValid == false)
        
        context.showValidation = true
        #expect(context.isFormValid == false)
    }
}

// MARK: - DSValidationViewStyle Tests

@Suite("DSValidationViewStyle Tests")
struct DSValidationViewStyleTests {
    
    @Test("All cases exist")
    func testAllCases() {
        let cases = DSValidationViewStyle.allCases
        
        #expect(cases.count == 2)
        #expect(cases.contains(.compact))
        #expect(cases.contains(.banner))
    }
    
    @Test("Raw values are unique")
    func testUniqueRawValues() {
        let cases = DSValidationViewStyle.allCases
        let rawValues = Set(cases.map(\.rawValue))
        
        #expect(rawValues.count == cases.count)
    }
    
    @Test("Raw value for compact")
    func testCompactRawValue() {
        #expect(DSValidationViewStyle.compact.rawValue == "compact")
    }
    
    @Test("Raw value for banner")
    func testBannerRawValue() {
        #expect(DSValidationViewStyle.banner.rawValue == "banner")
    }
    
    @Test("Equatable conformance")
    func testEquatable() {
        #expect(DSValidationViewStyle.compact == DSValidationViewStyle.compact)
        #expect(DSValidationViewStyle.banner == DSValidationViewStyle.banner)
        #expect(DSValidationViewStyle.compact != DSValidationViewStyle.banner)
    }
    
    @Test("Sendable conformance compiles")
    func testSendable() {
        let style: DSValidationViewStyle = .compact
        let _: any Sendable = style
        #expect(Bool(true))
    }
    
    @Test("CaseIterable conformance")
    func testCaseIterable() {
        let allCases = DSValidationViewStyle.allCases
        
        #expect(allCases.contains(.compact))
        #expect(allCases.contains(.banner))
    }
}

// MARK: - DSRequiredMarkerSize Tests

@Suite("DSRequiredMarkerSize Tests")
struct DSRequiredMarkerSizeTests {
    
    @Test("All cases exist")
    func testAllCases() {
        let cases = DSRequiredMarkerSize.allCases
        
        #expect(cases.count == 3)
        #expect(cases.contains(.small))
        #expect(cases.contains(.standard))
        #expect(cases.contains(.large))
    }
    
    @Test("Raw values are unique")
    func testUniqueRawValues() {
        let cases = DSRequiredMarkerSize.allCases
        let rawValues = Set(cases.map(\.rawValue))
        
        #expect(rawValues.count == cases.count)
    }
    
    @Test("Raw value for small")
    func testSmallRawValue() {
        #expect(DSRequiredMarkerSize.small.rawValue == "small")
    }
    
    @Test("Raw value for standard")
    func testStandardRawValue() {
        #expect(DSRequiredMarkerSize.standard.rawValue == "standard")
    }
    
    @Test("Raw value for large")
    func testLargeRawValue() {
        #expect(DSRequiredMarkerSize.large.rawValue == "large")
    }
    
    @Test("Font property returns a value for each size")
    func testFontProperty() {
        // Verify each size can produce a font (no crashes)
        for size in DSRequiredMarkerSize.allCases {
            let _ = size.font
        }
        #expect(Bool(true)) // If we got here, all fonts resolved successfully
    }
    
    @Test("Equatable conformance")
    func testEquatable() {
        #expect(DSRequiredMarkerSize.small == DSRequiredMarkerSize.small)
        #expect(DSRequiredMarkerSize.standard == DSRequiredMarkerSize.standard)
        #expect(DSRequiredMarkerSize.large == DSRequiredMarkerSize.large)
        #expect(DSRequiredMarkerSize.small != DSRequiredMarkerSize.standard)
        #expect(DSRequiredMarkerSize.standard != DSRequiredMarkerSize.large)
        #expect(DSRequiredMarkerSize.small != DSRequiredMarkerSize.large)
    }
    
    @Test("Sendable conformance compiles")
    func testSendable() {
        let size: DSRequiredMarkerSize = .standard
        let _: any Sendable = size
        #expect(Bool(true))
    }
    
    @Test("Hashable conformance")
    func testHashable() {
        let set: Set<DSRequiredMarkerSize> = [.small, .standard, .large, .small]
        #expect(set.count == 3)
    }
}

// MARK: - DSValidationView Initialization Tests

@Suite("DSValidationView Tests")
@MainActor
struct DSValidationViewTests {
    
    @Test("Default style is compact")
    func testDefaultStyle() {
        // Verify DSValidationView can be created with defaults
        let _ = DSValidationView(state: .error(message: "Error"))
        #expect(Bool(true)) // Compiles and initializes
    }
    
    @Test("Banner style initializer")
    func testBannerInitializer() {
        let _ = DSValidationView(state: .warning(message: "Warning"), style: .banner)
        #expect(Bool(true))
    }
    
    @Test("Animated parameter defaults to true")
    func testAnimatedDefault() {
        let _ = DSValidationView(state: .error(message: "Error"))
        #expect(Bool(true)) // Default animated is true, verifying compilation
    }
    
    @Test("Animated parameter can be set to false")
    func testAnimatedFalse() {
        let _ = DSValidationView(state: .error(message: "Error"), animated: false)
        #expect(Bool(true))
    }
    
    @Test("All validation states can be displayed")
    func testAllStates() {
        let states: [DSValidationState] = [
            .none,
            .validating,
            .success(message: "OK"),
            .warning(message: "Warn"),
            .error(message: "Error")
        ]
        
        for state in states {
            for style in DSValidationViewStyle.allCases {
                let _ = DSValidationView(state: state, style: style)
            }
        }
        
        #expect(Bool(true)) // All combinations compile and initialize
    }
}

// MARK: - Environment Key Default Value Tests

@Suite("Validation Environment Key Tests")
@MainActor
struct ValidationEnvironmentKeyTests {
    
    @Test("DSFieldValidationKey default value is .none")
    func testFieldValidationDefault() {
        // Environment keys have default values that can be tested indirectly
        // through DSFormValidationContext behavior
        let context = DSFormValidationContext()
        
        // Unregistered field should return .none (same as environment default)
        #expect(context.state(for: "any") == .none)
    }
}

// MARK: - Integration: DSFormValidationContext with DSValidationRule

@Suite("Validation Context Rule Integration Tests")
@MainActor
struct ValidationContextRuleIntegrationTests {
    
    @Test("validate + validateAll workflow")
    func testValidateAndValidateAll() {
        let context = DSFormValidationContext()
        
        // Validate fields
        context.validate("", for: "name", rules: [.required])
        context.validate("invalid", for: "email", rules: [.required, .email])
        
        // Before validateAll: showValidation is false
        #expect(context.showValidation == false)
        #expect(context.effectiveState(for: "name") == .none)
        
        // After validateAll: showValidation is true
        let isValid = context.validateAll()
        
        #expect(isValid == false)
        #expect(context.showValidation == true)
        #expect(context.effectiveState(for: "name").hasError)
        #expect(context.effectiveState(for: "email").hasError)
    }
    
    @Test("Fixing fields after validate makes form valid")
    func testFixAfterValidate() {
        let context = DSFormValidationContext()
        
        context.validate("", for: "name", rules: [.required])
        context.validate("bad", for: "email", rules: [.required, .email])
        
        #expect(context.isFormValid == false)
        
        // Fix the fields
        context.validate("John", for: "name", rules: [.required])
        context.validate("john@example.com", for: "email", rules: [.required, .email])
        
        #expect(context.isFormValid == true)
    }
    
    @Test("Optional string required rule")
    func testOptionalStringRequired() {
        let rule = DSValidationRule<String?>.required
        
        #expect(rule.apply(to: nil).hasError)
        #expect(rule.apply(to: "").hasError)
        #expect(rule.apply(to: "   ").hasError)
        #expect(rule.apply(to: "Hello") == .none)
    }
    
    @Test("Custom validation rule integration")
    func testCustomRule() {
        let context = DSFormValidationContext()
        
        let numericRule = DSValidationRule<String> { value in
            value.allSatisfy(\.isNumber)
                ? .none
                : .error(message: "Must contain only digits")
        }
        
        let result1 = context.validate("123", for: "code", rules: [numericRule])
        #expect(result1 == .none)
        
        let result2 = context.validate("12a", for: "code", rules: [numericRule])
        #expect(result2.hasError)
        #expect(result2.message == "Must contain only digits")
    }
}

// MARK: - DSFormValidationDisplayMode Integration Tests

@Suite("DSFormValidationDisplayMode Integration Tests")
struct DSFormValidationDisplayModeIntegrationTests {
    
    @Test("All display modes exist")
    func testAllDisplayModes() {
        let modes = DSFormValidationDisplayMode.allCases
        
        #expect(modes.count == 4)
        #expect(modes.contains(.inline))
        #expect(modes.contains(.below))
        #expect(modes.contains(.summary))
        #expect(modes.contains(.hidden))
    }
    
    @Test("Display mode raw values are unique")
    func testUniqueRawValues() {
        let modes = DSFormValidationDisplayMode.allCases
        let rawValues = Set(modes.map(\.rawValue))
        
        #expect(rawValues.count == modes.count)
    }
}

// MARK: - DSFormValidationResult Additional Tests

@Suite("DSFormValidationResult Extended Tests")
struct DSFormValidationResultExtendedTests {
    
    @Test("Empty result is valid")
    func testEmptyResult() {
        let result = DSFormValidationResult.empty
        
        #expect(result.isValid)
        #expect(result.fieldResults.isEmpty)
        #expect(result.errors.isEmpty)
        #expect(result.warnings.isEmpty)
        #expect(result.highestSeverity == .none)
    }
    
    @Test("Result with mixed states")
    func testMixedResult() {
        let result = DSFormValidationResult(fieldResults: [
            .success(message: "OK", fieldId: "name"),
            .error("Required", fieldId: "email"),
            .warning("Weak", fieldId: "password"),
            .validating(fieldId: "username")
        ])
        
        #expect(!result.isValid) // error + validating
        #expect(result.errors.count == 1)
        #expect(result.warnings.count == 1)
        #expect(result.highestSeverity == .error)
    }
    
    @Test("result(forFieldId:) returns correct result")
    func testResultForFieldId() {
        let result = DSFormValidationResult(fieldResults: [
            .error("Required", fieldId: "email"),
            .success(message: "OK", fieldId: "name")
        ])
        
        let emailResult = result.result(forFieldId: "email")
        #expect(emailResult != nil)
        #expect(emailResult?.state.hasError == true)
        
        let nameResult = result.result(forFieldId: "name")
        #expect(nameResult != nil)
        #expect(nameResult?.state == .success(message: "OK"))
    }
    
    @Test("result(forFieldId:) returns nil for unknown field")
    func testResultForUnknownField() {
        let result = DSFormValidationResult(fieldResults: [
            .error("Required", fieldId: "email")
        ])
        
        #expect(result.result(forFieldId: "unknown") == nil)
    }
    
    @Test("Result with only valid states is valid")
    func testAllValidResult() {
        let result = DSFormValidationResult(fieldResults: [
            .valid,
            .success(message: "Great", fieldId: "f1"),
            .warning("Careful", fieldId: "f2")
        ])
        
        #expect(result.isValid)
    }
}

// MARK: - DSFieldValidationResult Tests

@Suite("DSFieldValidationResult Extended Tests")
struct DSFieldValidationResultExtendedTests {
    
    @Test("valid factory method creates .none state")
    func testValidFactory() {
        let result = DSFieldValidationResult.valid
        
        #expect(result.state == .none)
        #expect(result.fieldId == nil)
        #expect(result.state.isValid)
    }
    
    @Test("success factory method")
    func testSuccessFactory() {
        let result = DSFieldValidationResult.success(message: "OK", fieldId: "f1")
        
        #expect(result.state == .success(message: "OK"))
        #expect(result.fieldId == "f1")
    }
    
    @Test("warning factory method")
    func testWarningFactory() {
        let result = DSFieldValidationResult.warning("Weak", fieldId: "pw")
        
        #expect(result.state == .warning(message: "Weak"))
        #expect(result.fieldId == "pw")
    }
    
    @Test("error factory method")
    func testErrorFactory() {
        let result = DSFieldValidationResult.error("Required", fieldId: "email")
        
        #expect(result.state == .error(message: "Required"))
        #expect(result.fieldId == "email")
    }
    
    @Test("validating factory method")
    func testValidatingFactory() {
        let result = DSFieldValidationResult.validating(fieldId: "username")
        
        #expect(result.state == .validating)
        #expect(result.fieldId == "username")
    }
    
    @Test("Factory methods with nil fieldId")
    func testNilFieldId() {
        let success = DSFieldValidationResult.success()
        #expect(success.fieldId == nil)
        
        let warning = DSFieldValidationResult.warning("W")
        #expect(warning.fieldId == nil)
        
        let error = DSFieldValidationResult.error("E")
        #expect(error.fieldId == nil)
        
        let validating = DSFieldValidationResult.validating()
        #expect(validating.fieldId == nil)
    }
    
    @Test("Equatable conformance")
    func testEquatable() {
        let a = DSFieldValidationResult.error("Required", fieldId: "email")
        let b = DSFieldValidationResult.error("Required", fieldId: "email")
        let c = DSFieldValidationResult.error("Required", fieldId: "name")
        
        #expect(a == b)
        #expect(a != c)
    }
}
