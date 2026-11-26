import 'package:flutter/material.dart';

class HomeLabel extends StatelessWidget {
  const HomeLabel(
    this.text, {
    super.key,
    this.size = 12,
    this.color = Colors.black,
    this.weight = FontWeight.w400,
    this.maxLines = 1,
    this.align,
    this.direction,
  });

  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final int? maxLines;
  final TextAlign? align;
  final TextDirection? direction;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
      textAlign: align,
      textDirection: direction,
      style: TextStyle(
        fontSize: size,
        height: size <= 12 ? 16 / size : 1.33,
        letterSpacing: size >= 14 ? -0.3 : 0,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}
