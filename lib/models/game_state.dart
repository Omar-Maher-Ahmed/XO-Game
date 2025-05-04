import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

import '../widgets/board_tile.dart';
import '../models/game_state.dart';
import '../utils/helpers.dart';

class GameScreen extends StatefulWidget {
  final bool isSinglePlayer;
  const GameScreen({super.key, this.isSinglePlayer = false});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState game;
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));
  bool showLoserEffect = false;

  @override
  void initState() {
    super.initState();
    game = GameState();
  }

  void handleTap(int index) {
    if (!game.makeMove(index)) return;

    setState(() {});

    if (game.winner.isNotEmpty) {
      if (game.winner != 'Draw') {
        _confettiController.play();
        showLoserEffect = true;
      }
      return;
    }

    // لو بيلعب ضد الكمبيوتر
    if (widget.isSinglePlayer && !game.isXTurn) {
      Future.delayed(const Duration(milliseconds: 400), () {
        int move = getComputerMove(game.board);
        game.makeMove(move);
        setState(() {
          if (game.winner != '' && game.winner != 'Draw') {
            _confettiController.play();
            showLoserEffect = true;
          }
        });
      });
    }
  }

  void resetGame() {
    setState(() {
      game.reset();
      showLoserEffect = false;
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final loser = (game.winner == 'X') ? 'O' : 'X';

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tic Tac Toe',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      game.winner.isNotEmpty
                          ? (game.winner == 'Draw'
                              ? 'It\'s a Draw!'
                              : '${game.winner} Wins!')
                          : 'Turn: ${game.isXTurn ? 'X' : 'O'}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: size.width * 0.8,
                      height: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: GridView.count(
                        padding: const EdgeInsets.all(12),
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: List.generate(9, (index) {
                          return BoardTile(
                            symbol: game.board[index],
                            onTap: () => handleTap(index),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: resetGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: const Text('Restart Game',
                          style: TextStyle(fontSize: 18)),
                    )
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                maxBlastForce: 30,
                minBlastForce: 10,
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                gravity: 0.2,
                colors: const [Colors.purple, Colors.pink, Colors.orange],
              ),
            ),

            if (game.winner != '' && game.winner != 'Draw')
              Positioned(
                bottom: 100,
                child: Column(
                  children: [
                    Text(
                      '${game.winner} Wins! \uD83C\uDFC6',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Icon(Icons.emoji_events, color: Colors.amber, size: 50),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
