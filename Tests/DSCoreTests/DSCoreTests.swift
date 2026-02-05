// DSCoreTests.swift
// DesignSystem

import Foundation
import Testing
@testable import DSCore

@Suite("DSCore Tests")
struct DSCoreTests {
    
    @Test("Module version is defined")
    func testVersion() {
        #expect(DSCore.version == "0.1.0")
    }
}

// MARK: - Platform Tests

@Suite("DSPlatform Tests")
struct DSPlatformTests {
    
    @Test("Current platform is detected")
    func testCurrentPlatform() {
        let platform = DSPlatform.current
        #expect(DSPlatform.allCases.contains(platform))
        
        // Should be one of the known platforms in tests
        #expect(platform != .unknown)
    }
    
    @Test("Platform properties are consistent")
    func testPlatformProperties() {
        // Test iOS properties
        #expect(DSPlatform.iOS.isMobile == true)
        #expect(DSPlatform.iOS.isTouchPrimary == true)
        #expect(DSPlatform.iOS.isWearable == false)
        
        // Test macOS properties
        #expect(DSPlatform.macOS.isMobile == false)
        #expect(DSPlatform.macOS.supportsPointerInput == true)
        #expect(DSPlatform.macOS.supportsMultipleWindows == true)
        
        // Test watchOS properties
        #expect(DSPlatform.watchOS.isMobile == true)
        #expect(DSPlatform.watchOS.isWearable == true)
        #expect(DSPlatform.watchOS.isTouchPrimary == true)
    }
    
    @Test("Device form factor is detected")
    func testFormFactor() {
        let formFactor = DSDeviceFormFactor.current
        #expect(formFactor != .unknown)
    }
    
    @Test("Form factor compact property")
    func testFormFactorCompact() {
        #expect(DSDeviceFormFactor.phone.isCompact == true)
        #expect(DSDeviceFormFactor.watch.isCompact == true)
        #expect(DSDeviceFormFactor.tablet.isCompact == false)
        #expect(DSDeviceFormFactor.desktop.isCompact == false)
    }
}

// MARK: - Input Mode Tests

@Suite("DSInputMode Tests")
struct DSInputModeTests {
    
    @Test("Input mode hover support")
    func testHoverSupport() {
        #expect(DSInputMode.pointer.supportsHover == true)
        #expect(DSInputMode.touch.supportsHover == false)
        #expect(DSInputMode.keyboard.supportsHover == false)
    }
    
    @Test("Input mode tap target requirements")
    func testTapTargets() {
        #expect(DSInputMode.touch.requiresLargeTapTargets == true)
        #expect(DSInputMode.assistive.requiresLargeTapTargets == true)
        #expect(DSInputMode.pointer.requiresLargeTapTargets == false)
    }
    
    @Test("Input mode focus ring support")
    func testFocusRingSupport() {
        #expect(DSInputMode.keyboard.supportsFocusRing == true)
        #expect(DSInputMode.assistive.supportsFocusRing == true)
        #expect(DSInputMode.touch.supportsFocusRing == false)
    }
    
    @Test("Input context platform defaults")
    func testInputContextDefaults() {
        let context = DSInputContext.platformDefault
        
        // Context should be valid
        #expect(DSInputMode.allCases.contains(context.primaryMode))
    }
    
    @Test("Minimum tap target sizes")
    func testMinimumTapTargetSizes() {
        #expect(DSInputMode.touch.minimumTapTargetSize == 44.0)
        #expect(DSInputMode.assistive.minimumTapTargetSize == 48.0)
        #expect(DSInputMode.pointer.minimumTapTargetSize == 24.0)
    }
}

// MARK: - Accessibility Policy Tests

@Suite("DSAccessibilityPolicy Tests")
struct DSAccessibilityPolicyTests {
    
    @Test("Default policy values")
    func testDefaultPolicy() {
        let policy = DSAccessibilityPolicy.default
        
        #expect(policy.reduceMotion == false)
        #expect(policy.increasedContrast == false)
        #expect(policy.dynamicTypeSize == .large)
        #expect(policy.isVoiceOverRunning == false)
    }
    
    @Test("Assistive technology detection")
    func testAssistiveTechnology() {
        let withVoiceOver = DSAccessibilityPolicy(isVoiceOverRunning: true)
        #expect(withVoiceOver.isAssistiveTechnologyActive == true)
        
        let withSwitch = DSAccessibilityPolicy(isSwitchControlRunning: true)
        #expect(withSwitch.isAssistiveTechnologyActive == true)
        
        let neither = DSAccessibilityPolicy()
        #expect(neither.isAssistiveTechnologyActive == false)
    }
    
