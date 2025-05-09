import 'package:calendar_planner_view/src/models/time_label_eums.dart';
import 'package:flutter/material.dart';

/// Displays time labels for the calendar timeline.
///
/// Shows hourly time markers that can be customized with different styles
/// and highlights the current hour if specified. Supports custom time label
/// formatting through a builder function.
///
/// Features:
/// - Configurable time range (start and end hours)
/// - Current hour highlighting
/// - Custom time label formatting
/// - Support for 12-hour or 24-hour time formats
/// - Responsive layout
/// - Theme-aware styling
/// - Automatic height calculation
/// - Flexible positioning
/// - Two display modes: hour-only and hour-with-half
class TimeLabels extends StatelessWidget {
  /// Creates time labels for the calendar timeline.
  ///
  /// The [customTimeLabelBuilder] allows complete customization of time format,
  /// supporting any international time representation.
  ///
  /// Example with 24-hour format:
  /// TimeLabels(
  ///   startHour: 8,
  ///   endHour: 18,
  ///   highlightCurrentHour: true,
  ///   style: TextStyle(fontSize: 12),
  ///   type: TimeLabelType.hourAndHalf,
  ///   customTimeLabelBuilder: (time) =>
  ///     '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
  /// )
  const TimeLabels({
    super.key,
    this.startHour = 0,
    this.endHour = 24,
    this.highlightCurrentHour = false,
    this.customTimeLabelBuilder,
    this.style,
    this.type = TimeLabelType.hourOnly,
  });

  /// First hour to display (0-23)
  final int startHour;

  /// Last hour to display (0-23)
  final int endHour;

  /// Whether to highlight the current hour (if viewing today)
  final bool highlightCurrentHour;

  /// Optional custom builder for time labels
  ///
  /// This allows complete customization of time representation for any locale.
  /// Can be used to implement:
  /// - 12-hour format with AM/PM
  /// - 24-hour format with leading zeros
  /// - Custom hour/minute separators
  /// - Locale-specific time formats
  final String Function(DateTime)? customTimeLabelBuilder;

  /// Optional custom style for time labels
  final TextStyle? style;

  /// Type of time label display
  final TimeLabelType? type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    return LayoutBuilder(
      builder: (context, constraints) {
        final hourHeight = constraints.maxHeight / (endHour - startHour);

        return Stack(
          fit: StackFit.expand,
          children: type == TimeLabelType.hourAndHalf
              ? _buildHourAndHalfLabels(now, hourHeight, theme)
              : _buildHourOnlyLabels(now, hourHeight, theme),
        );
      },
    );
  }

  /// Builds time labels showing only hour markers
  /// Supports international time formats through customTimeLabelBuilder
  List<Widget> _buildHourOnlyLabels(DateTime now, double hourHeight, ThemeData theme) {
    return List.generate(
      endHour - startHour,
      (index) {
        final hour = startHour + index;
        final time = DateTime(now.year, now.month, now.day, hour);
        final isCurrentHour = highlightCurrentHour && now.hour == hour && now.day == time.day;

        return Positioned(
          top: index * hourHeight,
          left: 0,
          right: 0,
          child: SizedBox(
            height: hourHeight,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  customTimeLabelBuilder?.call(time) ?? '${time.hour.toString().padLeft(2, '0')}:00',
                  style: (style ?? theme.textTheme.bodySmall)?.copyWith(
                    color: isCurrentHour ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(100),
                    fontWeight: isCurrentHour ? FontWeight.bold : null,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds time labels showing both hour and half-hour markers
  /// Supports international time formats through customTimeLabelBuilder
  List<Widget> _buildHourAndHalfLabels(DateTime now, double hourHeight, ThemeData theme) {
    final labels = <Widget>[];
    final halfHourHeight = hourHeight / 2;

    for (var index = 0; index < endHour - startHour; index++) {
      final hour = startHour + index;
      final hourTime = DateTime(now.year, now.month, now.day, hour);
      final halfHourTime = DateTime(now.year, now.month, now.day, hour, 30);

      final isCurrentHour = highlightCurrentHour && now.hour == hour && now.minute < 30 && now.day == hourTime.day;
      final isCurrentHalfHour = highlightCurrentHour && now.hour == hour && now.minute >= 30 && now.day == halfHourTime.day;

      // Hour label
      labels.add(
        Positioned(
          top: index * hourHeight,
          left: 0,
          right: 0,
          height: halfHourHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                customTimeLabelBuilder?.call(hourTime) ?? '${hourTime.hour.toString().padLeft(2, '0')}:00',
                style: (style ?? theme.textTheme.bodySmall)?.copyWith(
                  color: isCurrentHour ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(60),
                  fontWeight: isCurrentHour ? FontWeight.bold : null,
                ),
              ),
            ),
          ),
        ),
      );

      // Half hour label
      labels.add(
        Positioned(
          top: index * hourHeight + halfHourHeight,
          left: 0,
          right: 0,
          height: halfHourHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                customTimeLabelBuilder?.call(halfHourTime) ?? '${halfHourTime.hour.toString().padLeft(2, '0')}:30',
                style: (style ?? theme.textTheme.bodySmall)?.copyWith(
                  color: isCurrentHalfHour ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(70),
                  fontWeight: isCurrentHalfHour ? FontWeight.bold : null,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return labels;
  }
}
