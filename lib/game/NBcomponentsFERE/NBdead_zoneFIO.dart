import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../NBforge2d_game_worldfEERE.dart';

class NBDeadZoneFJJ extends BodyComponent<NBForge2dGameWorldFERE> {
  final Size nbsize;
  final Vector2 nbposition;

  NBDeadZoneFJJ({
    required this.nbsize,
    required this.nbposition,
  });

  @override
  bool get renderBody => false;

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.static
      ..userData = this
      ..position = nbposition;

    final zoneBody = world.createBody(bodyDef);

    final shape = PolygonShape()
      ..setAsBox(
        nbsize.width / 2.0,
        nbsize.height / 2.0,
        Vector2.zero(),
        0.0,
      );

    zoneBody.createFixture(FixtureDef(shape)..isSensor = true);

    return zoneBody;
  }
}
