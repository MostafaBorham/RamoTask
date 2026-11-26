import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../home_colors.dart';

class HomePhoto extends StatelessWidget {
  const HomePhoto(this.name, this.images, {super.key, this.fallback});

  final String name;
  final Map<String, ImageProvider<Object>> images;
  final ImageProvider<Object>? fallback;

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: Color(0xFFD8E5E9),
      child: Center(
        child: Icon(Icons.image_outlined, color: HomeColors.primary, size: 26),
      ),
    );
    final image = images[name] ?? fallback;
    return image == null
        ? placeholder
        : Image(
            image: image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            excludeFromSemantics: true,
            errorBuilder: (context, error, stackTrace) => placeholder,
          );
  }
}

class HomeSvg extends StatelessWidget {
  const HomeSvg(
    this.name, {
    super.key,
    required this.width,
    required this.height,
  });

  final String name;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/$name.svg',
      width: width,
      height: height,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );
  }
}
