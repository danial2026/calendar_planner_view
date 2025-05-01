import 'package:flutter/material.dart';
import 'package:calendar_planner_view/calendar_planner_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mock_events.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'blocs/theme_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Calendar Planner View Demo',
            theme: _buildTheme(state.theme, false),
            darkTheme: _buildTheme(state.theme, true),
            themeMode: state.theme.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const MyHomePage(),
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(AppTheme theme, bool isDark) {
    final seedColor = theme.seedColor;
    final brightness = isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
        primary: seedColor,
        secondary: seedColor.withAlpha(204),
        tertiary: seedColor.withAlpha(153),
        surface: isDark ? Colors.grey[900]! : Colors.grey[50]!,
        error: Colors.red,
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _onEventTap(BuildContext context, CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time: ${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} - '
              '${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}',
            ),
            if (event.description != null) ...[
              const SizedBox(height: 8),
              Text(event.description!),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final currentTheme = state.theme;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Calendar Planner View Demo'),
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
            initialView: CalendarViewType.month,
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
          ),
        );
      },
    );
  }
}
