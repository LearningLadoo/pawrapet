import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawrapet/screens/account/Account.dart';
import 'package:pawrapet/screens/home/utils/widgets/bottomNav.dart';
import 'package:pawrapet/screens/petShop/petShop.dart';
import '../../utils/constants.dart';
import '../notifications/notificationsScreen.dart';
import '../search/search.dart';
import 'feed.dart';

class Home extends StatefulWidget {
  final int index;
  const Home({Key? key, this.index = 1}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late int _index;

  @override
  void initState() {
    // todo i need to know if the user profile needs a quick profile or not
    _index = widget.index;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getScreen() {
    switch (_index) {
      case 0:
        return Account();
        break;
      case 1:
        return Feed();
        break;
      case 2:
        return PetShop();
        break;
      case 3:
        return NotificationsScreen();
        break;
      case 4:
        return Search();
        break;
      default:
        return Center();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: getScreen()),
            XBottomNavigator(
              initialIndex: _index,
              onChanged: (int index) {
                setState(() {
                  _index = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
