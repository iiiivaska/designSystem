// DSTokensTests.swift
// DesignSystem

import Testing
@testable import DSTokens

// MARK: - Module Tests

@Suite("DSTokens Module Tests")
struct DSTokensModuleTests {
    
    @Test("Module version is defined")
    func testVersion() {
        #expect(DSTokens.version == "0.1.0")
    }
    
    @Test("All token categories are accessible")
    func testTokenCategoriesAccessible() {
        // Verify all categories exist
        _ = DSTokens.colors
        _ = DSTokens.typography
        _ = DSTokens.spacing
        _ = DSTokens.radius
        _ = DSTokens.shadow
        _ = DSTokens.motion
    }
}

// MARK: - Color Palette Tests

@Suite("DSColorPalette Tests")
struct DSColorPaletteTests {
    
    @Suite("Light Neutrals")
    struct LightNeutralsTests {
        
        @Test("N0 is white")
        func testN0() {
            #expect(DSLightNeutrals.n0 == "#FFFFFF")
        }
        
        @Test("N9 is near-black")
        func testN9() {
            #expect(DSLightNeutrals.n9 == "#131824")
        }
        
        @Test("All array contains 10 colors")
        func testAllCount() {
            #expect(DSLightNeutrals.all.count == 10)
        }
        
        @Test("All array values match individual tokens")
        func testAllValues() {
            #expect(DSLightNeutrals.all[0] == DSLightNeutrals.n0)
            #expect(DSLightNeutrals.all[5] == DSLightNeutrals.n5)
            #expect(DSLightNeutrals.all[9] == DSLightNeutrals.n9)
        }
    }
    
    @Suite("Dark Neutrals")
    struct DarkNeutralsTests {
        
        @Test("D0 is base dark")
        func testD0() {
            #expect(DSDarkNeutrals.d0 == "#0B0E14")
        }
        
        @Test("D9 is white")
        func testD9() {
            #expect(DSDarkNeutrals.d9 == "#FFFFFF")
        }
        
        @Test("All array contains 10 colors")
        func testAllCount() {
            #expect(DSDarkNeutrals.all.count == 10)
        }
    }
    
    @Suite("Teal Accent")
    struct TealAccentTests {
        
        @Test("Teal 500 is primary light")
        func testTeal500() {
            #expect(DSTealAccent.teal500 == "#0BAEA3")
        }
        
        @Test("TealDark A is dark-safe accent")
        func testTealDarkA() {
            #expect(DSTealAccent.tealDarkA == "#17BDB0")
        }
        
        @Test("TealDark B is pressed state")
        func testTealDarkB() {
            #expect(DSTealAccent.tealDarkB == "#0E8E84")
        }
    }
    
    @Suite("State Colors")
    struct StateColorsTests {
        
        @Test("Green 500 is success")
        func testGreen500() {
            #expect(DSGreenState.green500 == "#22C55E")
        }
        
        @Test("Yellow 500 is warning")
        func testYellow500() {
            #expect(DSYellowState.yellow500 == "#F59E0B")
        }
        
        @Test("Red 500 is danger")
        func testRed500() {
            #expect(DSRedState.red500 == "#EF4444")
        }
        
        @Test("Blue 500 is info")
        func testBlue500() {
            #expect(DSBlueState.blue500 == "#3B82F6")
        }
        
        @Test("Dark-safe variants are defined")
        func testDarkSafeVariants() {
            #expect(DSGreenState.greenDarkA == "#4ADE80")
            #expect(DSYellowState.yellowDarkA == "#F6C453")
            #expect(DSRedState.redDarkA == "#F87171")
            #expect(DSBlueState.blueDarkA == "#60A5FA")
        }
    }
    
    @Suite("Color Hex Format")
    struct ColorHexFormatTests {
        
        @Test("All hex values start with #")
        func testHexPrefix() {
            for hex in DSLightNeutrals.all {
                #expect(hex.hasPrefix("#"), "Hex value \(hex) should start with #")
            }
            for hex in DSDarkNeutrals.all {
                #expect(hex.hasPrefix("#"), "Hex value \(hex) should start with #")
            }
        }
        
