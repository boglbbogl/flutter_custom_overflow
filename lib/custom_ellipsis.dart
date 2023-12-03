import 'package:flutter/material.dart';

class CustomEllipsis extends StatefulWidget {
  final TextSpan text;
  final int? maxLines;
  final Text? ellipsis;
  final double scaleUp;
  final Function()? onTap;
  const CustomEllipsis({
    super.key,
    required this.text,
    this.maxLines,
    this.ellipsis,
    this.scaleUp = 0,
    this.onTap,
  });

  @override
  State<CustomEllipsis> createState() => _CustomEllipsisState();
}

class _CustomEllipsisState extends State<CustomEllipsis> {
  TextPainter textPaint = TextPainter();
  TextPainter? ellipsisPaint;
  int? maxLines;
  double scaleUp = 0;

  @override
  void didUpdateWidget(covariant CustomEllipsis oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updatePainter();
  }

  @override
  void initState() {
    super.initState();
    _updatePainter();
  }

  void _updatePainter() {
    maxLines = widget.maxLines != null && widget.maxLines == 0
        ? null
        : widget.maxLines;
    textPaint = TextPainter(
      text: widget.text,
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
      ellipsis: _ellipsis(),
    );
    scaleUp =
        2.0 >= widget.scaleUp && widget.scaleUp >= -2.0 ? widget.scaleUp : 0;
    _setEllipsisPainter();
  }

  void _setEllipsisPainter() {
    if (widget.ellipsis != null && maxLines != null) {
      TextStyle style =
          widget.ellipsis!.style ?? widget.text.style ?? const TextStyle();
      // double fontSize =
      //     2.0 >= widget.scaleUp && widget.scaleUp >= -2.0 ? widget.scaleUp : 0;
      ellipsisPaint = TextPainter(
        text: TextSpan(
          text: widget.ellipsis!.data,
          style: style.copyWith(
            color: style.color ?? style.color,
            fontSize: (textPaint.text!.style!.fontSize ?? 14) + scaleUp,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
    }
  }

  String? _ellipsis() {
    if (widget.ellipsis != null && (maxLines != null)) {
      if (scaleUp > 0 && scaleUp <= 2) {
        return " " *
            (widget.ellipsis!.data!.length * 2 - 1 + ((scaleUp ~/ 1) * 2 - 2));
      } else if (scaleUp < 0 && scaleUp >= -2) {
        return " " *
            (widget.ellipsis!.data!.length * 2 - 1 + (scaleUp ~/ 1 + 2 - 2));
      } else {
        return " " * (widget.ellipsis!.data!.length * 2 - 1);
      }
    } else {
      return null;
    }
  }

  Future<dynamic> _onTapDown(
    TapDownDetails details,
    TextPainter text,
    TextPainter? ellipsis,
  ) async {
    if (text.didExceedMaxLines && ellipsis != null) {
      Offset offset = details.localPosition;
      int max = maxLines ?? 1;
      double minHeight = ((max - 1) * ellipsis.height);
      double maxHeight = ellipsis.height + ((max - 1) * ellipsis.height);
      if (text.width - ellipsis.width < offset.dx &&
          (minHeight <= offset.dy && offset.dy <= maxHeight) &&
          widget.onTap != null) {
        widget.onTap!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      BuildContext context,
      BoxConstraints constraints,
    ) {
      return GestureDetector(
        onTapDown: (TapDownDetails details) =>
            _onTapDown(details, textPaint, ellipsisPaint),
        child: Column(
          children: [
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _Painter(
                textPaint,
                maxLines,
                ellipsisPainter: ellipsisPaint,
                maxHeight: constraints.maxHeight,
                textStyle: widget.text.style ?? const TextStyle(),
                scaleUp: scaleUp,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _Painter extends CustomPainter {
  final TextPainter textPaint;
  final int? maxLines;
  final TextPainter? ellipsisPainter;
  final double maxHeight;
  final TextStyle textStyle;
  final double scaleUp;

  _Painter(
    this.textPaint,
    this.maxLines, {
    required this.ellipsisPainter,
    required this.maxHeight,
    required this.textStyle,
    required this.scaleUp,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double componentMaxHeight = 0;
    List<String> components = textPaint.plainText.split("");
    List<String> ellipsisComponents =
        ellipsisPainter != null ? ellipsisPainter!.plainText.split("") : [];
    for (final component in components) {
      TextPainter sizePainter = TextPainter(
        text: TextSpan(
          text: component,
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      sizePainter.layout(minWidth: 0, maxWidth: size.width);
      if (componentMaxHeight < sizePainter.height) {
        componentMaxHeight = sizePainter.height;
      }
    }
    for (final component in ellipsisComponents) {
      TextPainter sizePainter = TextPainter(
        text: TextSpan(
          text: component,
          style: textStyle.copyWith(
            fontSize: (textStyle.fontSize ?? 14) + scaleUp,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      sizePainter.layout(minWidth: 0, maxWidth: size.width);
      if (componentMaxHeight < sizePainter.height) {
        componentMaxHeight = sizePainter.height;
      }
    }

    if (componentMaxHeight <= maxHeight) {
      int componentMaxLines = maxHeight ~/ componentMaxHeight;

      if (maxLines == null) {
        textPaint.maxLines = componentMaxLines;
        textPaint.layout(minWidth: 0, maxWidth: size.width);
      } else {
        if (componentMaxLines < maxLines!) {
          textPaint.maxLines = componentMaxLines;
        }
        textPaint.layout(minWidth: 0, maxWidth: size.width);
      }

      textPaint.paint(canvas, const Offset(0, 0));
      if (ellipsisPainter != null &&
          textPaint.didExceedMaxLines &&
          maxLines != null) {
        ellipsisPainter!.layout();
        ellipsisPainter!.paint(
            canvas,
            Offset(size.width - ellipsisPainter!.width,
                textPaint.height - (ellipsisPainter!.height)));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
