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

// MARK: - DSCapabilities Tests

@Suite("DSCapabilities Tests")
struct DSCapabilitiesTests {
    
    @Test("Platform default capabilities exist")
    func testPlatformDefaultExists() {
        let caps = DSCapabilities.platformDefault
        // Should have valid enum values
        #expect(DSFormRowLayout.allCases.contains(caps.preferredFormRowLayout))
        #expect(DSPickerPresentation.allCases.contains(caps.preferredPickerPresentation))
        #expect(DSTextFieldMode.allCases.contains(caps.preferredTextFieldMode))
    }
    
    @Test("iOS capabilities defaults")
    func testIOSCapabilities() {
        let caps = DSCapabilities.iOS()
        
        // Interaction
        #expect(caps.supportsHover == false)
        #expect(caps.supportsFocusRing == false)
        
        // Input
        #expect(caps.supportsInlineTextEditing == true)
        #expect(caps.supportsInlinePickers == true)
        #expect(caps.supportsToasts == true)
        
        // Layout
        #expect(caps.prefersLargeTapTargets == true)
        #expect(caps.preferredFormRowLayout == .inline)
        #expect(caps.preferredPickerPresentation == .sheet)
        #expect(caps.preferredTextFieldMode == .inline)
    }
    
    @Test("iOS with pointer capabilities")
    func testIOSWithPointerCapabilities() {
        let caps = DSCapabilities.iOSWithPointer()
        
        // Should enable hover and focus ring
        #expect(caps.supportsHover == true)
        #expect(caps.supportsFocusRing == true)
        
        // Other properties same as iOS
        #expect(caps.supportsInlineTextEditing == true)
        #expect(caps.prefersLargeTapTargets == true)
        #expect(caps.preferredFormRowLayout == .inline)
    }
    
    @Test("macOS capabilities defaults")
    func testMacOSCapabilities() {
        let caps = DSCapabilities.macOS()
        
        // Interaction
        #expect(caps.supportsHover == true)
        #expect(caps.supportsFocusRing == true)
        
        // Input
        #expect(caps.supportsInlineTextEditing == true)
        #expect(caps.supportsInlinePickers == true)
        #expect(caps.supportsToasts == true)
        
        // Layout
        #expect(caps.prefersLargeTapTargets == false)
        #expect(caps.preferredFormRowLayout == .twoColumn)
        #expect(caps.preferredPickerPresentation == .menu)
        #expect(caps.preferredTextFieldMode == .inline)
    }
    
    @Test("watchOS capabilities defaults")
    func testWatchOSCapabilities() {
        let caps = DSCapabilities.watchOS()
        
        // Interaction
        #expect(caps.supportsHover == false)
        #expect(caps.supportsFocusRing == false)
        
        // Input
        #expect(caps.supportsInlineTextEditing == false)
        #expect(caps.supportsInlinePickers == false)
        #expect(caps.supportsToasts == false)
        
        // Layout
        #expect(caps.prefersLargeTapTargets == true)
        #expect(caps.preferredFormRowLayout == .stacked)
        #expect(caps.preferredPickerPresentation == .navigation)
        #expect(caps.preferredTextFieldMode == .separateScreen)
    }
    
    @Test("Capabilities for platform factory method")
    func testCapabilitiesForPlatform() {
        let iosCaps = DSCapabilities.for(platform: .iOS)
        let macCaps = DSCapabilities.for(platform: .macOS)
        let watchCaps = DSCapabilities.for(platform: .watchOS)
        
        // Should match direct factory methods
        #expect(iosCaps == DSCapabilities.iOS())
        #expect(macCaps == DSCapabilities.macOS())
        #expect(watchCaps == DSCapabilities.watchOS())
    }
    
    @Test("Capabilities equality")
    func testCapabilitiesEquality() {
        let caps1 = DSCapabilities.iOS()
        let caps2 = DSCapabilities.iOS()
        let caps3 = DSCapabilities.macOS()
        
        #expect(caps1 == caps2)
        #expect(caps1 != caps3)
    }
    
    @Test("Capabilities hashable")
    func testCapabilitiesHashable() {
        let caps1 = DSCapabilities.iOS()
        let caps2 = DSCapabilities.iOS()
        let caps3 = DSCapabilities.macOS()
        
        var set = Set<DSCapabilities>()
        set.insert(caps1)
        set.insert(caps2)
        set.insert(caps3)
        
        // Should have 2 unique entries (iOS and macOS)
        #expect(set.count == 2)
    }
    
