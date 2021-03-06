import 'package:app/navigator_tabs.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // logger 에서 appPackageName 사용함.
  static const appPackageName = "toy";

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: appPackageName,
      home: NavigatorTabs(),
    );
  }
}
