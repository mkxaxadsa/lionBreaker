import 'package:NineBreaked/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NBSoundZXC extends StatelessWidget {
  const NBSoundZXC({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Sound",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: NBswitchControllerFTE,
          builder: (_, value, __) {
            return Switch(
              value: value,
              activeTrackColor: const Color(0xFFE65C0B),
              onChanged: (x) {
                NBswitchControllerFTE.set(x);
              },
            );
          },
        )
      ],
    );
  }
}

final NBswitchControllerFTE = BoolController();

class BoolController extends ValueNotifier<bool> {
  BoolController() : super(false) {
    init();
  }

  void init() async {
    final sound = preferences.getBool("sound");
    if (sound == null) {
      await preferences.setBool("sound", false);
    }

    value = preferences.getBool("sound")!;
    notifyListeners();
  }

  void set(bool v) async {
    await preferences.setBool("sound", v);
    value = v;
    notifyListeners();
  }
}
