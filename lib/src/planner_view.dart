import 'package:calendar_planner_view/src/models/time_label_eums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:table_calendar/table_calendar.dart';
import 'time_labels.dart';
import 'event_list.dart';
import 'models/calendar_enums.dart';
import 'models/event_model.dart';
import 'date_picker.dart';
import 'utils/date_utils.dart';
import 'utils/style_utils.dart';
import 'models/event_utils.dart';

/// A highly customizable calendar planner widget with event management.
///
/// Features:
/// - Month and week view support with smooth transitions
/// - Customizable date picker position (top or modal)
/// - Event dots with customizable shapes and colors
/// - Flexible time range display
/// - Localization support
/// - Custom styling for all components
/// - Animated modal dialog for date selection
/// - Responsive design for different screen sizes
/// - Multi-column layout support
/// - Customizable time labels
/// - Current hour highlighting
/// - Current time indicator
/// - Event overlap handling
/// - Theme-aware styling
/// - Complete date picker customization:
///   - Week number styling and layout
///   - Chevron icon customization
///   - Calendar container styling
///   - Date range constraints
///   - Header styling
///   - Container colors for all states:
///     - Today, selected, weekend, and holiday dates
///     - Current and outside month dates
///     - Disabled dates and range selection
/// - Loading overlay with customizable appearance
///
/// The widget is built with a modular architecture:
/// - `FlexibleDatePicker`: Handles date selection with customizable appearance
/// - `TimeLabels`: Displays time markers in the timeline
/// - `EventList`: Manages event display and interaction
///
/// Example:
/// CalendarPlannerView(
///   events: myEvents,
///   onEventTap: (event) => handleEventTap(event),
///   startHour: 8,
///   endHour: 18,
///   datePickerPosition: DatePickerPosition.top,
///   showDayTitle: true,
///   enableViewToggle: true,
///   showCurrentTimeIndicator: true,
///   columns: [
///     (id: 'col1', title: 'Column 1'),
///     (id: 'col2', title: 'Column 2'),
///   ],
/// Custom colors for different states:
///   todayContainerColor: Colors.blue.withAlpha(10),
///   selectedContainerColor: Colors.blue,
///   weekendContainerColor: Colors.grey.withAlpha(10),
/// Loading overlay customization:
///   isLoading: true,
///   loadingBuilder: (context) => CircularProgressIndicator(),
///   loadingOverlayColor: Colors.black54,
///   showContentWhileLoading: false,
/// )
class CalendarPlannerView extends HookWidget {
  /// Creates a calendar planner view with extensive customization options.
  ///
  /// The widget supports two main display modes:
  /// 1. Top position: Date picker is always visible above the timeline
  /// 2. Modal position: Date picker appears in a modal dialog when calendar icon is clicked
  ///
  /// The modal dialog features:
  /// - Smooth scale and fade animations
  /// - Gradient header with calendar icon
  /// - "Today" button with icon
  /// - Customizable styling for all elements
  /// - Responsive layout with max width constraint
  ///
  /// The timeline view includes:
  /// - Customizable time range
  /// - Event indicators with dots
  /// - Support for overlapping events
  /// - Custom event builders
  /// - Responsive layout
  /// - Multi-column support with customizable titles
  /// - Current hour highlighting
  /// - Current time indicator
  /// - Custom time label formatting
  /// - Theme-aware styling
  const CalendarPlannerView({
    super.key,
    required this.events,
    this.onEventTap,
    this.onDateChanged,
    this.availableCalendarFormats,
    this.datePickerPosition = DatePickerPosition.top,
    this.startHour = 0,
    this.endHour = 24,
    this.hourRowHeight = 120.0,
    this.eventBuilder,
    this.timeLabelStyle,
    this.timeLabelType,
    this.datePickerStyle,
    this.showDayTitle = false,
    this.monthTitleStyle,
    this.weekTitleStyle,
    this.dayTitleStyle,
    this.dotColor,
    this.dotSize = 5.0,
    this.eventDotShape = EventDotShape.circle,
    this.calendarTitle = 'Calendar',
    this.calendarTitleStyle,
    this.monthLabelStyle,
    this.weekdayLabelStyle,
    this.dayNumberStyle,
    this.locale = 'en',
    this.toggleColorBackground,
    this.toggleColor,
    this.modalIconColor,
    this.modalHeaderGradient,
    this.modalHeaderColor = Colors.transparent,
    this.dropdownLabel = 'Select Column',
    this.dropdownBorder = const OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(12.0),
      ),
    ),
    this.dropdownAllLabel = 'All Columns',
    this.dropdownBorderRadius = 12.0,
    this.dropdownMenuBorderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.dropdownPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.dropdownContentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.dropdownIcon,
    this.dropdownColor,
    this.dropdownTextStyle,
    this.dropdownItemBuilder,
    this.showColumnHeadersInDropdownAllOption = false,
    this.weekNumberStyle,
    this.titleCalendarWidget,
    this.enableViewToggle = false,
    this.toggleButtonsWidget,
    this.initialView = CalendarViewType.month,
    this.datePickerShape = BoxShape.circle,
    this.datePickerBorderRadius,
    this.monthLabelText = 'Month',
    this.weekLabelText = 'Week',
    this.startingDayOfWeek,
    this.monthNames,
    this.weekdayNames,
    this.todayLabel = 'Today',
    this.tomorrowLabel = 'Tomorrow',
    this.yesterdayLabel = 'Yesterday',
    this.dateFormat = 'MMMM d, yyyy',
    this.calendarDatePickerButtonsWidget,
    this.modalTitle = 'Select Date',
    this.modalTitleStyle,
    this.modalBackgroundColor,
    this.modalBorderRadius = 16.0,
    this.modalShadowColor,
    this.modalShadowBlurRadius = 12.0,
    this.modalShadowOffset = const Offset(0, 4),
    this.modalMaxWidth = 400.0,
    this.modalPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.modalHeaderPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    this.modalShowCloseButton = true,
    this.modalCloseButtonStyle,
    this.modalTodayButtonStyle,
    this.modalTodayButtonTextStyle,
    this.columnTitleStyle,
    this.titleTextStyle,
    this.timeTextStyle,
    this.descriptionTextStyle,
    this.showCurrentTimeIndicator,
    this.timeLabelWidth = 50,
    this.highlightCurrentHour = false,
    this.timeLabelBuilder,
    this.columns = const [],
    this.columnLabelType = ColumnLabelType.columnHeaders,
    this.onColumnChanged,
    this.columnBackgroundColor,
    this.columnTitleHeight = 42,
    this.scrollController,
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
    this.calendarBackgroundColor,
    this.calendarBorderRadius,
    this.calendarBorder,
    this.calendarShadowColor,
    this.calendarShadowBlurRadius = 4.0,
    this.calendarShadowOffset = const Offset(0, 2),
    this.minDate,
    this.maxDate,
    this.headerStyle,
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
    this.isLoading = false,
    this.loadingBuilder,
    this.loadingOverlayColor,
    this.showContentWhileLoading = true,
  });

  /// List of events to display in the calendar
  /// Each event should have a start and end time, and can include additional metadata.
  final List<CalendarEvent> events;

  /// Callback when an event is tapped.
  /// Provides the tapped event for handling user interaction
  final void Function(CalendarEvent)? onEventTap;

  /// Callback when the date is changed.
  /// Provides the selected date for handling user interaction
  final void Function(DateTime)? onDateChanged;

  /// Position of the date picker
  /// - [DatePickerPosition.top]: Always visible above the timeline
  /// - [DatePickerPosition.modal]: Shows in a modal dialog when calendar icon is clicked
  final DatePickerPosition datePickerPosition;

  /// First hour to display in the timeline (0-23)
  /// Events before this hour will be hidden.
  final int startHour;

  /// Last hour to display in the timeline (0-23)
  /// Events after this hour will be hidden.
  final int endHour;

  /// Height of each hour row in the timeline.
  final double hourRowHeight;

  /// Text style for the event title
  final TextStyle? titleTextStyle;

  /// Text style for the event time
  final TextStyle? timeTextStyle;

  /// Text style for the event description
  final TextStyle? descriptionTextStyle;

  /// Whether to show the current time indicator in the timeline
  final bool? showCurrentTimeIndicator;

  /// Custom builder for event widgets in the timeline
  /// Allows complete customization of event appearance and behavior
  /// Parameters include:
  /// - event: The calendar event to display
  /// - startTime: Event start time
  /// - endTime: Event end time
  /// - duration: Event duration in minutes
  /// - height: Calculated height for the event widget
  /// - width: Available width for the event widget
  /// - isOverlapping: Whether the event overlaps with others
  /// - overlapIndex: Position in the overlap stack
  /// - totalOverlapping: Total number of overlapping events
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

  /// Style for time labels in the timeline
  /// Affects the appearance of hour markers
  final TextStyle? timeLabelStyle;

  /// Type of time labels in the timeline
  /// Affects the appearance of hour markers
  final TimeLabelType? timeLabelType;

  /// Starting day of week for the date picker
  /// Affects the starting day of the week in the date picker
  final StartingDayOfWeek? startingDayOfWeek;

  /// Style for the date picker calendar
  /// Controls the appearance of the calendar grid and cells
  final CalendarStyle? datePickerStyle;

  /// Whether to show the current day title
  /// Displays a formatted date or relative day (Today/Tomorrow/Yesterday)
  final bool showDayTitle;

  /// Style for month view title
  /// Controls the appearance of the month name in the calendar header
  final TextStyle? monthTitleStyle;

  /// Style for week view title
  /// Controls the appearance of the week number in week view
  final TextStyle? weekTitleStyle;

  /// Style for day titles
  /// Controls the appearance of the selected date display
  final TextStyle? dayTitleStyle;

  /// Color for event indicator dots
  /// Sets the color of the dots shown under dates with events
  final Color? dotColor;

  /// Size of event indicator dots
  /// Controls the diameter of the event dots
  final double dotSize;

  /// Shape of event indicator dots
  /// Options include circle, square, and diamond shapes
  final EventDotShape eventDotShape;

  /// Title shown above the calendar
  /// Main heading for the calendar view
  final String calendarTitle;

  /// Style for the calendar title
  /// Controls the appearance of the main calendar heading
  final TextStyle? calendarTitleStyle;

  /// Style for month names in the calendar
  /// Controls the appearance of month names in the calendar header
  final TextStyle? monthLabelStyle;

  /// Style for weekday names
  /// Controls the appearance of day names in the calendar header
  final TextStyle? weekdayLabelStyle;

  /// Style for day numbers
  /// Controls the appearance of date numbers in the calendar grid
  final TextStyle? dayNumberStyle;

  /// Locale for date formatting (e.g., 'en', 'es')
  /// Affects the language of dates and day names
  final String locale;

  /// Color for the toggle button text
  /// Controls the appearance of the text in the view toggle buttons
  final Color? toggleColor;

  /// Color for the toggle button background
  /// Controls the appearance of the background in the view toggle buttons
  final Color? toggleColorBackground;

  /// Color for the modal icon
  /// Controls the appearance of the icon in the modal
  final Color? modalIconColor;

  /// Gradient for the modal header
  /// Controls the appearance of the gradient in the modal header
  final Gradient? modalHeaderGradient;

  /// Color for the modal header
  /// Controls the appearance of the color in the modal header
  final Color? modalHeaderColor;

  /// Whether to show the column headers in the dropdown while all option is selected
  final bool showColumnHeadersInDropdownAllOption;

  /// Style for week numbers
  /// Controls the appearance of week numbers in week view
  final TextStyle? weekNumberStyle;

  /// Custom widget for the calendar title
  /// Allows complete customization of the calendar title
  final Widget? titleCalendarWidget;

  /// Whether to show the view toggle button
  /// Enables switching between month and week views
  final bool enableViewToggle;

  /// Custom widget for the view toggle buttons
  /// Allows complete customization of the view toggle buttons
  final Widget? toggleButtonsWidget;

  /// Initial calendar view type
  /// Sets the default view when the widget is first displayed
  final CalendarViewType initialView;

  /// Shape of date picker cells
  /// Controls the shape of individual date cells in the calendar
  final BoxShape datePickerShape;

  /// Border radius for rectangular date picker cells
  /// Only applies when [datePickerShape] is [BoxShape.rectangle]
  final BorderRadius? datePickerBorderRadius;

  /// Text for month view toggle
  /// Label for the month view button in the view toggle
  final String monthLabelText;

  /// Text for week view toggle
  /// Label for the week view button in the view toggle
  final String weekLabelText;

  /// Custom month names (optional)
  /// Override default month names for localization
  final List<String>? monthNames;

  /// Custom weekday names (optional)
  /// Override default weekday names for localization
  final List<String>? weekdayNames;

  /// Available calendar formats
  /// Controls the available calendar formats in the date picker
  final Map<CalendarFormat, String>? availableCalendarFormats;

  /// Label for today's date
  /// Text shown when the selected date is today
  final String todayLabel;

  /// Label for tomorrow's date
  /// Text shown when the selected date is tomorrow
  final String tomorrowLabel;

  /// Label for yesterday's date
  /// Text shown when the selected date is yesterday
  final String yesterdayLabel;

  /// Format for displaying dates
  /// Controls how dates are formatted in the day title
  final String dateFormat;

  /// Custom widget for the calendar date picker buttons
  /// Allows complete customization of the calendar date picker buttons
  final Widget? calendarDatePickerButtonsWidget;

  /// Title shown in the modal header
  /// Heading for the date picker modal dialog
  final String modalTitle;

  /// Style for the modal title
  /// Controls the appearance of the modal dialog heading
  final TextStyle? modalTitleStyle;

  /// Background color for the modal
  /// Sets the background color of the date picker modal
  final Color? modalBackgroundColor;

  /// Border radius for the modal
  /// Controls the corner radius of the modal dialog
  final double modalBorderRadius;

  /// Shadow color for the modal
  /// Sets the color of the modal's shadow
  final Color? modalShadowColor;

  /// Shadow blur radius for the modal
  /// Controls the spread of the modal's shadow
  final double modalShadowBlurRadius;

  /// Shadow offset for the modal
  /// Controls the position of the modal's shadow
  final Offset modalShadowOffset;

  /// Maximum width for the modal
  /// Constrains the width of the date picker modal
  final double modalMaxWidth;

  /// Padding for the modal content
  /// Controls the spacing around the calendar in the modal
  final EdgeInsets modalPadding;

  /// Padding for the modal header
  /// Controls the spacing in the modal's header section
  final EdgeInsets modalHeaderPadding;

  /// Style for the modal close button
  /// Controls the appearance of the modal's close button
  final ButtonStyle? modalCloseButtonStyle;

  /// Whether to show the modal close button
  /// Controls the visibility of the modal's close button
  final bool modalShowCloseButton;

  /// Style for the modal today button
  /// Controls the appearance of the "Today" button in the modal
  final ButtonStyle? modalTodayButtonStyle;

  /// Text style for the modal today button
  /// Controls the appearance of the "Today" button text
  final TextStyle? modalTodayButtonTextStyle;

  /// Whether to highlight the current hour
  /// Controls whether the current hour is highlighted in the timeline
  final bool highlightCurrentHour;

  /// Custom builder for time labels
  /// Allows customizing the time labels in the timeline
  final String Function(DateTime)? timeLabelBuilder;

  /// Width of the time labels
  /// Controls the width of the time labels in the timeline
  final double timeLabelWidth;

  /// Background color for columns
  /// Controls the background color of the columns in the multi-column layout
  final Color? columnBackgroundColor;

  /// Height of the column titles
  /// Controls the height of the column titles in the multi-column layout
  final double columnTitleHeight;

  /// Style for column titles
  /// Controls the appearance of column titles in the multi-column layout
  final TextStyle? columnTitleStyle;

  /// List of column configurations for multi-column layout
  /// Each column has an id and optional title
  /// Minimum 2 columns, maximum 10 columns
  final List<({String id, String? title})> columns;

  /// Type of column labels
  final ColumnLabelType columnLabelType;

  /// Callback for when a column is changed
  final void Function(String)? onColumnChanged;

  /// Dropdown label
  final String? dropdownLabel;

  /// Dropdown all label
  final String dropdownAllLabel;

  /// Dropdown border radius
  final double? dropdownBorderRadius;

  /// Dropdown padding
  final EdgeInsetsGeometry? dropdownPadding;

  /// Dropdown content padding
  final EdgeInsets? dropdownContentPadding;

  /// Dropdown icon
  final Widget? dropdownIcon;

  /// Dropdown color
  final Color? dropdownColor;

  /// Dropdown text style
  final TextStyle? dropdownTextStyle;

  /// Dropdown item builder
  final Widget Function(BuildContext, String, String?)? dropdownItemBuilder;

  /// Dropdown border
  final InputBorder? dropdownBorder;

  /// Dropdown menu border radius
  final BorderRadius? dropdownMenuBorderRadius;

  /// Scroll controller for the calendar
  final ScrollController? scrollController;

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

  /// Size of chevron icons
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

  /// Earliest selectable date
  final DateTime? minDate;

  /// Latest selectable date
  final DateTime? maxDate;

  /// Custom header styling
  final HeaderStyle? headerStyle;

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

  /// Whether the calendar is in a loading state
  final bool isLoading;

  /// Custom builder for the loading indicator
  /// If not provided, defaults to a centered CircularProgressIndicator
  final Widget Function(BuildContext)? loadingBuilder;

  /// Color for the loading overlay
  /// If not provided, defaults to Colors.black54
  final Color? loadingOverlayColor;

  /// Whether to show the calendar content while loading
  /// If false, only the loading indicator will be shown
  final bool showContentWhileLoading;

  String _formattedDate(DateTime date) {
    return CalendarDateUtils.formatDate(date, format: dateFormat, locale: locale);
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    ValueNotifier<DateTime> selectedDate,
    ScrollController scrollController,
    DateTime now,
    DateTime midnightToday,
    DateTime midnightSelected,
    int dayDifference,
    bool isToday,
    bool isTomorrow,
    bool isYesterday,
    List<CalendarEvent> filteredEvents,
    ValueNotifier<CalendarViewType> viewType,
    ValueNotifier<String?> selectedColumnId,
  ) {
    return Column(
      children: [
        // Main calendar title and toggle in a row
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Row(
            children: [
              Text(
                calendarTitle,
                style: calendarTitleStyle ??
                    theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: calendarDatePickerButtonsWidget ?? Icon(Icons.calendar_today, color: modalIconColor ?? theme.colorScheme.onSurface),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierColor: Colors.black54,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 0.95 + (0.05 * value),
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          constraints: BoxConstraints(maxWidth: modalMaxWidth),
                          decoration: CalendarStyleUtils.getDefaultCalendarDecoration(
                            theme,
                            backgroundColor: modalBackgroundColor,
                            borderRadius: BorderRadius.circular(modalBorderRadius),
                            shadowColor: modalShadowColor,
                            shadowBlurRadius: modalShadowBlurRadius,
                            shadowOffset: modalShadowOffset,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header with gradient background
                              Container(
                                decoration: BoxDecoration(
                                  color: modalHeaderGradient == null ? modalHeaderColor : null,
                                  gradient: modalHeaderGradient,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(modalBorderRadius),
                                    topRight: Radius.circular(modalBorderRadius),
                                  ),
                                ),
                                child: Padding(
                                  padding: modalHeaderPadding,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: modalIconColor ?? theme.colorScheme.onSurface,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        modalTitle,
                                        style: modalTitleStyle ??
                                            theme.textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.onSurface,
                                            ),
                                      ),
                                      const Spacer(),
                                      TextButton.icon(
                                        onPressed: () {
                                          selectedDate.value = DateTime.now();
                                          Navigator.pop(context);
                                        },
                                        style: modalTodayButtonStyle ??
                                            TextButton.styleFrom(
                                              foregroundColor: theme.colorScheme.onSurface,
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                        icon: Icon(
                                          Icons.today,
                                          size: 16,
                                          color: modalIconColor ?? theme.colorScheme.onSurface,
                                        ),
                                        label: Text(
                                          todayLabel,
                                          style: modalTodayButtonTextStyle ??
                                              theme.textTheme.labelLarge?.copyWith(
                                                color: theme.colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      if (modalShowCloseButton)
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () => Navigator.pop(context),
                                          style: modalCloseButtonStyle ??
                                              IconButton.styleFrom(
                                                foregroundColor: theme.colorScheme.onSurface.withAlpha(153),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: const EdgeInsets.all(8),
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              // Calendar content
                              Padding(
                                padding: modalPadding,
                                child: FlexibleDatePicker(
                                  selectedDate: selectedDate.value,
                                  startingDayOfWeek: startingDayOfWeek,
                                  onDateChanged: (date) {
                                    selectedDate.value = date;
                                    onDateChanged?.call(date);
                                    Navigator.pop(context);
                                  },
                                  availableCalendarFormats: availableCalendarFormats,
                                  displayMode: DatePickerDisplayMode.inline,
                                  calendarView: CalendarFormat.month,
                                  dayStyle: datePickerStyle,
                                  monthTitleStyle: monthTitleStyle,
                                  weekdayLabelStyle: weekdayLabelStyle,
                                  dayNumberStyle: dayNumberStyle,
                                  weekNumberStyle: weekNumberStyle,
                                  locale: locale,
                                  cellShape: datePickerShape,
                                  cellBorderRadius: datePickerBorderRadius,
                                  events: events,
                                  dotColor: dotColor,
                                  dotSize: dotSize,
                                  eventDotShape: eventDotShape,
                                  monthNames: monthNames,
                                  weekdayNames: weekdayNames,
                                  monthLabelText: monthLabelText,
                                  weekLabelText: weekLabelText,
                                  todayLabel: todayLabel,
                                  weekNumberBackgroundColor: weekNumberBackgroundColor,
                                  weekNumberTextColor: weekNumberTextColor,
                                  weekNumberBorderRadius: weekNumberBorderRadius,
                                  weekNumberPadding: weekNumberPadding,
                                  weekNumberTextStyle: weekNumberTextStyle,
                                  weekNumberContainerStyle: weekNumberContainerStyle,
                                  chevronIconColor: chevronIconColor,
                                  chevronIconSize: chevronIconSize,
                                  chevronIconPadding: chevronIconPadding,
                                  chevronIconStyle: chevronIconStyle,
                                  calendarPadding: calendarPadding,
                                  calendarMargin: calendarMargin,
                                  calendarBackgroundColor: calendarBackgroundColor,
                                  calendarBorderRadius: calendarBorderRadius,
                                  calendarBorder: calendarBorder,
                                  calendarShadowColor: calendarShadowColor,
                                  calendarShadowBlurRadius: calendarShadowBlurRadius,
                                  calendarShadowOffset: calendarShadowOffset,
                                  minDate: minDate,
                                  maxDate: maxDate,
                                  headerStyle: headerStyle,
                                  isTodayHighlighted: isTodayHighlighted,
                                  canMarkersOverflow: canMarkersOverflow,
                                  outsideDaysVisible: outsideDaysVisible,
                                  markersMaxCount: markersMaxCount,
                                  markerSizeScale: markerSizeScale,
                                  markersAnchor: markersAnchor,
                                  highlightWeekends: highlightWeekends,
                                  highlightHolidays: highlightHolidays,
                                  showWeekNumbers: showWeekNumbers,
                                  highlightCurrentMonth: highlightCurrentMonth,
                                  todayContainerColor: todayContainerColor,
                                  selectedContainerColor: selectedContainerColor,
                                  weekendContainerColor: weekendContainerColor,
                                  holidayContainerColor: holidayContainerColor,
                                  currentMonthContainerColor: currentMonthContainerColor,
                                  outsideMonthContainerColor: outsideMonthContainerColor,
                                  disabledContainerColor: disabledContainerColor,
                                  rangeHighlightColor: rangeHighlightColor,
                                  rangeStartContainerColor: rangeStartContainerColor,
                                  rangeEndContainerColor: rangeEndContainerColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              titleCalendarWidget ?? const SizedBox.shrink(),
              const Spacer(),
              if (enableViewToggle)
                toggleButtonsWidget ??
                    ToggleButtons(
                      isSelected: [viewType.value == CalendarViewType.month, viewType.value == CalendarViewType.week],
                      onPressed: (index) {
                        viewType.value = index == 0 ? CalendarViewType.month : CalendarViewType.week;
                      },
                      borderRadius: BorderRadius.circular(8),
                      color: toggleColor ?? theme.colorScheme.onSurface.withAlpha(51),
                      selectedColor: toggleColor ?? theme.colorScheme.onSurface,
                      fillColor: toggleColorBackground ?? theme.colorScheme.surfaceContainerHighest,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(monthLabelText),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(weekLabelText),
                        ),
                      ],
                    ),
            ],
          ),
        ),
        if (datePickerPosition == DatePickerPosition.top)
          FlexibleDatePicker(
            selectedDate: selectedDate.value,
            startingDayOfWeek: startingDayOfWeek,
            onDateChanged: (date) {
              selectedDate.value = date;
              onDateChanged?.call(date);
            },
            availableCalendarFormats: availableCalendarFormats,
            displayMode: DatePickerDisplayMode.inline,
            calendarView: viewType.value == CalendarViewType.month ? CalendarFormat.month : CalendarFormat.week,
            dayStyle: datePickerStyle,
            monthTitleStyle: monthTitleStyle,
            weekdayLabelStyle: weekdayLabelStyle,
            dayNumberStyle: dayNumberStyle,
            weekNumberStyle: weekNumberStyle,
            locale: locale,
            cellShape: datePickerShape,
            cellBorderRadius: datePickerBorderRadius,
            events: events,
            dotColor: dotColor,
            dotSize: dotSize,
            eventDotShape: eventDotShape,
            monthNames: monthNames,
            weekdayNames: weekdayNames,
            monthLabelText: monthLabelText,
            weekLabelText: weekLabelText,
            todayLabel: todayLabel,
            onCalendarFormatChanged: (format) {
              viewType.value = format == CalendarFormat.month ? CalendarViewType.month : CalendarViewType.week;
            },
            weekNumberBackgroundColor: weekNumberBackgroundColor,
            weekNumberTextColor: weekNumberTextColor,
            weekNumberBorderRadius: weekNumberBorderRadius,
            weekNumberPadding: weekNumberPadding,
            weekNumberTextStyle: weekNumberTextStyle,
            weekNumberContainerStyle: weekNumberContainerStyle,
            chevronIconColor: chevronIconColor,
            chevronIconSize: chevronIconSize,
            chevronIconPadding: chevronIconPadding,
            chevronIconStyle: chevronIconStyle,
            calendarPadding: calendarPadding,
            calendarMargin: calendarMargin,
            calendarBackgroundColor: calendarBackgroundColor,
            calendarBorderRadius: calendarBorderRadius,
            calendarBorder: calendarBorder,
            calendarShadowColor: calendarShadowColor,
            calendarShadowBlurRadius: calendarShadowBlurRadius,
            calendarShadowOffset: calendarShadowOffset,
            minDate: minDate,
            maxDate: maxDate,
            headerStyle: headerStyle,
            isTodayHighlighted: isTodayHighlighted,
            canMarkersOverflow: canMarkersOverflow,
            outsideDaysVisible: outsideDaysVisible,
            markersMaxCount: markersMaxCount,
            markerSizeScale: markerSizeScale,
            markersAnchor: markersAnchor,
            highlightWeekends: highlightWeekends,
            highlightHolidays: highlightHolidays,
            showWeekNumbers: showWeekNumbers,
            highlightCurrentMonth: highlightCurrentMonth,
            todayContainerColor: todayContainerColor,
            selectedContainerColor: selectedContainerColor,
            weekendContainerColor: weekendContainerColor,
            holidayContainerColor: holidayContainerColor,
            currentMonthContainerColor: currentMonthContainerColor,
            outsideMonthContainerColor: outsideMonthContainerColor,
            disabledContainerColor: disabledContainerColor,
            rangeHighlightColor: rangeHighlightColor,
            rangeStartContainerColor: rangeStartContainerColor,
            rangeEndContainerColor: rangeEndContainerColor,
          )
        else
          FlexibleDatePicker(
            selectedDate: selectedDate.value,
            startingDayOfWeek: startingDayOfWeek,
            onDateChanged: (date) => selectedDate.value = date,
            availableCalendarFormats: availableCalendarFormats,
            displayMode: DatePickerDisplayMode.popup,
            calendarView: CalendarFormat.month,
            dayStyle: datePickerStyle,
            monthTitleStyle: monthTitleStyle,
            weekdayLabelStyle: weekdayLabelStyle,
            dayNumberStyle: dayNumberStyle,
            weekNumberStyle: weekNumberStyle,
            locale: locale,
            cellShape: datePickerShape,
            cellBorderRadius: datePickerBorderRadius,
            events: events,
            dotColor: dotColor,
            dotSize: dotSize,
            eventDotShape: eventDotShape,
            monthNames: monthNames,
            weekdayNames: weekdayNames,
            monthLabelText: monthLabelText,
            weekLabelText: weekLabelText,
            todayLabel: todayLabel,
            onCalendarFormatChanged: (format) {
              viewType.value = format == CalendarFormat.month ? CalendarViewType.month : CalendarViewType.week;
            },
            weekNumberBackgroundColor: weekNumberBackgroundColor,
            weekNumberTextColor: weekNumberTextColor,
            weekNumberBorderRadius: weekNumberBorderRadius,
            weekNumberPadding: weekNumberPadding,
            weekNumberTextStyle: weekNumberTextStyle,
            weekNumberContainerStyle: weekNumberContainerStyle,
            chevronIconColor: chevronIconColor,
            chevronIconSize: chevronIconSize,
            chevronIconPadding: chevronIconPadding,
            chevronIconStyle: chevronIconStyle,
            calendarPadding: calendarPadding,
            calendarMargin: calendarMargin,
            calendarBackgroundColor: calendarBackgroundColor,
            calendarBorderRadius: calendarBorderRadius,
            calendarBorder: calendarBorder,
            calendarShadowColor: calendarShadowColor,
            calendarShadowBlurRadius: calendarShadowBlurRadius,
            calendarShadowOffset: calendarShadowOffset,
            minDate: minDate,
            maxDate: maxDate,
            headerStyle: headerStyle,
            isTodayHighlighted: isTodayHighlighted,
            canMarkersOverflow: canMarkersOverflow,
            outsideDaysVisible: outsideDaysVisible,
            markersMaxCount: markersMaxCount,
            markerSizeScale: markerSizeScale,
            markersAnchor: markersAnchor,
            highlightWeekends: highlightWeekends,
            highlightHolidays: highlightHolidays,
            showWeekNumbers: showWeekNumbers,
            highlightCurrentMonth: highlightCurrentMonth,
            todayContainerColor: todayContainerColor,
            selectedContainerColor: selectedContainerColor,
            weekendContainerColor: weekendContainerColor,
            holidayContainerColor: holidayContainerColor,
            currentMonthContainerColor: currentMonthContainerColor,
            outsideMonthContainerColor: outsideMonthContainerColor,
            disabledContainerColor: disabledContainerColor,
            rangeHighlightColor: rangeHighlightColor,
            rangeStartContainerColor: rangeStartContainerColor,
            rangeEndContainerColor: rangeEndContainerColor,
          ),
        if (showDayTitle)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              isToday
                  ? todayLabel
                  : isTomorrow
                      ? tomorrowLabel
                      : isYesterday
                          ? yesterdayLabel
                          : _formattedDate(selectedDate.value),
              style: dayTitleStyle ??
                  theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        // Column title dropdown
        if (columnLabelType == ColumnLabelType.dropdown)
          buildCustomDropdown(
            context: context,
            selectedColumnId: selectedColumnId,
          ),
        // Column titles
        if (columns.isNotEmpty &&
            (columnLabelType == ColumnLabelType.columnHeaders || (showColumnHeadersInDropdownAllOption && selectedColumnId.value == 'all')))
          Row(
            children: [
              SizedBox(width: timeLabelWidth),
              Container(
                height: columnTitleHeight,
                decoration: BoxDecoration(
                  color: columnBackgroundColor ?? Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: List.generate(
                    columns.length,
                    (index) {
                      final column = columns[index];
                      final columnWidth = (MediaQuery.of(context).size.width - timeLabelWidth) / columns.length;
                      return SizedBox(
                        width: columnWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            column.title ?? column.id.toUpperCase(),
                            style: columnTitleStyle ??
                                theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        // Event list and time labels
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: SizedBox(
              height: (endHour - startHour) * hourRowHeight, // duration of hours * height of each hour
              child: Row(
                children: [
                  SizedBox(
                    width: timeLabelWidth,
                    child: TimeLabels(
                      startHour: startHour,
                      endHour: endHour,
                      highlightCurrentHour: highlightCurrentHour,
                      customTimeLabelBuilder: timeLabelBuilder,
                      style: timeLabelStyle,
                      type: timeLabelType,
                    ),
                  ),
                  Expanded(
                    child: EventList(
                      events: filteredEvents,
                      onEventTap: onEventTap,
                      startHour: startHour,
                      endHour: endHour,
                      eventBuilder: eventBuilder,
                      scrollController: scrollController,
                      selectedDate: selectedDate.value,
                      columns: (columnLabelType == ColumnLabelType.columnHeaders ||
                              (showColumnHeadersInDropdownAllOption && selectedColumnId.value == 'all'))
                          ? columns
                          : [],
                      titleTextStyle: titleTextStyle,
                      timeTextStyle: timeTextStyle,
                      descriptionTextStyle: descriptionTextStyle,
                      showCurrentTimeIndicator: showCurrentTimeIndicator,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCustomDropdown({
    required BuildContext context,
    required ValueNotifier<String?> selectedColumnId,
  }) {
    List<DropdownMenuItem<String>> items = [];

    items.add(
      DropdownMenuItem<String>(
        value: 'all',
        child: Text(dropdownAllLabel),
      ),
    );

    items.addAll(
      columns.map(
        (column) => DropdownMenuItem<String>(
          value: column.id,
          child: Text(column.title ?? column.id.toUpperCase()),
        ),
      ),
    );
    return Padding(
      padding: dropdownPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: dropdownLabel,
          border: dropdownBorder,
          contentPadding: dropdownContentPadding,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              isExpanded: true,
              value: selectedColumnId.value ?? columns.first.id,
              icon: dropdownIcon ?? const Icon(Icons.expand_more),
              borderRadius: dropdownMenuBorderRadius,
              dropdownColor: dropdownColor,
              style: dropdownTextStyle,
              focusColor: Colors.transparent,
              items: items,
              onChanged: (value) {
                selectedColumnId.value = value;
                if (onColumnChanged != null && columns.isNotEmpty) {
                  onColumnChanged?.call(value ?? columns.first.id);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay(BuildContext context, ThemeData theme) {
    return Container(
      color: loadingOverlayColor ?? Colors.black54,
      child: Center(
        child: loadingBuilder?.call(context) ??
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDate = useState(DateTime.now());
    final scrollController = useScrollController();
    final now = DateTime.now();
    final midnightToday = CalendarDateUtils.getMidnight(now);
    final midnightSelected = CalendarDateUtils.getMidnight(selectedDate.value);
    final dayDifference = CalendarDateUtils.getDayDifference(midnightToday, midnightSelected);

    final isToday = dayDifference == 0;
    final isTomorrow = dayDifference == 1;
    final isYesterday = dayDifference == -1;

    // State for selected column in dropdown
    final selectedColumnId = useState<String?>(columns.isNotEmpty ? 'all' : null);

    // Filter events for the selected date
    final filteredEvents = useMemoized(() {
      var result = EventUtils.filterEventsForDate(selectedDate.value, events);
      if (columns.isNotEmpty) {
        if (selectedColumnId.value != 'all') {
          result = EventUtils.filterEventsForColumn(selectedColumnId.value ?? columns.first.id, result);
        }
      }
      return result;
    }, [events, selectedDate.value, selectedColumnId.value]);

    // State for week/month view (responsive)
    final viewType = useState<CalendarViewType>(initialView);

    return Stack(
      children: [
        if (showContentWhileLoading || !isLoading)
          _buildContent(
            context,
            theme,
            selectedDate,
            scrollController,
            now,
            midnightToday,
            midnightSelected,
            dayDifference,
            isToday,
            isTomorrow,
            isYesterday,
            filteredEvents,
            viewType,
            selectedColumnId,
          ),
        if (isLoading) _buildLoadingOverlay(context, theme),
      ],
    );
  }
}
