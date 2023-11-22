import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
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
  late YoutubePlayerController _controllerYoutube;

  @override
  void initState() {
    super.initState();
    _controllerYoutube = YoutubePlayerController.fromVideoId(
      videoId: '2OTMsrmyGvA',
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controllerYoutube,
      builder: (context, player) {
        return TemplatePage(
          hasProx: "home",
          answerLenght: 1,
          header: const Text(
            'Sobre / Informações:',
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
                  GlobalKey<FormFieldState<List<ValueNotifier<String>>>>
                      state) =>
              [
            const Text(
              textAlign: TextAlign.justify,
              '\nEsta\tpágina\tvisa\tproporcionar\tum\tnatal\tcheio\tde\tmuito\tamor\te\tfraternidade.\n\nAqui\tvocê\tpode\tfazer\ta\tdiferença!!\tVeja\tcomo\té\tsimples!!\n\nBasta\tescolher\tum\tdos\tquatro\t(4)\tpostos\tde\tassistência\tdas\tObras\tSociais\tdo\tGrupo\tEspírita\tPaulo\tde\tTarso,\tnos\tbotões\tabaixo,\tselecionar\tuma\tfamília\tna\tsequência\te\tpreencher\tseus\tdados\tcomo\tdoador.\n\nPronto.\tAgora\tbasta\tsalvar\to\tarquivo\tcom\to\tresumo\tdesta\tfamília.\tNeste\tarquivo\tvocê\tterá\tas\tinformações\tpara\tpoder\tentregar\tpessoalmente\testa\tcesta,\tou\tos\tdados\tdo\tcoordenador\tdo\trespectivo\tposto\tpara\tvocê\talinhar\tcom\tele\tcomo\tserá\testa\tentrega.\n\nPara\tsaber\tmais\tcomo\tusar\testa\tferramenta,\tveja\to\tvideo\tabaixo:\n\n',
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            player,
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
                'Bezerra de Menezes',
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
              builder:
                  (BuildContext context, String activeTag, Widget? child) =>
                      Column(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    controller.activeTagButtom.value == ""
                        ? ""
                        : """
Posto de Assistência Espírita ${controller.activeTagButtom.value} 
${postos[controller.activeTagButtom.value]![0]}
${postos[controller.activeTagButtom.value]![1]}
${postos[controller.activeTagButtom.value]![2]}, e
${postos[controller.activeTagButtom.value]![3]}
""",
                    style: const TextStyle(color: Colors.indigo, fontSize: 15.0),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    controller.activeTagButtom.value == ""
                        ? ""
                        : postos[controller.activeTagButtom.value]![4],
                    style: const TextStyle(color: Colors.red, fontSize: 15.0),
                  ),                  
                ],
              ),
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
    _controllerYoutube.close();
    super.dispose();
  }
}
