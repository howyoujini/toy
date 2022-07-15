import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:app/color_schemes.dart';
import 'package:core/model/message.dart';
import 'package:app/screen/chat/vm_chat.dart';
import 'package:app/widget/message_bubble/w_message_bubble.dart';
import 'package:flutter/rendering.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  var scroll = ScrollController();


  late MessageListViewModel viewModel;
  late final List<Message> data;

  @override
  void initState() {
    super.initState();
    data = MessageGenerator.generate(60, 300);
    scroll.addListener(() {
      print(scroll.position.pixels== scroll.position.maxScrollExtent);
    });

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scroll,
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        reverse: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final message = data[index];
          return MessageBubble(
            message: message,
            child: Text(message.text),
          );
        });
  }
}

@immutable
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.child});

  final Message message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final messageAlignment = message.isUser ? Alignment.topRight : Alignment.topLeft;

    return FractionallySizedBox(
      alignment: messageAlignment,
      widthFactor: 0.8,
      child: Align(
        alignment: messageAlignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(0.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            child: BubbleBackground(
              colors: [
                message.isUser ? lightColorScheme.secondary : const Color.fromRGBO(255, 255, 255, 0.5),
                message.isUser ? lightColorScheme.primary : const Color.fromRGBO(0, 0, 0, 0.1),
              ],
              child: DefaultTextStyle.merge(
                style: const TextStyle(fontSize: 14.0, color: CupertinoColors.black),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BubbleBackground extends StatelessWidget {
  const BubbleBackground({super.key, required this.colors, this.child});

  final List<Color> colors;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        scrollable: Scrollable.of(context)!,
        bubbleContext: context,
        colors: colors,
        bRadius: 18.0,
        sWidth: 2.0,
      ),
      child: child,
    );
  }
}

// 가상데이터 자동생성 만들어둔건데 이후 삭제할 예정
class MessageGenerator {
  static List<Message> generate(int count, [int? seed]) {
    final random = Random(seed);
    return List.unmodifiable(List<Message>.generate(
      count,
      (index) => Message(
        owner: random.nextBool() ? MessageOwner.bot : MessageOwner.user,
        text: _mockData[random.nextInt(_mockData.length)],
      ),
    ));
  }

  static final _mockData = [
    'Hello, World',
    'Welcome to HERE',
    'lorem100',
    '안녕하세요',
    'This will draw a gradient around the text. However, this border will be tightly bound around the text itself, which is not conducive to a presentable UI. To improve our UI, we need to insert some further customizations, such as rounded corners and padding.',
    '이용할 수 있습니다. (단, 라이선스가 명시된 일부 문서 및 삽화 제외) 기여하신 문서의 저작권은 각 기여자에게 있으며, 각 기여자는 기여하신 부분의 저작권을 갖습니다. 나무위키는 백과사전이 아니며 검증되지 않았거나, 편향적이거나, 잘못된 서술이 있을 수 있습니다.나무위키는 위키위키입니다. 여러분이 직접 문서를 고칠 수 있으며, 다른 사람의 의견을 원할 경우 직접 토론을 발제할 수 있습니다.'
  ];
}
