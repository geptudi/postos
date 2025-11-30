import 'dart:convert';
import 'package:http/http.dart' as http;

class Parameters {
  /// Armazena os dados carregados de postos.json
  static Map<String, List<String>> postos = {};

  /// Carrega o JSON externo apenas 1 vez (antes do app iniciar)
  static Future<void> loadPostos() async {
    try {
      final response = await http.get(Uri.parse('/postos.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        postos = (data as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        );
      } else {
        throw Exception(
            'Erro ao carregar postos.json (status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro ao carregar postos.json: $e');
    }
  }
}
