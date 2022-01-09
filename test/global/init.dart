import 'dart:io';

import 'package:http/http.dart' as http;

getStubbedHttpResponse() async {
  return http.Response(
      File("test/backgroundjob/gletschbericht.html").readAsStringSync(),
      200,
      headers: {HttpHeaders.contentTypeHeader: 'text/html; charset=UTF-8'}
  );
}


