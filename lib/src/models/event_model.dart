import 'package:flutter/material.dart';

/// Represents a calendar event with customizable properties.
///
/// Each event has a title, time range, color, and optional properties like ID, description,
/// and column assignment. Events can be displayed in the calendar view and planner timeline.
/// Events can be assigned to specific columns in multi-column layouts.
///
/// The event model supports:
/// * Required properties: title, startTime
/// * Optional properties: id, endTime, color, description, columnId
/// * Default values: endTime (1 hour after start), color (blue)
/// * Immutable design for thread safety
/// * Equality comparison and hash code generation
class CalendarEvent {
  /// Creates a calendar event.
  ///
  /// Required parameters:
  /// * [title] - The event title to display
  /// * [startTime] - When the event begins
  ///
  /// Optional parameters:
  /// * [id] - Unique identifier for the event (useful for tracking and updates)
  /// * [endTime] - When the event ends (defaults to 1 hour after start)
  /// * [color] - Event display color (defaults to blue)
  /// * [description] - Additional event details or notes
  /// * [columnId] - Column assignment for multi-column layout
  ///
  /// Example:
  /// final event = CalendarEvent(
  ///   id: 'meeting_123', // Optional unique identifier
  ///   title: 'Team Meeting',
  ///   startTime: DateTime(2024, 3, 15, 10, 0), // March 15, 2024, 10:00 AM
  ///   endTime: DateTime(2024, 3, 15, 11, 0),   // March 15, 2024, 11:00 AM
  ///   color: Colors.blue,
  ///   description: 'Weekly team sync meeting',
  ///   columnId: 'work', // Optional column identifier
  /// );
  CalendarEvent({
    required this.title,
    required this.startTime,
    this.id,
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

  /// Optional unique identifier for the event.
  ///
  /// The ID can be used to:
  /// * Track events across updates
  /// * Identify events in callbacks
  /// * Link events to external data
  /// * Support event persistence
  final String? id;

  /// Event display color (defaults to blue)
  final Color color;

  /// Optional event description or notes
  final String? description;

  /// Optional column identifier for multi-column layout.
  ///
  /// When using multi-column layout:
  /// * Must match one of the column IDs defined in the layout
  /// * If not specified or invalid, event will be displayed in the default column
  /// * Used to organize events into specific columns
  /// * Helpful for creating separate timelines for different event categories
  final String? columnId;

  /// Creates a new event with updated properties.
  ///
  /// This method creates a new event instance with the specified properties
  /// updated while keeping all other properties the same as the original event.
  ///
  /// Example:
  /// final updatedEvent = event.copyWith(
  ///   title: 'Updated Meeting Title',
  ///   color: Colors.red,
  /// );
  CalendarEvent copyWith({
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    String? id,
    Color? color,
    String? description,
    String? columnId,
  }) {
    return CalendarEvent(
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      id: id ?? this.id,
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
        other.id == id &&
        other.color == color &&
        other.description == description &&
        other.columnId == columnId;
  }

  @override
  int get hashCode {
    return Object.hash(title, startTime, endTime, id, color, description, columnId);
  }
}
