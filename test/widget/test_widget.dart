// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dachstein_pistes/logging/init.dart';
import 'package:dachstein_pistes/widgets/init.dart';
import 'package:flutter_test/flutter_test.dart';

import '../global/init.dart';

void main() {
  testWidgets('widget test: load stubbed pistes', (WidgetTester tester) async {
    // Given: Widget is stared
    logger.info("widget test started");
    TestWidgetsFlutterBinding.ensureInitialized();
    MainPageState.response = await getStubbedHttpResponse();
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // When: I wait till the pistes are fetched
    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 10), () async {
        await tester.pumpAndSettle();

        // Then: Verify that pistes are on the list
        expect(find.text('Piste'), findsWidgets);
        expect(find.text(
        "Zugang Skiroute Wilde Abfahrt Edelgriess (Rosmariestollen)"),
        findsWidgets);
        expect(find.text(
        "Mittersteinabfahrt"), findsWidgets);
      });
    });
  });
}
