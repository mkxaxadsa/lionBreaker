import 'package:NineBreaked/app/NBcardsFUE.dart';
import 'package:NineBreaked/app/NBsettings_screenFER.dart';
import 'package:NineBreaked/app/NBshop_screenFCI.dart';
import 'package:NineBreaked/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NBMainScreenFSS extends StatelessWidget {
  const NBMainScreenFSS({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF060F2B),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80),
        child: NBCustomAppBarFER(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: 40),
              NBCardsFER(),
            ],
          ),
        ),
      ),
    );
  }
}

class NBCustomAppBarFER extends StatelessWidget {
  const NBCustomAppBarFER({super.key});

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
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => const NBShopScreenFUE()),
                ),
                child: const ShopButton(),
              ),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: coinController,
                builder: (_, value, __) {
                  return AppBarTagAmount(
                    amount: value,
                  );
                },
              ),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: diamondController,
                builder: (_, value, __) {
                  return AppBarTagAmount(
                    amount: value,
                    icon: "assets/images/others/diamond.png",
                  );
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => const NBSettingsScreenGHF()),
                ),
                child: const SettingsButton(),
              ),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}

class ShopButton extends StatelessWidget {
  const ShopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        color: Color(0xFF353A53),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/others/shop.png",
            height: 24,
          ),
          const SizedBox(width: 8),
          const Text(
            "Shop",
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        color: Color(0xFF353A53),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Image.asset("assets/images/others/settings.png"),
    );
  }
}

class AppBarTagAmount extends StatelessWidget {
  const AppBarTagAmount({
    super.key,
    required this.amount,
    String? icon,
  }) : icon = icon ?? "assets/images/others/coin.png";

  final int amount;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 7),
      constraints: const BoxConstraints(
        maxWidth: 72,
        minWidth: 60,
        maxHeight: 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF353A53),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: _AppBarTagPPP(
        amount: amount,
        image: icon,
      ),
    );
  }
}

class _AppBarTagPPP extends StatelessWidget {
  const _AppBarTagPPP({
    super.key,
    required this.amount,
    String? image,
  }) : image = image ?? "assets/images/others/coin.png";

  final String image;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(image, height: 24),
        const Spacer(),
        Text(
          amount.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
