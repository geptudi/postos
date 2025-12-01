import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_controller.dart';
import 'modelsview/single_selection_list.dart';
import 'modelsview/template_page.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();

    // Recupera controller
    controller = Modular.get<HomeController>();

    // Inicia carregamento:
    // - JSON dos postos
    // - Repositório remoto
    controller.init();
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
      itens:
          (
            HomeController controller,
            GlobalKey<FormFieldState<List<ValueNotifier<String>>>> state,
          ) {
            return [
              const Text(
                textAlign: TextAlign.justify,
                'Esta página visa proporcionar um natal cheio de muito amor e fraternidade.\n\n'
                'Para saber mais como usar esta ferramenta, veja o vídeo abaixo:',
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
                '\nPerfeito! Agora escolha o posto de assistência que deseja ajudar:\n',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),

              /// Lista de postos – atualizada para usar activeTagButtom
              SingleSelectionList(
                answer: controller.activeTagButtom
                  ..addListener(() {
                    if (state.currentState != null) {
                      state.currentState!.didChange(<ValueNotifier<String>>[
                        controller.activeTagButtom,
                      ]);
                    }
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
                '\nO posto escolhido foi:\n',
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),

              /// Agora com PostoModel seguro
              ValueListenableBuilder(
                valueListenable: controller.activeTagButtom,
                builder: (_, selectedTag, __) {
                  if (selectedTag.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final posto = controller.getPosto(selectedTag);

                  return Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        """
Posto de Assistência Espírita $selectedTag

${posto.endereco}
${posto.bairro}

${posto.coordenador1}, e
${posto.coordenador2}
""",
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        posto.entrega,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const Text(
                textAlign: TextAlign.justify,
                '\nSua generosidade faz a diferença na vida de quem mais precisa.\n\n'
                'Junte-se a nós nessa causa e ajude a construir um natal melhor e recheado para todos.\n\n'
                'Clique em "próximo" para continuar.\n\n'
                'E que Deus lhe abençoe.\n\n',
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ];
          },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
