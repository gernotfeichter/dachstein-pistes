// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:developer';
import 'package:dachstein_pistes/widgets/0/init.dart';
import 'package:flutter_test/flutter_test.dart';

import '../global/init.dart';

void main() {
  testWidgets('Piste found smoke test', (WidgetTester tester) async {
    log("widget test started");

    TestWidgetsFlutterBinding.ensureInitialized();
    log("ensure initialized");

    // Build our app and trigger a frame.
    MyHomePageState.response = await getStubbedHttpResponse();
    await tester.pumpWidget(const MyApp());
    // sleep(const Duration(seconds: 30));
    // await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify that pistes are on the list
    expect(find.text('Piste'), findsWidgets);
    expect(find.text("Zugang Skiroute Wilde Abfahrt Edelgriess (Rosmariestollen)"), findsWidgets);

    log("widget test finished");

  });
}
