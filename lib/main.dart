import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/landing_page.dart';
import 'services/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The flutter/lifecycle channel has a default buffer size of 1.
  // Firebase Web fires multiple lifecycle messages during its async JS
  // initialization, causing extras to be discarded with a warning.
  // Increasing the buffer ensures all messages are retained and delivered
  // once the WidgetsBinding handler is registered.
  ui.channelBuffers.resize('flutter/lifecycle', 64);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final themeProvider = ThemeProvider();
  await themeProvider.loadFromPrefs();
  runApp(
    ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const LandingPage(),
    );
  }
}
