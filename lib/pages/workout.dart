import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/services/support_widget.dart';
import 'package:fitness_app/services/theme_provider.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  static const List<Map<String, dynamic>> _workouts = [
    {
      'title': 'Squats',
      'details': '2 sets | 10 Repetition',
      'time': '10:00',
      'icon': Icons.fitness_center,
      'color': 0xFF7C4DFF,
    },
    {
      'title': 'Push Ups',
      'details': '3 sets | 15 Repetition',
      'time': '08:00',
      'icon': Icons.sports_gymnastics,
      'color': 0xFFFF6D00,
    },
    {
      'title': 'Lunges',
      'details': '3 sets | 12 Repetition',
      'time': '12:00',
      'icon': Icons.directions_walk,
      'color': 0xFF00BFA5,
    },
    {
      'title': 'Plank',
      'details': '3 sets | 60 Seconds',
      'time': '05:00',
      'icon': Icons.accessibility_new,
      'color': 0xFFE91E63,
    },
    {
      'title': 'Burpees',
      'details': '3 sets | 10 Repetition',
      'time': '09:00',
      'icon': Icons.local_fire_department,
      'color': 0xFFFF3D00,
    },
    {
      'title': 'Jumping Jacks',
      'details': '3 sets | 20 Repetition',
      'time': '06:00',
      'icon': Icons.directions_run,
      'color': 0xFF2979FF,
    },
    {
      'title': 'Deadlifts',
      'details': '4 sets | 8 Repetition',
      'time': '15:00',
      'icon': Icons.fitness_center,
      'color': 0xFF00C853,
    },
    {
      'title': 'Mountain Climbers',
      'details': '3 sets | 20 Repetition',
      'time': '07:00',
      'icon': Icons.terrain,
      'color': 0xFF6D4C41,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Workouts',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => themeProvider.toggleTheme(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            themeProvider.isDarkMode
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.filter_list,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),
              const Text(
                '8 exercises available',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: _workouts.length,
                  itemBuilder: (context, index) {
                    final w = _workouts[index];
                    return WorkoutCard(
                      title: w['title'] as String,
                      details: w['details'] as String,
                      time: w['time'] as String,
                      icon: w['icon'] as IconData,
                      iconColor: Color(w['color'] as int),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
