import 'package:calendar_planner_view/calendar_planner_view.dart';
import 'package:flutter/material.dart';
import 'dart:math';

final List<CalendarEvent> mockEvents = _generateMockEvents();

List<CalendarEvent> _generateMockEvents() {
  final now = DateTime.now();
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
  final titles = [
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
  List<CalendarEvent> events = [];
  for (int i = 0; i < 40; i++) {
    int day = random.nextInt(30) + 1;
    int hour = 8 + random.nextInt(11); // 8-19
    int minute = [0, 15, 30, 45][random.nextInt(4)];
    int duration = [30, 45, 60, 90][random.nextInt(4)];
    DateTime start = DateTime(now.year, now.month, day, hour, minute);
    DateTime end = start.add(Duration(minutes: duration));
    events.add(
      CalendarEvent(
        title: titles[random.nextInt(titles.length)],
        startTime: start,
        endTime: end,
        color: colors[random.nextInt(colors.length)],
        description: 'Demo event for day $day',
      ),
    );
  }
  return events;
}
