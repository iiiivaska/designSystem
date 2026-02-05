// DSIconToken.swift
// DesignSystem
//
// Common SF Symbol name constants used throughout the design system.
// Centralizes icon names for consistency and easy updating.

import Foundation

// MARK: - DSIconToken

/// Common SF Symbol name constants used throughout the design system.
///
/// `DSIconToken` centralizes icon names to ensure consistency and
/// make it easy to update icons across all components.
///
/// ## Overview
///
/// Instead of using raw SF Symbol name strings, reference constants:
///
/// ```swift
/// // Instead of:
/// Image(systemName: "chevron.right")
///
/// // Use:
/// DSIcon(DSIconToken.Navigation.chevronRight)
/// ```
///
/// ## Categories
///
/// - ``Navigation``: Navigation-related icons
/// - ``Action``: Action and interaction icons
/// - ``State``: Status and state indicator icons
/// - ``Form``: Form and input-related icons
/// - ``General``: General-purpose icons
///
/// ## Topics
///
/// ### Icon Categories
///
/// - ``Navigation``
/// - ``Action``
/// - ``State``
/// - ``Form``
/// - ``General``
public enum DSIconToken {
    
    // MARK: - Navigation
    
    /// Navigation-related SF Symbol names.
    ///
    /// Used for directional indicators and navigation elements.
    public enum Navigation {
        /// Right chevron for navigation links.
        public static let chevronRight = "chevron.right"
        
        /// Left chevron for back navigation.
        public static let chevronLeft = "chevron.left"
        
        /// Down chevron for expandable content.
        public static let chevronDown = "chevron.down"
        
        /// Up chevron for collapsible content.
        public static let chevronUp = "chevron.up"
        
        /// Forward arrow.
        public static let arrowRight = "arrow.right"
        
        /// Back arrow.
        public static let arrowLeft = "arrow.left"
        
        /// External link indicator.
        public static let externalLink = "arrow.up.right"
    }
    
    // MARK: - Action
    
    /// Action and interaction SF Symbol names.
    ///
    /// Used for buttons and interactive elements.
    public enum Action {
        /// Add/create action.
        public static let plus = "plus"
        
        /// Remove/delete action.
        public static let minus = "minus"
        
        /// Close/dismiss action.
        public static let close = "xmark"
        
        /// Edit action.
        public static let edit = "pencil"
        
        /// Delete/trash action.
        public static let delete = "trash"
        
        /// Share action.
        public static let share = "square.and.arrow.up"
        
        /// Copy to clipboard.
        public static let copy = "doc.on.doc"
        
        /// Search action.
        public static let search = "magnifyingglass"
        
        /// Refresh/reload action.
        public static let refresh = "arrow.clockwise"
        
        /// Settings/gear action.
        public static let settings = "gearshape"
        
        /// More options (horizontal ellipsis).
        public static let more = "ellipsis"
    }
    
    // MARK: - State
    
    /// Status and state indicator SF Symbol names.
    ///
    /// Used for validation, feedback, and status display.
    public enum State {
        /// Checkmark for success/completion.
        public static let checkmark = "checkmark"
        
        /// Checkmark in circle for confirmed state.
        public static let checkmarkCircle = "checkmark.circle.fill"
        
        /// Warning triangle.
        public static let warning = "exclamationmark.triangle.fill"
        
        /// Error circle.
        public static let error = "xmark.circle.fill"
        
        /// Info circle.
        public static let info = "info.circle.fill"
        
        /// Loading indicator.
        public static let loading = "arrow.2.circlepath"
        
        /// Empty/no content.
        public static let empty = "tray"
    }
    
    // MARK: - Form
    
    /// Form and input-related SF Symbol names.
    ///
    /// Used for form controls and field accessories.
    public enum Form {
        /// Required field indicator.
        public static let required = "asterisk"
        
        /// Toggle on.
        public static let toggleOn = "checkmark.circle.fill"
        
        /// Toggle off.
        public static let toggleOff = "circle"
        
        /// Text field clear button.
        public static let clear = "xmark.circle.fill"
        
        /// Secure field visibility toggle (show).
        public static let eyeOpen = "eye"
        
        /// Secure field visibility toggle (hide).
        public static let eyeClosed = "eye.slash"
        
        /// Dropdown indicator.
        public static let dropdown = "chevron.up.chevron.down"
        
        /// Calendar/date picker.
        public static let calendar = "calendar"
    }
    
    // MARK: - General
    
    /// General-purpose SF Symbol names.
    ///
    /// Common icons used across various contexts.
    public enum General {
        /// Star (empty).
        public static let star = "star"
        
        /// Star (filled).
        public static let starFilled = "star.fill"
        
        /// Heart (empty).
        public static let heart = "heart"
        
        /// Heart (filled).
        public static let heartFilled = "heart.fill"
        
        /// Person/user.
        public static let person = "person"
        
        /// Person in circle.
        public static let personCircle = "person.circle"
        
        /// Lock.
        public static let lock = "lock"
        
        /// Bell/notification.
        public static let bell = "bell"
        
        /// Photo/image.
        public static let photo = "photo"
        
        /// Document.
        public static let document = "doc"
        
        /// Folder.
        public static let folder = "folder"
        
        /// Link.
        public static let link = "link"
    }
}
