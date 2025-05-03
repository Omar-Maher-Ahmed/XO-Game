import 'dart:math';

String checkWinner(List<String> board) {
  final winPatterns = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  for (var pattern in winPatterns) {
    final a = pattern[0];
    final b = pattern[1];
    final c = pattern[2];
    if (board[a] != '' && board[a] == board[b] && board[a] == board[c]) {
      return board[a];
    }
  }

  return board.contains('') ? '' : 'Draw';
}

int getBestMove(List<String> board, String aiPlayer, String humanPlayer) {
  int bestScore = -1000;
  int move = -1;

  for (int i = 0; i < 9; i++) {
    if (board[i] == '') {
      board[i] = aiPlayer;
      int score = minimax(board, 0, false, aiPlayer, humanPlayer);
      board[i] = '';
      if (score > bestScore) {
        bestScore = score;
        move = i;
      }
    }
  }

  return move;
}

int minimax(List<String> board, int depth, bool isMaximizing, String aiPlayer, String humanPlayer) {
  String result = checkWinner(board);
  if (result == aiPlayer) return 10 - depth;
  if (result == humanPlayer) return depth - 10;
  if (result == 'Draw') return 0;

  if (isMaximizing) {
    int bestScore = -1000;
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = aiPlayer;
        int score = minimax(board, depth + 1, false, aiPlayer, humanPlayer);
        board[i] = '';
        bestScore = max(score, bestScore);
      }
    }
    return bestScore;
  } else {
    int bestScore = 1000;
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = humanPlayer;
        int score = minimax(board, depth + 1, true, aiPlayer, humanPlayer);
        board[i] = '';
        bestScore = min(score, bestScore);
      }
    }
    return bestScore;
  }
}
