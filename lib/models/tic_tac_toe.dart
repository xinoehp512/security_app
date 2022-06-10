import 'dart:math';

class TicTacToe {
  final _board = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
  ];
  final _ticTacToes = [
    [
      [0, 0],
      [0, 1],
      [0, 2]
    ],
    [
      [1, 0],
      [1, 1],
      [1, 2]
    ],
    [
      [2, 0],
      [2, 1],
      [2, 2]
    ],
    [
      [0, 0],
      [1, 0],
      [2, 0]
    ],
    [
      [0, 1],
      [1, 1],
      [2, 1]
    ],
    [
      [0, 2],
      [1, 2],
      [2, 2]
    ],
    [
      [0, 0],
      [1, 1],
      [2, 2]
    ],
    [
      [0, 2],
      [1, 1],
      [2, 0]
    ],
  ];
  var gameOver = false;
  var winner = 0;
  List get availableMoves {
    var moves = [];
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        if (getCell(j, i) == 0) {
          moves.add([j, i]);
        }
      }
    }
    return moves;
  }

  int getCell(int x, int y) {
    return _board[y][x];
  }

  void setCell(int x, int y, int v) {
    if (x < 0 || x > 2 || y < 0 || y > 2) {
      return;
    }
    _board[y][x] = v;
  }

  void clearBoard() {
    gameOver = false;
    winner = 0;
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        setCell(j, i, 0);
      }
    }
  }

  void markCell(int x, int y) {
    if (x < 0 || x > 2 || y < 0 || y > 2) {
      return;
    }
    _board[y][x] *= 2;
  }

  void playerMove(int x, int y, int val) {
    setCell(x, y, val);
  }

  void aiMove(int val) {
    var random = Random();
    if (availableMoves.isEmpty) {
      gameOver = true;
      return;
    }
    var moveIndex = random.nextInt(availableMoves.length);
    var move = availableMoves[moveIndex];
    setCell(move[0], move[1], val);
  }

  List<List<int>>? checkForVictory() {
    for (var tictactoe in _ticTacToes) {
      var match = getCell(tictactoe[0][0], tictactoe[0][1]);
      for (var tile in tictactoe) {
        var play = getCell(tile[0], tile[1]);
        if (play != match) {
          match = 0;
          break;
        }
      }
      if (match == 0) {
        continue;
      }
      gameOver = true;
      winner = match;
      return tictactoe;
    }
    return null;
  }

  void markVictory(List<List<int>> cells) {
    for (var tile in cells) {
      markCell(tile[0], tile[1]);
    }
  }
}
