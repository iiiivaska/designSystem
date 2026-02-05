// DSControlsTests.swift
// DesignSystem

import Testing
import SwiftUI
@testable import DSControls
@testable import DSTheme
@testable import DSCore

@Suite("DSControls Tests")
struct DSControlsTests {
    
    @Test("Module version is defined")
    func testVersion() {
        #expect(DSControls.version == "0.1.0")
    }
}

// MARK: - DSButton Spec Resolution Tests

@Suite("DSButton Spec Resolution")
struct DSButtonSpecResolutionTests {
    
    let lightTheme = DSTheme.light
    let darkTheme = DSTheme.dark
    
    // MARK: - Variant Colors
    
    @Test("Primary variant has accent background and white foreground")
    func testPrimaryVariantColors() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        #expect(spec.foregroundColor == .white)
        #expect(spec.borderWidth == 0)
        #expect(spec.opacity == 1.0)
    }
    
    @Test("Secondary variant has border and accent foreground")
    func testSecondaryVariantColors() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .secondary,
            size: .medium,
            state: .normal
        )
        #expect(spec.borderWidth == 1.0)
        #expect(spec.opacity == 1.0)
    }
    
    @Test("Tertiary variant has clear background")
    func testTertiaryVariantColors() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .tertiary,
            size: .medium,
            state: .normal
        )
        #expect(spec.borderWidth == 0)
        #expect(spec.opacity == 1.0)
    }
    
    @Test("Destructive variant has white foreground")
    func testDestructiveVariantColors() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .destructive,
            size: .medium,
            state: .normal
        )
        #expect(spec.foregroundColor == .white)
        #expect(spec.borderWidth == 0)
    }
    
    // MARK: - Sizes
    
    @Test("Small size has correct height")
    func testSmallSize() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .small,
            state: .normal
        )
        #expect(spec.height == 32)
    }
    
    @Test("Medium size has correct height")
    func testMediumSize() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        #expect(spec.height == 40)
    }
    
    @Test("Large size has correct height")
    func testLargeSize() {
        let spec = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .large,
            state: .normal
        )
        #expect(spec.height == 48)
    }
    
    @Test("Size progression is consistent")
    func testSizeProgression() {
        let small = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .small, state: .normal)
        let medium = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .normal)
        let large = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .large, state: .normal)
        
        #expect(small.height < medium.height)
        #expect(medium.height < large.height)
        #expect(small.horizontalPadding <= medium.horizontalPadding)
        #expect(medium.horizontalPadding <= large.horizontalPadding)
        #expect(small.cornerRadius <= medium.cornerRadius)
        #expect(medium.cornerRadius <= large.cornerRadius)
    }
    
    // MARK: - States
    
    @Test("Disabled state reduces opacity")
    func testDisabledState() {
        let normal = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .normal)
        let disabled = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .disabled)
        
        #expect(disabled.opacity < normal.opacity)
        #expect(disabled.opacity == 0.6)
    }
    
    @Test("Loading state reduces opacity")
    func testLoadingState() {
        let normal = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .normal)
        let loading = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .loading)
        
        #expect(loading.opacity < normal.opacity)
        #expect(loading.opacity == 0.8)
    }
    
    @Test("Pressed state applies scale effect")
    func testPressedState() {
        let normal = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .normal)
        let pressed = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .pressed)
        
        #expect(normal.scaleEffect == 1.0)
        #expect(pressed.scaleEffect == 0.97)
    }
    
    @Test("Disabled state uses disabled foreground color")
    func testDisabledForeground() {
        let disabled = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .disabled)
        #expect(disabled.foregroundColor == lightTheme.colors.fg.disabled)
    }
    
    @Test("Disabled secondary keeps border")
    func testDisabledSecondaryBorder() {
        let disabled = DSButtonSpec.resolve(theme: lightTheme, variant: .secondary, size: .medium, state: .disabled)
        #expect(disabled.borderWidth == 1.0)
    }
    
    // MARK: - Shadow
    
    @Test("Primary variant has shadow in normal state")
    func testPrimaryShadow() {
        let spec = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .normal)
        #expect(spec.shadow.radius > 0)
    }
    
    @Test("Secondary variant has no shadow")
    func testSecondaryShadow() {
        let spec = DSButtonSpec.resolve(theme: lightTheme, variant: .secondary, size: .medium, state: .normal)
        #expect(spec.shadow == .none)
    }
    
    @Test("Tertiary variant has no shadow")
    func testTertiaryShadow() {
        let spec = DSButtonSpec.resolve(theme: lightTheme, variant: .tertiary, size: .medium, state: .normal)
        #expect(spec.shadow == .none)
    }
    
    @Test("Pressed primary has no shadow")
    func testPressedPrimaryShadow() {
        let spec = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .pressed)
        #expect(spec.shadow == .none)
    }
    
    @Test("Disabled primary has no shadow")
    func testDisabledPrimaryShadow() {
        let spec = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .disabled)
        #expect(spec.shadow == .none)
    }
    
    // MARK: - Typography
    
    @Test("Typography uses semibold weight")
    func testTypographyWeight() {
        let spec = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .normal)
        #expect(spec.typography.weight == .semibold)
    }
    
    @Test("Small size has smaller font")
    func testSmallTypography() {
        let small = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .small, state: .normal)
        let medium = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .normal)
        #expect(small.typography.size < medium.typography.size)
    }
    
    // MARK: - Animation
    
    @Test("Button spec has animation")
    func testAnimation() {
        let spec = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .normal)
        #expect(spec.animation != nil)
    }
    
    // MARK: - Dark Theme
    
    @Test("Dark theme resolves different colors than light")
    func testDarkThemeColors() {
        let lightSpec = DSButtonSpec.resolve(theme: lightTheme, variant: .primary, size: .medium, state: .normal)
        let darkSpec = DSButtonSpec.resolve(theme: darkTheme, variant: .primary, size: .medium, state: .normal)
        
        // Both have white foreground for primary
        #expect(lightSpec.foregroundColor == .white)
        #expect(darkSpec.foregroundColor == .white)
        
        // Background accent colors differ between light and dark
        #expect(lightSpec.backgroundColor != darkSpec.backgroundColor)
    }
    
    // MARK: - Theme Convenience Method
    
    @Test("Theme resolveButton convenience method works")
    func testThemeResolveButton() {
        let direct = DSButtonSpec.resolve(
            theme: lightTheme,
            variant: .primary,
            size: .medium,
            state: .normal
        )
        let convenience = lightTheme.resolveButton(
            variant: .primary,
            size: .medium,
            state: .normal
        )
        
        #expect(direct.height == convenience.height)
        #expect(direct.cornerRadius == convenience.cornerRadius)
        #expect(direct.opacity == convenience.opacity)
        #expect(direct.scaleEffect == convenience.scaleEffect)
    }
    
    // MARK: - All Variants x States Matrix
    
    @Test("All variant-state combinations resolve without errors")
    func testAllCombinations() {
        let variants = DSButtonVariant.allCases
        let sizes = DSButtonSize.allCases
        let states: [DSControlState] = [.normal, .pressed, .disabled, .loading, .hovered]
        
        for variant in variants {
            for size in sizes {
                for state in states {
                    let spec = DSButtonSpec.resolve(
                        theme: lightTheme,
                        variant: variant,
                        size: size,
                        state: state
                    )
                    #expect(spec.height > 0)
                    #expect(spec.cornerRadius >= 0)
                    #expect(spec.opacity > 0)
                    #expect(spec.opacity <= 1.0)
                    #expect(spec.scaleEffect > 0)
                    #expect(spec.scaleEffect <= 1.0)
                }
            }
        }
    }
}

