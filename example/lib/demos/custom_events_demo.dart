import 'package:flutter/material.dart';
import 'package:calendar_planner_view/calendar_planner_view.dart';
import '../mock_events.dart';

/// A demo showcasing custom event styling and loading overlay.
///
/// Features:
/// - Custom event builder with color-coded events
/// - Loading overlay with customizable appearance
/// - Event details dialog
/// - Multi-column layout
/// - Custom time label formatting
/// - Theme-aware styling
class CustomEventsDemo extends StatefulWidget {
  const CustomEventsDemo({super.key});

  @override
  State<CustomEventsDemo> createState() => _CustomEventsDemoState();
}

class _CustomEventsDemoState extends State<CustomEventsDemo> {
  /// Shows event details in a dialog when an event is tapped
  void _onEventTap(BuildContext context, CalendarEvent event) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: event.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                event.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  '${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} - '
                  '${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (event.description != null) ...[
              const SizedBox(height: 12),
              Text(
                event.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Custom builder for event items with color-coded styling
  Widget _customEventBuilder(
    BuildContext context,
    CalendarEvent event, {
    required int duration,
    required DateTime endTime,
    required double height,
    required bool isOverlapping,
    required int overlapIndex,
    required DateTime startTime,
    required int totalOverlapping,
    required double width,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        color: event.color.withAlpha(51),
        border: Border.all(
          color: event.color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onEventTap(context, event),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: SizedBox(
              width: width,
              height: height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      event.title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: event.color,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (event.description != null && height > 30) ...[
                    const SizedBox(height: 2),
                    Flexible(
                      child: Text(
                        event.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: event.color.withAlpha(26),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Loading state for the calendar
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Events Demo'),
      ),
      body: CalendarPlannerView(
        events: mockEvents,
        onEventTap: (event) => _onEventTap(context, event),
        eventBuilder: _customEventBuilder,
        datePickerPosition: DatePickerPosition.top,
        startHour: 8,
        endHour: 20,
        showDayTitle: false,
        enableViewToggle: true,
        calendarTitle: 'Bookings',
        initialView: CalendarViewType.week,
        dotColor: Colors.pink[300],
        dotSize: 5.0,
        showCurrentTimeIndicator: true,
        customToggleColor: Colors.black87,
        calendarBackgroundColor: Colors.transparent,
        todayContainerColor: Colors.pink[300]?.withOpacity(0.2),
        selectedContainerColor: Colors.red[400]?.withOpacity(0.7),
        timeLabelWidth: 55,
        modalTitleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
        modalTodayButtonTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.pink[300],
              fontWeight: FontWeight.w600,
            ),
        calendarTitleStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
        dayTitleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
        customTimeLabelBuilder: (DateTime time) {
          return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        },
        dayNumberStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black87,
            ),
        weekdayLabelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
        monthLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
        timeTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black87,
            ),
        timeLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
        columnTitleStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
        modalShowCloseButton: false,
        modalBackgroundColor: Colors.white,
        columns: const [
          (id: 'work', title: 'Work'),
          (id: 'personal', title: 'Personal'),
          (id: 'meetings', title: 'Meetings'),
        ],
        loadingBuilder: (context) => Center(child: CircularProgressIndicator(color: Colors.pink[300])),
        scrollController: scrollController,
        isLoading: _loading,
        loadingOverlayColor: Colors.black12,
      ),
    );
  }
}
