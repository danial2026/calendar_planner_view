import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

/// A utility class that provides centralized styling for calendar components.
///
/// This class offers a comprehensive set of styling utilities for the calendar planner view,
/// including default styles, decorations, and theme-aware configurations. It ensures consistent
/// visual appearance across different calendar components while maintaining flexibility for
/// customization.
///
/// ## Features
/// * Theme-aware styling that adapts to light/dark modes
/// * Consistent spacing and padding across components
/// * Customizable shadows and borders
/// * Flexible cell shapes and decorations
/// * Pre-configured styles for headers, cells, and containers
///
/// ## Usage
/// ```dart
/// // Get default header style with theme
/// final headerStyle = CalendarStyleUtils.getDefaultHeaderStyle(
///   theme,
///   monthTitleStyle: customTitleStyle,
/// );
///
/// // Get default calendar style with custom cell shape
/// final calendarStyle = CalendarStyleUtils.getDefaultCalendarStyle(
///   theme,
///   cellShape: BoxShape.circle,
/// );
///
/// // Get default calendar decoration with shadow
/// final decoration = CalendarStyleUtils.getDefaultCalendarDecoration(
///   theme,
///   shadowColor: Colors.black26,
///   shadowBlurRadius: 8.0,
/// );
/// ```
///
/// ## Styling Components
/// * Calendar Header: Month/year display with navigation controls
/// * Calendar Cells: Date numbers with event indicators
/// * Week Numbers: Optional week number display
/// * Event Dots: Visual indicators for events
/// * Modal Dialogs: Calendar picker dialog styling
///
/// ## Theme Integration
/// All styling methods are designed to work with Flutter's theming system,
/// automatically adapting to the current theme's color scheme and text styles.
/// Custom colors and styles can be provided to override the defaults.
///
/// ## Constants
/// The class provides a set of default values for common styling properties:
/// * Padding values for various components
/// * Border radius values for containers
/// * Shadow properties for elevation effects
/// * Icon sizes for navigation controls
/// * Maximum widths for modal dialogs
///
/// These constants ensure consistent spacing and sizing across the calendar interface.
class CalendarStyleUtils {
  /// Default padding for calendar cells.
  /// Used for spacing between date numbers and cell borders.
  static const EdgeInsets defaultCellPadding = EdgeInsets.symmetric(horizontal: 1.5);

  /// Default padding for event dots.
  /// Controls the vertical spacing of event indicators below date numbers.
  static const EdgeInsets defaultEventDotPadding = EdgeInsets.only(top: 36.0);

