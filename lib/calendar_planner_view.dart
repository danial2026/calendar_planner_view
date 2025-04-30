library calendar_planner_view;

export 'src/planner_view.dart';
export 'src/models/event_model.dart';
export 'src/date_picker.dart';
export 'src/models/calendar_enums.dart';

/// A customizable daily calendar planner view with time-based events and Material 3 design.
///
/// This package provides a flexible and customizable calendar planner view that
/// allows users to display and manage time-based events in a daily view format.
/// It includes features such as:
/// * Time-based daily calendar
/// * Scrollable events view
/// * Customizable event items
/// * Material 3 design support
/// * Light and dark mode support
/// * Customizable date picker
/// * Sticky time labels
///
/// ## Installation
/// Add this to your package's `pubspec.yaml` file:
/// ```yaml
/// dependencies:
///   calendar_planner_view: ^1.0.0
/// ```
///
/// ## Usage
/// ```dart
/// import 'package:calendar_planner_view/calendar_planner_view.dart';
///
/// // Basic usage
/// CalendarPlannerView(
///   events: myEvents,
///   onEventTap: (event) => print('Event tapped: $event'),
///   datePickerPosition: DatePickerPosition.top,
///   showStickyTimeLabels: true,
/// )
///
/// // Advanced usage with customization
/// CalendarPlannerView(
///   events: myEvents,
///   onEventTap: (event) => print('Event tapped: $event'),
///   datePickerPosition: DatePickerPosition.modal,
///   showStickyTimeLabels: true,
///   startHour: 8,
///   endHour: 20,
///   showDayTitle: true,
///   enableViewToggle: true,
///   initialView: CalendarViewType.week,
///   dotColor: Colors.blue,
///   modalBackgroundColor: Colors.white,
///   modalTitleStyle: TextStyle(
///     color: Colors.black,
///     fontWeight: FontWeight.bold,
///   ),
/// )
/// ```
///
/// ## Features
/// * **Time-based Events**: Display events with specific start and end times
/// * **Multiple Views**: Switch between month and week views
/// * **Customizable Styling**: Theme-aware design with Material 3 support
/// * **Event Management**: Add, edit, and delete events
/// * **Date Navigation**: Easy date selection with customizable date picker
/// * **Responsive Design**: Adapts to different screen sizes
/// * **Accessibility**: Support for screen readers and keyboard navigation
///
/// ## Dependencies
/// * Flutter SDK
/// * intl: ^0.18.0
/// * table_calendar: ^3.0.9
///
/// ## Contributing
/// Contributions are welcome! Please feel free to submit a Pull Request.
/// For major changes, please open an issue first to discuss what you would like to change.
///
/// ## License
/// This project is licensed under the MIT License - see the LICENSE file for details.
