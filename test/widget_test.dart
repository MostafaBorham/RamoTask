import 'dart:convert';

import 'package:eramo_task/home_page.dart';
import 'package:eramo_task/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fontLoader = FontLoader('Noto Kufi Arabic');
    for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      fontLoader.addFont(
        rootBundle.load(
          'assets/fonts/noto-kufi-arabic/NotoKufiArabic-$weight.ttf',
        ),
      );
    }
    await fontLoader.load();
  });

  testWidgets('Home uses the SVG icons and updated header', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(HomePage), findsOneWidget);
    for (final path in [
      'assets/app-logo.svg',
      'assets/home-icon.svg',
      'assets/home/menu-icon.svg',
    ]) {
      final loader = SvgAssetLoader(path);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SvgPicture && widget.bytesLoader == loader,
        ),
        findsOneWidget,
      );
      final asset = await tester.runAsync(() => loader.loadBytes(null));
      expect(asset?.lengthInBytes, greaterThan(0));
    }

    final search = find.byType(TextField);
    final decoration = tester.widget<TextField>(search).decoration!;
    expect(decoration.hintText, 'كيف يمكننا مساعدتك');
    expect((decoration.prefixIcon! as Icon).size, 24);
    expect(
      Theme.of(tester.element(search)).textTheme.bodyMedium?.fontFamily,
      'Noto Kufi Arabic',
    );

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();
    expect(find.byType(PopupMenuItem<String>), findsNothing);
  });

  testWidgets('Both banners slide the overlay over the same photo', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    final livingRoom = MemoryImage(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAIAAAD91JpzAAAAFklEQVR4nGP8z8DAwMDAxMDAwMDAAAANHQEDasKb6QAAAABJRU5ErkJggg==',
      ),
    );
    final office = MemoryImage(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAIAAAD91JpzAAAAFklEQVR4nGNkYPjPwMDAxMDAwMDAAAALHwEDmIWXfgAAAABJRU5ErkJggg==',
      ),
    );
    final contacted = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Noto Kufi Arabic'),
        home: HomePage(
          images: {
            'pexels-vecislavas-popa-1643383': livingRoom,
            'pexels-huseyn-kamaladdin-667838': office,
          },
          onContact: contacted.add,
        ),
      ),
    );

    for (final (photo, initialTitle, nextTitle) in [
      (livingRoom, 'منزل احلامك الاَن متوفر', 'شقق سكنية في الشيخ زايد'),
      (office, 'مكتبك لازم يكون انيق', 'مكاتب في الشيخ زايد'),
    ]) {
      final initialSlide = find.text(initialTitle);
      await tester.scrollUntilVisible(
        initialSlide,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      final controller = tester
          .widget<PageView>(
            find.ancestor(of: initialSlide, matching: find.byType(PageView)),
          )
          .controller;
      final banner = find.byWidgetPredicate(
        (widget) => widget is PageView && widget.controller == controller,
      );
      final photoStack = find
          .ancestor(of: banner, matching: find.byType(Stack))
          .first;
      final photoWidget = find.byWidgetPredicate(
        (widget) => widget is Image && identical(widget.image, photo),
      );
      final background = find.descendant(of: photoStack, matching: photoWidget);
      final originalPhoto = tester.element(background);
      final photoBounds = tester.getRect(background);
      final previous = find.descendant(
        of: photoStack,
        matching: find.byWidgetPredicate(
          (widget) => widget is IconButton && widget.tooltip == 'السابق',
        ),
      );
      final next = find.descendant(
        of: photoStack,
        matching: find.byWidgetPredicate(
          (widget) => widget is IconButton && widget.tooltip == 'التالي',
        ),
      );
      final arrow = find.byWidgetPredicate(
        (widget) =>
            widget is SvgPicture &&
            widget.bytesLoader ==
                const SvgAssetLoader('assets/home/slider-circle-icon.svg'),
      );
      expect(
        find.descendant(of: photoStack, matching: arrow),
        findsNWidgets(2),
      );
      expect(
        (tester.widget<IconButton>(previous).icon as Transform).transform.entry(
          0,
          0,
        ),
        -1,
      );
      expect(find.descendant(of: banner, matching: photoWidget), findsNothing);

      final titleBounds = tester.getRect(initialSlide);
      await tester.tap(next);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(tester.getRect(background), photoBounds);
      expect(tester.getRect(initialSlide), isNot(titleBounds));
      await tester.pumpAndSettle();

      expect(find.text(nextTitle), findsOneWidget);
      expect(tester.element(background), same(originalPhoto));
      expect(tester.getRect(background), photoBounds);
      final contact = find.descendant(
        of: photoStack,
        matching: find.text('تواصل الاَن'),
      );
      await tester.tap(contact);
      expect(contacted.last, nextTitle);

      await tester.tap(previous);
      await tester.pumpAndSettle();
      expect(initialSlide, findsOneWidget);
      expect(tester.element(background), same(originalPhoto));
    }
  });
}
