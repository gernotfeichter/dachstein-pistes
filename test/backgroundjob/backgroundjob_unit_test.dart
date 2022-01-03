import 'package:dachstein_pistes/backgroundjob/init.dart' as bg;
import 'package:dachstein_pistes/db/model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../global/init.dart';

void main() {
  test('Background Job Test', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    AppSettings appSettings =
        await bg.job(responseInput: await getStubbedHttpResponse());

    assert(appSettings.pistes
            .where((element) =>
                element.name ==
                "Zugang Skiroute Wilde Abfahrt Edelgriess (Rosmariestollen)")
            .length ==
        1);
  });
}