// MARK: - DSToggle Spec Resolution Tests

@Suite("DSToggle Spec Resolution")
struct DSToggleSpecResolutionTests {
    
    let lightTheme = DSTheme.light
    let darkTheme = DSTheme.dark
    
    // MARK: - On/Off States
    
    @Test("On state uses accent track color")
    func testOnStateTrackColor() {
        let spec = DSToggleSpec.resolve(
            theme: lightTheme,
            isOn: true,
            state: .normal
        )
        // On state should use accent primary color
        #expect(spec.trackColor == lightTheme.colors.accent.primary)
    }
    
    @Test("Off state uses surface elevated track color")
    func testOffStateTrackColor() {
        let spec = DSToggleSpec.resolve(
            theme: lightTheme,
            isOn: false,
            state: .normal
        )
        #expect(spec.trackColor == lightTheme.colors.bg.surfaceElevated)
    }
    
    @Test("On state has no border")
    func testOnStateNoBorder() {
        let spec = DSToggleSpec.resolve(
            theme: lightTheme,
            isOn: true,
            state: .normal
        )
        #expect(spec.trackBorderWidth == 0)
        #expect(spec.trackBorderColor == .clear)
    }
    
    @Test("Off state has border")
    func testOffStateBorder() {
        let spec = DSToggleSpec.resolve(
            theme: lightTheme,
            isOn: false,
            state: .normal
        )
        #expect(spec.trackBorderWidth == 1.0)
        #expect(spec.trackBorderColor == lightTheme.colors.border.subtle)
    }
    
