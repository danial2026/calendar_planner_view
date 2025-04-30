/// Calendar configuration enums for the calendar planner view.
///
/// This file contains all the enumeration types used to configure various aspects
/// of the calendar planner view, including event visualization, view modes, and
/// date picker placement.
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
/// ### CalendarViewMode
/// Alternative view mode configuration:
/// * [CalendarViewMode.month]: Month view
/// * [CalendarViewMode.week]: Week view
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

/// Defines how the calendar view can be displayed (alternative to CalendarViewType)
enum CalendarViewMode {
  /// Month view of the calendar
  month,

  /// Week view of the calendar
  week
}

/// Determines the placement of the date selection interface (alternative to DatePickerPosition)
enum DatePickerDisplayMode {
  /// Date picker displayed inline
  inline,

  /// Date picker displayed as a popup
  popup
}
