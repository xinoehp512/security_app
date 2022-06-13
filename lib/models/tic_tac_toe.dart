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
    if (availableMoves.isEmpty || gameOver == true) {
      gameOver = true;
      return;
    }
    setCell(x, y, val);
  }

  void aiMove(int val, bool difficult) {
    if (availableMoves.isEmpty || gameOver == true) {
      gameOver = true;
      return;
    }
    var move = easyAI();
    if (difficult) {
      move = hardAI(val);
    }
    setCell(move[0], move[1], val);
  }

  List<int> easyAI() {
    var random = Random();
    var moveIndex = random.nextInt(availableMoves.length);
    return availableMoves[moveIndex];
  }

  List<int> hardAI(int val) {
    _ticTacToes.shuffle();
    List<int> bestmove = [];
    var priority = 0;
    for (var tictactoe in _ticTacToes) {
      var row = [];
      for (var tile in tictactoe) {
        var play = getCell(tile[0], tile[1]);
        row.add(play);
      }
      var map = {0: 0, 1: 0, -1: 0};
      for (var x in row) {
        map[x] = map[x]! + 1;
      }
      if (map[0] == 0) {
        continue;
      }
      if (map[val] == 1 && map[-val] == 1) {
        if (priority < 1) {
          var idx = row.indexOf(0);
          bestmove = tictactoe[idx];
        }
        continue;
      }
      if (map[val] == 2) {
        var idx = row.indexOf(0);
        return tictactoe[idx];
      }
      if (map[-val] == 2) {
        var idx = row.indexOf(0);
        bestmove = tictactoe[idx];
        priority = 4;
      }
      if (map[val] == 1 && priority < 3) {
        var idx = row.indexOf(0);
        if (tictactoe[idx].reduce((a, b) => a + b) % 2 != 0) {
          idx = 3 - idx - row.indexOf(val);
        }
        bestmove = tictactoe[idx];
        priority = 3;
      }
      if (map[-val] == 1 && priority < 2) {
        var idx = row.indexOf(0);
        if (tictactoe[idx].reduce((a, b) => a + b) % 2 != 0) {
          idx = 3 - idx - row.indexOf(-val);
        }
        bestmove = tictactoe[idx];
        priority = 2;
      }
      if (map[0] == 3 && priority < 1) {
        /*for (var move in tictactoe) {
          if (move.reduce((a, b) => a + b) % 2 == 0) {
            bestmove = move;
            break;
          }
        }*/
        bestmove = tictactoe[Random().nextInt(3)];
        priority = 1;
      }
    }
    return bestmove;
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
    if (availableMoves.isEmpty) {
      gameOver = true;
    }
    return null;
  }

  void markVictory(List<List<int>> cells) {
    for (var tile in cells) {
      markCell(tile[0], tile[1]);
    }
  }
}
