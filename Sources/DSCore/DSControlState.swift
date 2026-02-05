import Foundation

// MARK: - DSControlState

/// Represents the interaction state of a control.
///
/// `DSControlState` is an `OptionSet` that allows controls to be in multiple
/// states simultaneously (e.g., focused and hovered).
///
/// ## Overview
///
/// ```swift
/// var state: DSControlState = [.enabled, .hovered]
///
/// if state.contains(.disabled) {
///     // Render disabled appearance
/// } else if state.contains(.pressed) {
///     // Render pressed appearance
/// }
/// ```
///
/// For simpler use cases, see ``DSInteractionState`` which provides
/// mutually exclusive states.
///
/// ## Topics
///
/// ### Base States
///
/// - ``normal``
/// - ``enabled``
/// - ``disabled``
///
/// ### Interaction States
///
/// - ``pressed``
/// - ``hovered``
/// - ``focused``
///
/// ### Selection States
///
/// - ``selected``
/// - ``indeterminate``
///
/// ### Semantic States
///
/// - ``loading``
/// - ``highlighted``
/// - ``dragging``
///
/// ### Common Combinations
///
/// - ``disabledSelected``
/// - ``focusedHovered``
/// - ``focusedPressed``
public struct DSControlState: OptionSet, Sendable, Hashable {
    
    public let rawValue: UInt16
    
    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }
    
    // MARK: - Base States
    
    /// The normal/default state (no flags set).
    public static let normal = DSControlState([])
    
    /// The control is enabled (default state).
    public static let enabled = DSControlState(rawValue: 1 << 0)
    
    /// The control is disabled and cannot be interacted with.
    public static let disabled = DSControlState(rawValue: 1 << 1)
    
    // MARK: - Interaction States
    
    /// The control is being pressed (touch down, mouse down).
    public static let pressed = DSControlState(rawValue: 1 << 2)
    
    /// The pointer is hovering over the control.
    public static let hovered = DSControlState(rawValue: 1 << 3)
    
    /// The control has keyboard/accessibility focus.
    public static let focused = DSControlState(rawValue: 1 << 4)
    
    // MARK: - Selection States
    
    /// The control is selected (e.g., toggle on, radio selected).
    public static let selected = DSControlState(rawValue: 1 << 5)
    
    /// The control is in an indeterminate/mixed state (e.g., partial checkbox).
    public static let indeterminate = DSControlState(rawValue: 1 << 6)
    
    // MARK: - Semantic States
    
    /// The control is in a loading state.
    public static let loading = DSControlState(rawValue: 1 << 7)
    
    /// The control is highlighted (e.g., for drag and drop).
    public static let highlighted = DSControlState(rawValue: 1 << 8)
    
    /// The control is being dragged.
    public static let dragging = DSControlState(rawValue: 1 << 9)
    
    // MARK: - Common Combinations
    
    /// Disabled and selected (e.g., toggle on but not changeable).
    public static let disabledSelected: DSControlState = [.disabled, .selected]
    
    /// Focused and hovered.
    public static let focusedHovered: DSControlState = [.focused, .hovered]
    
    /// Pressed while focused.
    public static let focusedPressed: DSControlState = [.focused, .pressed]
}

// MARK: - CustomStringConvertible

extension DSControlState: CustomStringConvertible {
    
    /// A textual representation of the control state.
    ///
    /// Returns a comma-separated list of active state names,
    /// or "normal" if no states are set.
    public var description: String {
        var states: [String] = []
        
        if self == .normal { return "normal" }
        if contains(.enabled) { states.append("enabled") }
        if contains(.disabled) { states.append("disabled") }
        if contains(.pressed) { states.append("pressed") }
        if contains(.hovered) { states.append("hovered") }
        if contains(.focused) { states.append("focused") }
        if contains(.selected) { states.append("selected") }
        if contains(.indeterminate) { states.append("indeterminate") }
        if contains(.loading) { states.append("loading") }
        if contains(.highlighted) { states.append("highlighted") }
        if contains(.dragging) { states.append("dragging") }
        
        return states.isEmpty ? "normal" : states.joined(separator: ", ")
    }
}

// MARK: - DSControlStateTransition

/// Describes a state transition for controls.
///
/// Use `DSControlStateTransition` to track and animate state changes.
///
/// ## Usage
///
/// ```swift
/// let transition = DSControlStateTransition(
///     from: .normal,
///     to: .pressed,
///     animated: true
/// )
///
/// if transition.changesPressed {
///     // Animate the press state change
/// }
/// ```
///
/// ## Topics
///
/// ### Properties
///
/// - ``from``
/// - ``to``
/// - ``animated``
/// - ``suggestedDuration``
///
/// ### Computed Properties
///
/// - ``addedStates``
/// - ``removedStates``
/// - ``changesDisabled``
/// - ``changesPressed``
/// - ``changesSelected``
public struct DSControlStateTransition: Sendable, Equatable {
    
    /// The state transitioning from.
    public let from: DSControlState
    
    /// The state transitioning to.
    public let to: DSControlState
    
    /// Whether this transition should be animated.
    public let animated: Bool
    
    /// Suggested duration for animation (if animated).
    public let suggestedDuration: TimeInterval?
    
    /// Creates a new state transition.
    ///
    /// - Parameters:
    ///   - from: The starting ``DSControlState``.
    ///   - to: The ending ``DSControlState``.
    ///   - animated: Whether the transition should be animated. Defaults to `true`.
    ///   - suggestedDuration: Suggested animation duration. Defaults to `nil`.
    public init(
        from: DSControlState,
        to: DSControlState,
        animated: Bool = true,
        suggestedDuration: TimeInterval? = nil
    ) {
        self.from = from
        self.to = to
        self.animated = animated
        self.suggestedDuration = suggestedDuration
    }
    
