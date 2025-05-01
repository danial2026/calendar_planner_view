import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/event_model.dart';

/// A timeline view that displays events in a scrollable grid.
///
/// Features:
/// - Smart event positioning with automatic overlap handling
/// - Events with the same start time are always shown side by side in a row
/// - Customizable event display through builder pattern
/// - Flexible time range support (any start/end hour)
/// - Current time indicator for today's events
/// - Responsive grid lines for time visualization
/// - Support for custom event styling and interaction
/// - Multi-column layout support with column-specific events
/// - Automatic column width calculation
/// - Column dividers for visual separation
///
/// Example:
/// ```dart
/// EventList(
///   events: todaysEvents,
///   onEventTap: (event) => showEventDetails(event),
///   startHour: 8,
///   endHour: 18,
///   selectedDate: DateTime.now(),
///   columns: [
///     (id: 'work', title: 'Work'),
///     (id: 'personal', title: 'Personal'),
///   ],
///   eventBuilder: (context, event, ...) => CustomEventCard(...),
/// )
/// ```
class EventList extends StatelessWidget {
  /// Creates a timeline view for displaying events in a scrollable grid layout.
  /// The view supports customizable time ranges, event styling, and interaction handling.
  ///
  /// The [events] list contains all events to display for the [selectedDate].
  /// When an event is tapped, [onEventTap] is called with the event details.
  /// Use [startHour] and [endHour] to define the visible time range.
  ///
  /// For multi-column layout:
  /// - [columns] defines the column configuration with id and optional title
  /// - Events can be assigned to specific columns using [CalendarEvent.columnId]
  /// - Events without a columnId are displayed in the default column
  /// - Minimum 2 columns, maximum 10 columns
  ///
  /// Custom styling:
  /// - [titleTextStyle]: Custom text style for the event title
  /// - [timeTextStyle]: Custom text style for the event time
  /// - [descriptionTextStyle]: Custom text style for the event description
  ///
  /// Scrolling:
  /// - [scrollController]: Optional controller for timeline scrolling
  /// - [onScroll]: Callback for scroll position changes
  const EventList({
    super.key,
    required this.events,
    required this.onEventTap,
    this.startHour = 0,
    this.endHour = 24,
    this.titleTextStyle,
    this.timeTextStyle,
    this.descriptionTextStyle,
    this.eventBuilder,
    this.scrollController,
    this.onScroll,
    required this.selectedDate,
    this.columns = const [],
  });

  /// Events to display in the timeline
  final List<CalendarEvent> events;

  /// Called when an event is tapped
  final void Function(CalendarEvent)? onEventTap;

  /// First hour to show in the timeline (0-23)
  final int startHour;

  /// Last hour to show in the timeline (0-23)
  final int endHour;

  /// Text style for the event title
  final TextStyle? titleTextStyle;

  /// Text style for the event time
  final TextStyle? timeTextStyle;

  /// Text style for the event description
  final TextStyle? descriptionTextStyle;

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
  ///
  /// Note: Events with the same start time are always shown side by side in a row.
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

  /// List of column configurations for multi-column layout
  /// Each column has an id and optional title
  /// Minimum 2 columns, maximum 10 columns
  final List<({String id, String? title})> columns;

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

