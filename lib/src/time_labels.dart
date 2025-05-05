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
/// - Responsive layout
/// - Theme-aware styling
/// - Automatic height calculation
/// - Flexible positioning
///
/// Example:
/// ```dart
/// TimeLabels(
///   startHour: 8,
///   endHour: 18,
///   highlightCurrentHour: true,
///   style: TextStyle(fontSize: 12),
///   customTimeLabelBuilder: (time) => '${time.hour}:00',
/// )
/// ```
class TimeLabels extends StatelessWidget {
  /// Creates time labels for the calendar timeline.
  ///
  /// Example:
  /// ```dart
  /// TimeLabels(
  ///   startHour: 8,
  ///   endHour: 18,
  ///   highlightCurrentHour: true,
  ///   style: TextStyle(fontSize: 12),
  /// )
  /// ```
  const TimeLabels({
    super.key,
    this.startHour = 0,
    this.endHour = 24,
    this.highlightCurrentHour = false,
    this.customTimeLabelBuilder,
    this.style,
  });

  /// First hour to display (0-23)
  final int startHour;

  /// Last hour to display (0-23)
  final int endHour;

  /// Whether to highlight the current hour (if viewing today)
  final bool highlightCurrentHour;

  /// Optional custom builder for time labels
  final String Function(DateTime)? customTimeLabelBuilder;

  /// Optional custom style for time labels
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    return LayoutBuilder(
      builder: (context, constraints) {
        final hourHeight = constraints.maxHeight / (endHour - startHour);

        return Stack(
          children: [
            // Time labels with optional current hour highlight
            ...List.generate(
              endHour - startHour,
              (index) {
                final hour = startHour + index;
                final time = DateTime(now.year, now.month, now.day, hour);

                return Positioned(
                  top: index * hourHeight,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: hourHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        customTimeLabelBuilder?.call(time) ?? time.hour.toString(),
                        style: (style ?? theme.textTheme.bodyMedium)?.copyWith(
                          color: highlightCurrentHour ? Colors.white : Colors.grey[400],
                          fontWeight: highlightCurrentHour ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
