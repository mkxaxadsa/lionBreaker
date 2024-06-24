import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../NBforge2d_game_worldfEERE.dart';
import '../utils/NBimage_loaderFER.dart';
import 'NBarenaFER.dart';

class NBPaddleFEF extends BodyComponent<NBForge2dGameWorldFERE> with ContactCallbacks {
  Size nbsize;
  final Vector2 nbposition;
  ui.Image? nbimage;

  bool nbmovingLeft = false;
  bool nbmovingRight = false;
  bool nbpermissionToMovingLeft = true;
  bool nbpermissionToMovingRight = true;

  bool isVisible = false;

  NBPaddleFEF({
    required this.nbsize,
    required this.nbposition,
    required String imagePath,
  }) {
    _loadImage(imagePath);
  }

  Future<void> _loadImage(String imagePath) async {
    nbimage = await NBImageLoaderFER.loadImage(imagePath);
  }

  @override
  void render(Canvas canvas) {
    if (nbimage != null && isVisible) {
      final shape = body.fixtures.first.shape as PolygonShape;
      canvas.drawImageRect(
        nbimage!,
        Rect.fromLTWH(0, 0, nbimage!.width.toDouble(), nbimage!.height.toDouble()),
        Rect.fromPoints(
          Offset(shape.vertices[0].x, shape.vertices[0].y),
          Offset(shape.vertices[2].x, shape.vertices[2].y),
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
      ..fixedRotation = true
      ..angularDamping = 1.0
      ..linearDamping = 0.0;

    final paddleBody = world.createBody(bodyDef);

    final shape = PolygonShape()
      ..setAsBox(
        nbsize.width / 2.0,
        nbsize.height / 2.0,
        Vector2(0.0, 0.0),
        0.0,
      );

    paddleBody.createFixture(
      FixtureDef(shape)
        ..density = 100.0
        ..friction = 0.0
        ..restitution = 1.0
        ..isSensor = false,
    );

    return paddleBody;
  }

  void updateBody(
      {required Size newSize,
      required String imagePath,
      required bool isSensor}) {
    nbsize = newSize;

    final shape = PolygonShape()
      ..setAsBox(
        nbsize.width / 2.0,
        nbsize.height / 2.0,
        Vector2(0.0, 0.0),
        0.0,
      );
    body.destroyFixture(body.fixtures.first);
    body.createFixture(FixtureDef(shape)
      ..density = 100.0
      ..friction = 0.0
      ..restitution = 1.0
      ..isSensor = isSensor);
    _loadImage(imagePath);
  }

  bool handleKeyboardEvents(KeyEvent event) {
    if (gameRef.gameState == GameState.nbrunning) {
      if (event is KeyRepeatEvent || event is KeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          if (nbpermissionToMovingLeft) {
            body.linearVelocity = Vector2(-20, 0);
            nbpermissionToMovingRight = true;
            nbmovingLeft = true;
          }
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          if (nbpermissionToMovingRight) {
            body.linearVelocity = Vector2(20, 0);
            nbpermissionToMovingLeft = true;
            nbmovingRight = true;
          }
        }
      }
      if (event is KeyUpEvent && !gameRef.toTheNextLevel) {
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          nbmovingLeft = false;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          nbmovingRight = false;
        }

        if (!nbmovingLeft && !nbmovingRight) {
          body.linearVelocity = Vector2.zero();
        }
      }
    }
    return true;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is NBArenaFEP) {
      if (!gameRef.toTheNextLevel) {
        if (body.position.x < gameRef.size.x / 2) {
          nbpermissionToMovingLeft = false;
        } else {
          nbpermissionToMovingRight = false;
        }
      }
    }
  }

  @override
  void onMount() {
    super.onMount();

    HardwareKeyboard.instance.addHandler(handleKeyboardEvents);
  }

  void reset() {
    updateBody(
      newSize: nbsize,
      imagePath: 'assets/images/NBpaddleFERE/paddleOriginal.png',
      isSensor: false,
    );
    body.setTransform(nbposition, angle);
    body.angularVelocity = 0.0;
    body.linearVelocity = Vector2.zero();
    nbpermissionToMovingLeft = true;
    nbpermissionToMovingRight = true;
    nbmovingLeft = false;
    nbmovingRight = false;
    isVisible = true;
  }
}