    /// The states that were added in this transition.
    ///
    /// States present in ``to`` but not in ``from``.
    public var addedStates: DSControlState {
        DSControlState(rawValue: to.rawValue & ~from.rawValue)
    }
    
    /// The states that were removed in this transition.
    ///
    /// States present in ``from`` but not in ``to``.
    public var removedStates: DSControlState {
        DSControlState(rawValue: from.rawValue & ~to.rawValue)
    }
    
    /// Whether this transition changes the disabled state.
    public var changesDisabled: Bool {
        from.contains(.disabled) != to.contains(.disabled)
    }
    
    /// Whether this transition changes the pressed state.
    public var changesPressed: Bool {
        from.contains(.pressed) != to.contains(.pressed)
    }
    
    /// Whether this transition changes the selected state.
    public var changesSelected: Bool {
        from.contains(.selected) != to.contains(.selected)
    }
}

// MARK: - DSInteractionState

/// A simplified interaction state for common use cases.
///
/// Use `DSInteractionState` when you don't need the full flexibility
/// of ``DSControlState``. States are mutually exclusive.
///
/// ## Usage
///
/// ```swift
/// @State private var interaction: DSInteractionState = .normal
///
/// Button("Tap me") { }
///     .disabled(interaction == .disabled)
///     .opacity(interaction.allowsInteraction ? 1 : 0.5)
/// ```
///
/// ## Topics
///
/// ### State Cases
///
/// - ``normal``
/// - ``hovered``
/// - ``pressed``
/// - ``focused``
/// - ``disabled``
/// - ``loading``
///
/// ### Properties
///
/// - ``controlState``
/// - ``allowsInteraction``
public enum DSInteractionState: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Normal resting state.
    case normal
    
    /// Pointer hovering over element.
    case hovered
    
    /// Being pressed or touched.
    case pressed
    
    /// Has keyboard focus.
    case focused
    
    /// Disabled and inactive.
    case disabled
    
    /// Loading or processing.
    case loading
    
    /// Converts to the corresponding ``DSControlState``.
    ///
    /// | Interaction State | Control State |
    /// |-------------------|---------------|
    /// | ``normal`` | ``DSControlState/normal`` |
    /// | ``hovered`` | ``DSControlState/hovered`` |
    /// | ``pressed`` | ``DSControlState/pressed`` |
    /// | ``focused`` | ``DSControlState/focused`` |
    /// | ``disabled`` | ``DSControlState/disabled`` |
    /// | ``loading`` | ``DSControlState/loading`` |
    public var controlState: DSControlState {
        switch self {
        case .normal: return .normal
        case .hovered: return .hovered
        case .pressed: return .pressed
        case .focused: return .focused
        case .disabled: return .disabled
        case .loading: return .loading
        }
    }
    
    /// Whether this state allows interaction.
    ///
    /// Returns `false` for ``disabled`` and ``loading``.
    public var allowsInteraction: Bool {
        switch self {
        case .disabled, .loading:
            return false
        case .normal, .hovered, .pressed, .focused:
            return true
        }
    }
}

// MARK: - DSSelectionState

/// Represents the selection state of a selectable control.
///
/// Use `DSSelectionState` for toggles, checkboxes, and radio buttons.
///
/// ## Usage
///
/// ```swift
/// @State private var selection: DSSelectionState = .unselected
///
/// Button(action: { selection.toggle() }) {
///     // Checkbox UI
/// }
/// ```
///
/// ## Topics
///
/// ### State Cases
///
/// - ``unselected``
/// - ``selected``
/// - ``indeterminate``
///
/// ### Properties
///
/// - ``controlStateFlags``
/// - ``isSelected``
///
/// ### Methods
///
/// - ``toggle()``
/// - ``toggled()``
public enum DSSelectionState: String, Sendable, Equatable, Hashable, CaseIterable {
    
    /// Not selected.
    case unselected
    
    /// Fully selected.
    case selected
    
    /// Partially selected (e.g., some children selected in a parent checkbox).
    case indeterminate
    
    /// Converts to the corresponding ``DSControlState`` flags.
    ///
    /// | Selection State | Control State Flags |
    /// |-----------------|---------------------|
    /// | ``unselected`` | (none) |
    /// | ``selected`` | ``DSControlState/selected`` |
    /// | ``indeterminate`` | ``DSControlState/indeterminate`` |
    public var controlStateFlags: DSControlState {
        switch self {
        case .unselected: return []
        case .selected: return .selected
        case .indeterminate: return .indeterminate
        }
    }
    
    /// Whether this represents a selected state.
    ///
    /// Returns `true` only for ``selected``, not for ``indeterminate``.
    public var isSelected: Bool {
        self == .selected
    }
    
    /// Toggles between selected and unselected.
    ///
    /// - ``unselected`` → ``selected``
    /// - ``selected`` → ``unselected``
    /// - ``indeterminate`` → ``selected``
    public mutating func toggle() {
        switch self {
        case .unselected, .indeterminate:
            self = .selected
        case .selected:
            self = .unselected
        }
    }
    
    /// Returns the toggled state without mutating.
    ///
    /// - Returns: The new ``DSSelectionState`` after toggling.
    public func toggled() -> DSSelectionState {
        var copy = self
        copy.toggle()
        return copy
    }
}
