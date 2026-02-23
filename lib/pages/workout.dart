import 'package:flutter/material.dart';
import 'package:fitness_app/services/support_widget.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  static const List<Map<String, dynamic>> _workouts = [
    {
      'title': 'Squats',
      'details': '2 sets | 10 Repetition',
      'time': '10:00',
      'icon': Icons.fitness_center,
    },
    {
      'title': 'Push Ups',
      'details': '3 sets | 15 Repetition',
      'time': '08:00',
      'icon': Icons.fitness_center,
    },
    {
      'title': 'Lunges',
      'details': '3 sets | 12 Repetition',
      'time': '12:00',
      'icon': Icons.directions_walk,
    },
    {
      'title': 'Plank',
      'details': '3 sets | 60 Seconds',
      'time': '05:00',
      'icon': Icons.accessibility_new,
    },
    {
      'title': 'Burpees',
      'details': '3 sets | 10 Repetition',
      'time': '09:00',
      'icon': Icons.local_fire_department,
    },
    {
      'title': 'Jumping Jacks',
      'details': '3 sets | 20 Repetition',
      'time': '06:00',
      'icon': Icons.directions_run,
    },
    {
      'title': 'Deadlifts',
      'details': '4 sets | 8 Repetition',
      'time': '15:00',
      'icon': Icons.fitness_center,
    },
    {
      'title': 'Mountain Climbers',
      'details': '3 sets | 20 Repetition',
      'time': '07:00',
      'icon': Icons.terrain,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
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