  /// Default padding for week number container.
  /// Used for spacing around the week number indicator.
  static const EdgeInsets defaultWeekNumberPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 4);

  /// Default padding for calendar.
  /// Controls the spacing around the entire calendar widget.
  static const EdgeInsets defaultCalendarPadding = EdgeInsets.all(8.0);

  /// Default padding for calendar header.
  /// Used for spacing in the month/year display area.
  static const EdgeInsets defaultHeaderPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 6);

  /// Default padding for chevron icons.
  /// Controls the touch target size for navigation buttons.
  static const EdgeInsets defaultChevronPadding = EdgeInsets.all(8.0);

  /// Default border radius for week number container.
  /// Controls the corner roundness of the week number indicator.
  static const double defaultWeekNumberBorderRadius = 16.0;

  /// Default border radius for calendar.
  /// Controls the corner roundness of the calendar container.
  static const double defaultCalendarBorderRadius = 16.0;

  /// Default shadow blur radius for calendar.
  /// Controls the spread of the calendar's shadow.
  static const double defaultShadowBlurRadius = 12.0;

  /// Default shadow offset for calendar.
  /// Controls the position of the calendar's shadow.
  static const Offset defaultShadowOffset = Offset(0, 4);

  /// Default chevron icon size.
  /// Controls the size of navigation arrows.
  static const double defaultChevronIconSize = 24.0;

  /// Default event dot size.
  /// Controls the diameter of event indicator dots.
  static const double defaultEventDotSize = 5.0;

  /// Default maximum width for modal.
  /// Constrains the width of the calendar modal dialog.
  static const double defaultModalMaxWidth = 400.0;

  /// Get default header style with theme-aware customization.
  ///
  /// Returns a [HeaderStyle] configured with the provided theme and optional
  /// customizations. The style includes:
  /// - Centered title
  /// - Custom month title style
  /// - Navigation chevrons
  /// - Consistent padding
  ///
  /// All parameters are optional and will fall back to theme defaults if not specified.
  static HeaderStyle getDefaultHeaderStyle(
    ThemeData theme, {
    TextStyle? monthTitleStyle,
    Color? chevronIconColor,
    double? chevronIconSize,
    EdgeInsets? chevronPadding,
  }) {
    return HeaderStyle(
      titleCentered: true,
      formatButtonVisible: false,
      titleTextStyle: monthTitleStyle ??
          theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: theme.colorScheme.onSurface,
          ),
      leftChevronIcon: Icon(
        Icons.chevron_left,
        color: chevronIconColor ?? theme.colorScheme.onSurface,
        size: chevronIconSize ?? defaultChevronIconSize,
      ),
      rightChevronIcon: Icon(
        Icons.chevron_right,
        color: chevronIconColor ?? theme.colorScheme.onSurface,
        size: chevronIconSize ?? defaultChevronIconSize,
      ),
      leftChevronPadding: chevronPadding ?? defaultChevronPadding,
      rightChevronPadding: chevronPadding ?? defaultChevronPadding,
    );
  }

  /// Get default calendar style with theme-aware customization.
  ///
  /// Returns a [CalendarStyle] configured with the provided theme and optional
  /// customizations. The style includes:
  /// - Selected date highlighting
  /// - Today's date styling
  /// - Event marker positioning
  /// - Cell shape customization
  ///
  /// All parameters are optional and will fall back to theme defaults if not specified.
  static CalendarStyle getDefaultCalendarStyle(
    ThemeData theme, {
    required BoxShape cellShape,
    BorderRadius? cellBorderRadius,
  }) {
    return CalendarStyle(
      selectedDecoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: cellShape,
        borderRadius: cellShape == BoxShape.rectangle ? cellBorderRadius : null,
      ),
      todayDecoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.2),
        shape: cellShape,
        borderRadius: cellShape == BoxShape.rectangle ? cellBorderRadius : null,
      ),
      markersAlignment: Alignment.bottomCenter,
      markerMargin: const EdgeInsets.only(top: 8),
    );
  }

  /// Get default week number container decoration.
  ///
  /// Returns a [BoxDecoration] for the week number indicator with theme-aware
  /// styling. The decoration includes:
  /// - Background color
  /// - Border radius
  /// - Optional customizations
  ///
  /// All parameters are optional and will fall back to theme defaults if not specified.
  static BoxDecoration getDefaultWeekNumberDecoration(
    ThemeData theme, {
    Color? backgroundColor,
    double? borderRadius,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? theme.colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(borderRadius ?? defaultWeekNumberBorderRadius),
    );
  }

  /// Get default calendar container decoration.
  ///
  /// Returns a [BoxDecoration] for the calendar container with theme-aware
  /// styling. The decoration includes:
  /// - Background color
  /// - Border radius
  /// - Border
  /// - Shadow effects
  ///
  /// All parameters are optional and will fall back to theme defaults if not specified.
  static BoxDecoration getDefaultCalendarDecoration(
    ThemeData theme, {
    Color? backgroundColor,
    BorderRadius? borderRadius,
    BoxBorder? border,
    Color? shadowColor,
    double? shadowBlurRadius,
    Offset? shadowOffset,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? theme.colorScheme.surface,
      borderRadius: borderRadius,
      border: border,
      boxShadow: [
        BoxShadow(
          color: shadowColor ?? Colors.transparent,
          blurRadius: shadowBlurRadius ?? 0.0,
          offset: shadowOffset ?? Offset.zero,
        ),
      ],
    );
  }
}
