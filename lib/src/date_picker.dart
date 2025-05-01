import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:table_calendar/table_calendar.dart';
import 'models/calendar_enums.dart';
import 'models/event_model.dart';
import 'utils/date_utils.dart';
import 'utils/style_utils.dart';
import 'models/event_utils.dart';

/// Professional calendar date selection widget with extensive customization.
///
/// Features:
/// - Month and week view support with smooth transitions
/// - Gesture-based view switching (pull up/down)
/// - Horizontal swipe for month navigation
/// - Event indicators with customizable appearance
/// - Custom styling for all calendar elements
/// - Localization support
/// - Responsive design
/// - Theme-aware styling
/// - Customizable cell shapes and borders
/// - Week number display
/// - Custom month and weekday names
///
/// The widget is designed to work seamlessly with [CalendarPlannerView]
/// but can also be used independently. It supports both inline and modal
/// display modes, with extensive customization options for appearance
/// and behavior.
///
/// Example:
/// ```dart
/// FlexibleDatePicker(
///   selectedDate: DateTime.now(),
///   onDateChanged: (date) => setState(() => _selected = date),
///   onCalendarFormatChanged: (format) => setState(() => _format = format),
///   displayMode: DatePickerDisplayMode.inline,
///   events: myEvents,
///   dotColor: Colors.blue,
///   cellShape: BoxShape.circle,
///   locale: 'en_US',
/// )
/// ```
class FlexibleDatePicker extends HookWidget {
  /// Creates a flexible date picker with extensive customization options.
  ///
  /// The widget supports two display modes:
  /// - [DatePickerDisplayMode.inline]: Calendar is displayed directly in the widget tree
  /// - [DatePickerDisplayMode.popup]: Calendar is shown in a popup dialog
  ///
  /// The calendar features:
  /// - Smooth transitions between month and week views
  /// - Gesture-based view switching (pull up/down)
  /// - Horizontal swipe for month navigation
  /// - Customizable cell shapes (circle, rectangle)
  /// - Event indicators with dots
  /// - Week number display
  /// - Localized month and weekday names
  /// - Theme-aware styling
  /// - Responsive layout
  ///
  /// All styling options are optional and will fall back to theme defaults
  /// if not specified. The widget is designed to work well with both light
  /// and dark themes.
  const FlexibleDatePicker({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
    this.displayMode = DatePickerDisplayMode.inline,
    this.minDate,
    this.maxDate,
    this.calendarView = CalendarFormat.month,
    this.onCalendarFormatChanged,
    this.headerStyle,
    this.dayStyle,
    this.monthTitleStyle,
    this.weekdayLabelStyle,
    this.dayNumberStyle,
    this.weekNumberStyle,
    this.locale = 'en_US',
    this.cellShape = BoxShape.circle,
    this.cellBorderRadius,
    this.events = const [],
    this.dotColor,
    this.dotSize = 5.0,
    this.eventDotShape = EventDotShape.circle,
    this.monthNames,
    this.weekdayNames,
    this.weekLabelText = 'Week',
    this.todayLabel = 'Today',
    this.weekNumberBackgroundColor,
    this.weekNumberTextColor,
    this.weekNumberBorderRadius = 16.0,
    this.weekNumberPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.weekNumberTextStyle,
    this.weekNumberContainerStyle,
    this.chevronIconColor,
    this.chevronIconSize = 24.0,
    this.chevronIconPadding = const EdgeInsets.all(8.0),
    this.chevronIconStyle,
    this.calendarPadding = const EdgeInsets.all(8.0),
    this.calendarMargin = const EdgeInsets.all(8.0),
    this.calendarBackgroundColor = Colors.transparent,
    this.calendarBorderRadius,
    this.calendarBorder,
    this.calendarShadowColor,
    this.calendarShadowBlurRadius = 4.0,
    this.calendarShadowOffset = const Offset(0, 2),
  }) : super(key: key);

  /// Currently selected date
  final DateTime selectedDate;

  /// Callback when a new date is selected
  final ValueChanged<DateTime> onDateChanged;

  /// Callback when calendar format changes (month/week)
  /// This is called when the view changes either through the toggle button
  /// or through gesture-based switching.
  final ValueChanged<CalendarFormat>? onCalendarFormatChanged;

