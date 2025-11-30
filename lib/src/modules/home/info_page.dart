import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.play_circle_filled,
                color: Colors.red), // ou use um ícone SVG
            label: Text('YouTube'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.red,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        //player,
        const Text(
          textAlign: TextAlign.justify,
          '\nPerfeito!!\tAgora\tescolha\to\tposto\tde\tassistência\tque\tdeseja\tajudar:\n',
          style: TextStyle(color: Colors.black, fontSize: 16.0),
        ),
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
    final key = controller.activeTagButtom.value;

    // se nada foi escolhido ainda:
    if (key.isEmpty) {
      return const SizedBox.shrink();
    }

    // tenta pegar o posto
    final postoInfo = postos[key];

    // se não achou essa chave no mapa, evita crash
    if (postoInfo == null || postoInfo.length < 5) {
      return const Text(
        'Não foi possível carregar os dados desse posto.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.red),
      );
    }

    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          """
Posto de Assistência Espírita $key
${postoInfo[0]}
${postoInfo[1]}
${postoInfo[2]}, e
${postoInfo[3]}
""",
          style: const TextStyle(color: Colors.indigo, fontSize: 15.0),
        ),
        Text(
          textAlign: TextAlign.center,
          postoInfo[4],
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
  }

  @override
  void dispose() {
    super.dispose();
  }
}