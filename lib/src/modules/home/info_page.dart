import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../models/parameters.dart';
import 'home_controller.dart';
import 'modelsview/single_selection_list.dart';
import 'template_page.dart';

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
      videoId: 'CSOR7F6X4EU',
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
          isLeading: false,
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
              """
Esta página visa proporcionar um natal cheio de muito amor e fraternidade. 

Aqui você pode fazer a diferença!! Veja como é simples!!

Basta escolher um dos quarto (4) postos de assistência das Obras Sociais do Grupo Espírita Paulo de Tarso, nos botões abaixo, selecionar uma família na sequência e preencher seus dados como doador.

Pronto. Agora basta salvar o arquivo com o resumo desta família. Neste arquivo você terá as informações para poder entregar pessoalmente esta cesta, ou os dados do coordenador do respectivo posto para você alinhar com ele como será esta entrega.

Para saber mais como usar esta ferramenta, veja o video abaixo:
""",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            player,
            const Text(
              textAlign: TextAlign.justify,
              """

Perfeito!! Agora escolha o posto de assistência que deseja ajudar:
""",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            SingleSelectionList(
              answer: controller.answerAux.value[0]
                ..addListener(() {
                  state.currentState!.didChange(controller.answerAux.value);
                  controller.activeTagButtom.value =
                      controller.answerAux.value[0].value;
                }),
              hasPrefiroNaoDizer: false,
              options: const [
                'Bezerra de Menezes',
                'Eurípedes Barsanulfo',
                'Mãe Zeferina',
                'Simão Pedro',
              ],
              optionsColumnsSize: 2,
            ),
            const Text(
              textAlign: TextAlign.justify,
              """

O posto escolhido foi:
""",
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            ValueListenableBuilder(
              valueListenable: controller.activeTagButtom,
              builder:
                  (BuildContext context, String activeTag, Widget? child) =>
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
                style: const TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
            const Text(
              textAlign: TextAlign.justify,
              """
Sua generosidade faz a diferença na vida de quem mais precisa. 

Junte-se a nós nessa causa e ajude a construir um natal melhor e recheado para todos.

Clique em próximo para continuar.

E que Deus lhe abençõe.

""",
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