    // Validate column count
    if (columns.isNotEmpty && (columns.length < 2 || columns.length > 10)) {
      throw ArgumentError('Number of columns must be between 2 and 10');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final hourHeight = constraints.maxHeight / (endHour - startHour);
        final minuteHeight = (hourHeight / 60).toDouble();
        final totalHeight = hourHeight * (endHour - startHour);

        // Group events by column
        final eventsByColumn = <String, List<CalendarEvent>>{};
        if (columns.isNotEmpty) {
          // Initialize columns
          for (final column in columns) {
            eventsByColumn[column.id] = [];
          }
          // Add default column for events without columnId
          eventsByColumn['default'] = [];
        } else {
          eventsByColumn['default'] = [];
        }

        // Distribute events to columns
        for (final event in events) {
          if (columns.isNotEmpty && event.columnId != null) {
            if (eventsByColumn.containsKey(event.columnId)) {
              eventsByColumn[event.columnId]!.add(event);
            } else {
              eventsByColumn['default']!.add(event);
            }
          } else {
            eventsByColumn['default']!.add(event);
          }
        }

        // Calculate column widths
        final columnCount = columns.isNotEmpty ? columns.length : 1;
        final columnWidth = (constraints.maxWidth - 8.0) / columnCount;

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

                // Column dividers
                if (columns.isNotEmpty)
                  ...List.generate(
                    columnCount - 1,
                    (index) {
                      return Positioned(
                        top: 0,
                        bottom: 0,
                        left: 4.0 + (columnWidth * (index + 1)),
                        child: Container(
                          width: 1,
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
                      color: Theme.of(context).colorScheme.primary,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
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

                  // Determine column position
                  int columnIndex = 0;
                  if (columns.isNotEmpty) {
                    if (event.columnId != null) {
                      columnIndex = columns.indexWhere((col) => col.id == event.columnId);
                      if (columnIndex == -1) columnIndex = 0;
                    }
                  }

                  // Calculate overlapping events within the same column
                  final columnEvents = eventsByColumn[columns.isNotEmpty ? columns[columnIndex].id : 'default']!;
                  final overlapInfo = _calculateOverlappingEvents(columnEvents, startTime, endTime)[event] ?? (false, 0, 1);
                  final isOverlapping = overlapInfo.$1;
                  final overlapIndex = overlapInfo.$2;
                  final totalOverlapping = overlapInfo.$3;

                  // If there are multiple events with the same startTime, show them in a row
                  final sameStartTimeEvents = columnEvents.where((e) => e.startTime == event.startTime).toList();
                  if (sameStartTimeEvents.length > 1) {
                    final sameStartIndex = sameStartTimeEvents.indexOf(event);
                    final eventWidth = columnWidth / sameStartTimeEvents.length;
                    final eventLeft = 4.0 + (columnWidth * columnIndex) + (eventWidth * sameStartIndex);

                    return Positioned(
                      top: startMinutes * minuteHeight,
                      left: eventLeft,
                      width: eventWidth,
                      height: (duration * minuteHeight).toDouble(),
                      child: GestureDetector(
                        onTap: () => onEventTap?.call(event),
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
                              height: (duration * minuteHeight).toDouble(),
                              width: eventWidth.toDouble(),
                              titleTextStyle: titleTextStyle,
                              timeTextStyle: timeTextStyle,
                              descriptionTextStyle: descriptionTextStyle,
                            ),
                      ),
                    );
                  }

                  // Default: use overlap logic
                  final eventWidth = columnWidth / totalOverlapping;
                  final eventLeft = 4.0 + (columnWidth * columnIndex) + (eventWidth * overlapIndex);

                  return Positioned(
                    top: startMinutes * minuteHeight,
                    left: eventLeft,
                    width: eventWidth,
                    height: (duration * minuteHeight).toDouble(),
                    child: GestureDetector(
                      onTap: () => onEventTap?.call(event),
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
                            height: (duration * minuteHeight).toDouble(),
                            width: eventWidth.toDouble(),
                            titleTextStyle: titleTextStyle,
                            timeTextStyle: timeTextStyle,
                            descriptionTextStyle: descriptionTextStyle,
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
    final sortedEvents = events
        .where((event) =>
            event.startTime.year == startTime.year && event.startTime.month == startTime.month && event.startTime.day == startTime.day)
        .toList()
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
    return a.startTime == b.startTime;
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
    this.height,
    this.width,
    this.titleTextStyle,
    this.timeTextStyle,
    this.descriptionTextStyle,
  });

  /// The event to display.
  final CalendarEvent event;

  /// Whether this event overlaps with other events.
  final bool isOverlapping;

  /// The index of this event in overlapping events.
  final int overlapIndex;

  /// The total number of overlapping events.
  final int totalOverlapping;

  /// Calculated event height
  final double? height;

  /// Calculated event width
  final double? width;

  /// Text style for the event title
  final TextStyle? titleTextStyle;

  /// Text style for the event time
  final TextStyle? timeTextStyle;

  /// Text style for the event description
  final TextStyle? descriptionTextStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat.Hm();

    return Card(
      color: event.color.withAlpha(26),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: event.color,
          width: 1,
        ),
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  event.title,
                  style: titleTextStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: event.color,
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}',
                  style: timeTextStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: event.color.withAlpha(204),
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (event.description != null && height != null && height! > 60) ...[
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    event.description!,
                    style: descriptionTextStyle ??
                        theme.textTheme.bodySmall?.copyWith(
                          color: event.color.withAlpha(204),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
