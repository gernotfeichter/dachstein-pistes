import 'package:dachstein_pistes/backgroundjob/init.dart' as bg;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Background Job Test', () async {
    await bg.job();
  });
}
