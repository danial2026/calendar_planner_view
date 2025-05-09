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
class CustomJapaneseEventsDemo extends StatefulWidget {
  const CustomJapaneseEventsDemo({super.key});

  @override
  State<CustomJapaneseEventsDemo> createState() => _CustomJapaneseEventsDemoState();
}

class _CustomJapaneseEventsDemoState extends State<CustomJapaneseEventsDemo> {
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

  /// Japanese weekday names (月, 火, 水, 木, 金, 土, 日)
  static const List<String> japaneseWeekdays = ['月', '火', '水', '木', '金', '土', '日'];

  /// Japanese month names
  static const List<String> japaneseMonths = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(const Duration(seconds: 2), () {
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
        events: _loading ? [] : mockEvents,
        onEventTap: (event) => _onEventTap(context, event),
        eventBuilder: _customEventBuilder,
        datePickerPosition: DatePickerPosition.top,
        startHour: 8,
        endHour: 20,
        showDayTitle: false,
        enableViewToggle: true,
        calendarTitle: 'カレンダー',
        initialView: CalendarViewType.week,
        modalTitle: "日付を選択",
        dropdownLabel: "選択",
        dropdownAllLabel: "すべて",
        monthLabelText: '月',
        weekLabelText: '週',
        todayLabel: '日',
        tomorrowLabel: '明日',
        yesterdayLabel: '昨日',
        weekdayNames: japaneseWeekdays,
        monthNames: japaneseMonths,
        dotColor: Colors.pink[300],
        dotSize: 5.0,
        showColumnHeadersInDropdownAllOption: true,
        toggleColorBackground: Colors.red[300],
        showCurrentTimeIndicator: true,
        toggleColor: Colors.black87,
        calendarBackgroundColor: Colors.transparent,
        todayContainerColor: Colors.red[300]?.withAlpha(15),
        selectedContainerColor: Colors.red[400]?.withAlpha(70),
        modalHeaderGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.redAccent.withAlpha(75),
            Colors.white,
          ],
        ),
        timeLabelWidth: 55,
        timeLabelType: TimeLabelType.hourAndHalf,
        modalTitleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
        modalTodayButtonTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.black87,
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
        timeLabelBuilder: (DateTime time) {
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
        columnLabelType: ColumnLabelType.dropdown,
        loadingBuilder: (context) => Center(child: CircularProgressIndicator(color: Colors.pink[300])),
        scrollController: scrollController,
        isLoading: _loading,
        loadingOverlayColor: Colors.black12,
      ),
    );
  }
}
