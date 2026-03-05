import 'package:flutter/material.dart';
import 'package:fitness_app/exercise/exercise_detail.dart';
import 'package:fitness_app/services/support_widget.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  static const List<Map<String, dynamic>> _workouts = [
    {
      'title': 'Squats',
      'details': '3 sets | 15 Repetition',
      'time': '10:00',
      'icon': Icons.fitness_center,
      'color': 0xFF7C4DFF,
      'imagePath': 'images/fit1.png',
    },
    {
      'title': 'Lunges',
      'details': '3 sets | 12 Repetition',
      'time': '12:00',
      'icon': Icons.directions_walk,
      'color': 0xFF00BFA5,
      'imagePath': 'images/fit2.png',
    },
    {
      'title': 'Plank',
      'details': '3 sets | 60 Repetition',
      'time': '05:00',
      'icon': Icons.accessibility_new,
      'color': 0xFFE91E63,
      'imagePath': 'images/fit3.png',
    },
    {
      'title': 'Deadlifts',
      'details': '4 sets | 8 Repetition',
      'time': '15:00',
      'icon': Icons.fitness_center,
      'color': 0xFF00C853,
      'imagePath': 'images/fit1.png',
    },
    {
      'title': 'Bicep Curls',
      'details': '3 sets | 12 Repetition',
      'time': '10:00',
      'icon': Icons.fitness_center,
      'color': 0xFF2979FF,
      'imagePath': 'images/fit1.png',
    },
    {
      'title': 'Tricep Dips',
      'details': '3 sets | 15 Repetition',
      'time': '08:00',
      'icon': Icons.sports_gymnastics,
      'color': 0xFF7C4DFF,
      'imagePath': 'images/fit2.png',
    },
    {
      'title': 'Shoulder Press',
      'details': '3 sets | 12 Repetition',
      'time': '10:00',
      'icon': Icons.accessibility_new,
      'color': 0xFF00BFA5,
      'imagePath': 'images/shoulder-stretch.jpg',
    },
    {
      'title': 'Lateral Raises',
      'details': '3 sets | 15 Repetition',
      'time': '08:00',
      'icon': Icons.sports_handball,
      'color': 0xFFFF6D00,
      'imagePath': 'images/fit3.png',
    },
    {
      'title': 'Push-Ups',
      'details': '3 sets | 15 Repetition',
      'time': '09:00',
      'icon': Icons.sports_gymnastics,
      'color': 0xFFE91E63,
      'imagePath': 'images/girl.jpg',
    },
    {
      'title': 'Hammer Curls',
      'details': '3 sets | 12 Repetition',
      'time': '07:00',
      'icon': Icons.fitness_center,
      'color': 0xFF00C853,
      'imagePath': 'images/fit1.png',
    },
    {
      'title': 'Jump Rope',
      'details': '3 sets | 30 Repetition',
      'time': '10:00',
      'icon': Icons.directions_run,
      'color': 0xFF2979FF,
      'imagePath': 'images/fit1.png',
    },
    {
      'title': 'High Knees',
      'details': '3 sets | 20 Repetition',
      'time': '08:00',
      'icon': Icons.directions_walk,
      'color': 0xFF00BFA5,
      'imagePath': 'images/fit2.png',
    },
    {
      'title': 'Burpees',
      'details': '3 sets | 10 Repetition',
      'time': '09:00',
      'icon': Icons.local_fire_department,
      'color': 0xFFFF3D00,
      'imagePath': 'images/fit3.png',
    },
    {
      'title': 'Jumping Jacks',
      'details': '3 sets | 20 Repetition',
      'time': '06:00',
      'icon': Icons.sports,
      'color': 0xFF7C4DFF,
      'imagePath': 'images/girl.jpg',
    },
    {
      'title': 'Mountain Climbers',
      'details': '3 sets | 20 Repetition',
      'time': '07:00',
      'icon': Icons.terrain,
      'color': 0xFF6D4C41,
      'imagePath': 'images/fit1.png',
    },
    {
      'title': 'Box Jumps',
      'details': '3 sets | 15 Repetition',
      'time': '09:00',
      'icon': Icons.sports_gymnastics,
      'color': 0xFFFF6D00,
      'imagePath': 'images/fit2.png',
    },
    {
      'title': 'Calf Stretch',
      'details': '1 set | 10 Repetition',
      'time': '10:00',
      'icon': Icons.directions_walk,
      'color': 0xFF00BFA5,
      'imagePath': 'images/calfstretch.jpeg',
    },
    {
      'title': 'Cat-Cow Stretch',
      'details': '2 sets | 20 Repetition',
      'time': '10:00',
      'icon': Icons.accessibility_new,
      'color': 0xFF7C4DFF,
      'imagePath': 'images/catcow.jpg',
    },
    {
      'title': 'Shoulder Stretch',
      'details': '2 sets | 20 Repetition',
      'time': '10:00',
      'icon': Icons.sports_gymnastics,
      'color': 0xFFFF6D00,
      'imagePath': 'images/shoulder-stretch.jpg',
    },
    {
      'title': 'Chest Stretch',
      'details': '2 sets | 20 Repetition',
      'time': '05:00',
      'icon': Icons.fitness_center,
      'color': 0xFFE91E63,
      'imagePath': 'images/fit2.png',
    },
    {
      'title': 'Hamstring Stretch',
      'details': '2 sets | 20 Repetition',
      'time': '05:00',
      'icon': Icons.self_improvement,
      'color': 0xFF6C63FF,
      'imagePath': 'images/hamstring-stretch.png',
    },
  ];

  static (int sets, int reps) _parseSetsReps(String details) {
    final parts = details.split('|');
    final sets =
        int.tryParse(
          RegExp(r'\d+').firstMatch(parts.elementAtOrNull(0) ?? '')?.group(0) ??
              '3',
        ) ??
        3;
    final reps =
        int.tryParse(
          RegExp(r'\d+').firstMatch(parts.elementAtOrNull(1) ?? '')?.group(0) ??
              '10',
        ) ??
        10;
    return (sets, reps);
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                '${_workouts.length} exercises available',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: _workouts.length,
                  itemBuilder: (context, index) {
                    final w = _workouts[index];
                    final (sets, reps) = _parseSetsReps(w['details'] as String);
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExerciseDetailPage(
                            name: w['title'] as String,
                            imagePath: w['imagePath'] as String,
                            duration: w['time'] as String,
                            sets: sets,
                            defaultReps: reps,
                          ),
                        ),
                      ),
                      child: WorkoutCard(
                        title: w['title'] as String,
                        details: w['details'] as String,
                        time: w['time'] as String,
                        icon: w['icon'] as IconData,
                        iconColor: Color(w['color'] as int),
                      ),
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
