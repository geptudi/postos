import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

import '../../models/parameters.dart';
import 'home_controller.dart';
import 'modelsview/single_selection_list.dart';
import 'modelsview/template_page.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late Future<Map<String, List<String>>> futurePostos;
  Map<String, List<String>>? postosCarregados;

  @override
  void initState() {
    super.initState();
    futurePostos = carregarPostos();
  }

  /// Carrega o JSON externo `postos.json` na raiz do Flutter Web
  Future<Map<String, List<String>>> carregarPostos() async {
    try {
      final response = await http.get(Uri.parse('/postos.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        );
      } else {
        throw Exception('Erro ao carregar JSON: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar postos.json: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<String>>>(
      future: futurePostos,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        postosCarregados = snapshot.data!;

        return TemplatePage(
          hasProx: "home",
          answerLenght: 1,
          header: const Text(
            'Sejam bem vindos!!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              height: 1.5,
              color: Colors.white,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 1.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          ),
          itens: (HomeController controller,
              GlobalKey<FormFieldState<List<ValueNotifier<String>>>> state) =>
              [

            const Text(
              textAlign: TextAlign.justify,
              'Esta\tpágina\tvisa\tproporcionar\tum\tnatal\tcheio\tde\tmuito\tamor\te\tfraternidade.\n\nPara\tsaber\tmais\tcomo\tusar\testa\tferramenta,\tveja\to\tvideo\tabaixo:',
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                 Modular.to.pushNamed("youtube");
                },
                icon: const Icon(Icons.play_circle_filled, color: Colors.red),
                label: const Text('Vídeo explicativo'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            const Text(
              textAlign: TextAlign.justify,
              '\nPerfeito!!\tAgora\tescolha\to\tposto\tde\tassistência\tque\tdeseja\tajudar:\n',
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),

            // 🔥 Mesmo widget de antes – opções fixas (isto NÃO muda nada)
            SingleSelectionList(
              answer: controller.activeTagButtom
                ..addListener(() {
                  state.currentState!.didChange(
                      <ValueNotifier<String>>[controller.activeTagButtom]);
                }),
              hasPrefiroNaoDizer: false,
              options: const [
                'Fabiano de Cristo',
                'Eurípedes Barsanulfo',
                'Mãe Zeferina',
                'Simão Pedro',
              ],
              optionsColumnsSize: 1,
            ),

            const Text(
              textAlign: TextAlign.justify,
              '\nO\tposto\tescolhido\tfoi:\n',
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),

            ValueListenableBuilder(
              valueListenable: controller.answerAux.value[0],
              builder: (BuildContext context, String activeTag, Widget? child) {
                if (controller.activeTagButtom.value == "" ||
                    !postosCarregados!.containsKey(controller.activeTagButtom.value)) {
                  return const SizedBox.shrink();
                }

                final posto = postosCarregados![controller.activeTagButtom.value]!;

                return Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      """
Posto de Assistência Espírita ${controller.activeTagButtom.value} 
${posto[0]}
${posto[1]}
${posto[2]}, e
${posto[3]}
""",
                      style: const TextStyle(color: Colors.indigo, fontSize: 15.0),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      posto[4],
                      style: const TextStyle(color: Colors.red, fontSize: 15.0),
                    ),
                  ],
                );
              },
            ),

            const Text(
              textAlign: TextAlign.justify,
              '\nSua\tgenerosidade\tfaz\ta\tdiferença\tna\tvida\tde\tquem\tmais\tprecisa.\n\nJunte-se\ta\tnós\tnessa\tcausa\te\tajude\ta\tconstruir\tum\tnatal\tmelhor\te\trecheado\tpara\ttodos.\n\nClique\tem\tpróximo\tpara\tcontinuar.\n\nE\tque\tDeus\tlhe\tabençõe.\n\n',
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
