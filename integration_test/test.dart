
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dachstein_pistes/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("happy path test", (WidgetTester tester) async {
    // Given: Application is stared
    app.main();

    // When: I wait till the pistes are fetched
    Future.delayed(const Duration(seconds: 10), () async {
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
}