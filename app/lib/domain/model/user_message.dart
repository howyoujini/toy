import 'package:flutter_app/domain/model/message.dart';

class UserMessage extends Message {
  const UserMessage({required super.owner, required super.text});
}
