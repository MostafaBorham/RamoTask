import 'package:eramo_task/home_page.dart';
import 'package:eramo_task/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App opens the home page with the supplied logo and home icon', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(HomePage), findsOneWidget);
    for (final path in [
      'assets/home/app-logo.png',
      'assets/home/home-icon.png',
    ]) {
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName == path,
        ),
        findsOneWidget,
      );
      final asset = await tester.runAsync(() => rootBundle.load(path));
      expect(asset?.lengthInBytes, greaterThan(0));
    }
  });
}
