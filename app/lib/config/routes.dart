import 'package:flutter/cupertino.dart';
import 'package:flutter_app/screen/chat/v_chat.dart';

class AppRoutes {
  static Route? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _cupertinoRoute(const ChatBotScreen());

      default:
        return null;
    }
  }
}

Route<dynamic> _cupertinoRoute(Widget screen) {
  return CupertinoPageRoute(builder: (_) => screen);
}
