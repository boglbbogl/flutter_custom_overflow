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
    _setEllipsisPainter();
  }

  void _setEllipsisPainter() {
    if (widget.ellipsis != null && maxLines != null) {
      TextStyle style =
          widget.ellipsis!.style ?? widget.text.style ?? const TextStyle();
      double fontSize =
          2.0 >= widget.scaleUp && widget.scaleUp >= -2.0 ? widget.scaleUp : 0;
      ellipsisPaint = TextPainter(
        text: TextSpan(
          text: widget.ellipsis!.data,
          style: style.copyWith(
            color: style.color ?? style.color,
            fontSize: (textPaint.text!.style!.fontSize ?? 14) + fontSize,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
    }
  }

  String? _ellipsis() {
    if (widget.ellipsis != null && (maxLines != null)) {
      if (widget.scaleUp > 0 && widget.scaleUp <= 2) {
        return " " *
            (widget.ellipsis!.data!.length * 2 -
                1 +
                ((widget.scaleUp ~/ 1) * 2 - 2));
      } else if (widget.scaleUp < 0 && widget.scaleUp >= -2) {
        return " " *
            (widget.ellipsis!.data!.length * 2 -
                1 +
                (widget.scaleUp ~/ 1 + 2 - 2));
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
    return GestureDetector(
      onTapDown: (TapDownDetails details) =>
          _onTapDown(details, textPaint, ellipsisPaint),
      child: CustomPaint(
        painter: _Painter(
          textPaint,
          maxLines,
          ellipsisPainter: ellipsisPaint,
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final TextPainter textPaint;
  final int? maxLines;
  final TextPainter? ellipsisPainter;

  _Painter(
    this.textPaint,
    this.maxLines, {
    required this.ellipsisPainter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    textPaint.layout(minWidth: 0, maxWidth: size.width);
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
