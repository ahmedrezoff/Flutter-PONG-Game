import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'start_screen.dart';
import 'main.dart';

class GameOverScreen extends StatefulWidget
{
  final String result;
  final int score;
  final String playerName;
  final String difficulty;

  const GameOverScreen({
    super.key,
    required this.result,
    required this.score,
    required this.playerName,
    required this.difficulty,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
{
  bool saved = false;

  @override
  void initState()
  {
    super.initState();
    _saveScoreOnce();
  }

  Future<void> _saveScoreOnce() async
  {
    if (saved) return;
    saved = true;

    await FirebaseService.saveScore(
      player: widget.playerName,
      score: widget.score,
      difficulty: widget.difficulty,
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
                widget.result,
                style: const TextStyle(
                  color: NEON_YELLOW,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "Player: ${widget.playerName}",
                style: const TextStyle(color: NEON_YELLOW, fontSize: 20),
              ),

              Text(
                "Difficulty: ${widget.difficulty}",
                style: const TextStyle(color: NEON_YELLOW, fontSize: 18),
              ),

              const SizedBox(height: 20),

              Text(
                "Score: ${widget.score}",
                style: const TextStyle(color: NEON_YELLOW, fontSize: 28),
              ),

              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: ()
                {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StartScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: NEON_PURPLE,
                  foregroundColor: NEON_YELLOW,
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                ),
                child: const Text(
                  "Return to Menu",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