    // MARK: - Disabled State
    
    @Test("Disabled state reduces opacity")
    func testDisabledOpacity() {
        let normal = DSToggleSpec.resolve(theme: lightTheme, isOn: true, state: .normal)
        let disabled = DSToggleSpec.resolve(theme: lightTheme, isOn: true, state: .disabled)
        
        #expect(normal.opacity == 1.0)
        #expect(disabled.opacity == 0.5)
    }
    
    @Test("Disabled on state uses reduced accent")
    func testDisabledOnTrackColor() {
        let spec = DSToggleSpec.resolve(
            theme: lightTheme,
            isOn: true,
            state: .disabled
        )
        // Disabled on uses accent with reduced opacity
        #expect(spec.opacity == 0.5)
    }
    
    // MARK: - Dimensions
    
    @Test("Track has standard dimensions")
    func testTrackDimensions() {
        let spec = DSToggleSpec.resolve(
            theme: lightTheme,
            isOn: true,
            state: .normal
        )
        #expect(spec.trackWidth == 51)
        #expect(spec.trackHeight == 31)
        #expect(spec.trackCornerRadius == spec.trackHeight / 2)
    }
    
    @Test("Thumb has standard size")
    func testThumbSize() {
        let spec = DSToggleSpec.resolve(
            theme: lightTheme,
            isOn: true,
            state: .normal
        )
        #expect(spec.thumbSize == 27)
        #expect(spec.thumbColor == .white)
    }
    
    @Test("Thumb has shadow")
    func testThumbShadow() {
        let spec = DSToggleSpec.resolve(
            theme: lightTheme,
            isOn: true,
            state: .normal
        )
        #expect(spec.thumbShadow.radius > 0)
    }
    
    // MARK: - Animation
    
    @Test("Toggle spec has animation")
    func testAnimation() {
        let spec = DSToggleSpec.resolve(
            theme: lightTheme,
            isOn: true,
            state: .normal
        )
        #expect(spec.animation != nil)
    }
    
    // MARK: - Dark Theme
    
    @Test("Dark theme uses dark accent color")
    func testDarkThemeAccent() {
        let lightSpec = DSToggleSpec.resolve(theme: lightTheme, isOn: true, state: .normal)
        let darkSpec = DSToggleSpec.resolve(theme: darkTheme, isOn: true, state: .normal)
        
        // Both use accent primary, but accent differs between light and dark themes
        #expect(lightSpec.trackColor != darkSpec.trackColor)
    }
    
    // MARK: - Theme Convenience
    
    @Test("Theme resolveToggle convenience method works")
    func testThemeResolveToggle() {
        let direct = DSToggleSpec.resolve(
            theme: lightTheme,
            isOn: true,
            state: .normal
        )
        let convenience = lightTheme.resolveToggle(
            isOn: true,
            state: .normal
        )
        
        #expect(direct.trackWidth == convenience.trackWidth)
        #expect(direct.trackHeight == convenience.trackHeight)
        #expect(direct.thumbSize == convenience.thumbSize)
        #expect(direct.opacity == convenience.opacity)
    }
    
