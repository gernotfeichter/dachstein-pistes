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
  testWidgets('Piste found smoke test', (WidgetTester tester) async {
    logger.info("widget test started");

    TestWidgetsFlutterBinding.ensureInitialized();
    logger.info("ensure initialized");

    // Build our app and trigger a frame.
    MainPageState.response = await getStubbedHttpResponse();
    await tester.pumpWidget(const MyApp());
    // sleep(const Duration(seconds: 30));
    // await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify that pistes are on the list
    expect(find.text('Piste'), findsWidgets);
    expect(find.text("Zugang Skiroute Wilde Abfahrt Edelgriess (Rosmariestollen)"), findsWidgets);

    logger.info("widget test finished");

  });
}
