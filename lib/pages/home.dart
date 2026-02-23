import 'package:fitness_app/services/support_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text("Hi, Jane", style: AddWidget.headlineTextStyle(24.0)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