        @Test("All hex values have correct length")
        func testHexLength() {
            // #RRGGBB = 7 characters
            for hex in DSLightNeutrals.all {
                #expect(hex.count == 7, "Hex value \(hex) should be 7 characters")
            }
            for hex in DSDarkNeutrals.all {
                #expect(hex.count == 7, "Hex value \(hex) should be 7 characters")
            }
        }
    }
}

// MARK: - Typography Scale Tests

@Suite("DSTypographyScale Tests")
struct DSTypographyScaleTests {
    
    @Suite("Font Sizes")
    struct FontSizeTests {
        
        @Test("Large title is 36pt")
        func testLargeTitle() {
            #expect(DSFontSize.largeTitle == 36)
        }
        
        @Test("Title is 29pt")
        func testTitle() {
            #expect(DSFontSize.title == 29)
        }
        
        @Test("Headline is 22pt")
        func testHeadline() {
            #expect(DSFontSize.headline == 22)
        }
        
        @Test("Body is 17pt")
        func testBody() {
            #expect(DSFontSize.body == 17)
        }
        
        @Test("Callout is 16pt")
        func testCallout() {
            #expect(DSFontSize.callout == 16)
        }
        
        @Test("Footnote is 13pt")
        func testFootnote() {
            #expect(DSFontSize.footnote == 13)
        }
        
        @Test("Caption sizes decrease")
        func testCaptionSizes() {
            #expect(DSFontSize.caption1 == 12)
            #expect(DSFontSize.caption2 == 11)
            #expect(DSFontSize.caption1 > DSFontSize.caption2)
        }
        
        @Test("Mono size is 16pt")
        func testMono() {
            #expect(DSFontSize.mono == 16)
        }
    }
    
    @Suite("Font Weights")
    struct FontWeightTests {
        
        @Test("Regular is 400")
        func testRegular() {
            #expect(DSFontWeight.regular == 400)
        }
        
        @Test("Semibold is 600")
        func testSemibold() {
            #expect(DSFontWeight.semibold == 600)
        }
        
        @Test("Weight ordering is correct")
        func testWeightOrdering() {
            #expect(DSFontWeight.regular < DSFontWeight.medium)
            #expect(DSFontWeight.medium < DSFontWeight.semibold)
            #expect(DSFontWeight.semibold < DSFontWeight.bold)
        }
    }
    
    @Suite("Line Heights")
    struct LineHeightTests {
        
        @Test("Normal line height is 1.3")
        func testNormal() {
            #expect(DSLineHeight.normal == 1.3)
        }
        
        @Test("Line height ordering is correct")
        func testOrdering() {
            #expect(DSLineHeight.tight < DSLineHeight.normal)
            #expect(DSLineHeight.normal < DSLineHeight.relaxed)
            #expect(DSLineHeight.relaxed < DSLineHeight.loose)
        }
    }
}

// MARK: - Spacing Scale Tests

@Suite("DSSpacingScale Tests")
struct DSSpacingScaleTests {
    
    @Suite("Named Spacing")
    struct NamedSpacingTests {
        
        @Test("XS is 4pt")
        func testXS() {
            #expect(DSSpacing.xs == 4)
        }
        
        @Test("S is 8pt")
        func testS() {
            #expect(DSSpacing.s == 8)
        }
        
        @Test("M is 12pt")
        func testM() {
            #expect(DSSpacing.m == 12)
        }
        
        @Test("L is 16pt")
        func testL() {
            #expect(DSSpacing.l == 16)
        }
        
        @Test("XL is 24pt")
        func testXL() {
            #expect(DSSpacing.xl == 24)
        }
        
        @Test("XXL is 32pt")
        func testXXL() {
            #expect(DSSpacing.xxl == 32)
        }
        
        @Test("Max is 64pt")
        func testMax() {
            #expect(DSSpacing.max == 64)
        }
    }
    
    @Suite("Numeric Spacing")
    struct NumericSpacingTests {
        
        @Test("Numeric tokens match named tokens")
        func testNumericMatchesNamed() {
            #expect(DSSpacingNumeric.space1 == DSSpacing.xs) // 4
            #expect(DSSpacingNumeric.space2 == DSSpacing.s)  // 8
            #expect(DSSpacingNumeric.space3 == DSSpacing.m)  // 12
            #expect(DSSpacingNumeric.space4 == DSSpacing.l)  // 16
            #expect(DSSpacingNumeric.space6 == DSSpacing.xl) // 24
            #expect(DSSpacingNumeric.space8 == DSSpacing.xxl) // 32
        }
        
