import 'package:flutter/material.dart';

class CustomEllipsis extends StatelessWidget {
  final TextSpan text;
  final int maxLines;
  final Text? ellipsis;
  final double scaleUp;
  final Icon? icon;
  const CustomEllipsis({
    super.key,
    required this.text,
    this.maxLines = 1,
    this.ellipsis,
    this.scaleUp = 0,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(
        text,
        maxLines,
        textStyle: text.style ?? const TextStyle(),
        ellipsis: ellipsis,
        scaleUp: scaleUp,
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final TextSpan text;
  final TextStyle textStyle;
  final int maxLines;
  final Text? ellipsis;
  final double scaleUp;

  _Painter(
    this.text,
    this.maxLines, {
    required this.textStyle,
    required this.ellipsis,
    required this.scaleUp,
  });
  @override
  void paint(Canvas canvas, Size size) {
    TextPainter? ellipsisPaint;
    if (ellipsis != null) {
      TextStyle style = ellipsis!.style ?? (text.style ?? const TextStyle());
      double fontSize = 2.0 >= scaleUp && scaleUp >= -2.0 ? scaleUp : 0;
      ellipsisPaint = TextPainter(
        text: TextSpan(
          text: ellipsis!.data,
          style: style.copyWith(
            fontSize: (textStyle.fontSize ?? 14) + fontSize,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
    }

    String textEllipsis = "";
    if (ellipsis != null) {
      if (scaleUp > 0 && scaleUp <= 2) {
        textEllipsis = " " *
            (ellipsisPaint!.plainText.length * 2 - 1 + ((scaleUp ~/ 1) * 2));
      } else if (scaleUp < 0 && scaleUp >= -2) {
        textEllipsis = " " *
            (ellipsisPaint!.plainText.length * 2 - 1 + (scaleUp ~/ 1 + 2));
      } else {
        textEllipsis = " " * (ellipsisPaint!.plainText.length * 2 + 1);
      }
    }

    TextPainter textPaint = TextPainter(
      text: text,
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
      ellipsis: textEllipsis,
    );

    textPaint.layout(minWidth: 0, maxWidth: size.width);
    textPaint.paint(canvas, const Offset(0, 0));

    if (ellipsis != null && textPaint.didExceedMaxLines) {
      ellipsisPaint!.layout();
      double height = textPaint.height - (ellipsisPaint.height / maxLines);
      ellipsisPaint.paint(
          canvas, Offset(size.width - ellipsisPaint.width, height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
