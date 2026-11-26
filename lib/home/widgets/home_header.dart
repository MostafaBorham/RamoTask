import 'package:flutter/material.dart';

import '../home_colors.dart';
import 'home_label.dart';
import 'home_media.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.city,
    required this.topInset,
    required this.onQueryChanged,
    this.logo,
    this.onSearch,
    this.onMenu,
    this.onNotifications,
    this.onMessages,
  });

  final String city;
  final double topInset;
  final ImageProvider<Object>? logo;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onMenu;
  final VoidCallback? onNotifications;
  final VoidCallback? onMessages;

  @override
  Widget build(BuildContext context) {
    final logo = this.logo;
    const padding = EdgeInsets.fromLTRB(23, 12, 23, 16);
    const searchGap = 6.0;
    final searchOffset = 160 - topInset;
    final headerContentHeight = (searchOffset - padding.top - searchGap).clamp(
      0.0,
      160.0,
    );
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 26,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: headerContentHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 44,
                    child: Center(
                      child: logo == null
                          ? const HomeSvg('app-logo', width: 98, height: 28)
                          : Image(
                              image: logo,
                              width: 98,
                              height: 44,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _locationAndActions(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: searchGap),
            Align(alignment: Alignment.centerLeft, child: _searchField()),
          ],
        ),
      ),
    );
  }

  Widget _locationAndActions() {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Row(
            children: [
              const HomeSvg('location-icon', width: 18, height: 22),
              const SizedBox(width: 4),
              Flexible(child: HomeLabel(city, size: 18, maxLines: null)),
              const Icon(Icons.keyboard_arrow_down, color: HomeColors.primary),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderAction(
              const HomeSvg('message-icon', width: 26, height: 26),
              'الرسائل',
              count: '5',
              onPressed: onMessages,
            ),
            _HeaderAction(
              const HomeSvg('notification-icon', width: 19, height: 25),
              'الإشعارات',
              count: '2',
              onPressed: onNotifications,
            ),
            _HeaderAction(
              const HomeSvg('home/menu-icon', width: 26, height: 26),
              'القائمة',
              onPressed: onMenu,
            ),
          ],
        ),
      ],
    );
  }

  Widget _searchField() {
    return SizedBox(
      width: 381,
      height: 42,
      child: TextField(
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 16, height: 22 / 16),
        onChanged: onQueryChanged,
        onSubmitted: (value) => onSearch?.call(value.trim()),
        decoration: const InputDecoration(
          hintText: 'كيف يمكننا مساعدتك',
          hintStyle: TextStyle(color: Color(0x993C3C43)),
          isDense: true,
          prefixIconConstraints: BoxConstraints.tightFor(width: 32, height: 22),
          prefixIcon: Padding(
            // Material 3 supplies 4 dp of spacing after the prefix icon.
            padding: EdgeInsetsDirectional.only(start: 8, end: 2),
            child: Icon(Icons.search, size: 22, color: HomeColors.muted),
          ),
          filled: true,
          fillColor: Color(0x1F767680),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction(this.icon, this.label, {this.count, this.onPressed});

  final Widget icon;
  final String label;
  final String? count;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
      icon: SizedBox.square(
        dimension: 29,
        child: Stack(
          alignment: Alignment.center,
          children: [
            icon,
            if (count != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: HomeColors.danger,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: 13,
                    child: Center(
                      child: Text(
                        count!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