        @Test("Spacing function returns correct values")
        func testSpacingFunction() {
            #expect(DSSpacingNumeric.spacing(for: 1) == 4)
            #expect(DSSpacingNumeric.spacing(for: 4) == 16)
            #expect(DSSpacingNumeric.spacing(for: 12) == 48)
        }
    }
    
    @Suite("Row Heights")
    struct RowHeightTests {
        
        @Test("iOS minimum is 44pt")
        func testiOSMinimum() {
            #expect(DSRowHeight.iOSMinimum == 44)
        }
        
        @Test("watchOS has larger default")
        func testWatchOSLarger() {
            #expect(DSRowHeight.watchOSDefault > DSRowHeight.iOSMinimum)
        }
        
        @Test("macOS compact is smaller")
        func testmacOSCompact() {
            #expect(DSRowHeight.macOSCompact < DSRowHeight.iOSMinimum)
        }
    }
}

// MARK: - Radius Scale Tests

@Suite("DSRadiusScale Tests")
struct DSRadiusScaleTests {
    
    @Suite("Named Radius")
    struct NamedRadiusTests {
        
        @Test("None is 0pt")
        func testNone() {
            #expect(DSRadius.none == 0)
        }
        
        @Test("S is 6pt")
        func testS() {
            #expect(DSRadius.s == 6)
        }
        
        @Test("M is 10pt")
        func testM() {
            #expect(DSRadius.m == 10)
        }
        
        @Test("L is 14pt")
        func testL() {
            #expect(DSRadius.l == 14)
        }
        
        @Test("XL is 18pt")
        func testXL() {
            #expect(DSRadius.xl == 18)
        }
        
        @Test("Full is 9999pt")
        func testFull() {
            #expect(DSRadius.full == 9999)
        }
    }
    
    @Suite("Numbered Radius")
    struct NumberedRadiusTests {
        
        @Test("r.1 through r.5 progression")
        func testProgression() {
            #expect(DSRadiusNumbered.r1 == 6)
            #expect(DSRadiusNumbered.r2 == 10)
            #expect(DSRadiusNumbered.r3 == 14)
            #expect(DSRadiusNumbered.r4 == 18)
            #expect(DSRadiusNumbered.r5 == 24)
        }
        
        @Test("Numbered matches named")
        func testNumberedMatchesNamed() {
            #expect(DSRadiusNumbered.r1 == DSRadius.s)
            #expect(DSRadiusNumbered.r2 == DSRadius.m)
            #expect(DSRadiusNumbered.r3 == DSRadius.l)
            #expect(DSRadiusNumbered.r4 == DSRadius.xl)
            #expect(DSRadiusNumbered.r5 == DSRadius.xxl)
        }
    }
    
    @Suite("Component Radius")
    struct ComponentRadiusTests {
        
        @Test("Card radius is r.3")
        func testCard() {
            #expect(DSComponentRadius.card == DSRadiusNumbered.r3)
        }
        
        @Test("Modal radius is r.4")
        func testModal() {
            #expect(DSComponentRadius.modal == DSRadiusNumbered.r4)
        }
    }
}

// MARK: - Shadow Scale Tests

@Suite("DSShadowScale Tests")
struct DSShadowScaleTests {
    
    @Suite("Shadow Definitions")
    struct ShadowDefinitionTests {
        
        @Test("None shadow has zero values")
        func testNone() {
            #expect(DSShadow.none.y == 0)
            #expect(DSShadow.none.blur == 0)
            #expect(DSShadow.none.opacityLight == 0)
            #expect(DSShadow.none.opacityDark == 0)
        }
        
        @Test("Medium shadow matches guidelines")
        func testMedium() {
            // y=6, blur=18 per guidelines
            #expect(DSShadow.medium.y == 6)
            #expect(DSShadow.medium.blur == 18)
            #expect(DSShadow.medium.opacityLight == 0.08)
            #expect(DSShadow.medium.opacityDark == 0.12)
        }
        
        @Test("Large shadow matches guidelines")
        func testLarge() {
            // y=14, blur=40 per guidelines
            #expect(DSShadow.large.y == 14)
            #expect(DSShadow.large.blur == 40)
            #expect(DSShadow.large.opacityLight == 0.12)
            #expect(DSShadow.large.opacityDark == 0.18)
        }
        