    @Test("Dynamic type size ordering")
    func testDynamicTypeSizeOrdering() {
        #expect(DSDynamicTypeSize.extraSmall < DSDynamicTypeSize.large)
        #expect(DSDynamicTypeSize.large < DSDynamicTypeSize.accessibilityMedium)
        #expect(DSDynamicTypeSize.accessibilityMedium < DSDynamicTypeSize.accessibilityExtraExtraExtraLarge)
    }
    
    @Test("Dynamic type scale factors")
    func testDynamicTypeScaleFactors() {
        #expect(DSDynamicTypeSize.large.scaleFactor == 1.0) // Default
        #expect(DSDynamicTypeSize.extraSmall.scaleFactor < 1.0)
        #expect(DSDynamicTypeSize.accessibilityLarge.scaleFactor > 1.0)
    }
    
    @Test("Accessibility sizes detection")
    func testAccessibilitySizes() {
        #expect(DSDynamicTypeSize.large.isAccessibilitySize == false)
        #expect(DSDynamicTypeSize.extraExtraExtraLarge.isAccessibilitySize == false)
        #expect(DSDynamicTypeSize.accessibilityMedium.isAccessibilitySize == true)
        #expect(DSDynamicTypeSize.accessibilityExtraExtraExtraLarge.isAccessibilitySize == true)
    }
    
    @Test("Font size adjustments")
    func testFontSizeAdjustments() {
        let baseSize: CGFloat = 17.0
        
        // Default size should return base
        let defaultAdjusted = DSAccessibilityAdjustments.adjustedFontSize(baseSize, for: .large)
        #expect(defaultAdjusted == baseSize)
        
        // Smaller size should reduce
        let smallAdjusted = DSAccessibilityAdjustments.adjustedFontSize(baseSize, for: .small)
        #expect(smallAdjusted < baseSize)
        
        // Larger size should increase
        let largeAdjusted = DSAccessibilityAdjustments.adjustedFontSize(baseSize, for: .accessibilityLarge)
        #expect(largeAdjusted > baseSize)
        
        // Test minimum constraint
        let withMin = DSAccessibilityAdjustments.adjustedFontSize(baseSize, for: .extraSmall, minimum: 15.0)
        #expect(withMin >= 15.0)
    }
}

// MARK: - Control State Tests

@Suite("DSControlState Tests")
struct DSControlStateTests {
    
    @Test("Control state combinations")
    func testStateCombinations() {
        let focusedHovered: DSControlState = [.focused, .hovered]
        
        #expect(focusedHovered.contains(.focused) == true)
        #expect(focusedHovered.contains(.hovered) == true)
        #expect(focusedHovered.contains(.pressed) == false)
    }
    
    @Test("Control state description")
    func testStateDescription() {
        #expect(DSControlState.normal.description == "normal")
        #expect(DSControlState.pressed.description.contains("pressed"))
        
        let combined: DSControlState = [.focused, .selected]
        #expect(combined.description.contains("focused"))
        #expect(combined.description.contains("selected"))
    }
    
    @Test("State transitions")
    func testStateTransitions() {
        let transition = DSControlStateTransition(
            from: .normal,
            to: .pressed,
            animated: true
        )
        
        #expect(transition.addedStates.contains(.pressed) == true)
        #expect(transition.removedStates == .normal)
        #expect(transition.changesPressed == true)
    }
    
    @Test("Interaction state allows interaction")
    func testInteractionStateAllowsInteraction() {
        #expect(DSInteractionState.normal.allowsInteraction == true)
        #expect(DSInteractionState.hovered.allowsInteraction == true)
        #expect(DSInteractionState.disabled.allowsInteraction == false)
        #expect(DSInteractionState.loading.allowsInteraction == false)
    }
    
    @Test("Selection state toggle")
    func testSelectionStateToggle() {
        var state = DSSelectionState.unselected
        
        state.toggle()
        #expect(state == .selected)
        
        state.toggle()
        #expect(state == .unselected)
        
        // Indeterminate should toggle to selected
        state = .indeterminate
        state.toggle()
        #expect(state == .selected)
    }
    
    @Test("Selection state toggled returns new value")
    func testSelectionStateToggledReturns() {
        let unselected = DSSelectionState.unselected
        #expect(unselected.toggled() == .selected)
        
        let selected = DSSelectionState.selected
        #expect(selected.toggled() == .unselected)
    }
}

// MARK: - Validation State Tests

@Suite("DSValidationState Tests")
struct DSValidationStateTests {
    
    @Test("Validation state validity")
    func testValidity() {
        #expect(DSValidationState.none.isValid == true)
        #expect(DSValidationState.success().isValid == true)
        #expect(DSValidationState.warning(message: "Warning").isValid == true)
        #expect(DSValidationState.error(message: "Error").isValid == false)
        #expect(DSValidationState.validating.isValid == false)
    }
    
