import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, List<String>>> carregarPostos() async {
  final response = await http.get(Uri.parse('/postos.json'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, List<String>.from(value)),
    );
  } else {
    throw Exception('Erro ao carregar postos.json');
  }
}
