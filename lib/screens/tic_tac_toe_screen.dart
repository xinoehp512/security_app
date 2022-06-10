import 'package:flutter/material.dart';
import 'package:security_app/widgets/tic_tac_toe_board.dart';

class TicTacToeScreen extends StatelessWidget {
  const TicTacToeScreen({Key? key}) : super(key: key);
  static const routeName = "/tic-tac-toe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TicTacToe")),
      body: const Center(child: TicTacToeBoard()),
    );
  }
}
