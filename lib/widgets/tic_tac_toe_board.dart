import 'package:flutter/material.dart';
import 'package:security_app/models/tic_tac_toe.dart';

class TicTacToeBoard extends StatefulWidget {
  const TicTacToeBoard({Key? key}) : super(key: key);

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  final _ticTacToe = new TicTacToe();
  var gameOver = false;
  var winner = 0;
  void makeMove(int x, int y) {
    setState(() {
      _ticTacToe.playerMove(x, y);
      _ticTacToe.aiMove();
    });
    var victory = _ticTacToe.checkForVictory();
    if (victory != null) {
      setState(() {
        winner = _ticTacToe.markVictory(victory);
        gameOver = true;
      });
    }
    if (_ticTacToe.availableMoves.isEmpty) {
      gameOver = true;
    }
  }

  void reset() {
    gameOver = false;
    winner = 0;

    setState(() {
      _ticTacToe.clearBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          margin: EdgeInsets.all(20),
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
        ElevatedButton(onPressed: reset, child: Text("Start Over")),
      ],
    );
  }
}

class TicTacToeCell extends StatelessWidget {
  final int x;
  final int y;
  final int v;
  final Function(int x, int y) makeMove;
  TicTacToeCell(this.x, this.y, this.v, this.makeMove);

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
