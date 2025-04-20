
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dachstein_pistes/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("integration test: load real pistes", (WidgetTester tester) async {
    // Given: Application is stared
    app.main();
    await tester.pumpAndSettle();

    // When: I wait till the pistes are fetched
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
}