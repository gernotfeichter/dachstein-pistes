import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

getStubbedHttpResponse() async {
  return http.Response(
      await rootBundle.loadString("test/backgroundjob/gletschbericht.html"),
      200,
      headers: {HttpHeaders.contentTypeHeader: 'text/html; charset=UTF-8'}
  );
}
