import 'package:flutter/material.dart';
import 'package:security_app/models/tic_tac_toe.dart';

class TicTacToeBoard extends StatefulWidget {
  const TicTacToeBoard({Key? key}) : super(key: key);

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  final _ticTacToe = TicTacToe();
  var _playerMovesX = true;
  void makeMove(int x, int y) {
    setState(() {
      _ticTacToe.playerMove(x, y, _playerMovesX ? 1 : -1);
    });
    if (checkForVictory()) {
      return;
    }
    setState(() {
      _ticTacToe.aiMove(_playerMovesX ? -1 : 1);
    });
    checkForVictory();
  }

  bool checkForVictory() {
    var victory = _ticTacToe.checkForVictory();
    if (victory != null) {
      setState(() {
        _ticTacToe.markVictory(victory!);
      });
      return true;
    }
    return false;
  }

  void reset() {
    setState(() {
      _ticTacToe.clearBoard();
      if (!_playerMovesX) {
        _ticTacToe.aiMove(1);
      }
    });
  }

  void switchPlayer() {
    _playerMovesX = !_playerMovesX;
    reset();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          margin: const EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (ctx, i) => TicTacToeCell(i % 3, (i / 3).floor(),
                _ticTacToe.getCell(i % 3, (i / 3).floor()), makeMove),
            itemCount: 9,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: reset, child: const Text("Start Over")),
            SizedBox(width: 10),
            ElevatedButton(
                onPressed: switchPlayer, child: const Text("Switch Player")),
          ],
        ),
        Text("You are playing ${_playerMovesX ? "X" : "O"}"),
      ],
    );
  }
}

class TicTacToeCell extends StatelessWidget {
  final int x;
  final int y;
  final int v;
  final Function(int x, int y) makeMove;
  const TicTacToeCell(this.x, this.y, this.v, this.makeMove, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: v == 0
          ? () {
              makeMove(x, y);
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: v.abs() <= 1 ? Colors.blueGrey[100] : Colors.green,
        ),
        child: v == 0
            ? null
            : Icon(
                v > 0 ? Icons.close : Icons.circle_outlined,
                size: 40,
              ),
      ),
    );
  }
}
