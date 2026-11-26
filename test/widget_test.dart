import 'package:eramo_task/home_page.dart';
import 'package:eramo_task/home/widgets/pagination_dots.dart';
import 'package:eramo_task/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _assetImage(String path) => find.byWidgetPredicate((widget) {
  if (widget is! Image) return false;
  final image = widget.image;
  final source = image is ResizeImage ? image.imageProvider : image;
  return source is AssetImage && source.assetName == path;
});

Finder _svg(String path) => find.byWidgetPredicate(
  (widget) =>
      widget is SvgPicture && widget.bytesLoader == SvgAssetLoader(path),
);

Finder _iconButton(String tooltip) => find.byWidgetPredicate(
  (widget) => widget is IconButton && widget.tooltip == tooltip,
);

void _mobileViewport(WidgetTester tester, {double width = 390}) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    320,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

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

  testWidgets(
    'Header matches the search layout and keeps bottom-right counts',
    (tester) async {
      _mobileViewport(tester, width: 428);
      tester.view.padding = const FakeViewPadding(top: 24);
      addTearDown(tester.view.resetPadding);
      await tester.pumpWidget(const MyApp());

      expect(find.byType(HomePage), findsOneWidget);
      for (final path in [
        'assets/app-logo.svg',
        'assets/home-icon.svg',
        'assets/home/menu-icon.svg',
      ]) {
        expect(_svg(path), findsOneWidget);
        final loader = SvgAssetLoader(path);
        final asset = await tester.runAsync(() => loader.loadBytes(null));
        expect(asset?.lengthInBytes, greaterThan(0));
      }

      for (final (label, count) in [('الرسائل', '5'), ('الإشعارات', '2')]) {
        final icon = tester.widget<IconButton>(_iconButton(label)).icon;
        final badge = find.descendant(
          of: find.byWidget(icon),
          matching: find.byType(Positioned),
        );
        final placement = tester.widget<Positioned>(badge);
        expect(placement.right, 0);
        expect(placement.bottom, 0);
        expect(
          find.descendant(of: badge, matching: find.text(count)),
          findsOneWidget,
        );
      }

      final search = find.byType(TextField);
      final decoration = tester.widget<TextField>(search).decoration!;
      final prefix = decoration.prefixIcon! as Padding;
      expect(decoration.hintText, 'كيف يمكننا مساعدتك');
      expect(
        decoration.contentPadding,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      );
      expect(
        (decoration.border as OutlineInputBorder).borderRadius,
        BorderRadius.circular(10),
      );
      expect(tester.getRect(search), const Rect.fromLTWH(23, 160, 381, 42));
      expect(
        tester.getRect(find.byIcon(Icons.search)),
        const Rect.fromLTWH(374, 170, 22, 22),
      );
      expect(
        tester.getRect(find.byIcon(Icons.search)).left -
            tester.getRect(find.text('كيف يمكننا مساعدتك')).right,
        6,
      );
      expect((prefix.child! as Icon).color, const Color(0xFF6C6C6C));
      expect(
        Theme.of(tester.element(search)).textTheme.bodyMedium?.fontFamily,
        'Noto Kufi Arabic',
      );

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();
      expect(find.byType(PopupMenuItem<String>), findsNothing);
    },
  );

  testWidgets('Location wraps beside the header actions on a narrow screen', (
    tester,
  ) async {
    _mobileViewport(tester, width: 280);
    await tester.pumpWidget(const MyApp());

    final location = find.text('القاهرة').first;
    expect(tester.getSize(location).height, greaterThan(24));
    expect(tester.getRect(_iconButton('القائمة')).left, 23);
    expect(
      tester.getRect(location).left,
      greaterThan(tester.getRect(_iconButton('الرسائل')).right),
    );
    expect(tester.getSize(find.byType(TextField)).width, 234);
  });

  testWidgets(
    'Both banners slide the matching photo and copy under fixed arrows',
    (tester) async {
      _mobileViewport(tester);
      final contacted = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Noto Kufi Arabic'),
          home: HomePage(onContact: contacted.add),
        ),
      );

      const livingRoom = (
        'منزل احلامك الاَن متوفر',
        'assets/tmp/banner2-img.png',
      );
      const office = ('مكتبك لازم يكون انيق', 'assets/tmp/banner1-img.png');
      for (final ((initialTitle, initialPath), (nextTitle, nextPath)) in [
        (livingRoom, office),
        (office, livingRoom),
      ]) {
        final initialSlide = find.text(initialTitle);
        await _scrollTo(tester, initialSlide);
        final controller = tester
            .widget<PageView>(
              find.ancestor(of: initialSlide, matching: find.byType(PageView)),
            )
            .controller;
        final pages = find.byWidgetPredicate(
          (widget) => widget is PageView && widget.controller == controller,
        );
        final banner = find
            .ancestor(of: pages, matching: find.byType(Stack))
            .first;
        final previous = find.descendant(
          of: banner,
          matching: _iconButton('السابق'),
        );
        final next = find.descendant(
          of: banner,
          matching: _iconButton('التالي'),
        );
        expect(
          find.descendant(
            of: banner,
            matching: _svg('assets/home/slider-circle-icon.svg'),
          ),
          findsNWidgets(2),
        );
        expect(
          tester
              .widget<Transform>(
                find
                    .ancestor(
                      of: find.descendant(
                        of: previous,
                        matching: _svg('assets/home/slider-circle-icon.svg'),
                      ),
                      matching: find.byType(Transform),
                    )
                    .first,
              )
              .transform
              .entry(0, 0),
          -1,
        );
        expect(
          find.descendant(of: banner, matching: find.byType(BackdropFilter)),
          findsNWidgets(2),
        );

        final initialPhoto = find.descendant(
          of: pages,
          matching: _assetImage(initialPath),
        );
        final initialCopy = find.descendant(of: pages, matching: initialSlide);
        final photoX = tester.getTopLeft(initialPhoto).dx;
        final copyX = tester.getTopLeft(initialCopy).dx;
        final arrowBounds = (tester.getRect(previous), tester.getRect(next));
        await tester.tap(next);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));
        final photoMotion = tester.getTopLeft(initialPhoto).dx - photoX;
        final copyMotion = tester.getTopLeft(initialCopy).dx - copyX;
        expect(photoMotion.abs(), greaterThan(0));
        expect(copyMotion, closeTo(photoMotion, 0.1));
        expect((tester.getRect(previous), tester.getRect(next)), arrowBounds);
        await tester.pumpAndSettle();

        expect(
          find.descendant(of: pages, matching: _assetImage(nextPath)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: pages, matching: find.text(nextTitle)),
          findsOneWidget,
        );
        final contact = find.descendant(
          of: pages,
          matching: find.text('تواصل الاَن'),
        );
        await tester.tap(contact);
        expect(contacted.last, nextTitle);

        await tester.tap(previous);
        await tester.pumpAndSettle();
        expect(initialPhoto, findsOneWidget);
        expect(initialCopy, findsOneWidget);
        expect((tester.getRect(previous), tester.getRect(next)), arrowBounds);
      }
    },
  );

  testWidgets(
    'Property favorites survive filters and use the bundled cover and logo',
    (tester) async {
      _mobileViewport(tester);
      final opened = <String>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'Noto Kufi Arabic'),
          home: HomePage(onItemSelected: opened.add),
        ),
      );

      final saleCard = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label ==
                '4,000,000 ج.م، شقة سكنية للبيع تشطيب سوبر ...',
      );
      final cover = find.descendant(
        of: saleCard,
        matching: _assetImage('assets/tmp/reel-state-card-item-img.jpg'),
      );
      expect(cover, findsOneWidget);
      expect(
        find.descendant(
          of: saleCard,
          matching: _svg('assets/tmp/zillow-logo.svg'),
        ),
        findsOneWidget,
      );

      Finder inCard(Finder matching) =>
          find.descendant(of: saleCard, matching: matching);
      DecoratedBox badgeBox(Finder label) {
        final background = find
            .ancestor(of: label, matching: find.byType(DecoratedBox))
            .first;
        return tester.widget<DecoratedBox>(background);
      }

      Color? badgeColor(Finder label) =>
          (badgeBox(label).decoration as BoxDecoration).color;

      final saleColor = badgeColor(inCard(find.text('للبيع')));
      expect(saleColor, const Color(0xFFFFC700));
      final featuredBadge = inCard(find.text('مميز'));
      expect(badgeColor(featuredBadge), saleColor);
      final badgePadding = badgeBox(featuredBadge).child! as Padding;
      expect(
        badgePadding.padding,
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      );
      expect((badgePadding.child! as Row).mainAxisSize, MainAxisSize.min);
      for (final text in tester.widgetList<Text>(inCard(find.byType(Text)))) {
        expect(text.style?.fontWeight, FontWeight.w600, reason: text.data);
      }

      final rent = find.widgetWithText(InkWell, 'للإيجار').first;
      final all = find.widgetWithText(InkWell, 'الكل').first;
      final rentText = find.descendant(
        of: rent,
        matching: find.text('للإيجار'),
      );
      expect(
        tester.widget<Text>(rentText).style?.color,
        const Color(0xFF898989),
      );

      final favorite = inCard(_iconButton('إضافة إلى المفضلة'));
      final favoriteStyle = tester.widget<IconButton>(favorite).style!;
      expect(favoriteStyle.splashFactory, NoSplash.splashFactory);
      expect(
        favoriteStyle.overlayColor?.resolve({WidgetState.pressed}),
        Colors.transparent,
      );
      await tester.tap(favorite);
      await tester.pumpAndSettle();
      expect(inCard(find.byIcon(Icons.favorite)), findsOneWidget);
      expect(opened, isEmpty);
      await tester.tap(rent);
      await tester.pumpAndSettle();
      expect(saleCard, findsNothing);
      final rentCard = find
          .ancestor(
            of: find.text('4,000, ج.م شهريا'),
            matching: find.byType(Semantics),
          )
          .first;
      final rentBadge = find.descendant(
        of: rentCard,
        matching: find.text('للإيجار'),
      );
      expect(badgeColor(rentBadge), const Color(0xFFD9D9D9));
      await tester.tap(all);
      await tester.pumpAndSettle();
      expect(inCard(find.byIcon(Icons.favorite)), findsOneWidget);

      await tester.tap(inCard(_iconButton('إزالة من المفضلة')));
      await tester.pumpAndSettle();
      expect(inCard(find.byIcon(Icons.favorite_border)), findsOneWidget);
      await tester.tap(cover);
      expect(opened.single, 'شقة سكنية للبيع تشطيب سوبر ...');

      await _scrollTo(tester, find.text('اهم المشاريع العقارية في مصر'));
      expect(badgeColor(find.text('مشروع').first), const Color(0xFF2A803F));
    },
  );

  testWidgets('The three compact property sections leave out status badges', (
    tester,
  ) async {
    _mobileViewport(tester);
    await tester.pumpWidget(const MyApp());

    for (final title in [
      'أحدث الشقق في مصر',
      'أحدث الفيلات في مصر',
      'أحدث الدوبلكس في مصر',
    ]) {
      final heading = find.text(title);
      await _scrollTo(tester, heading);
      final section = find
          .ancestor(of: heading, matching: find.byType(Column))
          .first;
      expect(
        find.descendant(
          of: section,
          matching: _iconButton('إضافة إلى المفضلة'),
        ),
        findsWidgets,
      );
      for (final label in ['مشروع', 'مميز']) {
        expect(
          find.descendant(of: section, matching: find.text(label)),
          findsNothing,
        );
      }
    }
  });

  testWidgets('Listing dots follow the visible cards and reset on filtering', (
    tester,
  ) async {
    _mobileViewport(tester);
    await tester.pumpWidget(const MyApp());

    final heading = find.text('أحدث الشقق في مصر');
    await _scrollTo(tester, heading);
    final section = find
        .ancestor(of: heading, matching: find.byType(Column))
        .first;
    final dots = find.descendant(
      of: section,
      matching: find.byType(PaginationDots),
    );
    expect(tester.widget<PaginationDots>(dots).count, 2);

    await tester.ensureVisible(dots);
    await tester.tap(
      find.descendant(of: dots, matching: find.byType(InkWell)).last,
    );
    await tester.pumpAndSettle();
    expect(tester.widget<PaginationDots>(dots).selected, 1);

    final rentFilter = find
        .descendant(
          of: section,
          matching: find.widgetWithText(InkWell, 'للإيجار'),
        )
        .first;
    await tester.ensureVisible(rentFilter);
    await tester.pumpAndSettle();
    await tester.tap(rentFilter);
    await tester.pumpAndSettle();
    expect(tester.widget<PaginationDots>(dots).count, 1);
    expect(tester.widget<PaginationDots>(dots).selected, 0);
  });

  testWidgets('Home button is half above the bottom navigation and tappable', (
    tester,
  ) async {
    _mobileViewport(tester);
    final destinations = <HomeDestination>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Noto Kufi Arabic'),
        home: HomePage(onNavigation: destinations.add),
      ),
    );

    final market = _assetImage('assets/home/market-icon.png');
    expect(market, findsOneWidget);
    final row = find.ancestor(of: market, matching: find.byType(Row)).first;
    expect(
      tester.widget<Row>(row).crossAxisAlignment,
      CrossAxisAlignment.start,
    );
    final panel = find
        .ancestor(of: row, matching: find.byType(DecoratedBox))
        .first;
    final decoration =
        tester.widget<DecoratedBox>(panel).decoration as BoxDecoration;
    expect(
      decoration.borderRadius,
      const BorderRadius.vertical(bottom: Radius.circular(18)),
    );
    expect(tester.getRect(row).top - tester.getRect(panel).top, 10);
    expect(tester.getRect(panel).bottom - tester.getRect(row).bottom, 22);
    final shadow = decoration.boxShadow!.single;
    expect(shadow.offset.dy, lessThan(0));
    expect(shadow.color.a, lessThan(0.1));

    final homeButton = find
        .ancestor(
          of: _svg('assets/home-icon.svg'),
          matching: find.byType(Material),
        )
        .first;
    final homeBounds = tester.getRect(homeButton);
    expect(homeBounds.center.dy, tester.getRect(panel).top);
    await tester.tapAt(homeBounds.topCenter + const Offset(0, 8));
    await tester.tap(market);
    expect(destinations, [HomeDestination.home, HomeDestination.market]);
  });

  testWidgets('City and news cards load their shared cover assets', (
    tester,
  ) async {
    _mobileViewport(tester);
    await tester.pumpWidget(const MyApp());

    await _scrollTo(tester, find.text('إبحث عن عقارك بالمدينة'));
    expect(_assetImage('assets/tmp/city-img.jpg'), findsAtLeastNWidgets(2));

    await _scrollTo(tester, find.text('اهم الأخبار'));
    expect(_assetImage('assets/tmp/news-img.png'), findsAtLeastNWidgets(2));
  });
}
