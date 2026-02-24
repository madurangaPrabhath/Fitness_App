import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_app/services/support_widget.dart';
import 'package:fitness_app/services/theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, John',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Let's check your activity",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
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
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.deepPurple.withValues(
                            alpha: 0.15,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.deepPurple,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Container(
                  width: double.infinity,
                  height: 160,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset('images/girl.jpg', fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.5),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      const Positioned(
                        bottom: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stay Consistent!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Your body achieves what your mind believes',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Row(
                  children: [
                    Expanded(
                      child: InfoCard(
                        title: 'Finished',
                        value: '0',
                        subtitle: 'Completed Workouts',
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: InfoCard(
                        title: 'In Progress',
                        value: '0',
                        subtitle: 'Workouts',
                        icon: Icons.pending,
                        iconColor: Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                const InfoCard(
                  title: 'Time Spent',
                  value: '0.0',
                  subtitle: 'Minutes',
                  icon: Icons.timer,
                  iconColor: Colors.blue,
                ),

                const SizedBox(height: 30),

                const Text(
                  'Discover new workouts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryCard(
                        title: 'Cardio',
                        subtitle: '6 Exercises\n100 Minutes',
                        color: Colors.orange,
                        image: 'images/fit1.png',
                      ),
                      const SizedBox(width: 15),
                      CategoryCard(
                        title: 'Arm',
                        subtitle: '6 Exercises\n100 Minutes',
                        color: Colors.teal,
                        image: 'images/fit2.png',
                      ),
                      const SizedBox(width: 15),
                      CategoryCard(
                        title: 'Legs',
                        subtitle: '8 Exercises\n120 Minutes',
                        color: Colors.blue,
                        image: 'images/fit3.png',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Top Workouts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                const WorkoutCard(
                  title: 'Squats',
                  details: '2 sets | 10 Repetition',
                  time: '10:00',
                  icon: Icons.fitness_center,
                  iconColor: Color(0xFF7C4DFF),
                ),
                const WorkoutCard(
                  title: 'Push Ups',
                  details: '3 sets | 15 Repetition',
                  time: '08:00',
                  icon: Icons.sports_gymnastics,
                  iconColor: Color(0xFFFF6D00),
                ),
                const WorkoutCard(
                  title: 'Lunges',
                  details: '3 sets | 12 Repetition',
                  time: '12:00',
                  icon: Icons.directions_walk,
                  iconColor: Color(0xFF00BFA5),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
