import 'package:flutter/material.dart';
import 'package:calendar_planner_view/calendar_planner_view.dart';
import '../mock_events.dart';

/// A demo showcasing Turkish localization and custom event styling.
///
/// Features:
/// - Turkish month/weekday names and translations
/// - Deep purple & teal color scheme
/// - Minimalist event design with subtle shadows
/// - Customized dropdown styling with rounded borders
/// - Turkish column labels (İş, Kişisel, Toplantılar)
/// - Localized loading indicator and modal dialogs
/// - Responsive layout for Turkish text characteristics
/// - Custom time formatting (24-hour format)
class CustomTurkishEventsDemo extends StatefulWidget {
  const CustomTurkishEventsDemo({super.key});

  @override
  State<CustomTurkishEventsDemo> createState() => _CustomTurkishEventsDemoState();
}

class _CustomTurkishEventsDemoState extends State<CustomTurkishEventsDemo> {
  /// Shows event details in a Turkish-formatted dialog
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

  /// Custom event builder with Turkish-optimized layout:
  /// - Rounded corners (8px radius)
  /// - Subtle shadow effects
  /// - Responsive text sizing for Turkish characters
  /// - Color-coded titles with semi-transparent backgrounds
  /// - Space-efficient layout for longer Turkish words
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
        color: event.color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: event.color.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onEventTap(context, event),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: event.color,
                    fontWeight: FontWeight.w600,
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
    );
  }

  /// Loading state for the calendar
  bool _loading = true;

  /// Turkish weekday abbreviations (Pazartesi -> Pzt)
  static const List<String> turkishWeekdays = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  /// Full Turkish month names (Ocak = January)
  static const List<String> turkishMonths = [
    'Ocak', // January
    'Şubat', // February
    'Mart', // March
    'Nisan', // April
    'Mayıs', // May
    'Haziran', // June
    'Temmuz', // July
    'Ağustos', // August
    'Eylül', // September
    'Ekim', // October
    'Kasım', // November
    'Aralık' // December
  ];

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
        title: const Text('Özel Takvim Görünümü'),
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
        calendarTitle: 'Takvim',
        initialView: CalendarViewType.week,
        modalTitle: "Tarih Seçiniz",
        dropdownLabel: "seçme",
        dropdownAllLabel: "Tümü",
        monthLabelText: 'Ay',
        weekLabelText: 'Hafta',
        todayLabel: 'Bugün',
        tomorrowLabel: 'Yarın',
        yesterdayLabel: 'Dün',
        weekdayNames: turkishWeekdays,
        monthNames: turkishMonths,
        dotColor: Colors.deepPurple[300],
        dotSize: 5.0,
        showColumnHeadersInDropdownAllOption: true,
        toggleColorBackground: Colors.deepPurple,
        showCurrentTimeIndicator: true,
        toggleColor: Colors.black87,
        calendarBackgroundColor: Colors.transparent,
        todayContainerColor: Colors.deepPurple.withAlpha(15),
        selectedContainerColor: Colors.teal.withAlpha(70),
        timeLabelWidth: 55,
        timeLabelType: TimeLabelType.hourAndHalf,
        modalTitleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
        modalTodayButtonTextStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.deepPurple[300],
              fontWeight: FontWeight.w600,
            ),
        calendarTitleStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.deepPurple,
              fontWeight: FontWeight.w800,
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
              color: Colors.grey[700],
            ),
        timeLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[700],
            ),
        columnTitleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.deepPurple,
              fontWeight: FontWeight.w600,
            ),
        modalShowCloseButton: false,
        modalBackgroundColor: Colors.white,
        dropdownBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.deepPurple.withAlpha(30)),
        ),
        dropdownPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        columns: const [
          (id: 'work', title: 'İş'),
          (id: 'personal', title: 'Kişisel'),
          (id: 'meetings', title: 'Toplantılar'),
        ],
        columnLabelType: ColumnLabelType.dropdown,
        loadingBuilder: (context) => Center(child: CircularProgressIndicator(color: Colors.deepPurple[300])),
        scrollController: scrollController,
        isLoading: _loading,
        loadingOverlayColor: Colors.black12,
      ),
    );
  }
}
