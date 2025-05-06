library calendar_planner_view;

// Extensions
export 'src/extensions/calendar_style_extension.dart';
// Models
export 'src/models/calendar_enums.dart';
export 'src/models/event_model.dart';
export 'src/models/event_utils.dart';
// Utils
export 'src/utils/date_utils.dart';
export 'src/utils/style_utils.dart';
// Widgets
export 'src/date_picker.dart';
export 'src/event_list.dart';
export 'src/planner_view.dart';
export 'src/time_labels.dart';

/// A customizable calendar planner view with time-based events and Material 3 design.
///
/// This package provides a flexible and customizable calendar planner view that
/// allows users to display and manage time-based events in both daily and monthly views.
/// It includes features such as:
/// * Time-based daily calendar with customizable time range
/// * Month and week view support with smooth transitions
/// * Customizable event items with support for overlapping events
/// * Material 3 design support with theme awareness
/// * Light and dark mode support
/// * Flexible date picker (top or modal) with complete customization:
///   - Week number styling and layout
///   - Chevron icon customization
///   - Calendar container styling
///   - Date range constraints
///   - Header styling
/// * Sticky time labels with current hour highlighting
/// * Multi-column layout support
/// * Event indicators with customizable shapes and colors
/// * Responsive design for all screen sizes
/// * Localization support
/// * Current time indicator
/// * Event overlap handling
/// * Theme-aware styling
/// * Loading overlay with customizable appearance
///
/// ## Installation
/// Add this to your package's `pubspec.yaml` file:
/// ```yaml
/// dependencies:
///   calendar_planner_view: any
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
///   onDateChanged: (date) => print('Date changed: $date'),
///   datePickerPosition: DatePickerPosition.top,
///   startHour: 8,
///   endHour: 18,
///   showCurrentTimeIndicator: true,
/// )
///
/// // Advanced usage with multi-column layout and loading overlay
/// CalendarPlannerView(
///   events: myEvents,
///   onEventTap: (event) => print('Event tapped: $event'),
///   onDateChanged: (date) {
///     // Update your app's state with the new date
///     setState(() => selectedDate = date);
///     // Optionally fetch events for the new date
///     fetchEventsForDate(date);
///   },
///   datePickerPosition: DatePickerPosition.modal,
///   startHour: 8,
///   endHour: 20,
///   showDayTitle: true,
///   enableViewToggle: true,
///   initialView: CalendarViewType.week,
///   showCurrentTimeIndicator: true,
///   columns: [
///     (id: 'work', title: 'Work'),
///     (id: 'personal', title: 'Personal'),
///     (id: 'meetings', title: 'Meetings'),
///   ],
///   dotColor: Colors.blue,
///   dotSize: 5.0,
///   eventDotShape: EventDotShape.circle,
///   highlightCurrentHour: true,
///   modalBackgroundColor: Colors.white,
///   modalTitleStyle: TextStyle(
///     color: Colors.black,
///     fontWeight: FontWeight.bold,
///   ),
///   customTitleCalendarWidget: Icon(Icons.calendar_month, color: Colors.blue),
///   // Loading overlay configuration
///   isLoading: true,
///   loadingBuilder: (context) => Center(
///     child: CircularProgressIndicator(color: Colors.blue),
///   ),
///   loadingOverlayColor: Colors.black12,
///   showContentWhileLoading: false,
/// )
/// ```
///
/// ## Features
/// * **Time-based Events**: Display events with specific start and end times
/// * **Multiple Views**: Switch between month and week views with smooth transitions
/// * **Customizable Styling**: Theme-aware design with Material 3 support
/// * **Event Management**: Add, edit, and delete events with overlap handling
/// * **Date Navigation**: Flexible date selection with top or modal picker
/// * **Responsive Design**: Adapts to different screen sizes
/// * **Accessibility**: Support for screen readers and keyboard navigation
/// * **Multi-column Layout**: Organize events into separate columns
/// * **Event Overlap Handling**: Smart positioning of overlapping events
/// * **Custom Event Builders**: Create custom event displays
/// * **Time Range Control**: Set custom start and end hours
/// * **Event Indicators**: Visual dots with customizable shapes and colors
/// * **Date Change Callbacks**: Respond to date selection changes
/// * **Current Hour Highlighting**: Visual indicator for current time
/// * **Current Time Indicator**: Shows current time line in the timeline
/// * **Custom Time Labels**: Format time labels with custom builder
/// * **Localization**: Support for different languages and date formats
/// * **Loading Overlay**: Customizable loading state with optional content visibility
///
/// ## Multi-column Layout
/// The calendar planner supports organizing events into multiple columns:
/// * Define columns with unique IDs and optional titles
/// * Assign events to specific columns using `columnId`
/// * Automatic column width calculation
/// * Visual column dividers
/// * Minimum 2 columns, maximum 10 columns
/// * Events without columnId use default column
/// * Customizable column titles and styling
///
/// ## Date Picker
/// The widget offers two date picker modes:
/// * **Top Position**: Always visible above the timeline
/// * **Modal Position**: Appears in an animated dialog with:
///   - Smooth scale and fade animations
///   - Gradient header with calendar icon
///   - "Today" button with icon
///   - Customizable styling
///   - Responsive layout
///   - Complete customization options:
///     - Week number styling and layout
///     - Chevron icon customization
///     - Calendar container styling
///     - Date range constraints
///     - Header styling
///
/// ## Callbacks
/// The widget provides several callbacks for handling user interactions:
/// * `onEventTap`: Triggered when an event is tapped
/// * `onDateChanged`: Triggered when the selected date changes, which can occur when:
///   - User selects a new date from the calendar picker
///   - User clicks the "Today" button
///
/// ## Dependencies
/// * Flutter SDK
/// * intl: ^0.20.2
/// * table_calendar: ^3.2.0
/// * flutter_hooks: ^0.20.0
///
/// ## Contributing
/// Contributions are welcome! Please feel free to submit a Pull Request.
/// For major changes, please open an issue first to discuss what you would like to change.
///
/// ## License
/// This project is licensed under the MIT License - see the LICENSE file for details.
