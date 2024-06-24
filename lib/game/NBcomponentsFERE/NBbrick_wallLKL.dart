import 'dart:math';

import 'package:NineBreaked/game/NBforge2d_game_worldfEERE.dart';
import 'package:NineBreaked/main.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import 'NBbrickFIO.dart';

class NBBrickWallPOL extends Component with HasGameRef<NBForge2dGameWorldFERE> {
  final Vector2 nbposition;
  final Size? nbsize;
  final int nbrows;
  final int nbcolumns;
  final double nbgap;

  NBBrickWallPOL({
    Vector2? nbposition,
    this.nbsize,
    int? nbrows,
    int? nbcolumns,
    double? nbgap,
  })  : nbposition = nbposition ?? Vector2.zero(),
        nbrows = nbrows ?? 1,
        nbcolumns = nbcolumns ?? 1,
        nbgap = nbgap ?? 0.2;

  @override
  Future<void> onLoad() async {
    await _buildWall();
  }

  @override
  void update(double dt) {
    for (final child in [...children]) {
      if (child is Brick && child.destroy) {
        for (final fixture in [...child.body.fixtures]) {
          child.body.destroyFixture(fixture);
        }
        gameRef.world.destroyBody(child.body);
        remove(child);
      }
    }

    bool foundBrick = false;

    for (final child in [...children]) {
      if (child is Brick) {
        foundBrick = true;
        break;
      }
    }

    if (!foundBrick) {
      gameRef.gameState = GameState.nbwon;
    }

    super.update(dt);
  }

  Future<void> _buildWall() async {
    final wallSize = nbsize!;

    final brickSize = Size(
      ((wallSize.width - nbgap * 2.0) - (nbcolumns - 1) * nbgap) / nbcolumns / 1.1,
      (wallSize.height - (nbrows - 1) * nbgap) / nbrows * 2.4,
    );

    var brickPosition = Vector2(
      brickSize.width / 2.0 + nbposition.x + nbgap,
      brickSize.height / 2.0 + nbposition.y,
    );

    for (var i = 0; i < nbrows; i++) {
      for (var j = 0; j < nbcolumns; j++) {
        if (nbrows ~/ 2 == j && i == 0) {
          await add(
            Brick(
              nbsize: brickSize,
              isGold: true,
              nbposition: brickPosition,
              nbdata: goldBrick,
            ),
          );
          brickPosition += Vector2(brickSize.width + nbgap, 0.0);
          continue;
        }

        final randomIndex = Random().nextInt(bricks.length);
        await add(
          Brick(
            nbsize: brickSize,
            //isGold: true,
            nbposition: brickPosition,
            nbdata: bricks[randomIndex],
            // brickColor: brickColors[randomIndex],
          ),
        );
        brickPosition += Vector2(brickSize.width + nbgap, 0.0);
      }
      brickPosition += Vector2(
        (brickSize.width / 2.0 + nbgap) - brickPosition.x + nbposition.x,
        brickSize.height + nbgap,
      );
    }
  }

  Future<void> reset() async {
    removeAll(children);
    await _buildWall();
  }
}
