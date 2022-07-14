import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BubblePainter extends CustomPainter {
  BubblePainter({
    required ScrollableState scrollable,
    required BuildContext bubbleContext,
    required List<Color> colors,
    required this.bRadius,
    required this.sWidth,
  })  : _scrollable = scrollable,
        _bubbleContext = bubbleContext,
        _colors = colors,
        super(repaint: scrollable.position);

  final ScrollableState _scrollable;
  final BuildContext _bubbleContext;
  final List<Color> _colors;
  final double bRadius;
  final double sWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // 스크롤할 수 있는 스크린 범위
    final scrollableBox = _scrollable.context.findRenderObject() as RenderBox;

    // 그라디언트를 칠해야하는 채팅 스크린 범위
    // Offset.zero-> flutter: Offset(0.0, 0.0)
    // scrollableBox.size-> flutter: Size(375.0, 812.0) .. 디바이스 스크린의 Size 라고 보면 된다.
    final scrollableRect = Offset.zero &
        scrollableBox.size; // flutter: Rect.fromLTRB(0.0, 0.0, 375.0, 812.0)

    // 그라디언트를 그려야하는 버블하나의 박스

    final bubbleBox = _bubbleContext.findRenderObject() as RenderBox;
    Rect innerRect = Rect.fromLTRB(
        sWidth, sWidth, size.width - sWidth, size.height - sWidth);
    Rect outerRect = Offset.zero & size;
    RRect innerRoundedRect =
        RRect.fromRectAndRadius(innerRect, Radius.circular(bRadius));
    RRect outerRoundedRect =
        RRect.fromRectAndRadius(outerRect, const Radius.circular(0.0));

    // 개별 버블박스의 시작 지점
    final origin =
        bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);

    final paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        _colors,
        [0.0, 1.0],
        TileMode.clamp,
        Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
      );

    Path borderPath = _calculateBorderPath(outerRoundedRect, innerRoundedRect);

    // canvas.drawRect(Offset.zero & size, paint); // --> 이거는 배경 전체 색칠할 때
    canvas.drawPath(borderPath, paint); // --> 이거는 라인만 색칠할 때
  }

  Path _calculateBorderPath(RRect outerRect, RRect innerRect) {
    Path outerRectPath = Path()..addRRect(outerRect);
    Path innerRectPath = Path()..addRRect(innerRect);
    return Path.combine(PathOperation.difference, outerRectPath, innerRectPath);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return oldDelegate._scrollable != _scrollable ||
        oldDelegate._bubbleContext != _bubbleContext ||
        oldDelegate._colors != _colors;
  }
}
