import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'start_screen.dart';

const Color NEON_YELLOW = Color(0xFFF7EA48);
const Color NEON_PURPLE = Color(0xFFC41AFF);
const Color DARK_BG = Color(0xFF0B0010);

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PongApp());
}

class PongApp extends StatelessWidget
{
  const PongApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: DARK_BG,
        colorScheme: const ColorScheme.dark(
          primary: NEON_PURPLE,
          secondary: NEON_YELLOW,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: NEON_YELLOW),
          bodyLarge: TextStyle(color: NEON_YELLOW),
        ),
      ),
      home: const StartScreen(),
    );
  }
}
