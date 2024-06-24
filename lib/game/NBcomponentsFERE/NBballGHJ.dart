import 'dart:async';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/rendering.dart';
import 'package:flame/extensions.dart';

import '../NBforge2d_game_worldfEERE.dart';
import '../utils/NBimage_loaderFER.dart';
import 'NBpaddleFOO.dart';
import 'NBdead_zoneFIO.dart';

class NBBallManagerFKL extends Component {
  List<nbBall> nbballs = [];
  final Vector2 nbposition;
  final double nbradius;
  final String nbimagePath;

  NBBallManagerFKL(
      {required this.nbposition, required this.nbradius, required this.nbimagePath});

  Future<void> nbcreateBall({position, radius, linearVelocity}) async {
    final ball = nbBall(
      nbradius: radius ?? this.nbradius,
      nbposition: position ?? this.nbposition,
      nblinearVelocity: linearVelocity,
      nbimagePath: nbimagePath,
    );
    await add(ball);
    nbballs.add(ball);
    ball.nbisVisible = true;
  }

  void _removeBall(nbBall ballToRemove) {
    final index = nbballs.indexOf(ballToRemove);
    if (index != -1) {
      nbballs.removeAt(index);
      remove(ballToRemove);
    }
  }

  void removeBall() {
    for (final ball in [...nbballs]) {
      if (ball.destroy) {
        _removeBall(ball);
      }
    }
  }

  void reset() {
    for (final ball in [...nbballs]) {
      _removeBall(ball);
    }
    nbcreateBall();
  }
}

class nbBall extends BodyComponent<NBForge2dGameWorldFERE> with ContactCallbacks {
  final Vector2 nbposition;
  final Vector2? nblinearVelocity;
  final double nbradius;
  ui.Image? nbimage;
  String nbimagePath;

  bool nbisVisible = false;

  late double nbspeed;
  static const nbmaxSpeed = 20.0;
  static const nbminSpeed = 10.0;

  List<ui.Image?> nbimageList = [null];

  nbBall(
      {required this.nbposition,
      required this.nbradius,
      this.nblinearVelocity,
      required this.nbimagePath});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    nbimage = await NBImageLoaderFER.loadImage(nbimagePath);
  }

  @override
  void render(Canvas canvas) {
    if (nbimage != null && nbisVisible) {
      final circle = body.fixtures.first.shape as CircleShape;
      canvas.drawImageRect(
        nbimage!,
        Rect.fromLTWH(0, 0, nbimage!.width.toDouble(), nbimage!.height.toDouble()),
        Rect.fromCircle(
          center: circle.position.toOffset(),
          radius: nbradius,
        ),
        Paint(),
      );
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..type = BodyType.dynamic
      ..position = nbposition
      ..linearVelocity = nblinearVelocity ?? Vector2(0.0, 0.0)
      ..angularVelocity = 0;

    final ball = world.createBody(bodyDef);

    final shape = CircleShape()..radius = nbradius;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 1.0
      ..density = 1.0;

    ball.createFixture(fixtureDef);
    return ball;
  }

  var destroy = false;
  Object? otherObject;

  @override
  void beginContact(Object other, Contact contact) {
    if (other is NBDeadZoneFJJ) {
      destroy = true;
      gameRef.gameState = GameState.nblostTheBall;
    }
    nbspeed = body.linearVelocity.length;
  }

  @override
  void endContact(Object other, [Contact? contact]) {
    if (other is NBPaddleFEF) {
      // TODO: need more physical angles

      // if u wanna normal physic just commented this if-else code
      if (body.position.x > other.body.position.x) {
        if (body.position.x + other.nbsize.width * 2 / 6 >
            other.body.position.x) {
          body.linearVelocity = Vector2(7, -3);
        } else if (body.position.x + other.nbsize.width * 1 / 6 >
            other.body.position.x) {
          body.linearVelocity = Vector2(3, -3);
        } else {
          body.linearVelocity = Vector2(3, -7);
        }
      } else {
        if (body.position.x + other.nbsize.width * 2 / 6 <
            other.body.position.x) {
          body.linearVelocity = Vector2(-3, -7);
        } else if (body.position.x + other.nbsize.width * 1 / 6 <
            other.body.position.x) {
          body.linearVelocity = Vector2(-3, -3);
        } else {
          body.linearVelocity = Vector2(-7, -3);
        }
      }
    }

    if (!gameRef.isBallConnectedToThePaddle) {
      body.linearVelocity *= (nbspeed / body.linearVelocity.length);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameRef.isBallConnectedToThePaddle) {
      body.linearVelocity *= (1 + gameRef.accelerationRateForSpeed * dt);

      if (body.linearVelocity.length > nbmaxSpeed) {
        body.linearVelocity = body.linearVelocity.normalized() * nbmaxSpeed;
      }

      if (body.linearVelocity.length < nbminSpeed) {
        body.linearVelocity = body.linearVelocity.normalized() * nbminSpeed;
      }
    }
  }
}
