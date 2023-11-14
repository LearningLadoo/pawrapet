import 'package:flutter/material.dart';
import 'package:pawrapet/firebase/functions.dart';
import 'package:pawrapet/main.dart';
import 'package:pawrapet/providers/authProvider.dart';
import 'package:pawrapet/utils/widgets/buttons.dart';
import 'package:provider/provider.dart';
import '../../../../utils/functions/common.dart';
import '/../utils/constants.dart';
import 'package:pawrapet/utils/extensions/sizedBox.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  bool logoutPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FirebaseCloudFunctions().sendTestNotification();
        return;
        logoutPressed = true;
        setState(() {});
        await Provider.of<AuthProvider>(context, listen: false).logout(context);
      },
      child: Container(
        height: xSize * 1.5,
        padding: const EdgeInsets.symmetric(vertical: xSize / 4, horizontal: xSize / 4),
        decoration: BoxDecoration(
          color: xPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(xSize2),
        ),
        child: Center(
          child: (logoutPressed)
              ? CircularProgressIndicator()
              : Text(
                  "Logout",
                  style: TextStyle(
                    color: xPrimary.withOpacity(0.8),
                  ),
                ),
        ),
      ),
    );
  }
}