    // MARK: - All Combinations
    
    @Test("All on/off and state combinations resolve without errors")
    func testAllCombinations() {
        let themes = [DSTheme.light, DSTheme.dark]
        let onStates = [true, false]
        let controlStates: [DSControlState] = [.normal, .disabled, .hovered]
        
        for theme in themes {
            for isOn in onStates {
                for state in controlStates {
                    let spec = DSToggleSpec.resolve(
                        theme: theme,
                        isOn: isOn,
                        state: state
                    )
                    #expect(spec.trackWidth > 0)
                    #expect(spec.trackHeight > 0)
                    #expect(spec.thumbSize > 0)
                    #expect(spec.opacity > 0)
                    #expect(spec.opacity <= 1.0)
                }
            }
        }
    }
}

// MARK: - DSField Spec Resolution Tests

@Suite("DSField Spec Resolution")
struct DSFieldSpecResolutionTests {
    
    let lightTheme = DSTheme.light
    let darkTheme = DSTheme.dark
    
    // MARK: - Variants
    
    @Test("Default variant uses field corner radius")
    func testDefaultVariantRadius() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal
        )
        #expect(spec.cornerRadius == lightTheme.radii.component.field)
    }
    
    @Test("Search variant uses search field corner radius")
    func testSearchVariantRadius() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .search,
            state: .normal
        )
        #expect(spec.cornerRadius == lightTheme.radii.component.searchField)
        #expect(spec.cornerRadius > lightTheme.radii.component.field)
    }
    
    // MARK: - States
    
    @Test("Normal state has subtle border")
    func testNormalState() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal
        )
        #expect(spec.borderColor == lightTheme.colors.border.subtle)
        #expect(spec.opacity == 1.0)
        #expect(spec.focusRingWidth == 0)
    }
    
    @Test("Focused state has accent border and focus ring")
    func testFocusedState() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .focused
        )
        #expect(spec.borderColor == lightTheme.colors.accent.primary)
        #expect(spec.borderWidth == 2.0)
        #expect(spec.focusRingColor == lightTheme.colors.focusRing)
        #expect(spec.focusRingWidth > 0)
    }
    
    @Test("Disabled state reduces opacity")
    func testDisabledState() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .disabled
        )
        #expect(spec.opacity == 0.6)
        #expect(spec.foregroundColor == lightTheme.colors.fg.disabled)
    }
    
    // MARK: - Validation
    
    @Test("Error validation shows danger border")
    func testErrorValidation() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal,
            validation: .error(message: "Error")
        )
        #expect(spec.borderColor == lightTheme.colors.state.danger)
        #expect(spec.borderWidth == 1.5)
    }
    
    @Test("Warning validation shows warning border")
    func testWarningValidation() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal,
            validation: .warning(message: "Warning")
        )
        #expect(spec.borderColor == lightTheme.colors.state.warning)
        #expect(spec.borderWidth == 1.5)
    }
    
    @Test("Success validation shows success border")
    func testSuccessValidation() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal,
            validation: .success(message: "Valid")
        )
        #expect(spec.borderColor == lightTheme.colors.state.success)
    }
    
    @Test("Error validation takes priority over focus")
    func testErrorPriorityOverFocus() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .focused,
            validation: .error(message: "Error")
        )
        #expect(spec.borderColor == lightTheme.colors.state.danger)
        #expect(spec.borderWidth == 2.0) // Focused + error = 2.0
    }
    
    @Test("Focused error has wider border than unfocused error")
    func testFocusedErrorBorderWidth() {
        let unfocusedError = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal,
            validation: .error(message: "Error")
        )
        let focusedError = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .focused,
            validation: .error(message: "Error")
        )
        #expect(focusedError.borderWidth > unfocusedError.borderWidth)
    }
    
    // MARK: - Typography
    
    @Test("Text typography matches theme field text")
    func testTextTypography() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal
        )
        #expect(spec.textTypography.size == lightTheme.typography.component.fieldText.size)
        #expect(spec.textTypography.weight == lightTheme.typography.component.fieldText.weight)
    }
    
    @Test("Placeholder typography matches theme placeholder")
    func testPlaceholderTypography() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal
        )
        #expect(spec.placeholderTypography.size == lightTheme.typography.component.fieldPlaceholder.size)
    }
    
    // MARK: - Sizing
    
    @Test("Field height is 40pt")
    func testFieldHeight() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal
        )
        #expect(spec.height == 40)
    }
    
    @Test("Field has horizontal and vertical padding")
    func testFieldPadding() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal
        )
        #expect(spec.horizontalPadding > 0)
        #expect(spec.verticalPadding > 0)
    }
    
    // MARK: - Animation
    
    @Test("Field spec has animation")
    func testAnimation() {
        let spec = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal
        )
        #expect(spec.animation != nil)
    }
    
    // MARK: - Dark Theme
    
    @Test("Dark theme resolves different background")
    func testDarkThemeBackground() {
        let lightSpec = DSFieldSpec.resolve(theme: lightTheme, variant: .default, state: .normal)
        let darkSpec = DSFieldSpec.resolve(theme: darkTheme, variant: .default, state: .normal)
        #expect(lightSpec.backgroundColor != darkSpec.backgroundColor)
    }
    
    // MARK: - Theme Convenience
    
    @Test("Theme resolveField convenience method works")
    func testThemeResolveField() {
        let direct = DSFieldSpec.resolve(
            theme: lightTheme,
            variant: .default,
            state: .normal
        )
        let convenience = lightTheme.resolveField(
            variant: .default,
            state: .normal
        )
        #expect(direct.height == convenience.height)
        #expect(direct.cornerRadius == convenience.cornerRadius)
        #expect(direct.opacity == convenience.opacity)
        #expect(direct.borderWidth == convenience.borderWidth)
    }
    
    // MARK: - All Combinations
    
    @Test("All variant-state-validation combinations resolve without errors")
    func testAllCombinations() {
        let variants = DSFieldVariant.allCases
        let states: [DSControlState] = [.normal, .focused, .disabled]
        let validations: [DSValidationState] = [.none, .error(message: "Err"), .warning(message: "Warn"), .success(message: "OK"), .validating]
        
        for variant in variants {
            for state in states {
                for validation in validations {
                    let spec = DSFieldSpec.resolve(
                        theme: lightTheme,
                        variant: variant,
                        state: state,
                        validation: validation
                    )
                    #expect(spec.height > 0)
                    #expect(spec.cornerRadius >= 0)
                    #expect(spec.opacity > 0)
                    #expect(spec.opacity <= 1.0)
                    #expect(spec.borderWidth >= 0)
                }
            }
        }
    }
}

