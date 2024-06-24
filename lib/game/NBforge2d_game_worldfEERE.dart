import 'dart:math';

import 'package:NineBreaked/app/NBshop_screenFCI.dart';
import 'package:NineBreaked/main.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/src/gestures/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/drag_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'NBcomponentsFERE/NBarenaFER.dart';
import 'NBcomponentsFERE/NBballGHJ.dart';
import 'NBcomponentsFERE/NBbrick_wallLKL.dart';
import 'NBcomponentsFERE/NBpaddleFOO.dart';
import 'NBcomponentsFERE/NBdead_zoneFIO.dart';
import 'NBcomponentsFERE/NBbulletFUI.dart';
import 'NBcomponentsFERE/NBscoreFJE.dart';

enum GameState {
  nbinitializing,
  nbready,
  nbrunning,
  nbpaused,
  nbwon,
  nblost,
  nblostTheBall,
}

class NBForge2dGameWorldFERE extends Forge2DGame
    with HasDraggables, HasTappables {
  NBForge2dGameWorldFERE(this.context)
      : super(gravity: Vector2.zero(), zoom: 20);

  late final BuildContext context;

  GameState gameState = GameState.nbinitializing;

  // late final Score _score;
  // late final Size _scoreSize;
  late final Vector2 _scorePosition;

  late final NBArenaFEP _arena;
  late final Size _arenaSize;
  late final Vector2 _arenaPosition;

  late final NBBrickWallPOL _brickWall;
  late final Size _brickWallSize;
  late final Vector2 _brickWallPosition;

  late final NBDeadZoneFJJ _deadZone;
  late final Size _deadZoneSize;
  late final Vector2 _deadZonePosition;

  late final NBPaddleFEF _paddle;
  late final Size _paddleSize;
  late final Vector2 _paddlePosition;

  late final NBBallManagerFKL _balls;
  late final double _ballSize;
  late final Vector2 _ballPosition;

  late NBBulletManagerXCZ _bullets;

  bool isBallConnectedToThePaddle = false;
  bool isBonusesFall = true;
  bool makePaddleSensorAndDestroyBall = false;
  bool toTheNextLevel = false;
  double accelerationRateForSpeed = 0.0;

  var jointDef = PrismaticJointDef();

  int scoreValue = 0;

  @override
  Future<void> onLoad() async {
    await _initializeGame();
    FlameAudio.bgm.play('theme.ogg');
  }

  Future<void> _initializeGame() async {
    final paddingRatio = Vector2(0.0, 0.0);

    /// padding
    paddingRatio.x = 31 / 1060;
    paddingRatio.y = 20 / 1060;

    // _scoreSize = Size(
    //   size.x,
    //   size.y * 0.05,
    // );
    // _scorePosition = Vector2(0, 0);
    // _score = Score(
    //   size: _scoreSize,
    //   position: _scorePosition,
    //   score: 0,
    // );
    // await add(_score);

    _arenaSize = Size(
      size.x / 1,
      size.y / 1.9,
    );
    _arenaPosition = Vector2(0, 14);
    _arena = NBArenaFEP(
      nbsize: _arenaSize,
      nbposition: _arenaPosition,
      nbgifExitPath: 'assets/animations/exit.gif',
      nbimageExitPath: 'assets/images/exit.png',
    );
    await add(_arena);

    _brickWallSize = Size(
      _arenaSize.width * (1 - 2 * paddingRatio.x),
      _arenaSize.height * 255 / 1060,
    );
    _brickWallPosition = Vector2(
      _arenaSize.width / 14,
      _arenaPosition.y,
    );
    _brickWall = NBBrickWallPOL(
      nbposition: _brickWallPosition,
      nbsize: _brickWallSize,
      nbrows: 6,
      nbcolumns: 7,
    );
    await add(_brickWall);

    _deadZoneSize = Size(_arenaSize.width * (1 - 2 * paddingRatio.x),
        _arenaSize.height * (1 - paddingRatio.y - 940 / 1060));
    _deadZonePosition = Vector2(
      _arenaSize.width / 2.0,
      _arenaPosition.y + _arenaSize.height - _deadZoneSize.height / 2.0,
    );
    _deadZone = NBDeadZoneFJJ(
      nbsize: _deadZoneSize,
      nbposition: _deadZonePosition,
    );
    await add(_deadZone);

    _paddleSize = Size(
      _arenaSize.width * 230 / 1033,
      _arenaSize.height * 33 / 1060,
    );

    _paddlePosition = Vector2(
      _arenaSize.width / 2.0,
      _arenaPosition.y +
          _arenaSize.height -
          _deadZoneSize.height -
          _paddleSize.height / 2.0,
    );
    _paddle = NBPaddleFEF(
      nbsize: _paddleSize,
      nbposition: _paddlePosition,
      imagePath: 'assets/images/NBpaddleFERE/paddleOriginal.png',
    )..isVisible = true;
    await add(_paddle);

    _ballSize = 0.7 * _arenaSize.width * 27 / 1033;
    _ballPosition = Vector2(
      _arenaSize.width / 2.0,
      _arenaPosition.y +
          _arenaSize.height -
          _deadZoneSize.height -
          _paddleSize.height -
          1,
    );
    _balls = NBBallManagerFKL(
      nbradius: _ballSize,
      nbposition: _ballPosition,
      nbimagePath: balls[ballController.value.selected].image,
    );
    await _balls.nbcreateBall();
    await add(_balls);
    _balls.nbballs.last.nbisVisible = true;

    _bullets = NBBulletManagerXCZ();
    await add(_bullets);

    gameState = GameState.nbready;
    overlays.add('PreGame');
  }

  void updateScore(int value) {
    scoreValue += value;

    // _score.updateScore(score: scoreValue);
  }

  void resetScore() {
    scoreValue = 0;
    // _score.updateScore(score: scoreValue);
  }

  Future<void> resetGame() async {
    gameState = GameState.nbinitializing;

    _paddle.reset();
    _balls.reset();
    await _brickWall.reset();
    _bullets.reset();
    resetScore();

    isBonusesFall = true;
    accelerationRateForSpeed = 0.0;
    makePaddleSensorAndDestroyBall = false;
    toTheNextLevel = false;
    _arena.showExit = false;

    gameState = GameState.nbready;

    overlays.remove(overlays.activeOverlays.first);
    overlays.add('PreGame');

    resumeEngine();
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    if (gameState == GameState.nblostTheBall) {
      if (diamondController.value >= 1) {
        diamondController.sum(1);
      } else {
        _balls.removeBall();
      }

      if (_balls.nbballs.isEmpty) {
        pauseEngine();

        gameState = GameState.nblost;
      } else {
        gameState = GameState.nbrunning;
      }
    }

    if (gameState == GameState.nblost || gameState == GameState.nbwon) {
      pauseEngine();

      overlays.add('PostGame');
    }
  }

  @override
  void handleDragUpdate(int pointerId, DragUpdateDetails details) {
    if (gameState == GameState.nbrunning) {
      // Calculate the swipe distance
      double swipeDistance = details.delta.dx;

      // Update the NBpaddleFERE's position based on the swipe distance
      _paddle.body.linearVelocity = Vector2(swipeDistance * 5, 0);

      // Determine the swipe direction
      if (swipeDistance > 0) {
        _paddle.nbmovingRight = true;
        _paddle.nbmovingLeft = false;
      } else if (swipeDistance < 0) {
        _paddle.nbmovingLeft = true;
        _paddle.nbmovingRight = false;
      }
    }
  }

  @override
  void handleDragEnd(int pointerId, DragEndDetails details) {
    _paddle.body.linearVelocity = Vector2.zero();
    _paddle.nbmovingLeft = false;
    _paddle.nbmovingRight = false;
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    if (gameState == GameState.nbready) {
      if (gameState != GameState.nbrunning) {
        _paddle.isVisible = true;
        _balls.nbballs.last.nbisVisible = true;

        overlays.remove(overlays.activeOverlays.first);
        jointDef
          ..initialize(_paddle.body, _balls.nbballs.last.body,
              _paddle.body.position, Vector2(1, 0))
          ..enableLimit = true
          ..lowerTranslation = 0
          ..upperTranslation = 0;
        world.createJoint(PrismaticJoint(jointDef));
        isBallConnectedToThePaddle = true;
        gameState = GameState.nbrunning;
      }

      if (_paddle.body.joints.isNotEmpty) {
        final joint = _paddle.body.joints.first;
        world.destroyJoint(joint);
        _balls.nbballs.last.body
            .applyLinearImpulse(Vector2(-sqrt(50), -sqrt(50)));
        _balls.nbballs.last.body.angularVelocity = 0;
        isBallConnectedToThePaddle = false;
      }
    }
    super.onTapUp(pointerId, info);
  }
}
