import 'package:flutter/material.dart';

/// Represents a calendar event with customizable properties.
///
/// Each event has a title, time range, color, and optional description.
/// Events can be displayed in the calendar view and planner timeline.
/// Events can be assigned to specific columns in multi-column layouts.
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
  ///   columnId: 'work', // Optional column identifier for multi-column layout
  /// );
  /// ```
  CalendarEvent({
    required this.title,
    required this.startTime,
    DateTime? endTime,
    Color? color,
    this.description,
    this.columnId,
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

  /// Optional column identifier for multi-column layout.
  ///
  /// When using multi-column layout:
  /// - Must match one of the column IDs defined in the layout
  /// - If not specified or invalid, event will be displayed in the default column
  /// - Used to organize events into specific columns (e.g., 'work', 'personal')
  /// - Helps in creating separate timelines for different event categories
  final String? columnId;

  /// Creates a new event with updated properties.
  ///
  /// Only specify the properties you want to change.
  /// All other properties will be copied from the original event.
  CalendarEvent copyWith({
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    Color? color,
    String? description,
    String? columnId,
  }) {
    return CalendarEvent(
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      description: description ?? this.description,
      columnId: columnId ?? this.columnId,
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
        other.description == description &&
        other.columnId == columnId;
  }

  @override
  int get hashCode {
    return Object.hash(title, startTime, endTime, color, description, columnId);
  }
}
