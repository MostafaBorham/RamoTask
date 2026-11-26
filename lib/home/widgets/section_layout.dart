import 'package:flutter/material.dart';

import '../home_colors.dart';
import 'home_label.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({
    super.key,
    required this.title,
    required this.child,
    this.onViewAll,
    this.filters,
    this.footer,
  });

  final String title;
  final Widget child;
  final ValueChanged<String>? onViewAll;
  final Widget? filters;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: Row(
              children: [
                Expanded(
                  child: HomeLabel(
                    title,
                    size: 18,
                    maxLines: 2,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onViewAll == null ? null : () => onViewAll!(title),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: HomeLabel(
                      'مشاهدة الكل',
                      size: 16,
                      color: HomeColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ?filters,
          SizedBox(height: filters == null ? 16 : 14),
          child,
          ?footer,
        ],
      ),
    );
  }
}

class HorizontalCards extends StatelessWidget {
  const HorizontalCards({
    super.key,
    required this.height,
    required this.children,
    this.controller,
  });

  final double height;
  final List<Widget> children;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        controller: controller,
        primary: false,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => const SizedBox(width: 16),
      ),
    );
  }
}

class HomeCardSurface extends StatelessWidget {
  const HomeCardSurface({
    super.key,
    required this.child,
    required this.radius,
    required this.label,
    this.color = HomeColors.background,
    this.borderColor = HomeColors.border,
    this.onTap,
  });

  final Widget child;
  final double radius;
  final String label;
  final Color color;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (onTap == null)
            child
          else
            Semantics(
              label: label,
              button: true,
              child: InkWell(onTap: onTap, child: child),
            ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
