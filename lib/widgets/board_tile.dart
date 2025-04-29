import 'package:flutter/material.dart';

class BoardTile extends StatelessWidget {
  final String symbol;
  final VoidCallback onTap;

  const BoardTile({super.key, required this.symbol, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = symbol == 'X' ? Colors.deepPurple : Colors.pinkAccent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Center(
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: symbol.isNotEmpty ? color : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
