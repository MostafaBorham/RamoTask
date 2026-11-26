import 'package:flutter/material.dart';

import '../home_colors.dart';
import 'home_label.dart';
import 'home_media.dart';

enum HomeDestination { properties, offers, home, market, developers }

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({super.key, this.onSelected});

  final ValueChanged<HomeDestination>? onSelected;

  static const _leadingItems = [
    (
      HomeDestination.properties,
      HomeSvg('my-reel-states-icon', width: 24, height: 24),
      'عقاراتي',
    ),
    (
      HomeDestination.offers,
      HomeSvg('offers-icon', width: 17, height: 20),
      'العروض',
    ),
  ];
  static const _trailingItems = [
    (
      HomeDestination.market,
      Image(
        image: AssetImage('assets/home/market-icon.png'),
        width: 24,
        height: 24,
        fit: BoxFit.contain,
        excludeFromSemantics: true,
      ),
      'السوق',
    ),
    (
      HomeDestination.developers,
      HomeSvg('developers-icon', width: 29, height: 21),
      'المطورون',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 10),
      child: Center(
        heightFactor: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / 5;
                final homeDiameter = itemWidth.clamp(0.0, 63.0);
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: homeDiameter / 2),
                      child: _panel(),
                    ),
                    Positioned(top: 0, child: _homeButton(homeDiameter)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel() {
    return Stack(
      children: [
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 22),
          child: Row(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (destination, icon, label) in _leadingItems)
                Expanded(child: _destination(destination, icon, label)),
              const Spacer(),
              for (final (destination, icon, label) in _trailingItems)
                Expanded(child: _destination(destination, icon, label)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _homeButton(double diameter) {
    return Semantics(
      selected: true,
      button: true,
      child: Tooltip(
        message: 'الرئيسية',
        child: Material(
          color: HomeColors.primary,
          elevation: 4,
          shape: const CircleBorder(
            side: BorderSide(color: Colors.white, width: 4),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onSelected == null
                ? null
                : () => onSelected!(HomeDestination.home),
            child: SizedBox.square(
              dimension: diameter,
              child: const Center(
                child: HomeSvg('home-icon', width: 35, height: 35),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _destination(HomeDestination destination, Widget icon, String label) {
    return InkWell(
      onTap: onSelected == null ? null : () => onSelected!(destination),
      child: SizedBox(
        height: 48,
        child: Column(
          spacing: 3,
          children: [
            SizedBox(height: 24, child: Center(child: icon)),
            HomeLabel(label, size: 11, color: HomeColors.primary),
          ],
        ),
      ),
    );
  }
}
