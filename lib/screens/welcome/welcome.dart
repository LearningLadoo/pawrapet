import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pawrapet/screens/profile/profileDisplay.dart';
import 'package:pawrapet/utils/constants.dart';
import 'package:pawrapet/utils/extensions/buildContext.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // the lottie
            Positioned(
              top: xSize,
              left: -xWidth * 0.25,
              child: Lottie.asset(
                "assets/lotties/women_dog_love.json",
                height: xHeight * 0.7,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(xSize / 2),
                  width: xWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PAWRAPETS",
                        style: xTheme.textTheme.headlineLarge!.apply(fontSizeDelta: 4)
                      ),
                      Text(
                        "Because your pet deserves the absolute best.",
                        style: xTheme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: xSize),
                      Center(
                        child: XRoundedButton(
                          text: "Let's Get Started!",
                          onPressed: () {
                            context.push(const ProfileDisplay());
                          },
                          expand: true,
                        ),
                      ),
                      const SizedBox(height: xSize),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
