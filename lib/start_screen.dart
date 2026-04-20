import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'leaderboard_screen.dart';
import 'main.dart';

class StartScreen extends StatefulWidget
{
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
{
  final TextEditingController nameController = TextEditingController();

  String selectedMode = "ai";
  String difficulty = "Medium";

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [DARK_BG, Color(0xFF120017)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                "P O N G",
                style: TextStyle(
                  color: NEON_YELLOW,
                  fontSize: 84,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                  shadows: [
                    Shadow(
                      blurRadius: 18,
                      color: NEON_PURPLE,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: 260,
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(color: NEON_YELLOW),
                  decoration: const InputDecoration(
                    hintText: "Enter your name",
                    hintStyle: TextStyle(color: NEON_PURPLE),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: NEON_PURPLE),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              DropdownButton<String>(
                value: selectedMode,
                dropdownColor: DARK_BG,
                style: const TextStyle(color: NEON_YELLOW),
                items: const [
                  DropdownMenuItem(value: "ai", child: Text("Play vs AI")),
                  DropdownMenuItem(value: "wall", child: Text("Play vs Wall")),
                ],
                onChanged: (value)
                {
                  setState(() {
                    selectedMode = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButton<String>(
                value: difficulty,
                dropdownColor: DARK_BG,
                style: const TextStyle(color: NEON_YELLOW),
                items: const [
                  DropdownMenuItem(value: "Easy", child: Text("Easy")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "Hard", child: Text("Hard")),
                ],
                onChanged: (value)
                {
                  setState(() {
                    difficulty = value!;
                  });
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: ()
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(
                        mode: selectedMode,
                        playerName: nameController.text.isEmpty
                            ? "Player"
                            : nameController.text,
                        difficulty: difficulty,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: NEON_PURPLE,
                  foregroundColor: NEON_YELLOW,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                ),
                child: const Text("Start Game", style: TextStyle(fontSize: 20)),
              ),

              const SizedBox(height: 14),

              ElevatedButton(
                onPressed: ()
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaderboardScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: NEON_YELLOW,
                  side: const BorderSide(color: NEON_PURPLE),
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                ),
                child: const Text("View Leaderboard", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
