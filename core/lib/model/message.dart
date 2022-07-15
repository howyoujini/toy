import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum MessageOwner { bot, user }

@immutable
class Message extends Equatable {
  final MessageOwner owner;
  final String text;

  const Message({required final this.owner, required final this.text});

  bool get isUser => owner == MessageOwner.user;

  @override
  List<Object?> get props => [text];

  @override
  bool? get stringify => true;
}