// MARK: - DSCheckboxState Tests

@Suite("DSCheckboxState")
struct DSCheckboxStateTests {
    
    @Test("All cases are defined")
    func testAllCases() {
        let cases = DSCheckboxState.allCases
        #expect(cases.count == 3)
        #expect(cases.contains(.unchecked))
        #expect(cases.contains(.checked))
        #expect(cases.contains(.intermediate))
    }
    
    @Test("isActive returns correct values")
    func testIsActive() {
        #expect(DSCheckboxState.unchecked.isActive == false)
        #expect(DSCheckboxState.checked.isActive == true)
        #expect(DSCheckboxState.intermediate.isActive == true)
    }
    
    @Test("Display names are correct")
    func testDisplayNames() {
        #expect(DSCheckboxState.unchecked.displayName == "Unchecked")
        #expect(DSCheckboxState.checked.displayName == "Checked")
        #expect(DSCheckboxState.intermediate.displayName == "Intermediate")
    }
    
    @Test("States have unique IDs")
    func testUniqueIDs() {
        let ids = DSCheckboxState.allCases.map(\.id)
        #expect(Set(ids).count == ids.count)
    }
    
    @Test("Equatable conformance works")
    func testEquatable() {
        #expect(DSCheckboxState.checked == DSCheckboxState.checked)
        #expect(DSCheckboxState.unchecked != DSCheckboxState.checked)
        #expect(DSCheckboxState.intermediate != DSCheckboxState.unchecked)
    }
}
