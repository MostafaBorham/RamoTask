import 'package:flutter/material.dart';

import '../home_colors.dart';

class PaginationDots extends StatelessWidget {
  const PaginationDots({
    super.key,
    required this.selected,
    required this.onSelected,
    this.count = 4,
  });

  final int selected;
  final ValueChanged<int> onSelected;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children: [
        for (var index = 0; index < count; index++)
          Semantics(
            button: true,
            selected: index == selected,
            label: 'شريحة ${index + 1}',
            child: InkWell(
              onTap: () => onSelected(index),
              child: SizedBox(
                width: 18,
                height: 17,
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: index == selected
                          ? HomeColors.primary
                          : HomeColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 8),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
