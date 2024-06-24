import 'package:NineBreaked/app/NBmain_screenFUU.dart';
import 'package:NineBreaked/controllers/NBcontrollersFEO.dart';
import 'package:NineBreaked/game/NBcomponentsFERE/NBbrickFIO.dart';
import 'package:NineBreaked/game/utils/NBimage_loaderFER.dart';
import 'package:NineBreaked/FERsplash_screenFERE.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:ui' as ui;

import 'game/NBuiFER/NBmain_game_pageFFF.dart';

final goldBrick = NBBrickDataFER(
  nbimage: 'assets/images/NBbricksFERE/0.png',
  nbvalue: 100,
  nblives: 1,
);

final bricks = [
  NBBrickDataFER(
      nbimage: 'assets/images/NBbricksFERE/1.png', nbvalue: 100, nblives: 1),
  NBBrickDataFER(
      nbimage: 'assets/images/NBbricksFERE/2.png', nbvalue: 100, nblives: 2),
  NBBrickDataFER(
      nbimage: 'assets/images/NBbricksFERE/3.png', nbvalue: 100, nblives: 3),
  NBBrickDataFER(
      nbimage: 'assets/images/NBbricksFERE/4.png', nbvalue: 100, nblives: 4),
  NBBrickDataFER(
      nbimage: 'assets/images/NBbricksFERE/5.png', nbvalue: 100, nblives: 5),
];

late final SharedPreferences preferences;
final NBCoinControllerFPO coinController = NBCoinControllerFPO();
final NBDiamondControllerFER diamondController = NBDiamondControllerFER();
final NBBallControllerfER ballController = NBBallControllerfER();

final LevelController levelController = LevelController();

class LevelController extends ValueNotifier<int> {
  LevelController() : super(0) {
    init();
  }

  void init() async {
    int? level = preferences.getInt("level");
    if (level == null) {
      await preferences.setInt("level", value);
    }
    value = preferences.getInt("level")!;

    notifyListeners();
  }

  void set(int i) async {
    value = i;
    await preferences.setInt("level", i);

    notifyListeners();
  }

  void reset() async {
    value = 0;
    await preferences.setInt("level", 0);

    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setPortraitUpOnly();
  preferences = await SharedPreferences.getInstance();
  // await preferences.clear();
  goldBrick.nbimg = await NBImageLoaderFER.loadImage(goldBrick.nbimage);
  bricks[0].nbimg = await NBImageLoaderFER.loadImage(bricks[0].nbimage);
  bricks[1].nbimg = await NBImageLoaderFER.loadImage(bricks[1].nbimage);
  bricks[2].nbimg = await NBImageLoaderFER.loadImage(bricks[2].nbimage);
  bricks[3].nbimg = await NBImageLoaderFER.loadImage(bricks[3].nbimage);
  bricks[4].nbimg = await NBImageLoaderFER.loadImage(bricks[4].nbimage);

  runApp(const BreakoutApp());
}

class BreakoutApp extends StatelessWidget {
  const BreakoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MainGamePage(),
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Breakout',
      home: NBSplashScreenFERE(),
    );
  }
}
