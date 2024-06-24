import 'dart:async';

import 'package:NineBreaked/app/NBmain_screenFUU.dart';
import 'package:flutter/material.dart';

class NBSplashScreenFERE extends StatefulWidget {
  const NBSplashScreenFERE({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<NBSplashScreenFERE> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NBMainScreenFSS()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060F2B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 80),
              child: Image.asset(
                "assets/images/logo.png",
                height: 200,
              ),
            ),
            const SizedBox(height: 28),
            const CircularProgressIndicator(
              color: Color(0xFFE5590B),
              strokeWidth: 2,
            ),
          ],
        ), // Add your splash logo here
      ),
    );
  }
}
