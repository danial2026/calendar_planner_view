import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'blocs/theme_bloc.dart';
import 'demos/basic_demo.dart';
import 'demos/multi_column_demo.dart';
import 'demos/custom_events_demo.dart';
import 'demos/theme_demo.dart';

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
            debugShowCheckedModeBanner: false,
            title: 'Calendar Planner View Demo',
            theme: _buildTheme(state.theme, false),
            darkTheme: _buildTheme(state.theme, true),
            themeMode: state.theme.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const HomePage(),
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentTheme = context.watch<ThemeBloc>().state.theme;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Package info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calendar Planner View',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A customizable daily calendar planner view with time-based events and Material 3 design.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: () => _launchUrl('https://pub.dev/packages/calendar_planner_view'),
                          icon: const Icon(Icons.public),
                          label: const Text('pub.dev'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: () => _launchUrl('https://github.com/danial2026/calendar_planner_view'),
                          icon: const Icon(Icons.code),
                          label: const Text('GitHub'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Demo pages
            Text(
              'Demo Pages',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              children: [
                _DemoCard(
                  title: 'Basic Demo',
                  description: 'Simple calendar view with basic events',
                  icon: Icons.calendar_today,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BasicDemo()),
                  ),
                ),
                _DemoCard(
                  title: 'Multi-Column Demo',
                  description: 'Calendar with multiple columns for different event types',
                  icon: Icons.view_column,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MultiColumnDemo()),
                  ),
                ),
                _DemoCard(
                  title: 'Custom Events Demo',
                  description: 'Calendar with custom event styling and interactions',
                  icon: Icons.event,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CustomEventsDemo()),
                  ),
                ),
                _DemoCard(
                  title: 'Theme Demo',
                  description: 'Calendar with different theme variations',
                  icon: Icons.palette,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ThemeDemo()),
                  ),
                ),
              ],
            ),
          ],
        ),
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
}

class _DemoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _DemoCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 280),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surface.withAlpha(26),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View Demo',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
