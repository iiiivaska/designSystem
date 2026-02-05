// DSSpec.swift
// DesignSystem
//
// Base spec protocol for the resolve-then-render pattern.
// Specs are pure data — no SwiftUI views.

import SwiftUI

// MARK: - DSSpec Protocol

/// Base protocol for component specifications.
///
/// `DSSpec` defines the contract for component specs in the
/// resolve-then-render architecture. Each component has a spec
/// that encapsulates all resolved styling information.
///
/// ## Overview
///
/// The resolve-then-render pattern separates styling logic from
/// rendering logic:
///
/// 1. **Resolve**: A spec is created by mapping theme roles to
///    concrete values based on variant, size, and state.
/// 2. **Render**: The component uses the spec's concrete values
///    to build its SwiftUI view body.
///
/// ## Benefits
///
/// - Specs are **deterministic** and **testable** (unit tests)
/// - No SwiftUI view logic in resolution
/// - Theme changes automatically flow through specs
/// - Easy to snapshot and compare styling across variants
///
/// ## Example
///
/// ```swift
/// // 1. Resolve the spec
/// let spec = DSButtonSpec.resolve(
///     theme: theme,
///     variant: .primary,
///     size: .medium,
///     state: .normal
/// )
///
/// // 2. Render using resolved values
/// Text(label)
///     .font(spec.typography.font)
///     .foregroundStyle(spec.foregroundColor)
///     .padding(.horizontal, spec.horizontalPadding)
///     .frame(height: spec.height)
///     .background(spec.backgroundColor)
///     .clipShape(RoundedRectangle(cornerRadius: spec.cornerRadius))
/// ```
///
/// ## Topics
///
/// ### Component Specs
///
/// - ``DSButtonSpec``
/// - ``DSFieldSpec``
/// - ``DSToggleSpec``
/// - ``DSFormRowSpec``
/// - ``DSCardSpec``
/// - ``DSListRowSpec``
public protocol DSSpec: Sendable, Equatable {}
