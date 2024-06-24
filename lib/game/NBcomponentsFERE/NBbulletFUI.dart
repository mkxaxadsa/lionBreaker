import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';

import '../NBforge2d_game_worldfEERE.dart';
import '../utils/NBimage_loaderFER.dart';

class NBBulletManagerXCZ extends Component {
  void createBullets({
    required Size arenaSize,
    required paddlePosition,
    required Size paddleSize,
    required String imagePath,
  }) {
    final nbbulletLeftSize =
        Size(arenaSize.width * 5 / 1033, arenaSize.height * 22 / 1060);
    final bulletLeftPosition =
        paddlePosition - Vector2(43 / 135 * paddleSize.width, 1);

    add(Bullet(
      nbsize: nbbulletLeftSize,
      nbposition: bulletLeftPosition,
      nbimagePath: imagePath,
    ));

    final nbbulletRightSize =
        Size(arenaSize.width * 5 / 1033, arenaSize.height * 22 / 1060);
    final bulletRightPosition =
        paddlePosition + Vector2(43 / 135 * paddleSize.width, -1);

    add(Bullet(
      nbsize: nbbulletRightSize,
      nbposition: bulletRightPosition,
      nbimagePath: imagePath,
    ));
  }

  void reset() {
    for (final child in [...children]) {
      if (child is Bullet) {
        remove(child);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final child in [...children]) {
      if (child is Bullet && child.destroy) {
        remove(child);
      }
    }
  }
}

class Bullet extends BodyComponent<NBForge2dGameWorldFERE> with ContactCallbacks {
  final Size nbsize;
  final Vector2 nbposition;
  late String nbimagePath;
  ui.Image? nbimage;

  Bullet({
    required this.nbsize,
    required this.nbposition,
    required this.nbimagePath,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    nbimage = await NBImageLoaderFER.loadImage(nbimagePath);
  }

  @override
  void render(Canvas canvas) {
    if (nbimage != null) {
      if (body.fixtures.isEmpty) {
        return;
      }

      final rectangle = body.fixtures.first.shape as PolygonShape;

      canvas.drawImageRect(
        nbimage!,
        Rect.fromLTWH(0, 0, nbimage!.width.toDouble(), nbimage!.height.toDouble()),
        Rect.fromCenter(
          center: rectangle.centroid.toOffset(),
          width: nbsize.width,
          height: nbsize.height,
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
      ..linearVelocity = Vector2(0, -100)
      ..bullet = true;

    final bulletBody = world.createBody(bodyDef);

    final shape = PolygonShape()
      ..setAsBox(
        nbsize.width / 2.0,
        nbsize.height / 2.0,
        Vector2(0.0, 0.0),
        0.0,
      );

    bulletBody.createFixture(
      FixtureDef(shape)
        ..restitution = 0.0
        ..density = 0.0
        ..isSensor = false,
    );

    return bulletBody;
  }

  bool destroy = false;
}
