import 'package:flutter/material.dart';
import 'package:security_app/widgets/tic_tac_toe_board.dart';
import 'package:security_app/widgets/ultimate_tic_tac_toe_board.dart';

class UltimateTicTacToeScreen extends StatelessWidget {
  const UltimateTicTacToeScreen({Key? key}) : super(key: key);
  static const routeName = "/ultimate-tic-tac-toe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ultimate TicTacToe")),
      body: const Center(child: UltimateTicTacToeBoard()),
    );
  }
}
