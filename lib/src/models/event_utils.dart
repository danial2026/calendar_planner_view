import 'package:flutter/material.dart';
import 'event_model.dart';
import '../utils/date_utils.dart';
import 'calendar_enums.dart';

/// Helper functions for event handling in the calendar.
///
/// This utility class provides methods for managing calendar events, including:
/// - Event counting and filtering
/// - Event dot visualization
/// - Overlap detection and handling
/// - Position calculations for event display
///
/// The class is designed to work with the [CalendarEvent] model and provides
/// consistent event handling across the calendar components.
///
/// Example:
/// Count events for a specific day:
/// final eventCount = EventUtils.countEventsForDay(selectedDate, events);
///
/// uild event dots widget:
/// final dots = EventUtils.buildEventDots(
///   count: eventCount,
///   color: Colors.blue,
///   dotSize: 5.0,
///   shape: EventDotShape.circle,
/// );
///
/// Filter events for a date
/// final dayEvents = EventUtils.filterEventsForDate(selectedDate, events);
class EventUtils {
  /// Count events for a given day.
  ///
  /// Returns the number of events that occur on the specified day.
  /// Events are considered to occur on a day if their start time
  /// falls on that day.
  static int countEventsForDay(DateTime day, List<CalendarEvent> events) {
    return events.where((event) => CalendarDateUtils.isSameDay(event.startTime, day)).length;
  }

  /// Build event dots widget.
  ///
  /// Creates a row of dots representing the number of events for a day.
  /// Features:
  /// - Maximum of 4 dots displayed
  /// - Customizable dot shape (circle, square, diamond)
  /// - Consistent spacing and alignment
  /// - Theme-aware styling
  static Widget buildEventDots({
    required int count,
    required Color color,
    required double dotSize,
    required EventDotShape shape,
  }) {
    if (count == 0) return const SizedBox.shrink();
    final dotCount = count > 4 ? 4 : count;
    final boxShape = shape == EventDotShape.circle ? BoxShape.circle : BoxShape.rectangle;

    return Padding(
      padding: const EdgeInsets.only(top: 36.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          dotCount,
          (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: color,
              shape: boxShape,
              borderRadius: shape == EventDotShape.diamond ? BorderRadius.circular(dotSize / 2) : null,
            ),
            transform: shape == EventDotShape.diamond
                ? Matrix4.rotationZ(0.785398) // 45 degrees in radians
                : null,
          ),
        ),
      ),
    );
  }

  /// Filter events for a specific date.
  ///
  /// Returns a list of events that occur on the specified date.
  /// Events are considered to occur on a date if their start time
  /// falls on that date.
  static List<CalendarEvent> filterEventsForDate(DateTime date, List<CalendarEvent> events) {
    return events.where((event) => CalendarDateUtils.isSameDay(event.startTime, date)).toList();
  }

  /// Check if an event overlaps with any other events.
  ///
  /// Returns true if the event's time range overlaps with any other
  /// event in the list. An event is considered to overlap if:
  /// - It starts before another event ends AND
  /// - It ends after another event starts
  static bool doesEventOverlap(CalendarEvent event, List<CalendarEvent> events) {
    return events.any((otherEvent) {
      if (event == otherEvent) return false;
      return event.startTime.isBefore(otherEvent.endTime) && event.endTime.isAfter(otherEvent.startTime);
    });
  }

  /// Get overlapping events for a given event.
  ///
  /// Returns a list of events that overlap with the specified event.
  /// The returned list excludes the event itself and includes all
  /// events that share any time with the specified event.
  static List<CalendarEvent> getOverlappingEvents(CalendarEvent event, List<CalendarEvent> events) {
    return events.where((otherEvent) {
      if (event == otherEvent) return false;
      return event.startTime.isBefore(otherEvent.endTime) && event.endTime.isAfter(otherEvent.startTime);
    }).toList();
  }

  /// Calculate event position and dimensions.
  ///
  /// Returns a map containing the calculated position and size of an event
  /// within its container. The calculation takes into account:
  /// - Event start and end times
  /// - Container dimensions
  /// - Day start and end times
  ///
  /// Returns a map with:
  /// - 'top': Distance from the top of the container
  /// - 'height': Height of the event
  /// - 'width': Width of the event
  static Map<String, double> calculateEventPosition({
    required DateTime eventStart,
    required DateTime eventEnd,
    required DateTime dayStart,
    required DateTime dayEnd,
    required double containerHeight,
    required double containerWidth,
  }) {
    final dayDuration = dayEnd.difference(dayStart).inMinutes;
    final eventStartMinutes = eventStart.difference(dayStart).inMinutes;
    final eventDuration = eventEnd.difference(eventStart).inMinutes;

    final top = (eventStartMinutes / dayDuration) * containerHeight;
    final height = (eventDuration / dayDuration) * containerHeight;
    final width = containerWidth;

    return {
      'top': top,
      'height': height,
      'width': width,
    };
  }

  /// Filter events for a specific column.
  ///
  /// Returns a list of events that belong to the specified column.
  /// The events are filtered based on the column's id.
  static List<CalendarEvent> filterEventsForColumn(String columnId, List<CalendarEvent> events) {
    return events.where((event) => event.columnId == columnId).toList();
  }
}