    @Test("Validation state messages")
    func testMessages() {
        #expect(DSValidationState.none.message == nil)
        #expect(DSValidationState.success(message: "OK").message == "OK")
        #expect(DSValidationState.warning(message: "Warn").message == "Warn")
        #expect(DSValidationState.error(message: "Err").message == "Err")
    }
    
    @Test("Validation severity ordering")
    func testSeverityOrdering() {
        #expect(DSValidationSeverity.none < DSValidationSeverity.success)
        #expect(DSValidationSeverity.success < DSValidationSeverity.warning)
        #expect(DSValidationSeverity.warning < DSValidationSeverity.error)
    }
    
    @Test("Validation severity symbols")
    func testSeveritySymbols() {
        #expect(DSValidationSeverity.success.symbolName == "checkmark.circle.fill")
        #expect(DSValidationSeverity.warning.symbolName == "exclamationmark.triangle.fill")
        #expect(DSValidationSeverity.error.symbolName == "xmark.circle.fill")
    }
    
    @Test("Field validation result factory methods")
    func testFieldValidationResultFactories() {
        let valid = DSFieldValidationResult.valid
        #expect(valid.state == .none)
        
        let success = DSFieldValidationResult.success(message: "Great", fieldId: "field1")
        #expect(success.fieldId == "field1")
        
        let error = DSFieldValidationResult.error("Invalid", fieldId: "field2")
        #expect(error.state.hasError == true)
    }
    
    @Test("Form validation aggregation")
    func testFormValidation() {
        let results = [
            DSFieldValidationResult.valid,
            DSFieldValidationResult.warning("Check this"),
            DSFieldValidationResult.error("Required")
        ]
        
        let form = DSFormValidationResult(fieldResults: results)
        
        #expect(form.isValid == false)
        #expect(form.errors.count == 1)
        #expect(form.warnings.count == 1)
        #expect(form.highestSeverity == .error)
    }
    
    @Test("Validation rule - required string")
    func testRequiredStringRule() {
        let rule = DSValidationRule<String>.required
        
        #expect(rule.apply(to: "").hasError == true)
        #expect(rule.apply(to: "   ").hasError == true) // Whitespace only
        #expect(rule.apply(to: "Hello").hasError == false)
    }
    
    @Test("Validation rule - min/max length")
    func testLengthRules() {
        let minRule = DSValidationRule<String>.minLength(3)
        #expect(minRule.apply(to: "ab").hasError == true)
        #expect(minRule.apply(to: "abc").hasError == false)
        
        let maxRule = DSValidationRule<String>.maxLength(5)
        #expect(maxRule.apply(to: "abcdef").hasError == true)
        #expect(maxRule.apply(to: "abcde").hasError == false)
    }
    
    @Test("Validation rule - email")
    func testEmailRule() {
        let rule = DSValidationRule<String>.email
        
        #expect(rule.apply(to: "").hasError == false) // Empty is not checked by email rule
        #expect(rule.apply(to: "invalid").hasError == true)
        #expect(rule.apply(to: "test@example.com").hasError == false)
        #expect(rule.apply(to: "user.name@domain.co.uk").hasError == false)
    }
}

// MARK: - Density Tests

@Suite("DSDensity Tests")
struct DSDensityTests {
    
    @Test("Density multipliers")
    func testDensityMultipliers() {
        #expect(DSDensity.compact.spacingMultiplier < 1.0)
        #expect(DSDensity.regular.spacingMultiplier == 1.0)
        #expect(DSDensity.spacious.spacingMultiplier > 1.0)
    }
    
    @Test("Control height multipliers")
    func testControlHeightMultipliers() {
        #expect(DSDensity.compact.controlHeightMultiplier < 1.0)
        #expect(DSDensity.regular.controlHeightMultiplier == 1.0)
        #expect(DSDensity.spacious.controlHeightMultiplier > 1.0)
    }
}

// MARK: - Animation Context Tests

@Suite("DSAnimationContext Tests")
struct DSAnimationContextTests {
    
    @Test("Standard animation context")
    func testStandardContext() {
        let context = DSAnimationContext.standard
        #expect(context.animationsEnabled == true)
        #expect(context.defaultDuration > 0)
    }
    
    @Test("Reduced motion context")
    func testReducedMotionContext() {
        let context = DSAnimationContext.reducedMotion
        #expect(context.animationsEnabled == false)
        #expect(context.defaultDuration == 0)
    }
    
    @Test("Context from accessibility policy")
    func testContextFromPolicy() {
        let normalPolicy = DSAccessibilityPolicy()
        let normalContext = DSAnimationContext.from(accessibilityPolicy: normalPolicy)
        #expect(normalContext.animationsEnabled == true)
        
        let reducedMotionPolicy = DSAccessibilityPolicy(reduceMotion: true)
        let reducedContext = DSAnimationContext.from(accessibilityPolicy: reducedMotionPolicy)
        #expect(reducedContext.animationsEnabled == false)
    }
}
