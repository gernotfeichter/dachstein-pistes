import 'dart:io';

import 'package:dachstein_pistes/backgroundjob/init.dart' as bg;
import 'package:dachstein_pistes/db/model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('Background Job Test', () async {

    TestWidgetsFlutterBinding.ensureInitialized();

    http.Response stubbedResponse = http.Response(
        await rootBundle.loadString("test/backgroundjob/gletschbericht.html"),
        200,
        headers: {HttpHeaders.contentTypeHeader: 'text/html; charset=UTF-8'}
    );

    AppSettings appSettings = await bg.job(response: stubbedResponse);

    assert(appSettings.pistes.where(
            (element) => element.name == "Zugang Skiroute Wilde Abfahrt Edelgriess (Rosmariestollen)")
        .length == 1);

  });
}
