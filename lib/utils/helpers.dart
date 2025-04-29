String checkWinner(List<String> board) {
  const List<List<int>> winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6],
  ];

  for (var pattern in winPatterns) {
    final a = pattern[0], b = pattern[1], c = pattern[2];
    if (board[a] != '' && board[a] == board[b] && board[b] == board[c]) {
      return board[a];
    }
  }

  if (!board.contains('')) return 'Draw';

  return '';
}
