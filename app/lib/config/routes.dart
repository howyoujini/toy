import 'package:app/screen/home/v_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/screen/chat/v_chat.dart';

class AppRoutes {
  static Route? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _cupertinoRoute(const HomeScreen());

      case '/chat':
        return _cupertinoRoute(const ChatBotScreen());

      default:
        return null;
    }
  }
}

Route<dynamic> _cupertinoRoute(Widget screen) {
  return CupertinoPageRoute(builder: (_) => screen);
}
