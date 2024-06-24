import 'package:NineBreaked/app/NBmain_screenFUU.dart';
import 'package:NineBreaked/app/NBsettings_screenFER.dart';
import 'package:NineBreaked/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../alert/NBlocked_alertFOE.dart';

typedef BallDataT = ({
  String name,
  String image,
  int price,
  bool isDiamond,
});

List<BallDataT> balls = [
  (
    name: "Basic",
    image: "assets/images/ball.png",
    price: 0,
    isDiamond: false,
  ),
  (
    name: "Red",
    image: "assets/images/others/red.png",
    price: 80,
    isDiamond: false
  ),
  (
    name: "Green",
    image: "assets/images/others/green.png",
    price: 100,
    isDiamond: false
  ),
  (
    name: "Orange",
    image: 'assets/images/others/orange.png',
    price: 4,
    isDiamond: true
  ),
  (
    name: "Hole",
    image: "assets/images/others/hole.png",
    price: 8,
    isDiamond: true
  ),
  (
    name: "Fire eye",
    image: "assets/images/others/fire.png",
    price: 10,
    isDiamond: true
  ),
];

class NBShopScreenFUE extends StatelessWidget {
  const NBShopScreenFUE({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF060F2B),
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 150),
        child: ShopAppBar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 28),
              Center(
                child: ValueListenableBuilder(
                  valueListenable: ballController,
                  builder: (_, value, __) => Wrap(
                    runSpacing: 16,
                    spacing: 16,
                    alignment: WrapAlignment.center,
                    children: balls.indexed.map((x) {
                      final b = x.$2;
                      final index = x.$1;
                      if (b.price == 0 && value.selected == 0) {
                        return ShopCard(
                          label: b.name,
                          icon: b.image,
                          price: const Text(
                            "Selected",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else if (b.price == 0 ||
                          value.boughtBalls.contains(index)) {
                        if (index == value.selected) {
                          return ShopCard(
                            label: b.name,
                            icon: b.image,
                            price: const Text(
                              "Selected",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: () {
                            if (value.boughtBalls.contains(index)) {
                              ballController.selectBall(index);
                              return;
                            }
                          },
                          child: ShopCard(
                            label: b.name,
                            icon: b.image,
                            price: const SizedBox.shrink(),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          if (!b.isDiamond) {
                            if (b.price <= coinController.value) {
                              ballController.buyNewBall(index);
                              coinController.sum(b.price);
                            } else {
                              showDialog(
                                useSafeArea: false,
                                context: context,
                                builder: (BuildContext context) {

                                  return NBLockedAlertFER(inf: 'Not enought money',);
                                },
                              );
                            }
                          } else {
                            if (b.price <= diamondController.value) {
                              ballController.buyNewBall(index);
                              diamondController.sum(b.price);
                            } else {
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
                        child: PrimaryShopCard(
                          label: b.name,
                          icon: b.image,
                          price: b.price,
                          buyUsingCoin: !b.isDiamond,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => buyDiamonds(100, 1, context),
                      child: const ShopCardX(
                        label: "Extra D",
                        icon: "assets/images/others/diamond.png",
                        price: 100,
                        diamond: 1,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => buyDiamonds(180, 2, context),
                      child: const ShopCardX(
                        label: "Extra D",
                        icon: "assets/images/others/diamond.png",
                        price: 180,
                        diamond: 2,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => buyDiamonds(250, 3, context),
                      child: const ShopCardX(
                        label: "Extra D",
                        icon: "assets/images/others/diamond.png",
                        price: 250,
                        diamond: 3,
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

  void buyDiamonds(int amount, int diamond, BuildContext context) {
    if (coinController.value >= amount) {
      coinController.sum(amount);
      diamondController.sum(-diamond);
    } else {
      showDialog(
        useSafeArea: false,
        context: context,
        builder: (BuildContext context) {

          return NBLockedAlertFER(inf: 'Not enought money',);
        },
      );
    }
  }
}

class PrimaryShopCard extends StatelessWidget {
  const PrimaryShopCard({
    super.key,
    required this.label,
    required this.icon,
    required this.price,
    this.buyUsingCoin = true,
  });

  final String label;
  final String icon;
  final int price;
  final bool buyUsingCoin;

  @override
  Widget build(BuildContext context) {
    return ShopCard(
      label: label,
      icon: icon,
      price: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            buyUsingCoin
                ? "assets/images/others/coin.png"
                : "assets/images/others/diamond.png",
            height: 24,
          ),
          const SizedBox(width: 10),
          Text(
            price.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ShopCardX extends StatelessWidget {
  const ShopCardX({
    super.key,
    required this.label,
    required this.icon,
    required this.price,
    required this.diamond,
  });

  final String label;
  final String icon;
  final int price;
  final int diamond;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 165),
      padding: const EdgeInsets.only(
        top: 10,
        right: 12,
        left: 12,
        bottom: 18,
      ),
      width: MediaQuery.of(context).size.width * 0.275,
      decoration: const BoxDecoration(
        color: Color(0xFF161E36),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: _ShopCardTag(
              tag: label,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/others/diamond.png",
                height: 25,
                width: 25,
              ),
              const SizedBox(width: 10),
              Text(
                diamond.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/others/coin.png",
                height: 25,
                width: 25,
              ),
              const SizedBox(width: 10),
              Text(
                price.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key,
    required this.label,
    required this.icon,
    required this.price,
  });

  final String label;
  final String icon;
  final Widget price;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 165),
      padding: const EdgeInsets.only(
        top: 10,
        right: 12,
        left: 12,
        bottom: 18,
      ),
      width: MediaQuery.of(context).size.width * 0.275,
      decoration: const BoxDecoration(
        color: Color(0xFF161E36),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: _ShopCardTag(
              tag: label,
            ),
          ),
          const Spacer(),
          Image.asset(
            icon,
            height: 20,
            width: 20,
          ),
          const Spacer(),
          price
        ],
      ),
    );
  }
}

class _ShopCardTag extends StatelessWidget {
  const _ShopCardTag({
    super.key,
    required this.tag,
  });

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFF353A53),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ShopAppBar extends StatelessWidget {
  const ShopAppBar({
    super.key,
  });

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
              const Text(
                "Shop",
                style: TextStyle(
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
