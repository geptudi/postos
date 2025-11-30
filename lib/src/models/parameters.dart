import 'dart:convert';
import 'package:http/http.dart' as http;

class Parameters {
  static Map<String, List<String>> postos = {
  "Fabiano de Cristo": [
    "Rua Abilia Ferreira Diniz nº 105",
    "Bairro: Pacaembu",
    "Coordenador(a)es: Maria do Carmo - 9 9879 4774",
    "Mauro Roberto - 9 9886 0205",
    "As Cestas para este posto, devem ser entregues no sábado do dia 20/12 das 8:00 as 12:00, ou em uma data previamente combinada com os coordenadores do respectivo posto."
  ],
  "Eurípedes Barsanulfo": [
    "Rua Honorato Fagundes da Costa nº 841",
    "Bairro: Morada Nova",
    "Coordenador(a)es: Josué  - 9 9125 3106",
    "Thiago - 9 9267 2502",
    "As Cestas para este posto, devem ser entregues no domingo do dia 21/12 das 8:00 as 12:00, ou em uma data previamente combinada com os coordenadores do respectivo posto."
  ],
  "Mãe Zeferina": [
    "Av.: José Pires Defensor nº 35",
    "Bairro: Taiaman",
    "Coordenador(a)es: Edson - 9 9968 7096",
    "",
    "As Cestas para este posto, devem ser entregues no domingo do dia 21/12 das 8:00 as 12:00, ou em uma data previamente combinada com os coordenadores do respectivo posto."
  ],
  "Simão Pedro": [
    "Rua da Ternura nº 451",
    "Bairro: São Francisco",
    "Coordenador(a)es: Ozair  - 9 9928 4455",
    "Rodrigo - 9 9965 1410",
    "As Cestas para este posto, devem ser entregues no sábado do dia 20/12 das 8:00 as 12:00, ou em uma data previamente combinada com os coordenadores do respectivo posto."
  ]
};

  static Future<void> loadPostos() async {
    final url = Uri.parse(
      '${Uri.base.origin}/postos/postos.json'
    );

    print("🔍 Carregando JSON de: $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body);

      postos = decoded.map(
        (key, value) => MapEntry(
          key,
          List<String>.from(value),
        ),
      );

      print("✔ JSON carregado com sucesso!");
    } else {
      print("❌ ERRO HTTP: ${response.statusCode}");
      print("Resposta: ${response.body}");
      throw Exception('Failed to load postos.json');
    }
  }
}
