import 'package:flutter/material.dart';

/// Represents a calendar event with customizable properties.
///
/// Each event has a title, time range, color, and optional description.
/// Events can be displayed in the calendar view and planner timeline.
class CalendarEvent {
  /// Creates a calendar event.
  ///
  /// Example:
  /// ```dart
  /// final event = CalendarEvent(
  ///   title: 'Team Meeting',
  ///   startTime: DateTime(2024, 3, 15, 10, 0), // March 15, 2024, 10:00 AM
  ///   endTime: DateTime(2024, 3, 15, 11, 0),   // March 15, 2024, 11:00 AM
  ///   color: Colors.blue,
  ///   description: 'Weekly team sync meeting',
  /// );
  /// ```
  CalendarEvent({
    required this.title,
    required this.startTime,
    DateTime? endTime,
    Color? color,
    this.description,
  })  : endTime = endTime ?? startTime.add(const Duration(hours: 1)),
        color = color ?? Colors.blue;

  /// Event title displayed in the calendar
  final String title;

  /// Event start time and date
  final DateTime startTime;

  /// Event end time and date (defaults to 1 hour after start time)
  final DateTime endTime;

  /// Event display color (defaults to blue)
  final Color color;

  /// Optional event description or notes
  final String? description;

  /// Creates a new event with updated properties.
  ///
  /// Only specify the properties you want to change.
  CalendarEvent copyWith({
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    Color? color,
    String? description,
  }) {
    return CalendarEvent(
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalendarEvent &&
        other.title == title &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.color == color &&
        other.description == description;
  }

  @override
  int get hashCode {
    return Object.hash(title, startTime, endTime, color, description);
  }
}
