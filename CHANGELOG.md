# Changelog

## 0.1.14

* Added container color customization for all calendar states

## 0.1.13

* Added complete FlexibleDatePicker customization support

## 0.1.12

* Added current time indicator in timeline view
* Enhanced event overlap handling with smart positioning
* Improved theme-aware styling across all components
* Added customizable time label formatting

## 0.1.11

* Enhanced callback documentation with detailed examples and usage scenarios
* Added dedicated callbacks section to library documentation

## 0.1.10

* Added optional ID field to events for better tracking and persistence
* Improved event model documentation

## 0.1.9

* Update screenshots

## 0.1.8

* Added support for custom event columns:
  * Optional additional columns with custom titles and content
  * Minimum 2 and maximum 10 columns
  * Customizable column width
  * Flexible content builder for each column
* Enhanced event list layout with column headers
* Improved event time display
* Events with the same start time are now always shown side by side in a row in the timeline view, improving clarity for simultaneous events. 

## 0.1.7

* Enhanced documentation and code comments
* Fixed calendar view not updating when toggle button is pressed

## 0.1.6

* Fix horizontal swipe gesture support
* Enhanced gesture handling for smoother transitions

## 0.1.5

* Added smooth gesture-based view switching (month ↔ week) with natural animations
* Improved calendar UX with controlled drag distance and damping
* Added CalendarStyle extension for better customization
* Fixed toggle button state sync with gesture-based view changes

## 0.1.4

* Update package version to 0.1.4
* Upgrade dependencies to latest compatible versions:
  - table_calendar: ^3.2.0
  - intl: ^0.20.2
  - flutter_hooks: ^0.21.2
* Modified README.md to use 'any' version specifier for calendar_planner_view dependency
  allowing greater flexibility for consumers

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