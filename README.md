# Calendar Planner View

A customizable daily calendar planner view with time-based events and Material 3 design for Flutter.

## Features

- Time-based daily calendar
- Scrollable events view
- Customizable event items
- Material 3 design support
- Light and dark mode support
- Customizable date picker (top or modal)
- Sticky time labels
- Customizable event card builders

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  calendar_planner_view: ^0.1.0
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:calendar_planner_view/calendar_planner_view.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CalendarPlannerView(
          events: [
            CalendarEvent(
              title: 'Team Meeting',
              startTime: DateTime.now().copyWith(hour: 10, minute: 0),
              endTime: DateTime.now().copyWith(hour: 11, minute: 30),
              color: Colors.blue,
              description: 'Weekly team sync meeting',
            ),
          ],
          onEventTap: (event) {
            print('Event tapped: ${event.title}');
          },
          datePickerPosition: DatePickerPosition.top,
          showStickyTimeLabels: true,
          startHour: 8,
          endHour: 20,
        ),
      ),
    );
  }
}
```

## Customization

### Event Builder

You can customize how events are displayed by providing a custom event builder:

```dart
CalendarPlannerView(
  events: events,
  onEventTap: onEventTap,
  eventBuilder: (context, event) {
    return Card(
      child: ListTile(
        title: Text(event.title),
        subtitle: Text(event.description ?? ''),
      ),
    );
  },
)
```

### Date Picker

The date picker can be shown either at the top of the view or in a modal dialog:

```dart
CalendarPlannerView(
  events: events,
  onEventTap: onEventTap,
  datePickerPosition: DatePickerPosition.modal, // or DatePickerPosition.top
)
```

### Time Labels

You can customize the time labels style and make them sticky while scrolling:

```dart
CalendarPlannerView(
  events: events,
  onEventTap: onEventTap,
  showStickyTimeLabels: true,
  timeLabelStyle: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  ),
)
```

## Example

Check out the [example](example) directory for a complete working example of the package.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 