import 'package:flutter/material.dart';
import 'package:fitness_app/services/support_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, John",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Let's check your activity",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.deepPurple.withValues(alpha: 0.2),
                      child: const Icon(Icons.person, color: Colors.deepPurple, size: 30),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Row(
                  children: [
                    Expanded(
                      child: InfoCard(
                        title: "Finished",
                        value: "0",
                        subtitle: "Completed Workouts",
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: InfoCard(
                        title: "In Progress",
                        value: "0",
                        subtitle: "Workouts",
                        icon: Icons.pending,
                        iconColor: Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                const InfoCard(
                  title: "Time Spent",
                  value: "0.0",
                  subtitle: "Minutes",
                  icon: Icons.timer,
                  iconColor: Colors.blue,
                ),

                const SizedBox(height: 30),

                const Text(
                  "Discover new workouts",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryCard(
                        title: "Cardio",
                        subtitle: "6 Exercises\n100 Minutes",
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 15),
                      CategoryCard(
                        title: "Arm",
                        subtitle: "6 Exercises\n100 Minutes",
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Top Workouts",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const WorkoutCard(
                  title: "Squats",
                  details: "2 sets | 10 Repetition",
                  time: "10:00",
                ),

                const WorkoutCard(
                  title: "Push Ups",
                  details: "3 sets | 15 Repetition",
                  time: "08:00",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
