import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:NineBreaked/app/NBsoundFIE.dart';
import 'package:NineBreaked/main.dart';
import 'package:NineBreaked/NBprivacy_policyfERE.dart';

class NBSettingsScreenGHF extends StatelessWidget {
  const NBSettingsScreenGHF({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060F2B),
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 120),
        child: SettingsAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 28),
            const Profile(),
            const SizedBox(height: 28),
            const Awards(),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.only(left: 31, right: 21),
              width: MediaQuery.sizeOf(context).width * 0.92,
              height: 64,
              decoration: ShapeDecoration(
                color: const Color(0xFF161E36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const NBSoundZXC(),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(kPrivacyPolicy))) {
                  await launchUrl(Uri.parse(kPrivacyPolicy));
                }
              },
              child: const PrivacyPolicy(),
            )
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 31, right: 21),
      width: MediaQuery.sizeOf(context).width * 0.92,
      height: 64,
      decoration: ShapeDecoration(
        color: const Color(0xFF161E36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: const Row(
        children: [
          Text(
            "Privacy Policy",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class Awards extends StatelessWidget {
  const Awards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFF161E36),
          ),
          borderRadius: BorderRadius.circular(20)),
      width: MediaQuery.sizeOf(context).width * 0.92,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Awards",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: levelController,
            builder: (_, value, __) {
              if (value >= 1) {
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AwardItem(
                      path: "assets/images/others/award_1.png",
                    ),
                    SizedBox(width: 25),
                    AwardItem(
                      path: "assets/images/others/award_2.png",
                    ),
                  ],
                );
              }

              return SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.5,
                child: const Text(
                  "No awards at the moment, you need to pass at least 1 stage",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class AwardItem extends StatelessWidget {
  const AwardItem({
    super.key,
    required this.path,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 56,
        maxWidth: 56,
        minWidth: 56,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF161E36),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Image.asset(path),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.92,
        height: 228,
        decoration: BoxDecoration(
          color: const Color(0xFF161E36),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            const SizedBox(height: 18),
            const Text(
              "Your Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 22),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF35436A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  height: 144,
                  width: 144,
                  child: Center(
                    child: ValueListenableBuilder(
                      valueListenable: imageController,
                      builder: (_, file, __) {
                        if (file == null) {
                          return Image.asset(
                            "assets/images/others/person.png",
                            height: 104,
                          );
                        }

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            file,
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: -12,
                  right: -12,
                  child: GestureDetector(
                    onTap: () => imageController.set(),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 40,
                        maxWidth: 40,
                      ),
                      child: Image.asset(
                        "assets/images/others/plus.png",
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

final imageController = ImageController();

class ImageController extends ValueNotifier<File?> {
  ImageController() : super(null) {
    init();
  }

  void init() async {
    final path = preferences.getString("profile");

    if (path == null) return;

    value = File(path);
    notifyListeners();
  }

  void set() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');
      await preferences.setString('profile', savedImage.path);

      value = savedImage;
      notifyListeners();
    }
  }
}

class PinkButton extends StatelessWidget {
  const PinkButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 40,
        maxWidth: 40,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFDB00FF),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Center(
          child: Icon(
        Icons.close,
        color: Colors.white,
      )),
    );
  }
}

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({
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
                "Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            color: const Color(0xFF353A53),
            borderRadius: BorderRadius.circular(10)),
        child: Image.asset(
          "assets/images/others/arrow.png",
          height: 18,
        ),
      ),
    );
  }
}