        @Test("Dark theme has higher opacity")
        func testDarkThemeOpacity() {
            #expect(DSShadow.medium.opacityDark > DSShadow.medium.opacityLight)
            #expect(DSShadow.large.opacityDark > DSShadow.large.opacityLight)
        }
    }
    
    @Suite("Numbered Shadows")
    struct NumberedShadowTests {
        
        @Test("shadow.0 is none")
        func testShadow0() {
            #expect(DSShadowNumbered.shadow0.y == DSShadow.none.y)
            #expect(DSShadowNumbered.shadow0.blur == DSShadow.none.blur)
        }
        
        @Test("shadow.1 is medium (cards)")
        func testShadow1() {
            #expect(DSShadowNumbered.shadow1.y == DSShadow.medium.y)
            #expect(DSShadowNumbered.shadow1.blur == DSShadow.medium.blur)
        }
        
        @Test("shadow.2 is large (overlays)")
        func testShadow2() {
            #expect(DSShadowNumbered.shadow2.y == DSShadow.large.y)
            #expect(DSShadowNumbered.shadow2.blur == DSShadow.large.blur)
        }
    }
    
    @Suite("Border Definitions")
    struct BorderDefinitionTests {
        
        @Test("Default border is 1px")
        func testDefault() {
            #expect(DSBorder.default.width == 1)
        }
        
        @Test("Focus ring is 2px")
        func testFocusRing() {
            #expect(DSBorder.focusRing.width == 2)
        }
    }
}

// MARK: - Motion Scale Tests

@Suite("DSMotionScale Tests")
struct DSMotionScaleTests {
    
    @Suite("Duration")
    struct DurationTests {
        
        @Test("Instant is 0")
        func testInstant() {
            #expect(DSDuration.instant == 0)
        }
        
        @Test("Normal is 0.25s")
        func testNormal() {
            #expect(DSDuration.normal == 0.25)
        }
        
        @Test("Duration ordering is correct")
        func testOrdering() {
            #expect(DSDuration.instant < DSDuration.fastest)
            #expect(DSDuration.fastest < DSDuration.fast)
            #expect(DSDuration.fast < DSDuration.normal)
            #expect(DSDuration.normal < DSDuration.slow)
            #expect(DSDuration.slow < DSDuration.slower)
            #expect(DSDuration.slower < DSDuration.slowest)
        }
    }
    
    @Suite("Spring Presets")
    struct SpringTests {
        
        @Test("Snappy has low response")
        func testSnappy() {
            #expect(DSSpring.snappy.response == 0.3)
            #expect(DSSpring.snappy.dampingFraction == 0.7)
        }
        
        @Test("Smooth is default")
        func testSmooth() {
            #expect(DSSpring.smooth.response == 0.5)
            #expect(DSSpring.smooth.dampingFraction == 0.8)
        }
        
        @Test("Bouncy has lower damping")
        func testBouncy() {
            #expect(DSSpring.bouncy.dampingFraction < DSSpring.smooth.dampingFraction)
        }
        
        @Test("Stiff has highest damping")
        func testStiff() {
            #expect(DSSpring.stiff.dampingFraction == 0.9)
        }
    }
    
    @Suite("Easing Curves")
    struct EasingTests {
        
        @Test("Linear is identity")
        func testLinear() {
            #expect(DSEasing.linear.x1 == 0)
            #expect(DSEasing.linear.y1 == 0)
            #expect(DSEasing.linear.x2 == 1)
            #expect(DSEasing.linear.y2 == 1)
        }
        
        @Test("Ease out is most common")
        func testEaseOut() {
            #expect(DSEasing.easeOut.x1 == 0)
            #expect(DSEasing.easeOut.x2 == 0.58)
        }
    }
    
    @Suite("Reduce Motion")
    struct ReduceMotionTests {
        
        @Test("Minimum duration is near-zero")
        func testMinimumDuration() {
            #expect(DSReduceMotionAdjustment.minimumDuration < DSDuration.fastest)
        }
        
        @Test("Crossfade is preferred")
        func testCrossfade() {
            #expect(DSReduceMotionAdjustment.useCrossfade == true)
        }
        
        @Test("Springs are disabled")
        func testDisableSprings() {
            #expect(DSReduceMotionAdjustment.disableSprings == true)
        }
    }
}
