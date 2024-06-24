import 'dart:async';

import 'package:NineBreaked/alert/NBlocked_alertFOE.dart';
import 'package:NineBreaked/app/NBsettings_screenFER.dart';
import 'package:NineBreaked/app/NBstory_tellingFIO.dart';
import 'package:NineBreaked/game/NBforge2d_game_worldfEERE.dart';
import 'package:NineBreaked/game/NBuiFER/NBmain_game_pageFFF.dart';
import 'package:NineBreaked/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NBCardsFER extends StatefulWidget {
  const NBCardsFER({
    super.key,
  });

  @override
  State<NBCardsFER> createState() => _CardsState();
}

class _CardsState extends State<NBCardsFER> {
  late StreamController<int> controller;

  void _onCard(int n) async {
    final passedlevel = preferences
            .getStringList("passed_level")
            ?.map((e) => int.parse(e))
            .toList() ??
        [];

    if (passedlevel.contains(n)) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => MainGamePage(nbstage: n),
        ),
      );
      return;
    }
    passedlevel.add(n);
    await preferences
        .setStringList(
      "passed_level",
      passedlevel.map((e) => e.toString()).toList(),
    )
        .then(
      (value) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => NBStoryTellingPOL(stage: n),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: levelController,
                builder: (_, value, __) {
                  return GestureDetector(
                    onTap: () => _onCard(0),
                    child: const LevelCard(
                      image: "assets/images/others/lvl_1.png",
                      isOpen: true,
                      label: 'Free',
                      stage: "Stage 1",
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: levelController,
                builder: (_, value, __) {
                  return GestureDetector(
                    onTap: () {

                      if (value >= 1){
                        _onCard(1);
                      } else {
                        showDialog(
                          useSafeArea: false,
                          context: context,
                          builder: (BuildContext context) {

                            return NBLockedAlertFER(inf: 'Stage is locked',);
                          },
                        );
                      }
                    },
                    child: LevelCard(
                      image: "assets/images/others/lvl_2.png",
                      isOpen: value >= 1,
                      label: '100',
                      icon: "assets/images/others/coin.png",
                      stage: "Stage 2",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: levelController,
                builder: (_, value, __) {
                  return GestureDetector(
                    onTap: () {
                      if (value >= 2){
                        _onCard(2);
                      } else {
                        showDialog(
                          useSafeArea: false,
                          context: context,
                          builder: (BuildContext context) {

                            return NBLockedAlertFER(inf: 'Stage is locked',);
                          },
                        );
                      }
                    },
                    child: LevelCard(
                      image: "assets/images/others/lvl_3.png",
                      isOpen: value >= 2,
                      label: '400',
                      icon: "assets/images/others/coin.png",
                      stage: "Stage 3",
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: levelController,
                builder: (_, value, __) {
                  return GestureDetector(
                    onTap: () {
                      if (value >= 3){
                        _onCard(3);
                      } else {
                        showDialog(
                          useSafeArea: false,
                          context: context,
                          builder: (BuildContext context) {

                            return NBLockedAlertFER(inf: 'Stage is locked',);
                          },
                        );
                      }

                      },
                    child: LevelCard(
                      image: "assets/images/others/lvl_4.png",
                      isOpen: value >= 3,
                      label: '600',
                      icon: "assets/images/others/coin.png",
                      stage: "Stage 4",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

}

class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.image,
    required this.isOpen,
    required this.label,
    this.award,
    this.icon,
    required this.stage,
  });

  final String image;
  final bool isOpen;
  final String label;
  final int? award;
  final String? icon;
  final String stage;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width / 2,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Color(isOpen ? 0xFFE5590B : 0Xff161E36),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(image),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF060F2B),
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: Text(
                    stage,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (icon != null) ...[
                Image.asset(
                  icon!,
                  height: 24,
                ),
                const SizedBox(width: 10)
              ],
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              CardButton(
                icon: isOpen ? null : "assets/images/others/lock.png",
                color: isOpen ? null : const Color(0xFF393939),
                onTap: () {
                  if (!isOpen){
                    if (coinController.value >= 100){
                      coinController.sum(100);
                      levelController.set(levelController.value + 1);
                    }else {
                      showDialog(
                        useSafeArea: false,
                        context: context,
                        builder: (BuildContext context) {

                          return NBLockedAlertFER(inf: 'Not enought money',);
                        },
                      );
                  }

                  }

                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.onTap,
    String? icon,
    Color? color,
  })  : _icon = icon ?? "assets/images/others/tickMark.png",
        _color = color ?? const Color(0xFF46F180);

  final VoidCallback onTap;
  final String _icon;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        child: Image.asset(
          _icon,
          height: 16,
        ),
      ),
    );
  }
}
