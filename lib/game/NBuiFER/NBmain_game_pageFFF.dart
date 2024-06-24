import 'package:NineBreaked/app/NBmain_screenFUU.dart';
import 'package:NineBreaked/app/NBsettings_screenFER.dart';
import 'package:NineBreaked/NBlevelsFER.dart';
import 'package:NineBreaked/main.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import '../NBforge2d_game_worldfEERE.dart';
import 'NBoverlay_builderFER.dart';

class NBIntControllerFER extends ValueNotifier<int> {
  NBIntControllerFER(super.value);

  void set(int i) {
    value = i;
    notifyListeners();
  }

  void reset() {
    value = 0;
    notifyListeners();
  }
}

final scoreController = NBIntControllerFER(0);

class MainGamePage extends StatefulWidget {
  const MainGamePage({super.key, required this.nbstage});

  final int nbstage;

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGamePage> {
  late final forge2dGameWorld = NBForge2dGameWorldFERE(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: GameWidget(
              game: forge2dGameWorld,
              overlayBuilderMap: const {
                'PreGame': NBOverlayBuilderFER.preGame,
                'PostGame': NBOverlayBuilderFER.postGame,
              },
              backgroundBuilder: (context) => Image.asset(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                levels[widget.nbstage].bg,
                fit: BoxFit.cover,
              ),
            ),
          ),
          GameAppBar(
            stage: widget.nbstage,
          ),
          Positioned(
            top: 124,
            child: NBLevelInformatioFFEn(
              image: levels[widget.nbstage].image,
              title: levels[widget.nbstage].name,
              level: widget.nbstage + 1,
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 2,
            left: (MediaQuery.sizeOf(context).width * 0.1) / 2,
            child: Container(
              padding: const EdgeInsets.all(5),
              width: MediaQuery.sizeOf(context).width * 0.9,
              decoration: ShapeDecoration(
                color: const Color(0xAD060F2B),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFF009DCF)),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: Color(0xFF161E36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Image.asset(
                      "assets/images/others/award_1.png",
                      height: 36,
                      width: 36,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Task for today",
                        style: TextStyle(
                          color: Color(0xFF7EFFF7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Score a total of 4200 points',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NBLevelInformatioFFEn extends StatelessWidget {
  const NBLevelInformatioFFEn({
    super.key,
    required this.image,
    required this.title,
    required this.level,
  });

  final String image;
  final String title;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width - 32,
            height: 80,
            decoration: ShapeDecoration(
              color: const Color(0xFF161E36),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF2BCCFF)),
                borderRadius: BorderRadius.circular(24),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0xFF62DBFB),
                  blurRadius: 24,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              children: [
                SizedBox(width: 96),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: scoreController,
                        builder: (_, v, __) {
                          return Text(
                            "Score: $v",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16, top: 6, bottom: 6),
                        child: ScoreProgress(),
                      ),
                      Text(
                        "Level $level",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          NBLvlInformationAvatarFFS(
            name: title,
            image: image,
          ),
        ],
      ),
    );
  }
}

class ScoreProgress extends StatelessWidget {
  const ScoreProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white.withOpacity(0.2),
          ),
          child: Stack(
            children: [
              ValueListenableBuilder(
                valueListenable: scoreController,
                builder: (_, v, __) {
                  return Container(
                    width: 200 * (v / 42) / 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        Positioned(
          left: -8,
          child: Image.asset(
            "assets/images/others/award_2.png",
            height: 24,
          ),
        ),
      ],
    );
  }
}

class NBLvlInformationAvatarFFS extends StatelessWidget {
  const NBLvlInformationAvatarFFS({
    super.key,
    required this.name,
    required this.image,
  });

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _ImageLvlInformation(
          image: image,
        ),
        Positioned(
          bottom: -18,
          left: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 7,
            ),
            constraints: const BoxConstraints(
              maxWidth: 72,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0B14E5),
              border: Border.all(
                color: const Color(0xFFFFC700),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 0.98,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _ImageLvlInformation extends StatelessWidget {
  const _ImageLvlInformation({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFFFC700),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class GameAppBar extends StatelessWidget {
  const GameAppBar({
    super.key,
    required this.stage,
  });

  final int stage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      decoration: const BoxDecoration(
        color: Color(0xFF161E36),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          const SizedBox(height: kToolbarHeight),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomBackButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 36),
              Text(
                "Stage ${stage + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  ValueListenableBuilder(
                    valueListenable: coinController,
                    builder: (_, value, __) {
                      return AppBarTagAmount(amount: value);
                    },
                  ),
                  const SizedBox(width: 20),
                  ValueListenableBuilder(
                    valueListenable: diamondController,
                    builder: (_, value, __) {
                      return AppBarTagAmount(
                        amount: value,
                        icon: "assets/images/others/diamond.png",
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}
