import 'package:shared_preferences/shared_preferences.dart';
import 'package:studio_yaiverse_mobile/screens/home_screen.dart';
import 'package:studio_yaiverse_mobile/screens/get3d_screen.dart';
import 'package:studio_yaiverse_mobile/screens/ar_screen.dart';
import 'package:flutter/material.dart';
import 'package:studio_yaiverse_mobile/screens/login_screen.dart';

class StudioYaiverseHome extends StatefulWidget {
  final String title;

  const StudioYaiverseHome({required this.title, Key? key}) : super(key: key);

  @override
  State<StudioYaiverseHome> createState() => _StudioYaiverseHomeState();
}

class _StudioYaiverseHomeState extends State<StudioYaiverseHome> {
  int homeIdx = 0;

  //final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? _id;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  void _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString('ID');
    });
  }

  void onClickTab(int idx) {
    setState(() {
      if (idx == 2) {
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => ObjectGesturesWidget(username: _id!)));
      } else if (idx == 1) {
        Navigator.of(context).push(PageRouteBuilder(
          fullscreenDialog: true,
          pageBuilder: (_, __, ___) => const GetThreeD(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            var curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ));
      } else {
        homeIdx = idx;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_id == null) {
      return const LoginScreen();
    } else {
      final List<Widget> homeContents = <Widget>[
        HomeScreen(username: _id!),
        HomeScreen(username: _id!),
        HomeScreen(username: _id!),
      ];
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: homeContents.elementAt(homeIdx),
          bottomNavigationBar: BottomNavigationBar(
            // selectedFontSize: 12.0,
            // unselectedFontSize: 12.0,
            type: BottomNavigationBarType.fixed,
            onTap: onClickTab,
            currentIndex: homeIdx,
            showUnselectedLabels: true,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black45,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box),
                label: 'Get 3D',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.view_in_ar),
                label: 'AR',
              ),
            ],
          ),
        ),
      );
    }
  }
}
