import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/event_model.dart';

/// A timeline view that displays events in a scrollable grid.
///
/// Features:
/// - Smart event positioning with automatic overlap handling
/// - Customizable event display through builder pattern
/// - Flexible time range support (any start/end hour)
/// - Current time indicator for today's events
/// - Responsive grid lines for time visualization
/// - Support for custom event styling and interaction
///
/// Example:
/// ```dart
/// EventList(
///   events: todaysEvents,
///   onEventTap: (event) => showEventDetails(event),
///   startHour: 8,
///   endHour: 18,
///   selectedDate: DateTime.now(),
///   eventBuilder: (context, event, ...) => CustomEventCard(...),
/// )
/// ```
class EventList extends StatelessWidget {
  /// Creates a timeline view for displaying events.
  ///
  /// The [events] list contains all events to display for the [selectedDate].
  /// When an event is tapped, [onEventTap] is called with the event details.
  /// Use [startHour] and [endHour] to define the visible time range.
  const EventList({
    super.key,
    required this.events,
    required this.onEventTap,
    this.startHour = 0,
    this.endHour = 24,
    this.eventBuilder,
    this.scrollController,
    this.onScroll,
    required this.selectedDate,
  });

  /// Events to display in the timeline
  final List<CalendarEvent> events;

  /// Called when an event is tapped
  final void Function(CalendarEvent) onEventTap;

  /// First hour to show in the timeline (0-23)
  final int startHour;

  /// Last hour to show in the timeline (0-23)
  final int endHour;

  /// Custom builder for event display
  ///
  /// Parameters:
  /// - context: Build context
  /// - event: Event to display
  /// - startTime: Event start time
  /// - endTime: Event end time
  /// - duration: Event duration in minutes
  /// - height: Calculated event height
  /// - width: Available event width
  /// - isOverlapping: Whether event overlaps with others
  /// - overlapIndex: Position in overlapping group (0-based)
  /// - totalOverlapping: Total events in overlap group
  final Widget Function(
    BuildContext context,
    CalendarEvent event, {
    required DateTime startTime,
    required DateTime endTime,
    required int duration,
    required double height,
    required double width,
    required bool isOverlapping,
    required int overlapIndex,
    required int totalOverlapping,
  })? eventBuilder;

  /// Controls timeline scrolling
  final ScrollController? scrollController;

  /// Called when timeline scroll position changes
  final void Function(ScrollPosition)? onScroll;

  /// Date being displayed in the timeline
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      0, // Always start from 00:00
    );
    final endTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      24, // Always end at 24:00
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final hourHeight = constraints.maxHeight / (endHour - startHour);
        final minuteHeight = (hourHeight / 60).toDouble();
        final totalHeight = hourHeight * (endHour - startHour);

        // Calculate overlapping events
        final overlappingEvents = _calculateOverlappingEvents(events, startTime, endTime);

        return SingleChildScrollView(
          controller: scrollController,
          child: SizedBox(
            height: totalHeight,
            child: Stack(
              children: [
                // Time grid lines
                ...List.generate(
                  endHour - startHour + 1,
                  (index) {
                    return Positioned(
                      top: index * hourHeight,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: Colors.grey[800],
                      ),
                    );
                  },
                ),

                // Current time indicator (only for today)
                if (events.isNotEmpty && selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day)
                  Positioned(
                    top: ((now.hour - startHour) * 60 + now.minute) * minuteHeight,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 1,
                      color: Colors.white,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                // Events
                ...events.map((event) {
                  if (event.startTime.isBefore(startTime) || event.endTime.isAfter(endTime)) {
                    return const SizedBox.shrink();
                  }

                  final startMinutes = (event.startTime.hour * 60 + event.startTime.minute - startHour * 60).toDouble();
                  final endMinutes = (event.endTime.hour * 60 + event.endTime.minute - startHour * 60).toDouble();
                  final duration = (endMinutes - startMinutes).toDouble();

                  final overlapInfo = overlappingEvents[event] ?? (false, 0, 1);
                  final isOverlapping = overlapInfo.$1;
                  final overlapIndex = overlapInfo.$2;
                  final totalOverlapping = overlapInfo.$3;

                  final eventWidth =
                      isOverlapping ? (constraints.maxWidth - 8.0) / totalOverlapping.toDouble() : constraints.maxWidth - 8.0;
                  final eventLeft = isOverlapping ? 4.0 + (eventWidth * overlapIndex.toDouble()) : 4.0;

                  return Positioned(
                    top: startMinutes * minuteHeight,
                    left: eventLeft,
                    width: eventWidth,
                    child: GestureDetector(
                      onTap: () => onEventTap(event),
                      child: eventBuilder?.call(
                            context,
                            event,
                            startTime: event.startTime,
                            endTime: event.endTime,
                            duration: duration.toInt(),
                            height: (duration * minuteHeight).toDouble(),
                            width: eventWidth.toDouble(),
                            isOverlapping: isOverlapping,
                            overlapIndex: overlapIndex,
                            totalOverlapping: totalOverlapping,
                          ) ??
                          DefaultEventCard(
                            event: event,
                            isOverlapping: isOverlapping,
                            overlapIndex: overlapIndex,
                            totalOverlapping: totalOverlapping,
                          ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Map<CalendarEvent, (bool, int, int)> _calculateOverlappingEvents(
    List<CalendarEvent> events,
    DateTime startTime,
    DateTime endTime,
  ) {
    final result = <CalendarEvent, (bool, int, int)>{};
    final sortedEvents = events.where((event) => !event.startTime.isBefore(startTime) && !event.endTime.isAfter(endTime)).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    for (var i = 0; i < sortedEvents.length; i++) {
      final event = sortedEvents[i];
      var overlapCount = 1;
      var overlapIndex = 0;

      for (var j = 0; j < i; j++) {
        final otherEvent = sortedEvents[j];
        if (_doEventsOverlap(event, otherEvent)) {
          overlapCount++;
          if (result[otherEvent]!.$2 == overlapIndex) {
            overlapIndex++;
          }
        }
      }

      result[event] = (overlapCount > 1, overlapIndex, overlapCount);
    }

    return result;
  }

  bool _doEventsOverlap(CalendarEvent a, CalendarEvent b) {
    return a.startTime.isBefore(b.endTime) && b.startTime.isBefore(a.endTime);
  }
}

/// A default event card widget that displays event information.
class DefaultEventCard extends StatelessWidget {
  /// Creates a new default event card.
  const DefaultEventCard({
    super.key,
    required this.event,
    this.isOverlapping = false,
    this.overlapIndex = 0,
    this.totalOverlapping = 1,
  });

  /// The event to display.
  final CalendarEvent event;

  /// Whether this event overlaps with other events.
  final bool isOverlapping;

  /// The index of this event in overlapping events.
  final int overlapIndex;

  /// The total number of overlapping events.
  final int totalOverlapping;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat.Hm();

    return Card(
      color: event.color.withAlpha(26),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: event.color,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: event.color,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: event.color.withAlpha(204),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (event.description != null) ...[
              const SizedBox(height: 4),
              Text(
                event.description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: event.color.withAlpha(204),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
