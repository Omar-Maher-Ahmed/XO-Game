import 'package:flutter/material.dart';
import 'game_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("اختر طريقة اللعب", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GameScreen(isSinglePlayer: true),
                  ),
                );
              },
              child: const Text("2 لاعبين"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GameScreen(isSinglePlayer: true),
                  ),
                );
              },
              child: const Text("لاعب ضد الكمبيوتر"),
            ),
          ],
        ),
      ),
    );
  }
}
