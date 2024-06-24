import 'dart:math';
import 'dart:ui' as ui;

import 'package:NineBreaked/app/NBstory_tellingFIO.dart';
import 'package:NineBreaked/controllers/NBcontrollersFEO.dart';
import 'package:NineBreaked/game/NBuiFER/NBmain_game_pageFFF.dart';
import 'package:NineBreaked/game/NBuiFER/NBoverlay_builderFER.dart';
import 'package:NineBreaked/NBlevelsFER.dart';
import 'package:NineBreaked/main.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';

import '../../app/NBsoundFIE.dart';
import '../NBforge2d_game_worldfEERE.dart';
import '../utils/NBimage_loaderFER.dart';
import 'NBballGHJ.dart';
import 'NBbulletFUI.dart';

class NBBrickDataFER {
  String nbimage;
  ui.Image? nbimg;
  final int nbvalue;
  final int nblives;
  NBBrickDataFER({
    required this.nbimage,
    required this.nbvalue,
    required this.nblives,
  });
}

class Brick extends BodyComponent<NBForge2dGameWorldFERE> with ContactCallbacks {
  final Size nbsize;
  final Vector2 nbposition;
  final NBBrickDataFER nbdata;
  late final String nbimagePath;
  late int nbbrickLives;
  late final int nbvalue;

  late ui.Image? nbimage;

  int nbindex = 0;

  final bool isGold;

  Brick({
    required this.nbsize,
    required this.nbposition,
    required this.nbdata,
    this.isGold = false,
  }) {
    nbimage = nbdata.nbimg;
    nbbrickLives = nbdata.nblives;
    nbvalue = nbdata.nbvalue;
  }

  @override
  void render(Canvas canvas) {
    if (nbimage != null) {
      if (body.fixtures.isEmpty) {
        return;
      }

      final rectangle = body.fixtures.first.shape as PolygonShape;

      if (isGold) {
        canvas.drawImageRect(
          nbdata.nbimg!,
          Rect.fromLTWH(
            0,
            0,
            nbdata.nbimg!.width.toDouble(),
            nbdata.nbimg!.height.toDouble(),
          ),
          Rect.fromCenter(
            center: rectangle.centroid.toOffset(),
            width: nbsize.width,
            height: nbsize.height,
          ),
          Paint(),
        );
        return;
      }

      canvas.drawImageRect(
        bricks[nbbrickLives - 1].nbimg!,
        Rect.fromLTWH(
          0,
          0,
          bricks[nbbrickLives - 1].nbimg!.width.toDouble(),
          bricks[nbbrickLives - 1].nbimg!.height.toDouble(),
        ),
        Rect.fromCenter(
          center: rectangle.centroid.toOffset(),
          width: nbsize.width,
          height: nbsize.height,
        ),
        Paint(),
      );
    }
  }

  var destroy = false;

  @override
  void beginContact(Object other, Contact contact) {
    // if (other is Ball || other is Bullet) {
    if (other is nbBall) {
      nbbrickLives--;
      if(NBswitchControllerFTE.value){
        FlameAudio.play('NBaudFEI.mp3');
      }

      if (isGold) {
        gameRef.pauseEngine();
        gameRef.gameState = GameState.nbwon;
        coinController.sum(-levels[levelController.value].award);
        levelController.set(levelController.value);
        //CoinController().addmon(100);
        scoreController.reset();
        showDialog(
          context: gameRef.context,
          builder: (context) {
            return const WinnerDialog();
          },
        );
      }

      if (nbbrickLives == 0) {
        destroy = true;
        scoreController.set(scoreController.value + nbvalue);

        gameRef.updateScore(nbvalue);
      }
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..type = BodyType.static
      ..position = nbposition
      ..angularDamping = 1.0
      ..linearDamping = 1.0;

    final brickBody = world.createBody(bodyDef);

    final shape = PolygonShape()
      ..setAsBox(
        nbsize.width / 2.0,
        nbsize.height / 2.0,
        Vector2(0.0, 0.0),
        0.0,
      );

    brickBody.createFixture(
      FixtureDef(shape)
        ..density = 100.0
        ..friction = 0.0
        ..restitution = 0.1,
    );

    return brickBody;
  }
}

class WinnerDialog extends StatelessWidget {
  const WinnerDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.2,
          ),
          width: MediaQuery.sizeOf(context).width * 0.8,
          padding: const EdgeInsets.all(35),
          decoration: BoxDecoration(
            color: const Color(0xFF3958FF),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Color(0xFFFFC700), width: 4),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -90,
                child: Column(
                  children: [
                    const WinnerAvatar(),
                    const SizedBox(height: 22),
                    const Text(
                      'Congratulations!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ValueListenableBuilder(
                      valueListenable: levelController,
                      builder: (_, value, __) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/others/coin.png",
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "+${levels[value].award}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: ui.FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      child: OrangeButton(
                        onTap: () async {
                          Navigator.popUntil(context, (route) => route.isFirst);

                          final levels =
                              (preferences.getStringList("passed_level") ?? [])
                                  .map((e) => int.parse(e))
                                  .toList();
                          /*
                          levels.add(levelController.value);

                          preferences
                              .setStringList(
                            "passed_level",
                            levels.map((e) => e.toString()).toList(),
                          )
                              .then((value) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => StoryTelling(
                                  stage: levelController.value,
                                ),
                              ),
                            );
                          });

                           */
                        },
                        label: "Next level",
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.4,
                      child: OrangeButton(
                        onTap: () => Navigator.popUntil(
                            context, (route) => route.isFirst),
                        label: "Home",
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
