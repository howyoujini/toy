import 'package:flutter/cupertino.dart';
import 'package:flutter_app/config/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // logger 에서 appPackageName 사용함.
  static const appPackageName = "howyoujini";

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: appPackageName,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.onGenerateRoutes,
    );
  }
}