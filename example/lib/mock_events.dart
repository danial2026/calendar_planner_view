import 'package:calendar_planner_view/calendar_planner_view.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/// Generates a list of mock events with customizable columns, types, and count.
///
/// This function creates random calendar events for testing and demonstration purposes.
/// Each event can have a unique ID, custom column assignment, and randomized properties.
///
/// Example usage:
/// ```dart
/// // Generate 20 events with IDs in work and personal columns
/// final events = _generateMockEvents(
///   columns: ['work', 'personal'],
///   types: ['Project Planning', 'Client Call', 'Team Building'],
///   count: 20,
///   includeIds: true,
///   baseDate: DateTime.now(),
/// );
/// ```
///
/// Parameters:
/// * [columns] - Optional list of column IDs for multi-column layout
/// * [types] - Optional list of event types/titles to use
/// * [count] - Number of events to generate (default: 240)
/// * [baseDate] - Base date for event generation (default: current date)
/// * [includeIds] - Whether to generate unique IDs for events (default: false)
List<CalendarEvent> _generateMockEvents({
  List<String>? columns,
  List<String>? types,
  int count = 240,
  DateTime? baseDate,
  bool includeIds = false,
}) {
  final now = baseDate ?? DateTime.now();
  final random = Random();

  // Predefined color palette for events
  final colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.pink,
    Colors.cyan,
  ];

  // Default event titles if none provided
  final defaultTitles = [
    'Meeting',
    'Workout',
    'Lunch',
    'Call',
    'Project',
    'Review',
    'Sync',
    'Coffee',
    'Design',
    'Code',
    'Plan',
    'Demo',
    'Docs',
    '1:1',
    'Standup',
    'Retro',
    'Brainstorm',
    'Interview',
    'QA',
    'Deploy',
  ];
  final titles = types ?? defaultTitles;

  // Default columns if none provided
  final defaultColumns = ['work', 'personal', 'meetings'];
  final usedColumns = columns ?? defaultColumns;

  List<CalendarEvent> events = [];
  for (int i = 0; i < count; i++) {
    // Generate random event properties
    int day = random.nextInt(30) + 1;
    int hour = 8 + random.nextInt(11); // 8-19
    int minute = [30, 45, 60, 90][random.nextInt(4)];
    int duration = [30, 45, 60, 90][random.nextInt(4)];

    // Create event time range
    DateTime start = DateTime(now.year, now.month, day, hour, minute);
    DateTime end = start.add(Duration(minutes: duration));

    // Assign random column and title
    String columnId = usedColumns[random.nextInt(usedColumns.length)];
    String title = titles[random.nextInt(titles.length)];
    String description = '$title event in $columnId column for day $day, ${duration}min';

    // Create and add the event
    events.add(
      CalendarEvent(
        title: title,
        startTime: start,
        endTime: end,
        color: colors[random.nextInt(colors.length)],
        description: description,
        columnId: columnId,
        id: includeIds ? 'event_${i + 1}' : null, // Generate unique ID if requested
      ),
    );
  }
  return events;
}

/// Default list of mock events for backward compatibility.
///
/// This list contains 240 randomly generated events without IDs.
/// For events with IDs, use _generateMockEvents(includeIds: true).
final List<CalendarEvent> mockEvents = _generateMockEvents();
