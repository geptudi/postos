import 'dart:convert';
import 'package:http/http.dart' as http;

class Parameters {
  static Map<String, List<String>> postos = {};

  static Future<void> loadPostos() async {
    final response = await http.get(Uri.parse('postos.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);

      postos = decoded.map((key, value) => MapEntry(
        key,
        (value as List<dynamic>).map((item) => item.toString()).toList(),
      ));
    } else {
      throw Exception('Failed to load postos.json');
    }
  }
}
