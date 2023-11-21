import 'package:flutter/material.dart';
import '../../../../utils/extensions/buildContext.dart';
import '../../../profile/profile.dart';
import '/../utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';
class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.push(Profile());
      },
      child: Container(
        height: xSize * 3,
        padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFD4DDCE), Color(0xFFDBE9D2), Color(0xFFD4DDCE)], stops: [0.2, 0.5, 0.8], begin: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(xSize2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: Image.asset("assets/images/pet1.jpeg").image,
              radius: xSize,
            ),
            const SizedBox().horizontal(size: xSize / 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Edit Profile",
                    style: xTheme.textTheme.headlineMedium!.apply(color: xPrimary.withOpacity(0.8)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox().vertical(size: xSize / 16),
                  Text(
                    "₹5000 per mating",
                    overflow: TextOverflow.ellipsis,
                    style: xTheme.textTheme.bodySmall!.apply(color: xPrimary.withOpacity(0.8), fontSizeDelta: -1),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
