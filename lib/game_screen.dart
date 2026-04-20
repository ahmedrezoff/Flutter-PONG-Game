import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_over_screen.dart';
import 'main.dart';

class GameScreen extends StatefulWidget
{
  final String mode;
  final String playerName;
  final String difficulty;

  const GameScreen({
    super.key,
    required this.mode,
    required this.playerName,
    required this.difficulty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
{
  static const double baseBallXSpeed = 0.005;
  static const double baseBallYSpeed = 0.007;

  double ballX = 0.5;
  double ballY = 0.9;
  late double ballXSpeed;
  late double ballYSpeed;

  double playerX = 0.4;
  double aiX = 0.4;
  final double paddleWidth = 0.2;

  int score = 0;
  int playerRoundWins = 0;
  int aiRoundWins = 0;
  final int roundsToWin = 2;

  bool roundStarting = false;
  Timer? timer;
  final FocusNode _focus = FocusNode();

  double aiReaction = 0.0;
  double aiMaxSpeed = 0.0;

  @override
  void initState()
  {
    super.initState();
    _applyDifficulty();
    resetRoundPositionsAndSpeeds();
    _startMatchDelay();
  }

  void _applyDifficulty()
  {
    if (widget.difficulty == "Easy")
    {
      aiReaction = 0.015;
      aiMaxSpeed = 0.004;
    }
    else if (widget.difficulty == "Medium")
    {
      aiReaction = 0.010;
      aiMaxSpeed = 0.006;
    }
    else
    {
      aiReaction = 0.004;
      aiMaxSpeed = 0.009;
    }
  }

  void _startMatchDelay()
  {
    roundStarting = true;
    Future.delayed(const Duration(milliseconds: 700), ()
    {
      roundStarting = false;
      startGame();
    });
  }

  void startGame()
  {
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 16), (t)
    {
      updateGame();
    });
  }

  void resetRoundPositionsAndSpeeds()
  {
    ballX = 0.5;
    ballY = 0.5;
    playerX = 0.4;
    aiX = 0.4;

    ballXSpeed = baseBallXSpeed * (math.Random().nextBool() ? 1 : -1);
    ballYSpeed = baseBallYSpeed;
  }

  void _resetRoundWithDelay()
  {
    timer?.cancel();
    setState(() {
      roundStarting = true;
      resetRoundPositionsAndSpeeds();
    });

    Future.delayed(const Duration(milliseconds: 700), ()
    {
      setState(() {
        roundStarting = false;
      });
      startGame();
    });
  }

  void endMatch(String result)
  {
    timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameOverScreen(
          result: result,
          score: score,
          playerName: widget.playerName,
          difficulty: widget.difficulty,
        ),
      ),
    );
  }

  void updateGame()
  {
    if (roundStarting) return;

    setState(() {
      ballX += ballXSpeed;
      ballY += ballYSpeed;

      if (ballX <= 0 || ballX >= 1)
      {
        ballXSpeed = -ballXSpeed;
      }

      if (widget.mode == "wall" && ballY <= 0)
      {
        ballYSpeed = -ballYSpeed;
      }

      if (widget.mode == "ai")
      {
        double aiCenter = aiX + paddleWidth / 2;
        double targetX = ballX - paddleWidth / 2;
        double diff = targetX - aiX;

        if (diff.abs() > aiReaction)
        {
          aiX += diff.clamp(-aiMaxSpeed, aiMaxSpeed);
        }

        if (aiX < 0) aiX = 0;
        if (aiX + paddleWidth > 1) aiX = 1 - paddleWidth;
      }

      if (ballY >= 0.9 &&
          ballX >= playerX &&
          ballX <= playerX + paddleWidth &&
          ballYSpeed > 0)
      {
        ballYSpeed = -ballYSpeed;
        ballXSpeed *= 1.05;
        ballYSpeed *= 1.05;
        score++;
      }

      if (widget.mode == "ai")
      {
        if (ballY <= 0.1 &&
            ballX >= aiX &&
            ballX <= aiX + paddleWidth &&
            ballYSpeed < 0)
        {
          ballYSpeed = -ballYSpeed;
        }
      }

      if (ballY > 1)
      {
        if (widget.mode == "wall")
        {
          endMatch("You Lost!");
          return;
        }
        else
        {
          aiRoundWins++;
          if (aiRoundWins >= roundsToWin)
          {
            endMatch("AI Wins Match!");
            return;
          }
          _resetRoundWithDelay();
        }
      }

      if (widget.mode == "ai" && ballY < 0)
      {
        playerRoundWins++;
        if (playerRoundWins >= roundsToWin)
        {
          endMatch("Player Wins Match!");
          return;
        }
        _resetRoundWithDelay();
      }
    });
  }

  void moveLeft()
  {
    setState(() {
      playerX -= 0.05;
      if (playerX < 0) playerX = 0;
    });
  }

  void moveRight()
  {
    setState(() {
      playerX += 0.05;
      if (playerX + paddleWidth > 1) playerX = 1 - paddleWidth;
    });
  }

  @override
  void dispose()
  {
    timer?.cancel();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: _focus,
        autofocus: true,
        onKey: (event)
        {
          if (event is RawKeyDownEvent)
          {
            if (event.logicalKey == LogicalKeyboardKey.arrowLeft) moveLeft();
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) moveRight();
          }
        },
        child: CustomPaint(
          painter: _GamePainter(ballX, ballY, playerX, aiX, paddleWidth, widget.mode),
          child: Container(),
        ),
      ),
    );
  }
}

class _GamePainter extends CustomPainter
{
  final double ballX, ballY, playerX, aiX, width;
  final String mode;

  _GamePainter(this.ballX, this.ballY, this.playerX, this.aiX, this.width, this.mode);

  @override
  void paint(Canvas canvas, Size size)
  {
    final ballPaint = Paint()..color = NEON_YELLOW;
    final playerPaint = Paint()..color = NEON_PURPLE;
    final aiPaint = Paint()..color = const Color(0xFF7A0099);

    canvas.drawCircle(
      Offset(ballX * size.width, ballY * size.height),
      10,
      ballPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(playerX * size.width, size.height * 0.92, width * size.width, 10),
      playerPaint,
    );

    if (mode == "ai")
    {
      canvas.drawRect(
        Rect.fromLTWH(aiX * size.width, size.height * 0.06, width * size.width, 10),
        aiPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
