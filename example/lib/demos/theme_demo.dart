import 'package:flutter/material.dart';
import 'package:calendar_planner_view/calendar_planner_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../mock_events.dart';
import '../blocs/theme_bloc.dart';

class ThemeDemo extends StatelessWidget {
  const ThemeDemo({super.key});

  void _onEventTap(BuildContext context, CalendarEvent event) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: event.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                event.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  '${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} - '
                  '${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (event.description != null) ...[
              const SizedBox(height: 12),
              Text(
                event.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final currentTheme = context.read<ThemeBloc>().state.theme;
        final theme = Theme.of(context);

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Select Theme',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const Divider(),
              ...AppTheme.values.map((appTheme) {
                final isSelected = currentTheme == appTheme;
                return ListTile(
                  leading: Icon(
                    appTheme.icon,
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  ),
                  title: Text(appTheme.name),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    context.read<ThemeBloc>().add(ThemeChanged(appTheme));
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentTheme = context.watch<ThemeBloc>().state.theme;
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Demo'),
        actions: [
          IconButton(
            icon: Icon(currentTheme.icon),
            onPressed: () => _showThemeSelector(context),
          ),
        ],
      ),
      body: CalendarPlannerView(
        events: mockEvents,
        onEventTap: (event) => _onEventTap(context, event),
        datePickerPosition: DatePickerPosition.top,
        startHour: 8,
        endHour: 20,
        showDayTitle: true,
        enableViewToggle: true,
        initialView: CalendarViewType.week,
        dotColor: theme.colorScheme.primary,
        modalBackgroundColor: theme.colorScheme.surface,
        modalTitleStyle: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        modalTodayButtonTextStyle: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        calendarTitleStyle: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        dayTitleStyle: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        modalShowCloseButton: false,
        scrollController: scrollController,
      ),
    );
  }
}