  /// How the picker should be displayed
  final DatePickerDisplayMode displayMode;

  /// Earliest selectable date (defaults to 1 year before selected date)
  final DateTime? minDate;

  /// Latest selectable date (defaults to 1 year after selected date)
  final DateTime? maxDate;

  /// Calendar view format (month or week)
  final CalendarFormat calendarView;

  /// Custom header styling
  final HeaderStyle? headerStyle;

  /// Styling for calendar cells
  final CalendarStyle? dayStyle;

  /// Style for month title
  final TextStyle? monthTitleStyle;

  /// Style for weekday labels
  final TextStyle? weekdayLabelStyle;

  /// Style for day numbers
  final TextStyle? dayNumberStyle;

  /// Style for week number indicator
  final TextStyle? weekNumberStyle;

  /// Localization setting
  final String locale;

  /// Shape of date cells
  final BoxShape cellShape;

  /// Border radius for rectangular cell shapes
  final BorderRadius? cellBorderRadius;

  /// Events to display in the calendar
  final List<CalendarEvent> events;

  /// Color for event indicator dots
  final Color? dotColor;

  /// Size of event indicator dots
  final double dotSize;

  /// Shape of event indicator dots
  final EventDotShape eventDotShape;

  /// Custom month names
  final List<String>? monthNames;

  /// Custom weekday names
  final List<String>? weekdayNames;

  /// Label for week view and week numbers
  final String weekLabelText;

  /// Label for today's date
  final String todayLabel;

  /// Background color for week number container
  final Color? weekNumberBackgroundColor;

  /// Text color for week number
  final Color? weekNumberTextColor;

  /// Border radius for week number container
  final double weekNumberBorderRadius;

  /// Padding for week number container
  final EdgeInsets weekNumberPadding;

  /// Text style for week number
  final TextStyle? weekNumberTextStyle;

  /// Container style for week number
  final BoxDecoration? weekNumberContainerStyle;

  /// Color for chevron icons
  final Color? chevronIconColor;

  /// Size for chevron icons
  final double chevronIconSize;

  /// Padding for chevron icons
  final EdgeInsets chevronIconPadding;

  /// Style for chevron icons
  final IconThemeData? chevronIconStyle;

  /// Padding for calendar
  final EdgeInsets calendarPadding;

  /// Margin for calendar
  final EdgeInsets calendarMargin;

  /// Background color for calendar
  final Color? calendarBackgroundColor;

  /// Border radius for calendar
  final BorderRadius? calendarBorderRadius;

  /// Border for calendar
  final BoxBorder? calendarBorder;

  /// Shadow color for calendar
  final Color? calendarShadowColor;

  /// Shadow blur radius for calendar
  final double calendarShadowBlurRadius;

  /// Shadow offset for calendar
  final Offset calendarShadowOffset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calendarFormat = useState(calendarView);
    final dragStartY = useState<double?>(null);
    final dragDistance = useState<double>(0);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    // Update calendar format when prop changes (e.g., when toggle button is pressed)
    useEffect(() {
      calendarFormat.value = calendarView;
      return null;
    }, [calendarView]);

    // Constants for gesture control
    const maxDragDistance = 150.0; // Maximum distance the calendar can be dragged
    const dragThreshold = 80.0; // Distance required to trigger view change
    const dragDamping = 0.5; // Resistance applied to drag movement

    // Count events for a given day
    int eventCountForDay(DateTime day) {
      return EventUtils.countEventsForDay(day, events);
    }

    // Event dots builder
    Widget Function(BuildContext, DateTime, DateTime) eventDotsBuilder = (context, day, focusedDay) {
      final count = eventCountForDay(day);
      return EventUtils.buildEventDots(
        count: count,
        color: dotColor ?? theme.colorScheme.primary,
        dotSize: dotSize,
        shape: eventDotShape,
      );
    };

    // Default styling configurations
    final defaultHeaderStyle = CalendarStyleUtils.getDefaultHeaderStyle(
      theme,
      monthTitleStyle: monthTitleStyle,
      chevronIconColor: chevronIconColor,
      chevronIconSize: chevronIconSize,
      chevronPadding: chevronIconPadding,
    );

    final defaultCalendarStyle = CalendarStyleUtils.getDefaultCalendarStyle(
      theme,
      cellShape: cellShape,
      cellBorderRadius: cellBorderRadius,
    );

