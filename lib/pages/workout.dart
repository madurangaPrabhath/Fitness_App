import 'package:flutter/material.dart';
import 'package:fitness_app/exercise/exercise_detail.dart';
import 'package:fitness_app/services/support_widget.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  static const List<Map<String, dynamic>> _workouts = [
    {
      'title': 'Squats',
      'details': '3 sets | 15 Repetition',
      'time': '10:00',
      'icon': Icons.fitness_center,
      'color': 0xFF7C4DFF,
      'imagePath': 'images/fit1.png',
      'category': 'Strength',
    },
    {
      'title': 'Lunges',
      'details': '3 sets | 12 Repetition',
      'time': '12:00',
      'icon': Icons.directions_walk,
      'color': 0xFF00BFA5,
      'imagePath': 'images/fit2.png',
      'category': 'Strength',
    },
    {
      'title': 'Plank',
      'details': '3 sets | 60 Repetition',
      'time': '05:00',
      'icon': Icons.accessibility_new,
      'color': 0xFFE91E63,
      'imagePath': 'images/fit3.png',
      'category': 'Core',
    },
    {
      'title': 'Deadlifts',
      'details': '4 sets | 8 Repetition',
      'time': '15:00',
      'icon': Icons.fitness_center,
      'color': 0xFF00C853,
      'imagePath': 'images/fit1.png',
      'category': 'Strength',
    },
    {
      'title': 'Bicep Curls',
      'details': '3 sets | 12 Repetition',
      'time': '10:00',
      'icon': Icons.fitness_center,
      'color': 0xFF2979FF,
      'imagePath': 'images/fit1.png',
      'category': 'Strength',
    },
    {
      'title': 'Tricep Dips',
      'details': '3 sets | 15 Repetition',
      'time': '08:00',
      'icon': Icons.sports_gymnastics,
      'color': 0xFF7C4DFF,
      'imagePath': 'images/fit2.png',
      'category': 'Strength',
    },
    {
      'title': 'Shoulder Press',
      'details': '3 sets | 12 Repetition',
      'time': '10:00',
      'icon': Icons.accessibility_new,
      'color': 0xFF00BFA5,
      'imagePath': 'images/shoulder-stretch.jpg',
      'category': 'Strength',
    },
    {
      'title': 'Lateral Raises',
      'details': '3 sets | 15 Repetition',
      'time': '08:00',
      'icon': Icons.sports_handball,
      'color': 0xFFFF6D00,
      'imagePath': 'images/fit3.png',
      'category': 'Strength',
    },
    {
      'title': 'Push-Ups',
      'details': '3 sets | 15 Repetition',
      'time': '09:00',
      'icon': Icons.sports_gymnastics,
      'color': 0xFFE91E63,
      'imagePath': 'images/girl.jpg',
      'category': 'Strength',
    },
    {
      'title': 'Hammer Curls',
      'details': '3 sets | 12 Repetition',
      'time': '07:00',
      'icon': Icons.fitness_center,
      'color': 0xFF00C853,
      'imagePath': 'images/fit1.png',
      'category': 'Strength',
    },
    {
      'title': 'Jump Rope',
      'details': '3 sets | 30 Repetition',
      'time': '10:00',
      'icon': Icons.directions_run,
      'color': 0xFF2979FF,
      'imagePath': 'images/fit1.png',
      'category': 'Cardio',
    },
    {
      'title': 'High Knees',
      'details': '3 sets | 20 Repetition',
      'time': '08:00',
      'icon': Icons.directions_walk,
      'color': 0xFF00BFA5,
      'imagePath': 'images/fit2.png',
      'category': 'Cardio',
    },
    {
      'title': 'Burpees',
      'details': '3 sets | 10 Repetition',
      'time': '09:00',
      'icon': Icons.local_fire_department,
      'color': 0xFFFF3D00,
      'imagePath': 'images/fit3.png',
      'category': 'Cardio',
    },
    {
      'title': 'Jumping Jacks',
      'details': '3 sets | 20 Repetition',
      'time': '06:00',
      'icon': Icons.sports,
      'color': 0xFF7C4DFF,
      'imagePath': 'images/girl.jpg',
      'category': 'Cardio',
    },
    {
      'title': 'Mountain Climbers',
      'details': '3 sets | 20 Repetition',
      'time': '07:00',
      'icon': Icons.terrain,
      'color': 0xFF6D4C41,
      'imagePath': 'images/fit1.png',
      'category': 'Cardio',
    },
    {
      'title': 'Box Jumps',
      'details': '3 sets | 15 Repetition',
      'time': '09:00',
      'icon': Icons.sports_gymnastics,
      'color': 0xFFFF6D00,
      'imagePath': 'images/fit2.png',
      'category': 'Cardio',
    },
    {
      'title': 'Calf Stretch',
      'details': '1 set | 10 Repetition',
      'time': '10:00',
      'icon': Icons.directions_walk,
      'color': 0xFF00BFA5,
      'imagePath': 'images/calfstretch.jpeg',
      'category': 'Stretching',
    },
    {
      'title': 'Cat-Cow Stretch',
      'details': '2 sets | 20 Repetition',
      'time': '10:00',
      'icon': Icons.accessibility_new,
      'color': 0xFF7C4DFF,
      'imagePath': 'images/catcow.jpg',
      'category': 'Stretching',
    },
    {
      'title': 'Shoulder Stretch',
      'details': '2 sets | 20 Repetition',
      'time': '10:00',
      'icon': Icons.sports_gymnastics,
      'color': 0xFFFF6D00,
      'imagePath': 'images/shoulder-stretch.jpg',
      'category': 'Stretching',
    },
    {
      'title': 'Chest Stretch',
      'details': '2 sets | 20 Repetition',
      'time': '05:00',
      'icon': Icons.fitness_center,
      'color': 0xFFE91E63,
      'imagePath': 'images/fit2.png',
      'category': 'Stretching',
    },
    {
      'title': 'Hamstring Stretch',
      'details': '2 sets | 20 Repetition',
      'time': '05:00',
      'icon': Icons.self_improvement,
      'color': 0xFF6C63FF,
      'imagePath': 'images/hamstring-stretch.png',
      'category': 'Stretching',
    },
  ];

  static const List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.apps},
    {'label': 'Strength', 'icon': Icons.fitness_center},
    {'label': 'Cardio', 'icon': Icons.directions_run},
    {'label': 'Core', 'icon': Icons.accessibility_new},
    {'label': 'Stretching', 'icon': Icons.self_improvement},
  ];

  String _selectedCategory = 'All';

  List<Map<String, dynamic>> get _filteredWorkouts => _selectedCategory == 'All'
      ? _workouts
      : _workouts.where((w) => w['category'] == _selectedCategory).toList();

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

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter by Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setSheetState(() {});
                          setState(() => _selectedCategory = 'All');
                          Navigator.pop(ctx);
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _categories.map((cat) {
                      final isSelected =
                          _selectedCategory == cat['label'] as String;
                      return ChoiceChip(
                        avatar: Icon(
                          cat['icon'] as IconData,
                          size: 18,
                          color: isSelected ? Colors.white : Colors.deepPurple,
                        ),
                        label: Text(cat['label'] as String),
                        selected: isSelected,
                        selectedColor: Colors.deepPurple,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : null,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) {
                          setSheetState(
                            () => _selectedCategory = cat['label'] as String,
                          );
                          setState(
                            () => _selectedCategory = cat['label'] as String,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        'Apply',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredWorkouts;
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
                  GestureDetector(
                    onTap: _showFilterSheet,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedCategory == 'All'
                            ? Colors.deepPurple.withValues(alpha: 0.1)
                            : Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: _selectedCategory == 'All'
                            ? Colors.deepPurple
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                _selectedCategory == 'All'
                    ? '${filtered.length} exercises available'
                    : '${filtered.length} exercises · $_selectedCategory',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'No exercises found for this category.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final w = filtered[index];
                          final (sets, reps) = _parseSetsReps(
                            w['details'] as String,
                          );
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
