# Calendar Planner View

A customizable daily calendar planner view with time-based events and Material 3 design.

[![Live Demo](https://img.shields.io/badge/Live%20Demo-View%20Online-blue)](https://calendar-planner-view.pages.dev/)

| ![Month View](https://raw.githubusercontent.com/danial2026/calendar_planner_view/main/assets/basic-month-view.jpg) | ![Week View](https://raw.githubusercontent.com/danial2026/calendar_planner_view/main/assets/basic-week-view.jpg) |
|------------------------------------|------------------------------------|

| ![Select Date](https://raw.githubusercontent.com/danial2026/calendar_planner_view/main/assets/select-date.jpg) | ![Multi Theme](https://raw.githubusercontent.com/danial2026/calendar_planner_view/main/assets/select-theme.jpg) |
|------------------------------------|------------------------------------|


| ![Multi Column Month View](https://raw.githubusercontent.com/danial2026/calendar_planner_view/main/assets/multi-column-month-view.jpg) | ![Multi Column Week View](https://raw.githubusercontent.com/danial2026/calendar_planner_view/main/assets/multi-column-week-view.jpg) |
|------------------------------------|------------------------------------|


## Features

* Time-based daily calendar view
* Month and week view modes
* Customizable event display
* Material 3 design support
* Customizable theme support
* Customizable date picker
* Dropdown styling customization
* Sticky time labels
* Event dot indicators
* Multi-column layout support
* Responsive design
* Theme-aware styling
* Event loading overlay

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  calendar_planner_view: any
```

## Usage

```dart
import 'package:calendar_planner_view/calendar_planner_view.dart';

// Basic usage
CalendarPlannerView(
  events: myEvents,
  onEventTap: (event) => print('Event tapped: $event'),
  datePickerPosition: DatePickerPosition.top,
  showCurrentTimeIndicator: true,
)

// Advanced usage with customization
CalendarPlannerView(
  events: myEvents,
  onEventTap: (event) => print('Event tapped: $event'),
  datePickerPosition: DatePickerPosition.modal,
  showCurrentTimeIndicator: true,
  startHour: 8,
  endHour: 20,
  showDayTitle: true,
  enableViewToggle: true,
  initialView: CalendarViewType.week,
  dotColor: Colors.blue,
  modalBackgroundColor: Colors.white,
  modalTitleStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  ),
)
```

## Live Demo

Check out the [live demo](https://calendar-planner-view.pages.dev/) to see the calendar planner view in action.

## Dependencies

* Flutter SDK
* intl: ^0.20.2
* table_calendar: ^3.2.0
* flutter_hooks: ^0.21.2

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 