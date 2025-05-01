/// Calendar configuration enums for the calendar planner view.
///
/// This file contains all the enumeration types used to configure various aspects
/// of the calendar planner view, including event visualization, view modes,
/// date picker placement, and multi-column layout.
///
/// ## Event Visualization
/// The [EventDotShape] enum defines the visual representation of event indicators:
/// * [EventDotShape.circle]: Circular dots (default)
/// * [EventDotShape.square]: Square indicators
/// * [EventDotShape.diamond]: Diamond-shaped indicators
///
/// ## View Modes
/// Two enums are provided for view mode configuration:
///
/// ### CalendarViewType
/// Defines the primary calendar view modes:
/// * [CalendarViewType.month]: Full month calendar view
/// * [CalendarViewType.week]: Single week calendar view
///
/// ## Date Picker Configuration
/// Two enums are provided for date picker placement:
///
/// ### DatePickerPosition
/// Defines the primary date picker positions:
/// * [DatePickerPosition.top]: Date picker displayed at the top of the view
/// * [DatePickerPosition.modal]: Date picker displayed as a modal/popup
///
/// ### DatePickerDisplayMode
/// Alternative date picker configuration:
/// * [DatePickerDisplayMode.inline]: Date picker displayed inline
/// * [DatePickerDisplayMode.popup]: Date picker displayed as a popup
///
/// ## Multi-Column Layout
/// The calendar planner supports multi-column layout for organizing events:
/// * Each column has a unique identifier and optional title
/// * Events can be assigned to specific columns
/// * Minimum 2 columns, maximum 10 columns
/// * Automatic column width calculation
/// * Visual column dividers
///
/// ## Usage
/// ```dart
/// // Configure event dot shape
/// final dotShape = EventDotShape.circle;
///
/// // Set calendar view type
/// final viewType = CalendarViewType.week;
///
/// // Configure date picker position
/// final pickerPosition = DatePickerPosition.modal;
///
/// // Define multi-column layout
/// final columns = [
///   (id: 'work', title: 'Work'),
///   (id: 'personal', title: 'Personal'),
/// ];
/// ```

/// Event dot shape in the calendar view
enum EventDotShape {
  /// Circular shape
  circle,

  /// Square shape
  square,

  /// Diamond shape
  diamond
}

/// Calendar view display mode
enum CalendarViewType {
  /// Full month view
  month,

  /// Single week view
  week
}

/// Date picker display position
enum DatePickerPosition {
  /// Displayed at the top of the view
  top,

  /// Displayed as a modal/popup
  modal
}

/// Determines the placement of the date selection interface (alternative to DatePickerPosition)
enum DatePickerDisplayMode {
  /// Date picker displayed inline
  inline,

  /// Date picker displayed as a popup
  popup
}
