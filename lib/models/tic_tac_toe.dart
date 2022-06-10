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
  var _playerMovesX = true;
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

  void switchXPlayer() {
    _playerMovesX = !_playerMovesX;
  }

  void playerMove(int x, int y) {
    setCell(x, y, _playerMovesX ? 1 : -1);
  }

  void aiMove() {
    var random = Random();
    if (availableMoves.isEmpty) {
      return;
    }
    var moveIndex = random.nextInt(availableMoves.length);
    var move = availableMoves[moveIndex];
    setCell(move[0], move[1], _playerMovesX ? -1 : 1);
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
      return tictactoe;
    }
    return null;
  }

  int markVictory(List<List<int>> cells) {
    for (var tile in cells) {
      markCell(tile[0], tile[1]);
    }
    return getCell(cells[0][0], cells[0][1]);
  }
}
