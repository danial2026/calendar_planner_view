import 'package:intl/intl.dart';

/// A utility class for date formatting and manipulation in the calendar planner view.
///
/// This class provides a comprehensive set of date-related utilities for handling
/// calendar operations, including:
/// * Localized month and weekday names
/// * Week number calculations
/// * Date formatting with locale support
/// * Date comparison and manipulation
///
/// ## Features
/// * Localization support for month and weekday names
/// * Flexible date formatting with fallback options
/// * Efficient date comparison methods
/// * Time-based calculations for calendar display
///
/// ## Usage
/// ```dart
/// // Get localized month name
/// final monthName = CalendarDateUtils.getMonthName(date);
///
/// // Format date with custom format
/// final formattedDate = CalendarDateUtils.formatDate(
///   date,
///   format: 'MMM d, yyyy',
///   locale: 'en_US',
/// );
///
/// // Check if dates are the same day
/// final isSameDay = CalendarDateUtils.isSameDay(date1, date2);
/// ```
///
/// ## Localization
/// The class supports localization through:
/// * Custom month names list
/// * Custom weekday names list
/// * Locale-specific date formatting
///
/// ## Date Calculations
/// Provides methods for:
/// * Week number calculation within a month
/// * Day difference calculation
/// * Midnight time conversion
/// * Same day comparison
class CalendarDateUtils {
  /// Get localized month name
  static String getMonthName(DateTime date, {List<String>? monthNames}) {
    final defaultMonths = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return (monthNames ?? defaultMonths)[date.month - 1];
  }

  /// Get localized weekday name
  static String getWeekdayName(DateTime date, {List<String>? weekdayNames}) {
    final defaultWeekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return (weekdayNames ?? defaultWeekdays)[date.weekday - 1];
  }

  /// Calculate week number within the month (1-based)
  static int getWeekNumber(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;
    final dayOfMonth = date.day;

    return ((dayOfMonth + firstWeekday - 2) ~/ 7) + 1;
  }

  /// Format date with given format and locale
  static String formatDate(DateTime date, {required String format, String locale = 'en'}) {
    try {
      return DateFormat(format, locale).format(date);
    } catch (_) {
      return '${getMonthName(date)} ${date.day}, ${date.year}';
    }
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get midnight of a given date
  static DateTime getMidnight(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the difference in days between two dates
  static int getDayDifference(DateTime a, DateTime b) {
    final midnightA = getMidnight(a);
    final midnightB = getMidnight(b);
    return midnightB.difference(midnightA).inDays;
  }
}
