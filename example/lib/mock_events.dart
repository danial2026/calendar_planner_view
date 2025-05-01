import 'package:calendar_planner_view/calendar_planner_view.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/// Generates a list of mock events with customizable columns, types, and count.
///
/// Example usage:
///   _generateMockEvents(
///     columns: ['work', 'personal', 'meetings'],
///     types: ['Project Planning', 'Client Call', 'Team Building'],
///     count: 20,
///     baseDate: DateTime.now(),
///   );
List<CalendarEvent> _generateMockEvents({
  List<String>? columns,
  List<String>? types,
  int count = 240,
  DateTime? baseDate,
}) {
  final now = baseDate ?? DateTime.now();
  final random = Random();
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
  final defaultColumns = ['work', 'personal', 'meetings'];
  final usedColumns = columns ?? defaultColumns;

  List<CalendarEvent> events = [];
  for (int i = 0; i < count; i++) {
    int day = random.nextInt(30) + 1;
    int hour = 8 + random.nextInt(11); // 8-19
    int minute = [30, 45, 60, 90][random.nextInt(4)];
    int duration = [30, 45, 60, 90][random.nextInt(4)];
    DateTime start = DateTime(now.year, now.month, day, hour, minute);
    DateTime end = start.add(Duration(minutes: duration));
    String columnId = usedColumns[random.nextInt(usedColumns.length)];
    String title = titles[random.nextInt(titles.length)];
    String description = '$title event in $columnId column for day $day, ${duration}min';
    events.add(
      CalendarEvent(
        title: title,
        startTime: start,
        endTime: end,
        color: colors[random.nextInt(colors.length)],
        description: description,
        columnId: columnId,
      ),
    );
  }
  return events;
}

// Default export for backward compatibility
final List<CalendarEvent> mockEvents = _generateMockEvents();
