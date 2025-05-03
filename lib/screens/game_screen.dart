import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/board_tile.dart';
import '../utils/helpers.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final bool isSinglePlayer;

const GameScreen({super.key, this.isSinglePlayer = false});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  String winner = '';

  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));
  bool showLoserEffect = false;

  void handleTap(int index) {
    if (board[index] != '' || winner != '') return;

    setState(() {
      board[index] = isXTurn ? 'X' : 'O';
      isXTurn = !isXTurn;
      winner = checkWinner(board);

      if (winner == 'X' || winner == 'O') {
        _confettiController.play();
        showLoserEffect = true;
      } else if (winner == 'Draw') {
        showLoserEffect = false;
      }
    });
    // بعد التأكد إن اللعبة لسه مكملة و في وضع فردي
    if (widget.isSinglePlayer && !isXTurn && winner == '') {
      Future.delayed(const Duration(milliseconds: 500), () {
        int move = getBestMove(board, 'O', 'X'); // هنضيفة في helpers.dart
        if (move != -1) {
          setState(() {
            board[move] = 'O';
            isXTurn = true;
            winner = checkWinner(board);
            if (winner == 'X' || winner == 'O') {
              _confettiController.play();
              showLoserEffect = true;
            } else if (winner == 'Draw') {
              showLoserEffect = false;
            }
          });
        }
      });
    }

  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      winner = '';
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
    final loser = (winner == 'X') ? 'O' : 'X';

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
                      winner.isNotEmpty
                          ? (winner == 'Draw'
                              ? 'It\'s a Draw!'
                              : '$winner Wins!')
                          : 'Turn: ${isXTurn ? 'X' : 'O'}',
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
                            symbol: board[index],
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

            // ✅ Confetti when win
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

             // ✅ Funny loser animation
            if (winner != '' && winner != 'Draw')
              Positioned(
                bottom: 100,
                child: Column(
                  children: [
                    Text(
                      '$winner Wins! 🏆',
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
