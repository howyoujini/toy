import 'package:app/screen/chat/v_chat.dart';
import 'package:app/screen/home/v_home.dart';
import 'package:flutter/cupertino.dart';

class NavigatorTabs extends StatefulWidget {
  const NavigatorTabs({Key? key}) : super(key: key);

  @override
  State<NavigatorTabs> createState() => _NavigatorTabsState();
}

class _NavigatorTabsState extends State<NavigatorTabs> {
  final List<Widget> _tab = [
    const HomeScreen(),
    const ChatBotScreen(),
    const ChatBotScreen(),
    const ChatBotScreen(),
    const ChatBotScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.today), label: 'Today'),
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.rocket_fill), label: 'Games'),
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.layers_alt_fill), label: 'Apps'),
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.wand_stars_inverse), label: 'Archive'),
              BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: 'Search')
            ],
          ),
          tabBuilder: (BuildContext context, index) {
            return _tab[index];
          }),
    );
  }
}