    @Test("Computed capability queries")
    func testComputedCapabilityQueries() {
        let macos = DSCapabilities.macOS()
        #expect(macos.supportsPointerInteraction == true)
        #expect(macos.requiresNavigationPatterns == false)
        #expect(macos.isCompactScreen == false)
        #expect(macos.minimumTapTargetSize == 24)
        
        let watch = DSCapabilities.watchOS()
        #expect(watch.supportsPointerInteraction == false)
        #expect(watch.requiresNavigationPatterns == true)
        #expect(watch.isCompactScreen == true)
        #expect(watch.minimumTapTargetSize == 44)
        
        let ios = DSCapabilities.iOS()
        #expect(ios.supportsPointerInteraction == false)
        #expect(ios.requiresNavigationPatterns == false)
        #expect(ios.isCompactScreen == false)
        #expect(ios.minimumTapTargetSize == 44)
    }
    
    @Test("Custom capabilities initialization")
    func testCustomCapabilitiesInit() {
        let custom = DSCapabilities(
            supportsHover: true,
            supportsFocusRing: false,
            supportsInlineTextEditing: true,
            supportsInlinePickers: false,
            supportsToasts: true,
            prefersLargeTapTargets: true,
            preferredFormRowLayout: .stacked,
            preferredPickerPresentation: .popover,
            preferredTextFieldMode: .inline
        )
        
        #expect(custom.supportsHover == true)
        #expect(custom.supportsFocusRing == false)
        #expect(custom.supportsInlinePickers == false)
        #expect(custom.preferredFormRowLayout == .stacked)
        #expect(custom.preferredPickerPresentation == .popover)
    }
    
    @Test("Capabilities description")
    func testCapabilitiesDescription() {
        let caps = DSCapabilities.iOS()
        let description = caps.description
        
        // Description should contain key property names
        #expect(description.contains("supportsHover"))
        #expect(description.contains("supportsFocusRing"))
        #expect(description.contains("preferredFormRowLayout"))
        #expect(description.contains("DSCapabilities"))
    }
}

// MARK: - Form Row Layout Tests

@Suite("DSFormRowLayout Tests")
struct DSFormRowLayoutTests {
    
    @Test("Form row layout cases exist")
    func testFormRowLayoutCases() {
        #expect(DSFormRowLayout.allCases.count == 3)
        #expect(DSFormRowLayout.allCases.contains(.stacked))
        #expect(DSFormRowLayout.allCases.contains(.inline))
        #expect(DSFormRowLayout.allCases.contains(.twoColumn))
    }
    
    @Test("Form row layout raw values")
    func testFormRowLayoutRawValues() {
        #expect(DSFormRowLayout.stacked.rawValue == "stacked")
        #expect(DSFormRowLayout.inline.rawValue == "inline")
        #expect(DSFormRowLayout.twoColumn.rawValue == "twoColumn")
    }
}

// MARK: - Picker Presentation Tests

@Suite("DSPickerPresentation Tests")
struct DSPickerPresentationTests {
    
    @Test("Picker presentation cases exist")
    func testPickerPresentationCases() {
        #expect(DSPickerPresentation.allCases.count == 4)
        #expect(DSPickerPresentation.allCases.contains(.sheet))
        #expect(DSPickerPresentation.allCases.contains(.popover))
        #expect(DSPickerPresentation.allCases.contains(.menu))
        #expect(DSPickerPresentation.allCases.contains(.navigation))
    }
    
    @Test("Picker presentation raw values")
    func testPickerPresentationRawValues() {
        #expect(DSPickerPresentation.sheet.rawValue == "sheet")
        #expect(DSPickerPresentation.popover.rawValue == "popover")
        #expect(DSPickerPresentation.menu.rawValue == "menu")
        #expect(DSPickerPresentation.navigation.rawValue == "navigation")
    }
}

// MARK: - Text Field Mode Tests

@Suite("DSTextFieldMode Tests")
struct DSTextFieldModeTests {
    
    @Test("Text field mode cases exist")
    func testTextFieldModeCases() {
        #expect(DSTextFieldMode.allCases.count == 2)
        #expect(DSTextFieldMode.allCases.contains(.inline))
        #expect(DSTextFieldMode.allCases.contains(.separateScreen))
    }
    
    @Test("Text field mode raw values")
    func testTextFieldModeRawValues() {
        #expect(DSTextFieldMode.inline.rawValue == "inline")
        #expect(DSTextFieldMode.separateScreen.rawValue == "separateScreen")
    }
}
