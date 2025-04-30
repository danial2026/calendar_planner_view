# Changelog

## 0.1.3

* Fixed image paths in README.md for pub.dev compatibility
* Updated documentation with proper GitHub raw content URLs
* Added descriptive alt text for screenshots

## 0.1.2

* Fixed deprecated `surfaceVariant` usage across the codebase
* Replaced all instances with `surfaceContainerHighest` for Material 3 compatibility
* Updated color handling in:
  * Calendar cells
  * Toggle buttons
  * Modal dialogs

## 0.1.1

* Fixed deprecated `withOpacity` usage across the codebase
* Replaced all opacity values with alpha values for better precision
* Updated color handling in:
  * Calendar cells
  * Event cards
  * Modal dialogs
  * Time labels
  * Theme colors
* Improved color consistency across components

## 0.1.0

* Initial release of the calendar planner view package
* Core Features:
  * Time-based daily calendar view with customizable time range
  * Month and week view modes with smooth transitions
  * Customizable date picker (top or modal position)
  * Event dots with multiple shapes (circle, square, diamond)
  * Sticky time labels with customizable style
  * Responsive layout for different screen sizes
  * Theme-aware styling with Material 3 support
  * Light and dark mode support
  * Localization support for dates and labels

* Event Management:
  * Smart event positioning with automatic overlap handling
  * Customizable event display through builder pattern
  * Event indicators with dots
  * Support for event descriptions
  * Custom event colors and styling

* Date Picker Features:
  * Flexible display modes (inline or popup)
  * Customizable cell shapes and borders
  * Week number display
  * Custom month and weekday names
  * Animated modal dialog
  * "Today" button with icon
  * Gradient header with calendar icon

* Technical Features:
  * Flutter Hooks integration
  * Efficient event overlap calculation
  * Responsive design patterns
  * Theme-aware styling system
  * Customizable styling for all components
  * Comprehensive documentation
  * Example app with theme switching 