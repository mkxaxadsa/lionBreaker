import 'package:NineBreaked/game/NBuiFER/NBmain_game_pageFFF.dart';
import 'package:NineBreaked/NBlevelsFER.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NBStoryTellingPOL extends StatefulWidget {
  const NBStoryTellingPOL({super.key, required this.stage});

  final int stage;

  @override
  State<NBStoryTellingPOL> createState() => _StoryTellingState();
}

class _StoryTellingState extends State<NBStoryTellingPOL> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: levels[widget.stage].passage.passages.indexed.map((e) {
          return GestureDetector(
            onTap: () {
              if (e.$1 == 3) {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => MainGamePage(nbstage: widget.stage),
                  ),
                );

                return;
              }

              controller.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear,
              );
            },
            child: _Story(
              avatar: e.$1 == 0 ? null : levels[widget.stage].passage.avatar,
              passage: levels[widget.stage].passage.passages[e.$1],
              background: levels[widget.stage].passage.image[e.$1],
              card: levels[widget.stage].passage.bgColorCard,
              border: levels[widget.stage].passage.borderColorCard,
              onSkip: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => MainGamePage(nbstage: widget.stage),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Story extends StatelessWidget {
  const _Story({
    super.key,
    required this.background,
    this.avatar,
    required this.card,
    required this.border,
    required this.passage,
    required this.onSkip,
  });

  final String background;
  final String? avatar;
  final Color card;
  final Color border;
  final String passage;

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: Image.asset(background).image,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 80,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: onSkip,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            IntrinsicHeight(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  if (avatar != null)
                    Image.asset(
                      avatar!,
                      height: 340,
                    ),
                  Positioned(
                    bottom: -40,
                    child: _Passage(
                      card: card,
                      border: border,
                      passage: passage,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "Tap anywhere to continue",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Passage extends StatelessWidget {
  const _Passage({
    super.key,
    required this.card,
    required this.border,
    required this.passage,
  });

  final Color card;
  final Color border;
  final String passage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.85,
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 2),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 19,
        vertical: 16,
      ),
      child: Text(
        passage,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
