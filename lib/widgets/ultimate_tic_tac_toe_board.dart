import 'package:flutter/material.dart';
import 'package:security_app/models/tic_tac_toe.dart';
import 'package:security_app/widgets/tic_tac_toe_board.dart';

class UltimateTicTacToeBoard extends StatefulWidget {
  const UltimateTicTacToeBoard({Key? key}) : super(key: key);

  @override
  State<UltimateTicTacToeBoard> createState() => _UltimateTicTacToeBoardState();
}

class _UltimateTicTacToeBoardState extends State<UltimateTicTacToeBoard> {
  final _ultimateTicTacToe = TicTacToe();
  final _ticTacToes = [
    [TicTacToe(), TicTacToe(), TicTacToe()],
    [TicTacToe(), TicTacToe(), TicTacToe()],
    [TicTacToe(), TicTacToe(), TicTacToe()],
  ];
  var _playerMovesX = true;
  var difficulty = false;
  var freeMove = true;
  var nextMove = [0, 0];
  void resolveMove(int x, int y) {
    updateBoard();
    freeMove = false;
    if (checkForVictory()) {
      nextMove = [-1, -1];
      return;
    }
    nextMove = [x, y];
    if (_ticTacToes[y][x].gameOver) {
      freeMove = true;
    }
    _playerMovesX = !_playerMovesX;
  }

  void updateBoard() {
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        setState(() {
          _ultimateTicTacToe.setCell(j, i, _ticTacToes[i][j].winner);
        });
      }
    }
  }

  bool checkForVictory() {
    var victory = _ultimateTicTacToe.checkForVictory();
    if (victory != null) {
      setState(() {
        _ultimateTicTacToe.markVictory(victory);
      });
      return true;
    }
    return false;
  }

  void reset() {
    freeMove = true;
    setState(() {
      _ultimateTicTacToe.clearBoard();
      for (var row in _ticTacToes) {
        for (TicTacToe tictactoe in row) {
          tictactoe.clearBoard();
        }
      }
      _playerMovesX = true;
    });
  }

  /*void switchPlayer() {
    _playerMovesX = !_playerMovesX;
    reset();
  }

  void switchDifficulty() {
    difficulty = !difficulty;
    reset();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 300,
            height: 300,
            margin: const EdgeInsets.all(20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (ctx, i) {
                var x = i % 3;
                var y = (i / 3).floor();
                var active =
                    (freeMove || (x == nextMove[0] && y == nextMove[1])) &&
                        !_ticTacToes[y][x].gameOver;
                return TicTacToeDeadCell(
                  x,
                  y,
                  _ultimateTicTacToe.getCell(x, y),
                  100,
                  active,
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.all(5),
                    child: TicTacToeGrid(
                      ticTacToe: _ticTacToes[y][x],
                      playerMovesX: _playerMovesX,
                      spacing: 5,
                      resolveMove: resolveMove,
                    ),
                  ),
                );
              },
              itemCount: 9,
            )),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: reset, child: const Text("Start Over")),
            const SizedBox(width: 10),
            /*ElevatedButton(
                onPressed: switchPlayer, child: const Text("Switch Player")),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: switchDifficulty,
                child: Text("Difficulty: ${difficulty ? "Hard" : "Easy"}")),*/
          ],
        ),
        Text("You are playing ${_playerMovesX ? "X" : "O"}"),
      ],
    );
  }
}

class TicTacToeGrid extends StatefulWidget {
  const TicTacToeGrid({
    Key? key,
    required TicTacToe ticTacToe,
    required this.playerMovesX,
    required this.spacing,
    required this.resolveMove,
  })  : _ticTacToe = ticTacToe,
        super(key: key);

  final TicTacToe _ticTacToe;
  final bool playerMovesX;
  final double spacing;
  final Function(int x, int y) resolveMove;

  @override
  State<TicTacToeGrid> createState() => _TicTacToeGridState();
}

class _TicTacToeGridState extends State<TicTacToeGrid> {
  void makeMove(int x, int y) {
    setState(() {
      widget._ticTacToe.playerMove(x, y, widget.playerMovesX ? 1 : -1);
    });
    checkForVictory();
    widget.resolveMove(x, y);
  }

  bool checkForVictory() {
    var victory = widget._ticTacToe.checkForVictory();
    if (victory != null) {
      setState(() {
        widget._ticTacToe.markVictory(victory);
      });
      return true;
    }
    return false;
  }

  void reset() {
    setState(() {
      widget._ticTacToe.clearBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: widget.spacing,
        crossAxisSpacing: widget.spacing,
      ),
      itemBuilder: (ctx, i) => TicTacToeCell(
        i % 3,
        (i / 3).floor(),
        widget._ticTacToe.getCell(i % 3, (i / 3).floor()),
        makeMove,
        widget.spacing / 2,
      ),
      itemCount: 9,
    );
  }
}

class TicTacToeDeadCell extends StatelessWidget {
  final int x;
  final int y;
  final int v;
  final double size;
  final bool active;
  final Widget? child;
  const TicTacToeDeadCell(this.x, this.y, this.v, this.size, this.active,
      {Key? key, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 20),
        color: v.abs() <= 1 ? Colors.blueGrey[200] : Colors.green,
      ),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            if (child != null) child!,
            if (!active)
              Container(
                color: Colors.black38,
                width: size,
                height: size,
              ),
            if (v != 0)
              Icon(
                v > 0 ? Icons.close : Icons.circle_outlined,
                size: size,
              ),
            if (v == 0)
              Container(
                width: 0,
                height: 0,
              ),
          ],
        ),
      ),
    );
  }
}
