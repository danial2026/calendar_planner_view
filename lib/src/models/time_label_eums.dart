/// Type of time label display
enum TimeLabelType {
  /// Shows time labels at the start of each hour
  /// Works well with all locales and time formats
  hourOnly,

  /// Shows time labels at the start of each hour and at 30 minutes
  /// Provides more granular time display for detailed schedules
  /// Suitable for 12-hour or 24-hour time formats
  hourAndHalf
}
