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
