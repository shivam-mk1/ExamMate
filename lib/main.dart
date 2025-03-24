import 'package:exammate/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const Color customColor = Color.fromARGB(255, 39, 207, 193);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        fontFamily: 'Lato',
        primaryColor: customColor,

        colorScheme: ColorScheme.fromSeed(
          seedColor: customColor,
          primary: customColor,
          secondary: customColor,
          brightness: Brightness.light,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: customColor,
          selectionColor: Color.fromARGB(100, 39, 207, 193),
          selectionHandleColor: customColor,
        ),

        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: customColor,
          linearTrackColor: Color.fromARGB(100, 39, 207, 193),
        ),

        buttonTheme: const ButtonThemeData(buttonColor: customColor),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: customColor,
        ),
      ),
    );
  }
}
