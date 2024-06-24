import 'package:NineBreaked/game/NBuiFER/NBmain_game_pageFFF.dart';
import 'package:NineBreaked/NBlevelsFER.dart';
import 'package:NineBreaked/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../NBforge2d_game_worldfEERE.dart';

class NBOverlayBuilderFER {
  NBOverlayBuilderFER._();

  static Widget preGame(BuildContext context, NBForge2dGameWorldFERE game) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = game.size.x * (1033 - 2 * 43) / 1033;
        final fontSize = width * 0.9;

        return PreGameOverlay(fontSize: fontSize);
      },
    );
  }

  static Widget postGame(BuildContext context, NBForge2dGameWorldFERE game) {
    assert(game.gameState == GameState.nblost || game.gameState == GameState.nbwon);

    final message = game.gameState == GameState.nbwon ? 'Winner!' : 'Game Over';

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final fontSize = width * 0.1;

        return PostGameOverlay(
          message: message,
          game: game,
          fontSize: fontSize,
        );
      },
    );
  }

  static Widget level(BuildContext context, NBForge2dGameWorldFERE game) =>
      Container(
        color: Colors.red,
      );
}

class PreGameOverlay extends StatelessWidget {
  final double fontSize;

  const PreGameOverlay({Key? key, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 350.0),
        child: Text(
          'Tap to start the game',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

class PostGameOverlay extends StatelessWidget {
  final String message;
  final NBForge2dGameWorldFERE game;
  final double fontSize;

  const PostGameOverlay({
    Key? key,
    required this.message,
    required this.game,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (game.gameState == GameState.nbwon) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Container(
        height: 240,
        padding: EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: Color(0xFF3958FF),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Color(0xFFFFC700), width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: fontSize * 0.5),
            _resetButton(context, game)
          ],
        ),
      ),
    );
  }

  static Widget _resetButton(
      BuildContext context, NBForge2dGameWorldFERE game) {
    return OrangeButton(
      onTap: () {
        game.resetGame();
        scoreController.reset();
      },
      label: 'Restart',
    );

    // OutlinedButton.icon(
    //   style: OutlinedButton.styleFrom(
    //     side: const BorderSide(
    //       color: Colors.blue,
    //     ),
    //   ),
    //   onPressed: () {},
    //   icon: const Icon(Icons.restart_alt_outlined),
    //   label: const Text('Replay'),
    // );
  }
}

class WinnerAvatar extends StatelessWidget {
  const WinnerAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFFFC700),
          width: 4,
        ),
        borderRadius: BorderRadius.circular(42),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(42),
        child: ValueListenableBuilder(
          valueListenable: levelController,
          builder: (context, value, child) => Image.asset(
            levels[value].image,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class OrangeButton extends StatelessWidget {
  const OrangeButton({
    super.key,
    required this.onTap,
    required this.label,
  });

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFFFF8C4C), Color(0xFFFF5B00)],
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.white.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0xFFBE4400),
              blurRadius: 0,
              offset: Offset(0, 3),
              spreadRadius: 0,
            )
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
