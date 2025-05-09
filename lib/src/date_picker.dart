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
/// - Complete color customization for all states:
///   - Today, selected, weekend, and holiday dates
///   - Current and outside month dates
///   - Disabled dates and range selection
///
/// The widget is designed to work seamlessly with [CalendarPlannerView]
/// but can also be used independently. It supports both inline and modal
/// display modes, with extensive customization options for appearance
/// and behavior.
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
    this.startingDayOfWeek = StartingDayOfWeek.monday,
    this.availableCalendarFormats,
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
    this.monthLabelText = 'Month',
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
    this.isTodayHighlighted = true,
    this.canMarkersOverflow = true,
    this.outsideDaysVisible = true,
    this.markersMaxCount = 4,
    this.markerSizeScale = 0.2,
    this.markersAnchor = 0.7,
    this.highlightWeekends = true,
    this.highlightHolidays = true,
    this.showWeekNumbers = true,
    this.highlightCurrentMonth = true,
    this.todayContainerColor,
    this.selectedContainerColor,
    this.weekendContainerColor,
    this.holidayContainerColor,
    this.currentMonthContainerColor,
    this.outsideMonthContainerColor,
    this.disabledContainerColor,
    this.rangeHighlightColor,
    this.rangeStartContainerColor,
    this.rangeEndContainerColor,
  }) : super(key: key);

  /// Starting day of week
  final StartingDayOfWeek? startingDayOfWeek;

  /// Currently selected date
  final DateTime selectedDate;

  /// Callback when a new date is selected
  final ValueChanged<DateTime> onDateChanged;

  /// Available calendar formats
  final Map<CalendarFormat, String>? availableCalendarFormats;

  /// Label for month view
  final String? monthLabelText;

  /// Label for week view
  final String? weekLabelText;

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

  /// Whether to highlight today's date
  final bool isTodayHighlighted;

  /// Whether event markers can overflow cell boundaries
  final bool canMarkersOverflow;

  /// Whether to show days outside the current month
  final bool outsideDaysVisible;

  /// Maximum number of event markers to display per day
  final int markersMaxCount;

  /// Scale factor for event marker size relative to cell size
  final double markerSizeScale;

  /// Vertical anchor point for event markers (0.0 to 1.0)
  final double markersAnchor;

  /// Whether to show weekend days with different styling
  final bool highlightWeekends;

  /// Whether to show holidays with different styling
  final bool highlightHolidays;

  /// Whether to show week numbers in month view
  final bool showWeekNumbers;

  /// Whether to show the current month's days in a different style
  final bool highlightCurrentMonth;

  /// Color for today's date container
  final Color? todayContainerColor;

  /// Color for selected date container
  final Color? selectedContainerColor;

  /// Color for weekend date containers
  final Color? weekendContainerColor;

  /// Color for holiday date containers
  final Color? holidayContainerColor;

  /// Color for current month date containers
  final Color? currentMonthContainerColor;

  /// Color for outside month date containers
  final Color? outsideMonthContainerColor;

  /// Color for disabled date containers
  final Color? disabledContainerColor;

  /// Color for range selection highlight
  final Color? rangeHighlightColor;

  /// Color for range start date container
  final Color? rangeStartContainerColor;

  /// Color for range end date container
  final Color? rangeEndContainerColor;

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
      isTodayHighlighted: isTodayHighlighted,
      canMarkersOverflow: canMarkersOverflow,
      outsideDaysVisible: outsideDaysVisible,
      markersMaxCount: markersMaxCount,
      markerSizeScale: markerSizeScale,
      markersAnchor: markersAnchor,
      weekendTextStyle: highlightWeekends ? null : dayNumberStyle,
      holidayTextStyle: highlightHolidays ? null : dayNumberStyle,
      weekNumberTextStyle: showWeekNumbers ? weekNumberStyle : null,
      outsideTextStyle: highlightCurrentMonth ? null : dayNumberStyle,
      todayDecoration: BoxDecoration(
        color: todayContainerColor ?? theme.colorScheme.primary.withAlpha(51),
        shape: cellShape,
        borderRadius: cellShape == BoxShape.rectangle ? cellBorderRadius : null,
      ),
      selectedDecoration: BoxDecoration(
        color: selectedContainerColor ?? theme.colorScheme.primary,
        shape: cellShape,
        borderRadius: cellShape == BoxShape.rectangle ? cellBorderRadius : null,
      ),
      weekendDecoration: BoxDecoration(
        color: weekendContainerColor,
        shape: cellShape,
        borderRadius: cellShape == BoxShape.rectangle ? cellBorderRadius : null,
      ),
      holidayDecoration: BoxDecoration(
        color: holidayContainerColor,
        border: Border.fromBorderSide(
          BorderSide(
            color: theme.colorScheme.primary.withAlpha(153),
            width: 1.4,
          ),
        ),
        shape: cellShape,
        borderRadius: cellShape == BoxShape.rectangle ? cellBorderRadius : null,
      ),
      defaultDecoration: BoxDecoration(
        color: currentMonthContainerColor,
        shape: cellShape,
        borderRadius: cellShape == BoxShape.rectangle ? cellBorderRadius : null,
      ),
      outsideDecoration: BoxDecoration(
        color: outsideMonthContainerColor,
        shape: cellShape,
        borderRadius: cellShape == BoxShape.rectangle ? cellBorderRadius : null,
      ),
      disabledDecoration: BoxDecoration(
        color: disabledContainerColor,
        shape: cellShape,
        borderRadius: cellShape == BoxShape.rectangle ? cellBorderRadius : null,
      ),
      rangeHighlightColor: rangeHighlightColor ?? theme.colorScheme.primary.withAlpha(26),
      rangeStartDecoration: BoxDecoration(
        color: rangeStartContainerColor ?? theme.colorScheme.primary,
        shape: cellShape,
        borderRadius: cellShape == BoxShape.rectangle ? cellBorderRadius : null,
      ),
      rangeEndDecoration: BoxDecoration(
        color: rangeEndContainerColor ?? theme.colorScheme.primary,
        shape: cellShape,
        borderRadius: cellShape == BoxShape.rectangle ? cellBorderRadius : null,
      ),
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
                startingDayOfWeek: startingDayOfWeek ?? StartingDayOfWeek.monday,
                availableGestures: AvailableGestures.horizontalSwipe,
                firstDay: minDate ?? DateTime(selectedDate.year - 1),
                lastDay: maxDate ?? DateTime(selectedDate.year + 1),
                focusedDay: selectedDate,
                daysOfWeekHeight: 22.0,
                selectedDayPredicate: (day) => CalendarDateUtils.isSameDay(selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  onDateChanged(DateTime(selectedDay.year, selectedDay.month, selectedDay.day));
                },
                calendarFormat: calendarFormat.value,
                availableCalendarFormats: availableCalendarFormats ??
                    {
                      CalendarFormat.month: monthLabelText ?? 'Month',
                      CalendarFormat.week: weekLabelText ?? 'Week',
                    },
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
