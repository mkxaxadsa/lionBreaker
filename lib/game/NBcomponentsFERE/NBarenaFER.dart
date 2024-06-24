import 'dart:ui';
import 'dart:ui' as ui;

import 'NBbulletFUI.dart';
import 'NBpaddleFOO.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../NBforge2d_game_worldfEERE.dart';
import '../utils/NBimage_loaderFER.dart';

class NBArenaFEP extends BodyComponent<NBForge2dGameWorldFERE> with ContactCallbacks {
  final Size nbsize;
  final Vector2 nbposition;
  final String nbgifExitPath;
  final String nbimageExitPath;

  List<ui.Image> nbframes = [];
  int nbcurrentFrameIndex = 0;
  double nbtimeSinceLastFrame = 0.0;
  double nbframeDuration = 0.005;

  ui.Image? imageExit;

  NBArenaFEP(
      {required this.nbsize,
      required this.nbposition,
      required this.nbgifExitPath,
      required this.nbimageExitPath}) {
    assert(nbsize.width >= 1.0 && nbsize.height >= 1.0);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (nbframes.isNotEmpty) {
      nbtimeSinceLastFrame += dt;
      if (nbtimeSinceLastFrame >= nbframeDuration) {
        nbtimeSinceLastFrame = 0.0;
        nbcurrentFrameIndex = (nbcurrentFrameIndex + 1) % nbframes.length;
      }
    }
  }

  @override
  Future<void> onLoad() {
    renderBody = false;
    return super.onLoad();
  }

  bool showExit = true;

  @override
  Body createBody() {
    final ratio = Vector2(0.0, 0.0);
    ratio.x = (1033 - 43) / 1033;
    ratio.y = (1060 - 43) / 1060;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = Vector2(0, 0)
      ..type = BodyType.static;

    final arenaBody = world.createBody(bodyDef);

    final vertices = <Vector2>[
      Vector2(nbsize.width * ratio.x + nbposition.x,
          nbsize.height * ratio.y + nbposition.y),
      Vector2(nbsize.width * (1 - ratio.x) + nbposition.x,
          nbsize.height * ratio.y + nbposition.y),
      Vector2(nbsize.width * (1 - ratio.x) + nbposition.x,
          nbsize.height * (1 - ratio.y) + nbposition.y),
      Vector2(nbsize.width * ratio.x + nbposition.x,
          nbsize.height * (1 - ratio.y) + nbposition.y),
    ];

    final chain = ChainShape()..createLoop(vertices);

    for (var index = 0; index < chain.childCount; index++) {
      arenaBody.createFixture(
        FixtureDef(chain..childEdge(index))
          ..density = 0.0
          ..friction = 0.0
          ..restitution = 0.0,
      );
    }

    return arenaBody;
  }
}