    return GestureDetector(
      onVerticalDragStart: (details) {
        dragStartY.value = details.globalPosition.dy;
      },
      onVerticalDragUpdate: (details) {
        if (dragStartY.value != null) {
          final delta = dragStartY.value! - details.globalPosition.dy;
          // Allow both upward and downward drags based on current view
          if ((calendarFormat.value == CalendarFormat.month && delta > 0) || (calendarFormat.value == CalendarFormat.week && delta < 0)) {
            // Apply damping and limit maximum drag distance
            final dampedDelta = delta * dragDamping;
            dragDistance.value = delta > 0 ? dampedDelta.clamp(0, maxDragDistance) : dampedDelta.clamp(-maxDragDistance, 0);
          }
        }
      },
      onVerticalDragEnd: (details) {
        if (calendarFormat.value == CalendarFormat.month && dragDistance.value > dragThreshold) {
          // Switch to week view
          calendarFormat.value = CalendarFormat.week;
          onCalendarFormatChanged?.call(CalendarFormat.week);
          animationController.forward();
        } else if (calendarFormat.value == CalendarFormat.week && dragDistance.value < -dragThreshold) {
          // Switch to month view
          calendarFormat.value = CalendarFormat.month;
          onCalendarFormatChanged?.call(CalendarFormat.month);
          animationController.forward();
        } else {
          // Spring back to original position
          animationController.reverse();
        }
        dragStartY.value = null;
        dragDistance.value = 0;
      },
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -dragDistance.value * 0.3), // Reduced movement multiplier for more control
            child: Container(
              padding: calendarPadding,
              margin: calendarMargin,
              decoration: CalendarStyleUtils.getDefaultCalendarDecoration(
                theme,
                backgroundColor: calendarBackgroundColor,
                borderRadius: calendarBorderRadius,
                border: calendarBorder,
                shadowColor: calendarShadowColor,
                shadowBlurRadius: calendarShadowBlurRadius,
                shadowOffset: calendarShadowOffset,
              ),
              child: TableCalendar(
                availableGestures: AvailableGestures.horizontalSwipe,
                firstDay: minDate ?? DateTime(selectedDate.year - 1),
                lastDay: maxDate ?? DateTime(selectedDate.year + 1),
                focusedDay: selectedDate,
                selectedDayPredicate: (day) => CalendarDateUtils.isSameDay(selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  onDateChanged(DateTime(selectedDay.year, selectedDay.month, selectedDay.day));
                },
                calendarFormat: calendarFormat.value,
                headerStyle: headerStyle ?? defaultHeaderStyle,
                calendarStyle: dayStyle ?? defaultCalendarStyle,
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) => eventDotsBuilder(context, day, day),
                  headerTitleBuilder: (context, day) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        CalendarDateUtils.getMonthName(day, monthNames: monthNames).toUpperCase(),
                        style: monthTitleStyle ??
                            theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: theme.colorScheme.onSurface,
                            ),
                      ),
                      if (calendarFormat.value == CalendarFormat.week) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: weekNumberPadding,
                          decoration: weekNumberContainerStyle ??
                              CalendarStyleUtils.getDefaultWeekNumberDecoration(
                                theme,
                                backgroundColor: weekNumberBackgroundColor,
                                borderRadius: weekNumberBorderRadius,
                              ),
                          child: Text(
                            '$weekLabelText ${CalendarDateUtils.getWeekNumber(day)}',
                            style: weekNumberTextStyle ??
                                weekNumberStyle ??
                                theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: weekNumberTextColor ?? theme.colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  dowBuilder: (context, day) => Center(
                    child: Text(
                      CalendarDateUtils.getWeekdayName(day, weekdayNames: weekdayNames),
                      style: weekdayLabelStyle ??
                          theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface.withAlpha(153),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  defaultBuilder: (context, day, focusedDay) => Center(
                    child: Text(
                      '${day.day}',
                      style: dayNumberStyle ??
                          theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                  ),
                  outsideBuilder: (context, day, focusedDay) => Center(
                    child: Text(
                      '${day.day}',
                      style: dayNumberStyle ??
                          theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(102),
                          ),
                    ),
                  ),
                ),
                locale: locale,
              ),
            ),
          );
        },
      ),
    );
  }
}
