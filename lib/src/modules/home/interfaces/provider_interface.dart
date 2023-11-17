import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

class ProviderInterface extends Disposable {
  var client = http.Client();
  Future<Map<String, dynamic>?> get(String baseUrl,
      {String bodyUrl = "", Map<String, dynamic>? queryParameters}) async {
    final http.Response response;
    try {
      if (queryParameters != null) {
        queryParameters.removeWhere((key, value) => value == null);
      }
      response = await client.get(
        Uri.https(baseUrl, bodyUrl, queryParameters),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'connection': 'keep-alive',
        },
      );
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      debugPrint("ProviderInterface - $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> post(String baseUrl,
      {String bodyUrl = "",
      Map<String, dynamic>? queryParameters,
      required Uint8List body}) async {
    final http.Response response, response1;
    try {
      if (queryParameters != null) {
        queryParameters.removeWhere((key, value) => value == null);
      }
      response = await client.post(
        Uri.https(baseUrl, bodyUrl, queryParameters),
        headers: <String, String>{
          //"Content-Encoding": "gzip",
          "Content-Type": "application/json",
          'connection': 'keep-alive',
        }, //gzip.encode(body),
        body: jsonEncode({'p3': base64.encode(body)}),
      );
      response1 = await client.get(Uri.parse(response.headers["location"]!));
      return jsonDecode(utf8.decode(response1.bodyBytes));
    } catch (e) {
      debugPrint("ProviderInterface - $e");
      return null;
    }
  }

  @override
  void dispose() {
    client.close();
  }
}
