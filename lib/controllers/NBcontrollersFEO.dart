import 'package:NineBreaked/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NBLvlControllerFER extends ValueNotifier<int> {
  NBLvlControllerFER(super.value) {
    init();
  }

  void init() async {
    final coins = preferences.getInt("coins");
    if (coins == null) await preferences.setInt("coins", 0);
    value = coins ?? 0;
    notifyListeners();
  }
}

class NBDiamondControllerFER extends ValueNotifier<int> {
  NBDiamondControllerFER() : super(0) {
    init();
  }

  void init() async {
    final coins = preferences.getInt("diamonds");
    if (coins == null) await preferences.setInt("diamonds", 1);
    value = coins ?? 1;
    notifyListeners();
  }

  void sum(int d) async {
    if (value - d < 0) return;
    value = value - d;
    await preferences.setInt("diamonds", value);
    notifyListeners();
  }
}

class NBCoinControllerFPO extends ValueNotifier<int> {
  NBCoinControllerFPO() : super(0) {
    init();
  }

  void init() async {
    final coins = preferences.getInt("coins");
    if (coins == null) await preferences.setInt("coins", 0);
    value = coins ?? 0;
    notifyListeners();
  }

  void sum(int d) async {
    if (value - d < 0) return;
    value = value - d;
    await preferences.setInt("coins", value);
    notifyListeners();
  }

  void addmon(int d) async {
    value = value + d;
    await preferences.setInt("coins", value);
    notifyListeners();
  }
}

class NBSoundControllerFER extends ValueNotifier<bool> {
  NBSoundControllerFER(super.value) {
    init();
  }

  void init() async {
    final sound = preferences.getBool("sound");
    if (sound == null) await preferences.setBool("sound", false);
    value = sound ?? false;
    notifyListeners();
  }
}

class BallData {
  final int selected;
  final List<int> boughtBalls;

  const BallData({required this.selected, required this.boughtBalls});
}

class NBBallControllerfER extends ValueNotifier<BallData> {
  NBBallControllerfER() : super(const BallData(selected: 0, boughtBalls: [])) {
    init();
  }

  void init() async {
    final balls = preferences.getStringList("balls");
    final selected = preferences.getInt("selected_ball");

    if (balls == null) {
      await preferences.setStringList("balls", ["0"]);
    }

    if (selected == null) {
      await preferences.setInt("selected_ball", 0);
    }

    value = BallData(
      selected: selected ?? 0,
      boughtBalls: balls?.map((e) => int.parse(e)).toList() ?? [],
    );
    notifyListeners();
  }

  void selectBall(int index) async {
    await preferences.setInt("selected_ball", index);
    value = BallData(selected: index, boughtBalls: value.boughtBalls);
    notifyListeners();
  }

  void buyNewBall(int index) async {
    final balls = preferences.getStringList("balls");
    await preferences.setStringList(
      "balls",
      [
        ...balls!,
        index.toString(),
      ],
    );

    await preferences.setInt("selected_ball", index);

    value = BallData(
      selected: index,
      boughtBalls: [
        ...balls.map((e) => int.parse(e)).toList(),
        index,
      ],
    );
    notifyListeners();
  }
}
